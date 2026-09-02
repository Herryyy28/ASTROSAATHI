import 'package:flutter/material.dart';

/// Supported application languages in AstroSaathi.
enum AppLanguage {
  english,
  hindi,
  gujarati,
}

extension AppLanguageExtension on AppLanguage {
  /// Two-letter ISO language code.
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.hindi:
        return 'hi';
      case AppLanguage.gujarati:
        return 'gu';
    }
  }

  /// Flutter [Locale] object.
  Locale get locale => Locale(code);

  /// English display name.
  String get englishName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'Hindi';
      case AppLanguage.gujarati:
        return 'Gujarati';
    }
  }

  /// Native language display name.
  String get nativeName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिन्दी';
      case AppLanguage.gujarati:
        return 'ગુજરાતી';
    }
  }

  /// National flag emoji representation.
  String get flagEmoji {
    switch (this) {
      case AppLanguage.english:
        return '🇬🇧';
      case AppLanguage.hindi:
        return '🇮🇳';
      case AppLanguage.gujarati:
        return '🇮🇳';
    }
  }

  /// Formatted language subtitle.
  String get displayLabel => '$nativeName ($englishName)';

  /// Converts ISO language code to [AppLanguage]. Defaults to English.
  static AppLanguage fromCode(String code) {
    switch (code.toLowerCase().trim()) {
      case 'hi':
        return AppLanguage.hindi;
      case 'gu':
        return AppLanguage.gujarati;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }
}
