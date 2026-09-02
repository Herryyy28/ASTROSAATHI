import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Displays a zodiac sign emoji with an optional glow ring.
class ZodiacIcon extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final emoji = AppColors.zodiacEmojis[sign] ?? '⭐';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      width: size + 16,
      height: size + 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? AppColors.primary.withOpacity(0.15)
            : AppColors.getGlassSurface(context),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.getGlassBorder(context),
          width: isSelected ? 1.5 : 0.5,
        ),
        boxShadow: showGlow || isSelected
            ? [BoxShadow(color: AppColors.goldGlow, blurRadius: 16, spreadRadius: -4)]
            : null,
      ),
      child: Center(
        child: Text(
          emoji,
          style: TextStyle(fontSize: size * 0.55),
        ),
      ),
    );
  }
}
