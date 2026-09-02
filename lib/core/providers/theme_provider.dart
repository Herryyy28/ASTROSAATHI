import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  system('system', 'System Default', Icons.brightness_auto_rounded),
  light('light', 'Light Mode', Icons.light_mode_rounded),
  dark('dark', 'Dark Cosmic Mode', Icons.dark_mode_rounded);

  final String code;
  final String label;
  final IconData icon;

  const AppThemeMode(this.code, this.label, this.icon);

  ThemeMode get mode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static AppThemeMode fromCode(String? code) {
    switch (code) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
        return AppThemeMode.system;
      default:
        return AppThemeMode.system;
    }
  }
}

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.system) {
    _loadSavedThemeMode();
  }

  static const String _prefKey = 'preferred_theme_mode';

  Future<void> _loadSavedThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefKey);
      if (savedCode != null) {
        state = AppThemeMode.fromCode(savedCode);
      }
    } catch (_) {}
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    state = themeMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, themeMode.code);
    } catch (_) {}
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>((ref) {
  return ThemeModeNotifier();
});
