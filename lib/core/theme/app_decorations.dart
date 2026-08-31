import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable decoration presets for the AstroSaathi premium design system.
class AppDecorations {
  // ── Glassmorphic Card (iPhone Glass Aesthetic) ──────────────────────────────
  static BoxDecoration get glassCard => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.12),
        Colors.white.withOpacity(0.04),
      ],
    ),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.18), width: 0.8),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration glassCardCustom({
    double radius = 24,
    Color? borderColor,
    double borderWidth = 0.8,
  }) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withOpacity(0.12),
        Colors.white.withOpacity(0.04),
      ],
    ),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: borderColor ?? Colors.white.withOpacity(0.18),
      width: borderWidth,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // ── Glowing Card ──────────────────────────────────────────────────
  static BoxDecoration glowCard({
    Color glowColor = const Color(0x40D4AF37),
    double radius = 24,
  }) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.surfaceDark.withOpacity(0.9),
        AppColors.surfaceHighlightDark.withOpacity(0.7),
      ],
    ),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: glowColor.withOpacity(0.4), width: 0.8),
    boxShadow: [
      BoxShadow(color: glowColor, blurRadius: 24, spreadRadius: -4),
    ],
  );

  // ── Gradient Card ─────────────────────────────────────────────────
  static BoxDecoration get gradientCard => BoxDecoration(
    gradient: AppColors.cardGradient,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: Colors.white.withOpacity(0.18), width: 0.8),
  );

  // ── Premium Energy Card ───────────────────────────────────────────
  static BoxDecoration get energyCard => BoxDecoration(
    gradient: AppColors.premiumGradient,
    borderRadius: BorderRadius.circular(28),
    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
    boxShadow: AppColors.goldGlowShadow,
  );

  // ── Colored Accent Card (iPhone Glass Style) ──────────────────────
  static BoxDecoration accentCard({
    required Color accentColor,
    double radius = 20,
  }) => BoxDecoration(
    color: AppColors.surfaceHighlightDark.withOpacity(0.4),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: accentColor.withOpacity(0.35), width: 0.8),
    boxShadow: [
      BoxShadow(
        color: accentColor.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // ── Pulsing Glow Border (for warnings / important items) ─────────
  static BoxDecoration alertCard({
    required Color alertColor,
    double radius = 16,
  }) => BoxDecoration(
    color: AppColors.surfaceDark,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: alertColor.withOpacity(0.4), width: 1),
    boxShadow: [
      BoxShadow(color: alertColor.withOpacity(0.15), blurRadius: 16, spreadRadius: -2),
    ],
  );

  // ── Bottom Nav Bar ────────────────────────────────────────────────
  static BoxDecoration get bottomNavBar => BoxDecoration(
    color: AppColors.surfaceDark.withOpacity(0.85),
    border: const Border(
      top: BorderSide(color: AppColors.glassBorder, width: 0.5),
    ),
  );

  // ── Input Field ───────────────────────────────────────────────────
  static InputDecoration premiumInput({
    required String hintText,
    IconData? prefixIcon,
  }) => InputDecoration(
    hintText: hintText,
    prefixIcon: prefixIcon != null
        ? Icon(prefixIcon, color: AppColors.textTertiaryDark, size: 20)
        : null,
    filled: true,
    fillColor: AppColors.surfaceDark,
    isDense: false,
    hintStyle: const TextStyle(color: AppColors.textTertiaryDark, height: 1.2),
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.glassBorder, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: AppColors.glassBorder, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
  );

  // ── Section Header Style ──────────────────────────────────────────
  static TextStyle sectionHeader({Color color = AppColors.primary}) => TextStyle(
    color: color,
    fontWeight: FontWeight.w700,
    fontSize: 12,
    letterSpacing: 1.5,
  );
}
