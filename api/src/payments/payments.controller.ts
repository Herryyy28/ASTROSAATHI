import { Controller, Post, Get, Body, Req, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { AuthGuard } from '../auth/auth.guard';

class CreateOrderDto {
  amount!: number;
  currency?: string;
}

class VerifyPaymentDto {
  orderId!: string;
  paymentId!: string;
  signature!: string;
}

@Controller('payments')
@UseGuards(AuthGuard)
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Get('ledger')
  async getLedger(@Req() req: any) {
    const userId = req.user.uid;
    return this.paymentsService.getLedger(userId);
  }

  @Post('create-order')
  async createOrder(@Req() req: any, @Body() dto: CreateOrderDto) {
    const userId = req.user.uid;
    const userEmail = req.user.email || '';
    return this.paymentsService.createOrder(dto.amount, dto.currency, userId, userEmail);
  }

  @Post('verify-signature')
  async verifySignature(@Req() req: any, @Body() dto: VerifyPaymentDto) {
    const userId = req.user.uid;
    const userEmail = req.user.email || '';
    return this.paymentsService.verifyPaymentSignature(
      dto.orderId,
      dto.paymentId,
      dto.signature,
      userId,
      userEmail,
    );
  }
}
