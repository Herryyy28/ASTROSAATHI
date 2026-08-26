import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Reusable decoration presets for the AstroSaathi premium design system.
class AppDecorations {
  // ── Glassmorphic Card ───────────────────────────────────────────────
  static BoxDecoration get glassCard => BoxDecoration(
    color: AppColors.glassSurface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.glassBorder, width: 0.5),
  );

  static BoxDecoration glassCardCustom({
    double radius = 20,
    Color? borderColor,
    double borderWidth = 0.5,
  }) => BoxDecoration(
    color: AppColors.glassSurface,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: borderColor ?? AppColors.glassBorder,
      width: borderWidth,
    ),
  );

  // ── Glowing Card ──────────────────────────────────────────────────
  static BoxDecoration glowCard({
    Color glowColor = const Color(0x40D4AF37),
    double radius = 20,
  }) => BoxDecoration(
    color: AppColors.surfaceDark,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: glowColor.withOpacity(0.3), width: 0.5),
    boxShadow: [
      BoxShadow(color: glowColor, blurRadius: 20, spreadRadius: -4),
    ],
  );

  // ── Gradient Card ─────────────────────────────────────────────────
  static BoxDecoration get gradientCard => BoxDecoration(
    gradient: AppColors.cardGradient,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.glassBorder, width: 0.5),
  );

  // ── Premium Energy Card ───────────────────────────────────────────
  static BoxDecoration get energyCard => BoxDecoration(
    gradient: AppColors.premiumGradient,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: AppColors.glassBorder, width: 0.5),
    boxShadow: AppColors.goldGlowShadow,
  );

  // ── Colored Accent Card (left border accent) ─────────────────────
  static BoxDecoration accentCard({
    required Color accentColor,
    double radius = 16,
  }) => BoxDecoration(
    color: AppColors.surfaceDark,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: AppColors.glassBorder, width: 0.5),
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
    hintStyle: const TextStyle(color: AppColors.textTertiaryDark),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
