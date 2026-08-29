import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request permissions for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted notification permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    // Get the FCM token
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
        // TODO: Send this token to the NestJS backend
        await _syncTokenWithBackend(token);
      }
    } catch (e) {
      debugPrint('Failed to get FCM token: $e');
    }

    // Handle token refreshes
    _firebaseMessaging.onTokenRefresh.listen((String token) {
      debugPrint('FCM Token refreshed: $token');
      _syncTokenWithBackend(token);
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received a foreground message: ${message.messageId}');
      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> _syncTokenWithBackend(String token) async {
    // Implementation to send token to backend API
    // e.g., http.post('/api/notifications/register-token', body: {'token': token})
  }

  static String getLocalizedNotification(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'hi':
        return '🔮 आपका आज का कॉस्मिक गेम प्लान तैयार है।';
      case 'gu':
        return '🔮 તમારો આજનો કોસ્મિક ગેમ પ્લાન તૈયાર છે.';
      case 'en':
      default:
        return '🔮 Your Daily Cosmic Game Plan is ready.';
    }
  }
}
