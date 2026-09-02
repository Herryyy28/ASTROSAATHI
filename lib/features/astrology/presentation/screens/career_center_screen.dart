import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';

class CareerCenterScreen extends StatelessWidget {
  const CareerCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
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
                        gradient: AppColors.goldGradient,
                      ),
                      child: const Icon(Icons.business_center_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Career & Ambition Center',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                          ),
                          Text(
                            '10th House Karma, Business Timings & Leadership',
                            style: TextStyle(fontSize: 11.5, color: AppColors.getTextSecondary(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Career Energy Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.getCardGradient(context),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Career Score Today', style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context))),
                            const SizedBox(height: 4),
                            const Text('8.9 / 10', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('✦ High Executive Energy', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.trending_up_rounded, color: AppColors.primary, size: 54),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Career Insights Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.getSurface(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.getBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('10th House & Transit Analysis', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                      const SizedBox(height: 12),
                      _buildInsightItem(context, 'Sun & Mercury in 10th House', 'Enhances leadership speech, corporate negotiating power, and visibility.'),
                      _buildInsightItem(context, 'Jupiter Trine Aspect', 'Optimal phase for salary reviews, new client acquisition, and promotion discussions.'),
                      _buildInsightItem(context, 'Golden Time Window', 'Schedule high-stakes meetings between 11:15 AM and 1:20 PM.'),
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

  Widget _buildInsightItem(BuildContext context, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline_rounded, color: AppColors.getPrimary(context), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.getPrimary(context), fontSize: 13)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: AppColors.getTextSecondary(context), fontSize: 12, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
