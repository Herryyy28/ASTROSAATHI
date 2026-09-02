import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'design_tokens.dart';

/// Single Source of Truth Card Component (Blinkit Card System)
class AstroCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? borderColor;
  final Color? glowColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const AstroCard({
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
            BoxShadow(color: glowColor!, blurRadius: 16, spreadRadius: -2),
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

/// Primary Gold CTA Button (Compact 44-48px height, 12px radius, 100% visible text)
class AstroButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const AstroButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 46.0,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(context);
    const textColor = Color(0xFF0D131F);

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: AppRadius.borderButton,
        boxShadow: AppColors.goldGlowShadow,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: textColor, size: 18),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    text,
                    style: AppTypography.label(color: textColor),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Secondary Button (Surface background, 12px radius, 44px height)
class AstroSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final double height;

  const AstroSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.height = 44.0,
  });

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.getSurface(context);
    final borderColor = AppColors.getBorder(context);
    final textColor = AppColors.getTextPrimary(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.borderButton,
        border: Border.all(color: borderColor, width: 1.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 6),
            ],
            Text(text, style: AppTypography.label(color: textColor)),
          ],
        ),
      ),
    );
  }
}

/// Outlined Action Button (Gold border & Gold text, 12px radius)
class AstroOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const AstroOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = color ?? AppColors.getPrimary(context);
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: activeColor,
        side: BorderSide(color: activeColor.withOpacity(0.8), width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderButton),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      onPressed: onPressed,
      icon: icon != null ? Icon(icon, size: 16, color: activeColor) : const SizedBox.shrink(),
      label: Text(
        text,
        style: AppTypography.label(color: activeColor),
      ),
    );
  }
}

/// Blinkit Chip Component (Normal & Selected States, 100% Readable Text)
class AstroChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final bool isSelected;

  const AstroChip({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? AppColors.getPrimarySoft(context)
        : AppColors.getSurfaceSecondary(context);

    final textColor = isSelected
        ? AppColors.getPrimaryDarkToken(context)
        : AppColors.getTextSecondary(context);

    final valueColor = isSelected
        ? AppColors.getPrimaryDarkToken(context)
        : AppColors.getTextPrimary(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.borderChip,
        border: Border.all(
          color: isSelected
              ? AppColors.getPrimary(context).withOpacity(0.4)
              : AppColors.getBorder(context),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            '$label: ',
            style: AppTypography.caption(color: textColor),
          ),
          Text(
            value,
            style: AppTypography.label(color: valueColor).copyWith(fontSize: 12.5),
          ),
        ],
      ),
    );
  }
}

/// Standardized Section Header
class AstroSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const AstroSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: AppTypography.label(color: AppColors.getPrimary(context)),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: AppTypography.caption(color: AppColors.getTextSecondary(context)),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// Standardized Input Field (12px radius, 100% visible text)
class AstroTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;

  const AstroTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.label(color: AppColors.getTextSecondary(context)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: AppTypography.body(color: AppColors.getTextPrimary(context)),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.body(color: AppColors.getTextMuted(context)),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.getTextSecondary(context), size: 18) : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: AppColors.getSurfaceSecondary(context),
            contentPadding: AppSpacing.inputPadding,
            border: OutlineInputBorder(
              borderRadius: AppRadius.borderInput,
              borderSide: BorderSide(color: AppColors.getBorder(context), width: 0.8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderInput,
              borderSide: BorderSide(color: AppColors.getBorder(context), width: 0.8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.borderInput,
              borderSide: BorderSide(color: AppColors.getPrimary(context), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
