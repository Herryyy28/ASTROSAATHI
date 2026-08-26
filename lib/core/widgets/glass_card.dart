import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A premium glassmorphic card with frosted background and optional glow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final Color? glowColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
    this.glowColor,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: gradient,
            color: gradient == null ? AppColors.glassSurface : null,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 0.5,
            ),
            boxShadow: glowColor != null
                ? [BoxShadow(color: glowColor!, blurRadius: 20, spreadRadius: -4)]
                : null,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: AppColors.primary.withOpacity(0.1),
          highlightColor: AppColors.glassHighlight,
          child: card,
        ),
      );
    }
    return card;
  }
}
