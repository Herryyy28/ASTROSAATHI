import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Executive Professional Dynamic Brand Logo Widget for AstroSaathi
/// Combines a 3D metallic gold cosmic emblem with animated shimmer & typography.
/// ─────────────────────────────────────────────────────────────────────────────
class AppBrandLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  final bool showText;
  final bool isHorizontal;
  final VoidCallback? onTap;

  const AppBrandLogo({
    super.key,
    this.iconSize = 44,
    this.fontSize = 22,
    this.showText = true,
    this.isHorizontal = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    final logoIcon = Container(
      width: iconSize,
      height: iconSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2B200E), Color(0xFF140E05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFFFD700),
          width: iconSize > 60 ? 2.2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x70FFD700),
            blurRadius: iconSize * 0.4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/icon/app_icon.png',
              width: iconSize,
              height: iconSize,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Center(
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: iconSize * 0.52,
                  color: const Color(0xFFFFD700),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 3000.ms, color: Colors.white.withOpacity(0.35))
        .scale(
          begin: const Offset(0.98, 0.98),
          end: const Offset(1.02, 1.02),
          duration: 1800.ms,
          curve: Curves.easeInOut,
        );

    if (!showText) {
      return GestureDetector(onTap: onTap, child: logoIcon);
    }

    final brandText = ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: isLight
            ? [
                const Color(0xFF1A1407),
                const Color(0xFFB8860B),
                const Color(0xFFD4AF37),
              ]
            : [
                const Color(0xFFFFFFFF),
                const Color(0xFFFFE899),
                const Color(0xFFFFD700),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        'AstroSaathi',
        style: GoogleFonts.outfit(
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: Colors.white,
        ),
      ),
    );

    final content = isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              logoIcon,
              SizedBox(width: iconSize * 0.3),
              brandText,
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              logoIcon,
              SizedBox(height: iconSize * 0.25),
              brandText,
            ],
          );

    return GestureDetector(onTap: onTap, child: content);
  }
}
