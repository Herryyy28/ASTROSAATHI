import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/design_tokens.dart';

/// Single Source of Truth Card component implementing the Blinkit card system.
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
    final cardColor = AppColors.getSurface(context);
    final defaultBorderColor = AppColors.getBorder(context);
    final isLight = AppColors.isLight(context);
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
            BoxShadow(
              color: glowColor!,
              blurRadius: 16,
              spreadRadius: -2,
            ),
          BoxShadow(
            color: Colors.black.withOpacity(isLight ? 0.03 : 0.25),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
          splashColor: AppColors.getPrimary(context).withOpacity(0.12),
          highlightColor: isLight ? Colors.black.withOpacity(0.04) : AppColors.glassHighlight,
          child: card,
        ),
      );
    }
    return card;
  }
}
