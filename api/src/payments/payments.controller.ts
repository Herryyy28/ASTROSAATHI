import { Controller, Post, Get, Body } from '@nestjs/common';
import { PaymentsService } from './payments.service';

class CreateOrderDto {
  amount!: number;
  currency?: string;
  userId?: string;
  userEmail?: string;
}

class VerifyPaymentDto {
  orderId!: string;
  paymentId!: string;
  signature!: string;
  userId?: string;
  userEmail?: string;
}

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Get('ledger')
  async getLedger() {
    return this.paymentsService.getLedger();
  }

  @Post('create-order')
  async createOrder(@Body() dto: CreateOrderDto) {
    return this.paymentsService.createOrder(dto.amount, dto.currency, dto.userId, dto.userEmail);
  }

  @Post('verify-signature')
  async verifySignature(@Body() dto: VerifyPaymentDto) {
    return this.paymentsService.verifyPaymentSignature(
      dto.orderId,
      dto.paymentId,
      dto.signature,
      dto.userId,
      dto.userEmail,
    );
  }
}
