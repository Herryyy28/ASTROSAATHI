import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_language.dart';

export '../../l10n/app_language.dart';

class LocaleNotifier extends StateNotifier<AppLanguage> {
  LocaleNotifier() : super(AppLanguage.english) {
    _loadSavedLanguage();
  }

  static const String _prefKey = 'preferred_language';

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null) {
        state = AppLanguageExtension.fromCode(savedCode);
      }
    } catch (_) {}
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, language.code);
    } catch (_) {}
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, AppLanguage>((ref) {
  return LocaleNotifier();
});
