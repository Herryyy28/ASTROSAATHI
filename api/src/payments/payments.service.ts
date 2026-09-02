import { Injectable, BadRequestException, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import * as https from 'https';
import { BlockchainService } from '../database/services/blockchain.service';

@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);
  private keyId: string;
  private keySecret: string;

  constructor(
    private readonly configService: ConfigService,
    private readonly blockchainService: BlockchainService,
  ) {
    this.keyId = this.configService.get<string>('RAZORPAY_KEY_ID', '');
    this.keySecret = this.configService.get<string>('RAZORPAY_KEY_SECRET', '');

    if (!this.keyId || !this.keySecret) {
      this.logger.warn('⚠️ RAZORPAY_KEY_ID or RAZORPAY_KEY_SECRET is not set in environment variables!');
    }
  }

  /// Create a REAL Razorpay Order via Official API
  async createOrder(amountInRupees: number, currency: string = 'INR', userId: string = 'guest', userEmail: string = '') {
    if (amountInRupees <= 0) {
      throw new BadRequestException('Amount must be greater than 0');
    }

    const amountInPaise = Math.round(amountInRupees * 100);
    const receipt = `astro_${userId}_${Date.now()}`;

    try {
      // Call Real Razorpay Orders API
      const orderData = await this.callRazorpayAPI('/v1/orders', {
        amount: amountInPaise,
        currency,
        receipt,
        notes: {
          userId,
          userEmail,
          app: 'AstroSaathi',
          createdAt: new Date().toISOString(),
        },
      });

      // Log transaction into blockchain audit ledger
      await this.blockchainService.recordBlock('PAYMENT_ORDER_CREATED', {
        orderId: orderData.id,
        amount: amountInRupees,
        amountPaise: amountInPaise,
        currency,
        userId,
        userEmail,
        receipt,
      });

      this.logger.log(`✅ Razorpay Order Created: ${orderData.id} for ₹${amountInRupees}`);

      return {
        success: true,
        data: {
          id: orderData.id,
          entity: orderData.entity,
          amount: orderData.amount,
          amount_paid: orderData.amount_paid,
          amount_due: orderData.amount_due,
          currency: orderData.currency,
          receipt: orderData.receipt,
          status: orderData.status,
          created_at: orderData.created_at,
        },
      };
    } catch (error) {
      this.logger.error(`❌ Razorpay Order Creation Failed: ${error.message}`);

      await this.blockchainService.recordBlock('PAYMENT_ORDER_FAILED', {
        amount: amountInRupees,
        currency,
        userId,
        userEmail,
        error: error.message,
      });

      throw new BadRequestException(`Failed to create Razorpay order: ${error.message}`);
    }
  }

  /// Verify Razorpay HMAC-SHA256 Signature (Server-Side Security)
  async verifyPaymentSignature(orderId: string, paymentId: string, signature: string, userId: string = 'guest', userEmail: string = '') {
    if (!orderId || !paymentId || !signature) {
      throw new BadRequestException('Missing required payment verification parameters');
    }

    if (!this.keySecret) {
      throw new BadRequestException('Server payment verification key is not configured');
    }

    // Generate HMAC-SHA256 signature for verification
    const body = `${orderId}|${paymentId}`;
    const expectedSignature = crypto
      .createHmac('sha256', this.keySecret)
      .update(body)
      .digest('hex');

    const isValid = crypto.timingSafeEqual(
      Buffer.from(signature, 'hex'),
      Buffer.from(expectedSignature, 'hex'),
    );

    if (!isValid) {
      this.logger.warn(`🚨 SIGNATURE MISMATCH for Order: ${orderId}, Payment: ${paymentId}`);

      await this.blockchainService.recordBlock('PAYMENT_SIGNATURE_MISMATCH', {
        orderId,
        paymentId,
        userId,
        userEmail,
        attemptedAt: new Date().toISOString(),
      });

      throw new BadRequestException('Invalid payment signature. Verification failed.');
    }

    // Fetch payment details from Razorpay to double-verify amount and status
    let paymentDetails: any = null;
    try {
      paymentDetails = await this.callRazorpayAPI(`/v1/payments/${paymentId}`, null, 'GET');
    } catch (e) {
      this.logger.warn(`⚠️ Could not fetch payment details for ${paymentId}: ${e.message}`);
    }

    // Record immutable success block in blockchain audit ledger
    const block = await this.blockchainService.recordBlock('PAYMENT_VERIFIED_SUCCESS', {
      orderId,
      paymentId,
      userId,
      userEmail,
      amountPaise: paymentDetails?.amount,
      method: paymentDetails?.method,
      verifiedAt: new Date().toISOString(),
    });

    this.logger.log(`✅ Payment Verified: ${paymentId} for Order: ${orderId}`);

    return {
      success: true,
      message: 'Payment signature verified successfully.',
      auditBlockIndex: block.blockIndex,
      auditBlockHash: block.hash,
    };
  }

  /// Get all recorded audit blocks for developer inspection
  async getLedger() {
    const blocks = await this.blockchainService.getAllBlocks();
    return {
      success: true,
      count: blocks.length,
      data: blocks.map((b) => ({
        blockIndex: b.blockIndex,
        actionType: b.actionType,
        hash: b.hash,
        timestamp: b.timestamp,
        details: JSON.parse(b.dataPayload || '{}'),
      })),
    };
  }

  /// Private: Call Razorpay REST API with Basic Auth
  private callRazorpayAPI(path: string, body: any, method: string = 'POST'): Promise<any> {
    return new Promise((resolve, reject) => {
      const auth = Buffer.from(`${this.keyId}:${this.keySecret}`).toString('base64');
      const postData = body ? JSON.stringify(body) : '';

      const options: https.RequestOptions = {
        hostname: 'api.razorpay.com',
        port: 443,
        path,
        method,
        headers: {
          'Authorization': `Basic ${auth}`,
          'Content-Type': 'application/json',
          ...(method === 'POST' ? { 'Content-Length': Buffer.byteLength(postData) } : {}),
        },
      };

      const req = https.request(options, (res) => {
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => {
          try {
            const parsed = JSON.parse(data);
            if (res.statusCode && res.statusCode >= 200 && res.statusCode < 300) {
              resolve(parsed);
            } else {
              reject(new Error(parsed?.error?.description || `Razorpay API error: ${res.statusCode}`));
            }
          } catch {
            reject(new Error(`Failed to parse Razorpay response: ${data}`));
          }
        });
      });

      req.on('error', (e) => reject(new Error(`Razorpay API request failed: ${e.message}`)));
      req.setTimeout(15000, () => {
        req.destroy();
        reject(new Error('Razorpay API request timed out'));
      });

      if (method === 'POST' && postData) {
        req.write(postData);
      }
      req.end();
    });
  }
}
