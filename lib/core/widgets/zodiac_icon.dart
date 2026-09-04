import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Authentic Native Human-Crafted Astrological Icon & Button System
/// Clean, tactile, high-precision Material 3 / iOS design with natural press
/// feedback, crisp typography, and theme-adaptive palettes.
/// ─────────────────────────────────────────────────────────────────────────────

/// Precise Astrological Symbols & Palettes
class ZodiacSymbols {
  static const Map<String, String> glyphs = {
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

  static const Map<String, Color> signAccentColors = {
    'Aries': Color(0xFFEF4444),
    'Taurus': Color(0xFF10B981),
    'Gemini': Color(0xFFF59E0B),
    'Cancer': Color(0xFF0EA5E9),
    'Leo': Color(0xFFD97706),
    'Virgo': Color(0xFF059669),
    'Libra': Color(0xFFEC4899),
    'Scorpio': Color(0xFFE11D48),
    'Sagittarius': Color(0xFF9333EA),
    'Capricorn': Color(0xFF64748B),
    'Aquarius': Color(0xFF2563EB),
    'Pisces': Color(0xFF4F46E5),
  };
}

/// Clean Human-Crafted Zodiac Icon Tile Widget
class ZodiacIcon extends StatefulWidget {
  final String sign;
  final double size;
  final bool showGlow;
  final bool isSelected;

  const ZodiacIcon({
    super.key,
    required this.sign,
    this.size = 32,
    this.showGlow = false,
    this.isSelected = false,
  });

  @override
  State<ZodiacIcon> createState() => _ZodiacIconState();
}

class _ZodiacIconState extends State<ZodiacIcon> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final symbol = ZodiacSymbols.glyphs[widget.sign] ?? AppColors.zodiacEmojis[widget.sign] ?? '✦';
    final accentColor = ZodiacSymbols.signAccentColors[widget.sign] ?? AppColors.primary;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final bgColor = widget.isSelected
        ? accentColor.withOpacity(isLight ? 0.15 : 0.25)
        : (isLight ? AppColors.surfaceElevatedLight : const Color(0xFF161E2E));

    final borderColor = widget.isSelected
        ? accentColor
        : (isLight ? AppColors.borderLight : const Color(0xFF273246));

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : (widget.isSelected ? 1.05 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size + 16,
          height: widget.size + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(
              color: borderColor,
              width: widget.isSelected ? 1.8 : 1.0,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              symbol,
              style: GoogleFonts.outfit(
                fontSize: widget.size * 0.58,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w600,
                color: widget.isSelected
                    ? accentColor
                    : (isLight ? AppColors.textPrimaryLight : AppColors.textPrimaryDark),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Clean Universal Native Icon Button Widget for Feature Cards & Tools
class CosmicIconBadge extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color? color;
  final bool isGlowing;
  final VoidCallback? onTap;

  const CosmicIconBadge({
    super.key,
    required this.icon,
    this.size = 20,
    this.color,
    this.isGlowing = false,
    this.onTap,
  });

  @override
  State<CosmicIconBadge> createState() => _CosmicIconBadgeState();
}

class _CosmicIconBadgeState extends State<CosmicIconBadge> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final accent = widget.color ?? AppColors.primary;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final badgeContainer = AnimatedScale(
      scale: _isPressed ? 0.92 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: widget.size + 18,
        height: widget.size + 18,
        decoration: BoxDecoration(
          color: accent.withOpacity(isLight ? 0.12 : 0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accent.withOpacity(isLight ? 0.35 : 0.45),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.size,
            color: accent,
          ),
        ),
      ),
    );

    if (widget.onTap == null) {
      return badgeContainer;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        try {
          HapticFeedback.selectionClick();
        } catch (_) {}
        widget.onTap!();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: badgeContainer,
    );
  }
}
