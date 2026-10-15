import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/design_tokens.dart';

/// Legacy-compatible card surface backed by the AstroSaathi design system.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? borderColor;
  final Color? glowColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderColor,
    this.glowColor,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.surfaceLight;
    final defaultBorderColor = AppColors.borderLight;
    final radiusValue = borderRadius ?? AppRadius.card;

    final card = Container(
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: gradient == null ? cardColor : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radiusValue),
        border: Border.all(
          color: borderColor ?? defaultBorderColor,
          width: 1.0,
        ),
        boxShadow: [
          if (glowColor != null)
            BoxShadow(color: glowColor!, blurRadius: 16, spreadRadius: -2),
          const BoxShadow(
            color: Color(0x0D25283A),
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radiusValue),
          splashColor: AppColors.getPrimary(context).withValues(alpha: 0.12),
          highlightColor: AppColors.highlightSurface.withValues(alpha: 0.35),
          child: card,
        ),
      );
    }
    return card;
  }
}
