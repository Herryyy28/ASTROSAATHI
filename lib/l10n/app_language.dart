import 'package:flutter/material.dart';

/// Supported application languages in AstroSaathi.
enum AppLanguage {
  english,
  hindi,
  tamil,
  kannada,
  malayalam,
  gujarati,
  marathi,
  bengali,
  telugu,
}

extension AppLanguageExtension on AppLanguage {
  /// Two-letter ISO language code.
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.hindi:
        return 'hi';
      case AppLanguage.tamil:
        return 'ta';
      case AppLanguage.kannada:
        return 'kn';
      case AppLanguage.malayalam:
        return 'ml';
      case AppLanguage.gujarati:
        return 'gu';
      case AppLanguage.marathi:
        return 'mr';
      case AppLanguage.bengali:
        return 'bn';
      case AppLanguage.telugu:
        return 'te';
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
      case AppLanguage.tamil:
        return 'Tamil';
      case AppLanguage.kannada:
        return 'Kannada';
      case AppLanguage.malayalam:
        return 'Malayalam';
      case AppLanguage.gujarati:
        return 'Gujarati';
      case AppLanguage.marathi:
        return 'Marathi';
      case AppLanguage.bengali:
        return 'Bengali';
      case AppLanguage.telugu:
        return 'Telugu';
    }
  }

  /// Native language display name.
  String get nativeName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिन्दी';
      case AppLanguage.tamil:
        return 'தமிழ்';
      case AppLanguage.kannada:
        return 'ಕನ್ನಡ';
      case AppLanguage.malayalam:
        return 'മലയാളം';
      case AppLanguage.gujarati:
        return 'ગુજરાતી';
      case AppLanguage.marathi:
        return 'मराठी';
      case AppLanguage.bengali:
        return 'বাংলা';
      case AppLanguage.telugu:
        return 'తెలుగు';
    }
  }

  /// National flag emoji representation.
  String get flagEmoji {
    switch (this) {
      case AppLanguage.english:
        return '🇬🇧';
      case AppLanguage.hindi:
      case AppLanguage.tamil:
      case AppLanguage.kannada:
      case AppLanguage.malayalam:
      case AppLanguage.gujarati:
      case AppLanguage.marathi:
      case AppLanguage.bengali:
      case AppLanguage.telugu:
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
      case 'ta':
        return AppLanguage.tamil;
      case 'kn':
        return AppLanguage.kannada;
      case 'ml':
        return AppLanguage.malayalam;
      case 'gu':
        return AppLanguage.gujarati;
      case 'mr':
        return AppLanguage.marathi;
      case 'bn':
        return AppLanguage.bengali;
      case 'te':
        return AppLanguage.telugu;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }
}
