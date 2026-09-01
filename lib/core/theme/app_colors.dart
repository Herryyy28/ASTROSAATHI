import 'package:flutter/material.dart';

class AppColors {
  // ── Core Dark Surface Palette ──────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0A0C16);
  static const Color surfaceDark = Color(0xFF121626);
  static const Color surfaceHighlightDark = Color(0xFF191F34);
  static const Color surfaceElevated = Color(0xFF1C2337);

  // ── Glassmorphism ──────────────────────────────────────────────────
  static const Color glassSurface = Color(0x24FFFFFF); // 14% white tint
  static const Color glassBorder = Color(0x3BFFFFFF); // 23% white border
  static const Color glassHighlight = Color(0x14FFFFFF); // 8% white

  // ── Accent Colors (Authentic Solar Gold & Celestial Azure) ────────
  static const Color primary = Color(0xFFE5B842); // Solar Gold / Sun
  static const Color primaryLight = Color(0xFFF2C95D);
  static const Color ivory = Color(0xFFF6E8C3); // Warm Ivory
  static const Color warmGold = Color(0xFFE5B842); // Solar Gold
  static const Color secondary = Color(0xFF38BDF8); // Celestial Azure
  static const Color secondaryLight = Color(0xFF7DD3FC);
  static const Color tertiary = Color(0xFF3B82F6); // Ethereal Blue

  // ── Glow Colors (for ambient lighting / shadows) ──────────────────
  static const Color goldGlow = Color(0x35E5B842);
  static const Color purpleGlow = Color(0x3538BDF8); // Celestial Azure glow
  static const Color blueGlow = Color(0x353B82F6);
  static const Color goldGlowStrong = Color(0x70E5B842);

  // ── Status Colors ─────────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color successGlow = Color(0x2534C759);
  static const Color warning = Color(0xFFFF9500);
  static const Color warningGlow = Color(0x25FF9500);
  static const Color error = Color(0xFFFF3B30);
  static const Color errorGlow = Color(0x25FF3B30);

  // ── Text (Pure High-Contrast White & Slate White) ─────────────────
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFCBD5E1);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // ── Gradients ─────────────────────────────────────────────────────
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF0C0F1E), Color(0xFF141A33), Color(0xFF0E1A38)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFF0A0C16), Color(0xFF111827), Color(0xFF0A1526)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE5B842), Color(0xFFD4AF37), Color(0xFFC99B2A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldSubtleGradient = LinearGradient(
    colors: [Color(0x28E5B842), Color(0x12D4AF37)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFF2C3E50), Color(0xFFFD746C)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161C2E), Color(0xFF111626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient cosmicRadialGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [Color(0xFF151D2A), Color(0xFF0E1322), Color(0xFF0A0C16)],
  );

  // ── Shadows ───────────────────────────────────────────────────────
  static List<BoxShadow> get goldGlowShadow => [
    BoxShadow(color: goldGlow, blurRadius: 20, spreadRadius: 0),
  ];

  static List<BoxShadow> get purpleGlowShadow => [
    BoxShadow(color: purpleGlow, blurRadius: 20, spreadRadius: 0),
  ];

  static List<BoxShadow> get subtleLiftShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.35),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.22),
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
