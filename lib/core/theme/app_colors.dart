import 'package:flutter/material.dart';

class AppColors {
  // ── Core Dark Surface Palette ──────────────────────────────────────
  static const Color backgroundDark = Color(0xFF060810);
  static const Color surfaceDark = Color(0xFF0F1219);
  static const Color surfaceHighlightDark = Color(0xFF1A1E2E);
  static const Color surfaceElevated = Color(0xFF161A28);

  // ── Glassmorphism ──────────────────────────────────────────────────
  static const Color glassSurface = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color glassHighlight = Color(0x0DFFFFFF); // 5% white

  // ── Accent Colors ─────────────────────────────────────────────────
  static const Color primary = Color(0xFFD4AF37); // Gold / Sun
  static const Color primaryLight = Color(0xFFE8C84A);
  static const Color ivory = Color(0xFFF4E4BC); // Warm Ivory
  static const Color warmGold = Color(0xFFF7D070); // Radiant Gold
  static const Color secondary = Color(0xFF7B61FF); // Cosmic Purple
  static const Color secondaryLight = Color(0xFF9B85FF);
  static const Color tertiary = Color(0xFF4A90E2); // Ethereal Blue

  // ── Glow Colors (for ambient lighting / shadows) ──────────────────
  static const Color goldGlow = Color(0x40D4AF37);
  static const Color purpleGlow = Color(0x407B61FF);
  static const Color blueGlow = Color(0x404A90E2);
  static const Color goldGlowStrong = Color(0x80D4AF37);

  // ── Status Colors ─────────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color successGlow = Color(0x3034C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color warningGlow = Color(0x30FF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color errorGlow = Color(0x30FF3B30);

  // ── Text ──────────────────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryDark = Color(0xFF8E91A4);
  static const Color textTertiaryDark = Color(0xFF5A5D6F);

  // ── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF0A0D1A), Color(0xFF111633), Color(0xFF0D1B3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFF0A0D1A), Color(0xFF15103A), Color(0xFF0A1628)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFE8C84A), Color(0xFFF0D060)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldSubtleGradient = LinearGradient(
    colors: [Color(0x30D4AF37), Color(0x15E8C84A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF7B61FF), Color(0xFF9B85FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFF2C3E50), Color(0xFFFD746C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF141826), Color(0xFF0E1118)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient cosmicRadialGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [Color(0xFF1A1040), Color(0xFF0A0D1A), Color(0xFF060810)],
  );

  // ── Shadows ───────────────────────────────────────────────────────
  static List<BoxShadow> get goldGlowShadow => [
    BoxShadow(color: goldGlow, blurRadius: 24, spreadRadius: 0),
  ];

  static List<BoxShadow> get purpleGlowShadow => [
    BoxShadow(color: purpleGlow, blurRadius: 24, spreadRadius: 0),
  ];

  static List<BoxShadow> get subtleLiftShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ── Zodiac Emoji Map ──────────────────────────────────────────────
  static const Map<String, String> zodiacEmojis = {
    'Aries': '♈',
    'Taurus': '♉',
    'Gemini': '♊',
    'Cancer': '♋',
    'Leo': '♌',
    'Virgo': '♍',
    'Libra': '♎',
    'Scorpio': '♏',
    'Sagittarius': '♐',
    'Capricorn': '♑',
    'Aquarius': '♒',
    'Pisces': '♓',
  };

  // ── Muhurat Category Icons ────────────────────────────────────────
  static const Map<String, IconData> muhuratIcons = {
    'Business': Icons.business_center_rounded,
    'Meeting': Icons.groups_rounded,
    'Travel': Icons.flight_takeoff_rounded,
    'Investment': Icons.trending_up_rounded,
    'Contract': Icons.description_rounded,
    'Marriage': Icons.favorite_rounded,
    'Property': Icons.home_work_rounded,
  };
}
