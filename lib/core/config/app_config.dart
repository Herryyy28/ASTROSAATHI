import 'package:flutter/foundation.dart';

class AppConfig {
  static String get baseUrl {
    if (kReleaseMode) return 'https://api.astrosaathi.app';
    const envUrl = String.fromEnvironment('API_BASE_URL');
    if (envUrl.isNotEmpty) return envUrl;
    // 127.0.0.1:3000 works on physical Android devices via adb reverse, iOS, and Web.
    return 'http://127.0.0.1:3000';
  }

  static String get apiBaseUrl => '$baseUrl/api/v1';
}

