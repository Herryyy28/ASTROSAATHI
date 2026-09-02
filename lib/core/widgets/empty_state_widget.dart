import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../theme/design_tokens.dart';
import 'glass_card.dart';

/// A reusable empty state widget — fully theme-adaptive (Light & Dark).
/// Provides human-readable context, cosmic iconography, and an optional CTA.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final String? emoji;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.auto_awesome_rounded,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.getPrimary(context);
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: GlassCard(
          borderRadius: AppRadius.xl3,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: emoji != null
                      ? Text(
                          emoji!,
                          style: const TextStyle(fontSize: 30),
                        )
                      : Icon(
                          icon,
                          color: primaryColor,
                          size: 30,
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                description,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: textSecondary,
                  height: 1.45,
                ),
              ),
              if (buttonText != null && onButtonPressed != null) ...[
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.borderCard,
                    ),
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: onButtonPressed,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    buttonText!,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
