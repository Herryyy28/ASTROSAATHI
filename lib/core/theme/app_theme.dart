import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'design_tokens.dart';

/// Single Source of Truth ThemeData specifications for Light and Dark modes.
class AppTheme {
  // ── Light Theme Specifications (Fixed Warm Neutral #F7F7F5) ────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLightMode,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.errorLight,
        onPrimary: AppColors.textPrimaryLight,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.display(color: AppColors.textPrimaryLight),
        displayMedium: AppTypography.headline(color: AppColors.textPrimaryLight),
        titleLarge: AppTypography.title(color: AppColors.textPrimaryLight),
        titleMedium: AppTypography.title(color: AppColors.textPrimaryLight),
        bodyLarge: AppTypography.body(color: AppColors.textPrimaryLight),
        bodyMedium: AppTypography.body(color: AppColors.textSecondaryLight),
        bodySmall: AppTypography.caption(color: AppColors.textMutedLight),
        labelLarge: AppTypography.label(color: AppColors.textPrimaryLight),
        labelSmall: AppTypography.caption(color: AppColors.textSecondaryLight),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title(color: AppColors.textPrimaryLight),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderCard,
          side: const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLightMode,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderButton,
          ),
          textStyle: AppTypography.label(color: AppColors.textPrimaryLight),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedLight,
        hintStyle: AppTypography.body(color: AppColors.textMutedLight),
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(color: AppColors.borderLight, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(color: AppColors.primaryLightMode, width: 1.5),
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // ── Dark Theme Specifications (Fixed Deep Navy #090D16) ────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDarkMode,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.errorDark,
        onPrimary: AppColors.textPrimaryLight,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
        onError: Colors.white,
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.display(color: AppColors.textPrimaryDark),
        displayMedium: AppTypography.headline(color: AppColors.textPrimaryDark),
        titleLarge: AppTypography.title(color: AppColors.textPrimaryDark),
        titleMedium: AppTypography.title(color: AppColors.textPrimaryDark),
        bodyLarge: AppTypography.body(color: AppColors.textPrimaryDark),
        bodyMedium: AppTypography.body(color: AppColors.textSecondaryDark),
        bodySmall: AppTypography.caption(color: AppColors.textMutedDark),
        labelLarge: AppTypography.label(color: AppColors.textPrimaryDark),
        labelSmall: AppTypography.caption(color: AppColors.textSecondaryDark),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.title(color: AppColors.textPrimaryDark),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderCard,
          side: const BorderSide(color: AppColors.borderDark, width: 1.0),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDarkMode,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderButton,
          ),
          textStyle: AppTypography.label(color: AppColors.textPrimaryLight),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedDark,
        hintStyle: AppTypography.body(color: AppColors.textMutedDark),
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(color: AppColors.borderDark, width: 0.8),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(color: AppColors.borderDark, width: 0.8),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(color: AppColors.primaryDarkMode, width: 1.5),
        ),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
