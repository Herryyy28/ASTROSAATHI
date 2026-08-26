import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import 'vedic_chart_painter.dart';
import 'dart:ui';

class BirthChartCard extends StatelessWidget {
  const BirthChartCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy Data for visual representation
    final Map<int, List<String>> dummyPlanets = {
      1: ['Su', 'Me'], // 1st house (Ascendant)
      4: ['Ma'],       // 4th house
      7: ['Mo'],       // 7th house
      9: ['Ju'],       // 9th house
      10: ['Sa', 'Ve'],// 10th house
      12: ['Ra'],      // 12th house
      6: ['Ke'],       // 6th house
    };

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Your Birth Chart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'North Indian (Vedic) Layout',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 32),
              AspectRatio(
                aspectRatio: 1.0, // Perfect square
                child: CustomPaint(
                  painter: VedicChartPainter(housePlanets: dummyPlanets),
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(
                    duration: 3000.ms,
                    color: AppColors.primaryLight.withOpacity(0.3),
                  ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 800.ms).slideY(begin: 0.1);
  }
}
