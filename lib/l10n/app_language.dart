enum AppLanguage {
  english,
  hindi,
  gujarati,
}

extension AppLanguageExtension on AppLanguage {
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

  static AppLanguage fromCode(String code) {
    switch (code.toLowerCase()) {
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
