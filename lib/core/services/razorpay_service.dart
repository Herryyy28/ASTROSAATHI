import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';
import 'monitoring_service.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Razorpay Configuration — Security Keys & Merchant Info
/// ─────────────────────────────────────────────────────────────────────────────
class RazorpayConfig {
  // ┌─────────────────────────────────────────────────────────────────────────┐
  // │ IMPORTANT: Replace with your REAL Razorpay Key ID from                 │
  // │ https://dashboard.razorpay.com → Settings → API Keys                   │
  // │                                                                         │
  // │ Test Mode:  rzp_test_XXXXXXXXXXXXXXX                                    │
  // │ Live Mode:  rzp_live_XXXXXXXXXXXXXXX                                    │
  // └─────────────────────────────────────────────────────────────────────────┘
  static const String keyId = 'rzp_test_1DP5mmOlF5G5ag';

  static const String merchantName = 'AstroSaathi Technologies';
  static const String currency = 'INR';

  /// Validate Razorpay Key ID format
  static bool get isValidKey =>
      keyId.startsWith('rzp_live_') || keyId.startsWith('rzp_test_');

  /// Check if running in test mode
  static bool get isTestMode => keyId.startsWith('rzp_test_');
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Razorpay Payment Request DTO
/// ─────────────────────────────────────────────────────────────────────────────
class RazorpayPaymentRequest {
  final double amount;
  final String planName;
  final String userId;
  final String userEmail;
  final String userPhone;
  final String paymentMethod;

  RazorpayPaymentRequest({
    required this.amount,
    required this.planName,
    required this.userId,
    required this.userEmail,
    this.userPhone = '',
    required this.paymentMethod,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': RazorpayConfig.currency,
        'planName': planName,
        'userId': userId,
        'userEmail': userEmail,
        'userPhone': userPhone,
        'paymentMethod': paymentMethod,
        'timestamp': DateTime.now().toIso8601String(),
      };
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Razorpay Payment Gateway Service — End-to-End Secure Integration
/// ─────────────────────────────────────────────────────────────────────────────
class RazorpayService {
  static final RazorpayService instance = RazorpayService._internal();
  RazorpayService._internal();

  String get _baseUrl => AppConfig.baseUrl;

  // Security headers for all API calls
  Map<String, String> get _secureHeaders => {
        'Content-Type': 'application/json',
        'X-App-Platform': 'AstroSaathi-Flutter',
        'X-App-Version': '1.0.0',
      };

  /// ═══════════════════════════════════════════════════════════════════════════
  /// 1. CREATE ORDER — Calls backend to generate a real Razorpay Order ID
  /// ═══════════════════════════════════════════════════════════════════════════
  Future<Map<String, dynamic>> createRazorpayOrder(RazorpayPaymentRequest request) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/payments/create-order');
      final response = await http.post(
        url,
        headers: _secureHeaders,
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        if (body['success'] == true && body['data']?['id'] != null) {
          return {
            'success': true,
            'orderId': body['data']['id'],
            'amount': body['data']['amount'] ?? (request.amount * 100).toInt(),
            'currency': body['data']['currency'] ?? 'INR',
          };
        }
      }

      debugPrint('Order API response: ${response.statusCode} - ${response.body}');
      throw Exception('Server returned invalid order response');
    } catch (e) {
      debugPrint('Razorpay Order Creation Exception: $e');
      rethrow;
    }
  }

  /// ═══════════════════════════════════════════════════════════════════════════
  /// 2. VERIFY PAYMENT — Server-side HMAC-SHA256 signature verification
  /// ═══════════════════════════════════════════════════════════════════════════
  Future<bool> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
    required String userEmail,
  }) async {
    if (orderId.isEmpty || paymentId.isEmpty || signature.isEmpty) {
      debugPrint('Verification skipped: missing parameters');
      return false;
    }

    try {
      final url = Uri.parse('$_baseUrl/api/v1/payments/verify-signature');
      final response = await http.post(
        url,
        headers: {
          ..._secureHeaders,
          'X-Razorpay-Signature': signature,
        },
        body: jsonEncode({
          'orderId': orderId,
          'paymentId': paymentId,
          'signature': signature,
          'userId': userId,
          'userEmail': userEmail,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final verified = body['success'] == true;
        debugPrint('Payment verification result: $verified');
        return verified;
      }

      debugPrint('Verify API response: ${response.statusCode} - ${response.body}');
      MonitoringService.logError(
        'Server payment signature verification rejected (Status ${response.statusCode})',
        category: MetricCategory.payment,
        contextMessage: 'Razorpay Verification',
      );
    } catch (e, stack) {
      debugPrint('Razorpay Verification Exception: $e');
      MonitoringService.logError(
        e,
        stackTrace: stack,
        category: MetricCategory.payment,
        contextMessage: 'Razorpay Verification Exception',
      );
    }

    return false; // MUST fail-closed if not strictly verified
  }

  /// ═══════════════════════════════════════════════════════════════════════════
  /// 3. WEB FALLBACK — Launch Razorpay Checkout in external browser
  /// ═══════════════════════════════════════════════════════════════════════════
  Future<bool> launchRazorpayHostedCheckout({
    required String orderId,
    required double amount,
    required String userEmail,
  }) async {
    final amountInPaisa = (amount * 100).toInt();

    final params = <String, String>{
      'key_id': RazorpayConfig.keyId,
      'amount': '$amountInPaisa',
      'currency': RazorpayConfig.currency,
      'name': RazorpayConfig.merchantName,
      'description': 'AstroSaathi VIP Subscription',
      'prefill[email]': userEmail,
    };

    if (orderId.isNotEmpty) {
      params['order_id'] = orderId;
    }

    final queryString = params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    final Uri uri = Uri.parse('https://api.razorpay.com/v1/checkout/public?$queryString');

    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Failed to launch Razorpay hosted checkout: $e');
    }
    return false;
  }
}
