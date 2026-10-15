import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_colors.dart';
import 'design_tokens.dart';

/// Single source of truth for the fixed AstroSaathi light experience.
class AppTheme {
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
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
        onError: Colors.white,
      ),

      textTheme: TextTheme(
        displayLarge: AppTypography.display(color: AppColors.textPrimaryLight),
        displayMedium: AppTypography.headline(
          color: AppColors.textPrimaryLight,
        ),
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
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
          textStyle: AppTypography.label(color: Colors.white),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLightMode,
          side: const BorderSide(color: AppColors.borderLight),
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLightMode,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
        ),
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryLightMode
              : AppColors.surfaceLight,
        ),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: const BorderSide(color: AppColors.borderLight, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedColor: AppColors.highlightSurface,
        side: const BorderSide(color: AppColors.borderLight),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderPill),
        labelStyle: AppTypography.caption(color: AppColors.textSecondaryLight),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
        space: 1,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderModal),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        modalBackgroundColor: AppColors.surfaceLight,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.borderLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.modal),
          ),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primaryLightMode,
        linearTrackColor: AppColors.softLavender,
        circularTrackColor: AppColors.softLavender,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevatedLight,
        hintStyle: AppTypography.body(color: AppColors.textMutedLight),
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(
            color: AppColors.borderLight,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderInput,
          borderSide: const BorderSide(
            color: AppColors.primaryLightMode,
            width: 1.5,
          ),
        ),
      ),

      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.primaryLightMode,
        labelColor: AppColors.primaryLightMode,
        unselectedLabelColor: AppColors.textSecondaryLight,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        indicatorSize: TabBarIndicatorSize.label,
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
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryLightMode,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.errorDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
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
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
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
          borderSide: const BorderSide(
            color: AppColors.primaryDarkMode,
            width: 1.5,
          ),
        ),
      ),

      tabBarTheme: const TabBarThemeData(
        indicatorColor: AppColors.primaryDarkMode,
        labelColor: AppColors.primaryDarkMode,
        unselectedLabelColor: AppColors.textSecondaryDark,
        dividerColor: Colors.transparent,
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
        indicatorSize: TabBarIndicatorSize.label,
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
