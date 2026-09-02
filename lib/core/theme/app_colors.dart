import 'package:flutter/material.dart';

/// Single Source of Truth Color Architecture for AstroSaathi.
/// Implements the exact fixed Light (#F7F7F5) and Dark (#090D16) semantic palettes.
class AppColors {
  // ── Light Theme Palette Tokens (Fixed Warm Neutral) ───────────────
  static const Color backgroundLight = Color(0xFFF7F7F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceElevatedLight = Color(0xFFF1F2F4);
  static const Color surfaceSecondaryLight = Color(0xFFF1F2F4);
  static const Color primaryLightMode = Color(0xFFD9901A);
  static const Color primaryDarkLightMode = Color(0xFFB87308);
  static const Color primarySoftLight = Color(0xFFFFF0D3);
  static const Color textPrimaryLight = Color(0xFF172033);
  static const Color textSecondaryLight = Color(0xFF424B5A);
  static const Color textMutedLight = Color(0xFF545E6E);
  static const Color borderLight = Color(0xFFDEE2E7);
  static const Color dividerLight = Color(0xFFE8EAED);
  static const Color successLight = Color(0xFF2E8B68);
  static const Color warningLight = Color(0xFFC58A1A);
  static const Color errorLight = Color(0xFFC95353);
  static const Color infoLight = Color(0xFF4D78A8);

  // ── Dark Theme Palette Tokens (Fixed Deep Charcoal Navy) ───────────
  static const Color backgroundDark = Color(0xFF090D16);
  static const Color surfaceDark = Color(0xFF111827);
  static const Color surfaceSecondaryDark = Color(0xFF151D2C);
  static const Color surfaceElevatedDark = Color(0xFF182132);
  static const Color primaryDarkMode = Color(0xFFE0A13A);
  static const Color primaryDarkDarkMode = Color(0xFFB87917);
  static const Color primarySoftDark = Color(0xFF332817);
  static const Color textPrimaryDark = Color(0xFFF4F6F8);
  static const Color textSecondaryDark = Color(0xFFAAB3C2);
  static const Color textMutedDark = Color(0xFF737E91);
  static const Color borderDark = Color(0xFF273246);
  static const Color dividerDark = Color(0xFF202A3A);
  static const Color successDark = Color(0xFF45A77D);
  static const Color warningDark = Color(0xFFD6A044);
  static const Color errorDark = Color(0xFFDE6B6B);
  static const Color infoDark = Color(0xFF70A0D4);

  // ── Static Brand & Backward Compatibility Constants ────────────────
  static const Color primary = Color(0xFFE0A13A);
  static const Color primaryLight = Color(0xFFE5A63C);
  static const Color secondary = Color(0xFFD9901A);
  static const Color secondaryLight = Color(0xFFF5B041);
  static const Color secondaryBackground = Color(0xFF151D2C);
  static const Color cardSurface = Color(0xFF111827);
  static const Color cardHighlight = Color(0xFF182132);
  static const Color surfaceElevated = Color(0xFF182132);
  static const Color surfaceHighlightDark = Color(0xFF182132);
  static const Color glassSurface = Color(0xFF111827);
  static const Color glassBorder = Color(0xFF273246);
  static const Color glassHighlight = Color(0x1AFFFFFF);

  static const Color goldGlow = Color(0x1CE0A13A);
  static const Color purpleGlow = Color(0x1CE0A13A);

  static const Color textTertiaryDark = Color(0xFF737E91);
  static const Color textTertiaryLight = Color(0xFF545E6E);

  static const Color success = Color(0xFF45A77D);
  static const Color warning = Color(0xFFD6A044);
  static const Color error = Color(0xFFDE6B6B);
  static const Color info = Color(0xFF70A0D4);
  static const Color tertiary = Color(0xFF70A0D4);

  // ── Centralized Dynamic Token Getters ──────────────────────────────
  static bool isLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light;

  static Color getBackground(BuildContext context) =>
      isLight(context) ? backgroundLight : backgroundDark;

  static Color getSurface(BuildContext context) =>
      isLight(context) ? surfaceLight : surfaceDark;

  static Color getGlassSurface(BuildContext context) =>
      isLight(context) ? surfaceLight : glassSurface;

  static Color getGlassBorder(BuildContext context) =>
      isLight(context) ? borderLight : glassBorder;

  static Color getDynamicSurface(BuildContext context) => getSurface(context);

  static Color getSurfaceElevated(BuildContext context) =>
      isLight(context) ? surfaceElevatedLight : surfaceElevatedDark;

  static Color getSurfaceSecondary(BuildContext context) =>
      isLight(context) ? surfaceSecondaryLight : surfaceSecondaryDark;

  static Color getBorder(BuildContext context) =>
      isLight(context) ? borderLight : borderDark;

  static Color getDivider(BuildContext context) =>
      isLight(context) ? dividerLight : dividerDark;

  static Color getPrimary(BuildContext context) =>
      isLight(context) ? primaryLightMode : primaryDarkMode;

  static Color getPrimaryDarkToken(BuildContext context) =>
      isLight(context) ? primaryDarkLightMode : primaryDarkDarkMode;

  static Color getPrimarySoft(BuildContext context) =>
      isLight(context) ? primarySoftLight : primarySoftDark;

  static Color getAccentSoft(BuildContext context) => getPrimarySoft(context);

  static Color getTextPrimary(BuildContext context) =>
      isLight(context) ? textPrimaryLight : textPrimaryDark;

  static Color getDynamicTextPrimary(BuildContext context) => getTextPrimary(context);

  static Color getTextSecondary(BuildContext context) =>
      isLight(context) ? textSecondaryLight : textSecondaryDark;

  static Color getDynamicTextSecondary(BuildContext context) => getTextSecondary(context);

  static Color getTextMuted(BuildContext context) =>
      isLight(context) ? textMutedLight : textMutedDark;

  static Color getSuccess(BuildContext context) =>
      isLight(context) ? successLight : successDark;

  static Color getWarning(BuildContext context) =>
      isLight(context) ? warningLight : warningDark;

  static Color getError(BuildContext context) =>
      isLight(context) ? errorLight : errorDark;

  static Color getInfo(BuildContext context) =>
      isLight(context) ? infoLight : infoDark;

  static LinearGradient getDynamicCosmicGradient(BuildContext context) {
    if (isLight(context)) {
      return const LinearGradient(
        colors: [Color(0xFFF7F7F5), Color(0xFFF1F2F4), Color(0xFFFFFFFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
    return cosmicGradient;
  }

  // ── Simple Controlled Gradients ───────────────────────────────────
  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFF090D16), Color(0xFF111827), Color(0xFF090D16)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFE0A13A), Color(0xFFD9901A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldSubtleGradient = LinearGradient(
    colors: [Color(0x1CE0A13A), Color(0x0DD9901A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF090D16), Color(0xFF111827), Color(0xFF182132)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFE0A13A), Color(0xFFD9901A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF111827), Color(0xFF182132)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient cosmicRadialGradient = RadialGradient(
    center: Alignment.topRight,
    radius: 1.5,
    colors: [Color(0xFF182132), Color(0xFF111827), Color(0xFF090D16)],
  );

  // ── Minimal Ambient Shadows ───────────────────────────────────────
  static List<BoxShadow> get goldGlowShadow => [
    const BoxShadow(color: Color(0x1CE0A13A), blurRadius: 10, spreadRadius: 0),
  ];

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6,
      offset: const Offset(0, 2),
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
