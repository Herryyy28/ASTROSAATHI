import 'package:flutter/foundation.dart';

class NotificationService {
  Future<void> init() async {
    debugPrint('NotificationService initialized in local mode.');
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
