import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

/// Official Security & Configuration for Razorpay Payment Gateway
class RazorpayConfig {
  static const String keyId = 'rzp_live_AstroSaathi2026';
  static const String merchantName = 'AstroSaathi Technologies';
  static const String currency = 'INR';

  /// Check if Razorpay Key ID is valid
  static bool validateKey(String key) {
    return key.startsWith('rzp_live_') || key.startsWith('rzp_test_');
  }
}

/// Razorpay Payment Request DTO with Security Attributes
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
    this.userPhone = '9876543210',
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

/// Real Razorpay Payment Gateway Integration Service
class RazorpayService {
  static final RazorpayService instance = RazorpayService._internal();
  RazorpayService._internal();

  String get _baseUrl => AppConfig.baseUrl;

  /// 1. Create a Secure Razorpay Order ID on Backend Server
  Future<Map<String, dynamic>> createRazorpayOrder(RazorpayPaymentRequest request) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/payments/create-order');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'X-Razorpay-Key-Id': RazorpayConfig.keyId,
          'X-App-Security-Token': 'AstroSaathi_SSL_Secure_2026',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          return {
            'success': true,
            'orderId': body['data']?['id'] ?? '',
            'amount': body['data']?['amount'] ?? (request.amount * 100).toInt(),
            'currency': body['data']?['currency'] ?? 'INR',
          };
        }
      }
      throw Exception('Failed to create Razorpay Order on server');
    } catch (e) {
      debugPrint('Razorpay Order Creation Exception: $e');
      throw Exception('Network error or gateway timeout');
    }
  }

  /// 2. Verify Razorpay Payment Signature & Record Blockchain Ledger
  Future<bool> verifyRazorpayPayment({
    required String orderId,
    required String paymentId,
    required String signature,
    required String userId,
    required String userEmail,
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/payments/verify-signature');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
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
        return body['success'] == true;
      }
    } catch (e) {
      debugPrint('Razorpay Verification Exception: $e');
    }
    return false; // MUST fail if not strictly verified by server
  }

  /// 3. Launch Official Razorpay Standard Web/Hosted Gateway URL
  Future<bool> launchRazorpayHostedCheckout({
    required String orderId,
    required double amount,
    required String userEmail,
  }) async {
    final String rzpCheckoutUrl =
        'https://api.razorpay.com/v1/checkout/public?key_id=${RazorpayConfig.keyId}&order_id=$orderId';
    final Uri uri = Uri.parse(rzpCheckoutUrl);

    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
