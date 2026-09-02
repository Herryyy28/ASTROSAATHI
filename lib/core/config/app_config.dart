import 'dart:io';
import 'package:flutter/foundation.dart';

class AppConfig {
  static String get baseUrl {
    if (kReleaseMode) return 'https://api.astrosaathi.app';
    if (!kIsWeb && Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://127.0.0.1:3000';
  }

  static String get apiBaseUrl => '$baseUrl/api/v1';
}
