import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/engine/models/game_plan_data.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/gamification_provider.dart';

class WhatChangedTodayCard extends ConsumerWidget {
  final GamePlanData gamePlan;

  const WhatChangedTodayCard({super.key, required this.gamePlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamification = ref.watch(gamificationProvider);
    final yesterdayScore = gamification.yesterdayScore;
    final todayScore = gamePlan.dayScore;
    final delta = todayScore - yesterdayScore;
    final isPositive = delta >= 0;

    // Persist today's score for subsequent comparison
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(gamificationProvider.notifier).recordTodayScore(todayScore);
    });

    // Derive highest category dynamically
    String topCategory = 'Vitality & Clarity';
    double topScore = 0.0;
    gamePlan.categories.forEach((cat, score) {
      if (score > topScore) {
        topScore = score;
        topCategory = cat[0].toUpperCase() + cat.substring(1);
      }
    });

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderColor: isPositive ? AppColors.success.withValues(alpha: 0.4) : AppColors.warning.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isPositive ? AppColors.success : AppColors.warning).withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: isPositive ? AppColors.success : AppColors.warning,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WHAT CHANGED TODAY?',
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                    Text(
                      'Daily Cosmic Comparison Engine',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.greenAccent : Colors.orangeAccent).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: (isPositive ? Colors.greenAccent : Colors.orangeAccent).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  '${isPositive ? "▲ +" : "â–¼ "}${delta.abs().toStringAsFixed(1)} PTS',
                  style: GoogleFonts.outfit(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? Colors.greenAccent : Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Score Comparison Bars
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceSecondary(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.getBorder(context)),
                  ),
                  child: Column(
                    children: [
                      Text('YESTERDAY', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.getTextSecondary(context))),
                      const SizedBox(height: 4),
                      Text(
                        yesterdayScore.toStringAsFixed(1),
                        style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.arrow_forward_rounded, color: AppColors.primary, size: 18),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                  ),
                  child: Column(
                    children: [
                      Text('TODAY', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text(
                        todayScore.toStringAsFixed(1),
                        style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Delta Drivers List (Dynamic from gamePlan)
          _buildDriverRow(
            context,
            Icons.star_rounded,
            'Dominant Energy Surge',
            '$topCategory alignment is strongest today at ${(topScore * 10).toInt()}% peak cosmic capacity.',
          ),
          const SizedBox(height: 8),
          _buildDriverRow(
            context,
            Icons.access_time_filled_rounded,
            'Optimal Muhurat Window',
            'Golden Window active between ${gamePlan.bestWindow.start} and ${gamePlan.bestWindow.end}.',
          ),
          const SizedBox(height: 8),
          _buildDriverRow(
            context,
            Icons.check_circle_outline_rounded,
            'Priority Action Directive',
            gamePlan.doList.isNotEmpty ? gamePlan.doList.first : 'Maintain balance during mid-day transits.',
          ),
          const SizedBox(height: 16),

          // Explain Changes Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.smart_toy_rounded, size: 16, color: AppColors.primary),
              label: Text(
                'Explain Changes with Astro Baba',
                style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              onPressed: () {
                final prompt = 'Explain why my cosmic score changed from ${yesterdayScore.toStringAsFixed(1)} yesterday to ${todayScore.toStringAsFixed(1)} today. '
                    'How does the peak in $topCategory and my Golden Window (${gamePlan.bestWindow.start} - ${gamePlan.bestWindow.end}) impact my day?';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AstroBabaScreen(initialMessage: prompt),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverRow(BuildContext context, IconData icon, String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context), height: 1.3),
              children: [
                TextSpan(text: '$title: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                TextSpan(text: detail),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

