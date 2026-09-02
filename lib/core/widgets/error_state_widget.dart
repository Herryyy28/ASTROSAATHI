import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_animations.dart';
import '../theme/design_tokens.dart';
import '../../l10n/app_localizations.dart';
import 'gradient_button.dart';

/// Fully theme-adaptive error state widget with retry action.
class ErrorStateWidget extends ConsumerWidget {
  final String? title;
  final String? message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    this.title,
    this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context, ref);
    final displayTitle = title ?? l10n.somethingWentWrong;
    final displayMessage = message ?? l10n.error;
    final textPrimary = AppColors.getTextPrimary(context);
    final textSecondary = AppColors.getTextSecondary(context);
    final errorColor = AppColors.getError(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: errorColor.withOpacity(0.08),
                  border: Border.all(color: errorColor.withOpacity(0.25), width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.cloud_off_rounded,
                    size: 42,
                    color: errorColor,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .moveY(begin: -4, end: 4, duration: 2.seconds, curve: Curves.easeInOut),

              const SizedBox(height: AppSpacing.xxxl),

              Text(
                displayTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Text(
                displayMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: textSecondary,
                ),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              GradientButton(
                text: l10n.retry,
                onPressed: onRetry,
              ),
            ],
          ).fadeSlideUp(),
        ),
      ),
    );
  }
}
