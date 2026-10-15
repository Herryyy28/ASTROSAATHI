import 'package:flutter/material.dart';

/// Authoritative Lovable palette for AstroSaathi.
abstract final class AppColors {
  static const Color backgroundLight = Color(0xFFF7F7FC);
  static const Color secondaryBackground = Color(0xFFEEF0FA);
  static const Color softLavender = Color(0xFFE6E7F5);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color highlightSurface = Color(0xFFD7DBF4);
  static const Color primaryLightMode = Color(0xFF3F4DB8);
  static const Color secondary = Color(0xFF7668D8);
  static const Color actionPurple = Color(0xFFA75BEA);
  static const Color pink = Color(0xFFE96AC5);
  static const Color textPrimaryLight = Color(0xFF25283A);
  static const Color textSecondaryLight = Color(0xFF6F748D);

  static const Color surfaceElevatedLight = secondaryBackground;
  static const Color surfaceSecondaryLight = softLavender;
  static const Color borderLight = softLavender;
  static const Color dividerLight = softLavender;
  static const Color textMutedLight = textSecondaryLight;
  static const Color primaryDarkLightMode = primaryLightMode;
  static const Color primarySoftLight = highlightSurface;
  static const Color successLight = secondary;
  static const Color warningLight = pink;
  static const Color errorLight = pink;
  static const Color infoLight = secondary;

  // Compatibility aliases keep older feature widgets on the same palette.
  static const Color backgroundDark = backgroundLight;
  static const Color surfaceDark = surfaceLight;
  static const Color surfaceSecondaryDark = secondaryBackground;
  static const Color surfaceElevatedDark = softLavender;
  static const Color primaryDarkMode = primaryLightMode;
  static const Color primaryDarkDarkMode = primaryLightMode;
  static const Color primarySoftDark = highlightSurface;
  static const Color premiumPlum = secondary;
  static const Color textPrimaryDark = textPrimaryLight;
  static const Color textSecondaryDark = textSecondaryLight;
  static const Color textMutedDark = textSecondaryLight;
  static const Color borderDark = softLavender;
  static const Color dividerDark = softLavender;
  static const Color successDark = successLight;
  static const Color warningDark = warningLight;
  static const Color errorDark = errorLight;
  static const Color infoDark = infoLight;
  static const Color primary = primaryLightMode;
  static const Color primaryLight = secondary;
  static const Color cardSurface = surfaceLight;
  static const Color cardHighlight = highlightSurface;
  static const Color surfaceElevated = softLavender;
  static const Color surfaceHighlightDark = highlightSurface;
  static const Color glassSurface = surfaceLight;
  static const Color glassBorder = softLavender;
  static const Color glassHighlight = Color(0x66FFFFFF);
  static const Color goldGlow = Color(0x263F4DB8);
  static const Color purpleGlow = Color(0x267668D8);
  static const Color textTertiaryDark = textSecondaryLight;
  static const Color textTertiaryLight = textSecondaryLight;
  static const Color success = successLight;
  static const Color warning = warningLight;
  static const Color error = errorLight;
  static const Color info = infoLight;
  static const Color tertiary = actionPurple;

  static bool isLight(BuildContext context) => true;
  static Color getBackground(BuildContext context) => backgroundLight;
  static Color getSurface(BuildContext context) => surfaceLight;
  static Color getGlassSurface(BuildContext context) => surfaceLight;
  static Color getGlassBorder(BuildContext context) => borderLight;
  static Color getDynamicSurface(BuildContext context) => surfaceLight;
  static Color getSurfaceElevated(BuildContext context) => surfaceElevatedLight;
  static Color getSurfaceSecondary(BuildContext context) =>
      surfaceSecondaryLight;
  static Color getBorder(BuildContext context) => borderLight;
  static Color getDivider(BuildContext context) => dividerLight;
  static Color getPrimary(BuildContext context) => primaryLightMode;
  static Color getPrimaryDarkToken(BuildContext context) => primaryLightMode;
  static Color getPrimarySoft(BuildContext context) => primarySoftLight;
  static Color getAccentSoft(BuildContext context) => primarySoftLight;
  static Color getTextPrimary(BuildContext context) => textPrimaryLight;
  static Color getDynamicTextPrimary(BuildContext context) => textPrimaryLight;
  static Color getTextSecondary(BuildContext context) => textSecondaryLight;
  static Color getDynamicTextSecondary(BuildContext context) =>
      textSecondaryLight;
  static Color getTextMuted(BuildContext context) => textMutedLight;
  static Color getSuccess(BuildContext context) => successLight;
  static Color getWarning(BuildContext context) => warningLight;
  static Color getError(BuildContext context) => errorLight;
  static Color getInfo(BuildContext context) => infoLight;

  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [backgroundLight, secondaryBackground, backgroundLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient cosmicRadialGradient = LinearGradient(
    colors: [backgroundLight, secondaryBackground],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient goldGradient = LinearGradient(
    colors: [secondary, actionPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient goldSubtleGradient = LinearGradient(
    colors: [highlightSurface, softLavender],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [highlightSurface, softLavender],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [secondary, actionPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient cardGradient = LinearGradient(
    colors: [surfaceLight, secondaryBackground],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient getDynamicCosmicGradient(BuildContext context) =>
      cosmicGradient;
  static LinearGradient getCardGradient(BuildContext context) => cardGradient;
  static const List<BoxShadow> goldGlowShadow = [
    BoxShadow(color: Color(0x183F4DB8), blurRadius: 18, offset: Offset(0, 8)),
  ];
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
  static const Map<String, IconData> muhuratIcons = {
    'Marriage': Icons.favorite_outline,
    'Business': Icons.business_center_outlined,
    'Travel': Icons.flight_takeoff_outlined,
    'Property': Icons.home_work_outlined,
    'Education': Icons.school_outlined,
    'Health': Icons.health_and_safety_outlined,
  };
}
