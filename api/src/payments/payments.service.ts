import { Injectable, BadRequestException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as crypto from 'crypto';
import { BlockchainService } from '../database/services/blockchain.service';

@Injectable()
export class PaymentsService {
  private keyId: string;
  private keySecret: string;

  constructor(
    private readonly configService: ConfigService,
    private readonly blockchainService: BlockchainService,
  ) {
    this.keyId = this.configService.get<string>('RAZORPAY_KEY_ID', 'rzp_test_mockKeyId123');
    this.keySecret = this.configService.get<string>('RAZORPAY_KEY_SECRET', 'mockSecretKey123');
  }

  /// Create a Razorpay Order
  async createOrder(amountInRupees: number, currency: string = 'INR', userId: string = 'guest', userEmail: string = '') {
    const amountInPaise = Math.round(amountInRupees * 100);
    const receipt = `rcpt_${Date.now()}_${Math.floor(Math.random() * 1000)}`;

    const orderPayload = {
      id: `order_${Date.now()}_${Math.random().toString(36).substring(7)}`,
      entity: 'order',
      amount: amountInPaise,
      amount_paid: 0,
      amount_due: amountInPaise,
      currency,
      receipt,
      status: 'created',
      attempts: 0,
      created_at: Math.floor(Date.now() / 1000),
      key_id: this.keyId,
    };

    // Log transaction request into blockchain ledger
    await this.blockchainService.recordBlock('PAYMENT_ORDER_CREATED', {
      orderId: orderPayload.id,
      amount: amountInRupees,
      currency,
      userId,
      userEmail,
    });

    return {
      success: true,
      data: orderPayload,
    };
  }

  /// Verify Razorpay HMAC-SHA256 Signature
  async verifyPaymentSignature(orderId: string, paymentId: string, signature: string, userId: string = 'guest', userEmail: string = '') {
    const body = `${orderId}|${paymentId}`;
    const expectedSignature = crypto
      .createHmac('sha256', this.keySecret)
      .update(body)
      .digest('hex');

    // Enforce real signature verification
    const isValid = signature === expectedSignature;

    if (!isValid) {
      await this.blockchainService.recordBlock('PAYMENT_FAILED_SIGNATURE_MISMATCH', {
        orderId,
        paymentId,
        userId,
        userEmail,
      });
      throw new BadRequestException('Invalid payment signature. Verification failed.');
    }

    // Record immutable success transaction block in blockchain ledger
    const block = await this.blockchainService.recordBlock('PAYMENT_SUCCESS_VERIFIED', {
      orderId,
      paymentId,
      userId,
      userEmail,
      verifiedAt: new Date().toISOString(),
    });

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
}
