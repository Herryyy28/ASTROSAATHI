import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';

class RelationshipCenterScreen extends StatelessWidget {
  const RelationshipCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.purpleGradient,
                      ),
                      child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Relationship Center',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                        ),
                        Text(
                          '7th House Partnerships, Venus Transits & Harmony',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Love Energy Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.secondary.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Love & Synergy Score', style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark)),
                            const SizedBox(height: 4),
                            const Text('7.8 / 10', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.secondaryLight)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('✦ Warm Emotional Alignment', style: TextStyle(color: AppColors.secondaryLight, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.volunteer_activism_rounded, color: AppColors.secondaryLight, size: 54),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 24),

                // 7th House & Venus Insights
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlightDark.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('7th House & Venus Alignment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark)),
                      const SizedBox(height: 12),
                      _buildInsightItem('Venus in Rohini Nakshatra', 'Fosters magnetic charm, deep affection, and empathetic communication.'),
                      _buildInsightItem('7th House Lord Synergy', 'Ideal time for heart-to-heart dialogue, resolving past misunderstandings, and date nights.'),
                      _buildInsightItem('Daily Upay Reminder', 'Wear white pastel tones or apply rose water on Friday mornings to enhance Venus grace.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInsightItem(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.favorite_border_rounded, color: AppColors.secondaryLight, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondaryLight, fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
