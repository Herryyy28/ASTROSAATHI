import 'dart:async';

/// Compatibility facade used by the existing premium preview UI.
/// No SDK, browser, backend, bank, or payment processor is contacted.
class Razorpay {
  static const eventPaymentSuccess = 'payment.success';
  static const eventPaymentError = 'payment.error';
  static const eventExternalWallet = 'payment.wallet';
  final _handlers = <String, Function>{};

  void on(String event, Function handler) => _handlers[event] = handler;

  void open(Map<String, dynamic> options) {
    scheduleMicrotask(() {
      _handlers[eventPaymentSuccess]?.call(
        PaymentSuccessResponse(
          paymentId: 'DEMO_PAYMENT_PREVIEW',
          orderId: options['order_id']?.toString() ?? 'DEMO_ORDER',
          signature: 'DEMO_SIGNATURE',
        ),
      );
    });
  }

  void clear() => _handlers.clear();
}

class PaymentSuccessResponse {
  const PaymentSuccessResponse({this.paymentId, this.orderId, this.signature});
  final String? paymentId;
  final String? orderId;
  final String? signature;
}

class PaymentFailureResponse {
  const PaymentFailureResponse({this.code, this.message});
  final int? code;
  final String? message;
}

class ExternalWalletResponse {
  const ExternalWalletResponse({this.walletName});
  final String? walletName;
}

class RazorpayConfig {
  static const keyId = 'DEMO_ONLY';
  static const currency = 'INR';
  static const merchantName = 'AstroSaathi Demo';
}

class RazorpayPaymentRequest {
  const RazorpayPaymentRequest({
    required this.amount,
    required this.planName,
    required this.userId,
    required this.userEmail,
    required this.paymentMethod,
  });
  final double amount;
  final String planName;
  final String userId;
  final String userEmail;
  final String paymentMethod;
}

class RazorpayService {
  RazorpayService._();
  static final instance = RazorpayService._();

  Future<Map<String, dynamic>> createRazorpayOrder(
    RazorpayPaymentRequest request,
  ) async => {
    'success': true,
    'orderId': 'DEMO_ORDER_${DateTime.now().millisecondsSinceEpoch}',
    'amount': (request.amount * 100).round(),
    'demoOnly': true,
  };

  Future<bool> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
    required String userEmail,
  }) async => true;

  Future<bool> launchRazorpayHostedCheckout({
    required String orderId,
    required double amount,
    required String userEmail,
  }) async => false;
}
