import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';

class CosmicInboxScreen extends StatelessWidget {
  const CosmicInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alerts = [
      {'title': '🔮 Daily Cosmic Game Plan Ready', 'desc': 'Energy score 8.7/10 — Jupiter aspecting 10th Karma House today.', 'time': '07:00 AM'},
      {'title': '⏰ Rahu Kaal Alert', 'desc': 'Rahu Kaal starting in 20 minutes (1:30 PM - 3:00 PM). Avoid signing deals.', 'time': '01:10 PM'},
      {'title': '💼 Best Career Window Approaching', 'desc': 'Abhijit Muhurat starts at 11:15 AM — optimal for executive calls.', 'time': '10:45 AM'},
      {'title': '📿 Mantra Counter Reminder', 'desc': 'Your Mahamrityunjaya Japa goal is 54 beads completed out of 108.', 'time': 'Yesterday'},
    ];

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
                      child: const Icon(Icons.inbox_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cosmic Alert Inbox',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                        ),
                        Text(
                          'In-App Planetary Insights & Timing Notifications',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ...alerts.map((a) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlightDark.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                a['title']!,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                            Text(
                              a['time']!,
                              style: const TextStyle(fontSize: 11, color: AppColors.textTertiaryDark),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          a['desc']!,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark, height: 1.3),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
