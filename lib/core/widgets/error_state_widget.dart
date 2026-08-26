import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_animations.dart';
import 'gradient_button.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    this.title = 'The Stars are Clouded',
    this.message = 'Our servers are currently reconnecting to the celestial network. Please try again in a moment.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Floating planet or moon icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withOpacity(0.1),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: const Center(
                child: Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: -5, end: 5, duration: 2.seconds),
            
            const SizedBox(height: 32),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryDark,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 16,
                height: 1.5,
                color: AppColors.textSecondaryDark,
              ),
            ),
            
            const SizedBox(height: 40),
            
            GradientButton(
              text: 'Realign Stars',
              onPressed: onRetry,
            ),
          ],
        ).fadeSlideUp(),
      ),
    );
  }
}
