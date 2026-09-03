import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';

class LifeTimelineScreen extends StatefulWidget {
  const LifeTimelineScreen({super.key});

  @override
  State<LifeTimelineScreen> createState() => _LifeTimelineScreenState();
}

class _LifeTimelineScreenState extends State<LifeTimelineScreen> {
  final List<Map<String, dynamic>> dashaPhases = [
    {
      'period': 'Past Phase (2014 - 2020)',
      'mahadasha': 'Rahu Mahadasha',
      'status': 'Completed',
      'color': AppColors.textTertiaryDark,
      'summary': 'Transformation, ambition, travel, and foundational learning.',
      'favorableFor': 'Adaptability, tech learning, breaking old routines',
    },
    {
      'period': 'Present Active Phase (2020 - 2036)',
      'mahadasha': 'Jupiter (Guru) Mahadasha',
      'status': 'Active Present',
      'color': AppColors.primary,
      'summary': 'Wisdom expansion, executive leadership, spiritual clarity, and financial growth.',
      'favorableFor': 'Career advancement, marriage, investments, higher learning',
    },
    {
      'period': 'Upcoming Phase (2036 - 2055)',
      'mahadasha': 'Saturn (Shani) Mahadasha',
      'status': 'Future',
      'color': AppColors.secondary,
      'summary': 'Karma stabilization, long-term discipline, organizational authority, and legacy.',
      'favorableFor': 'Building enduring assets, mentorship, long-term stability',
    },
  ];

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
                        gradient: AppColors.purpleGradient,
                      ),
                      child: const Icon(Icons.timeline_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Life Timeline & Dasha Phases',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Vimshottari Dasha Lifecycle',
                            style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Active Phase Highlight
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldSubtleGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.goldGradient,
                        ),
                        child: const Center(child: Icon(Icons.auto_awesome, color: Colors.black, size: 22)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current Life Phase', style: TextStyle(fontSize: 11, color: AppColors.getTextSecondary(context))),
                            const SizedBox(height: 2),
                            const Text('Jupiter (Guru) Mahadasha', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text('2020–2036 • Active Phase', style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Dasha Timeline Cards
                Text(
                  'Vimshottari Dasha Progression',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                ),
                const SizedBox(height: 12),
                ...dashaPhases.map((phase) {
                  final Color themeColor = phase['color'] as Color;
                  final isActive = phase['status'] == 'Active Present';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isActive ? themeColor.withOpacity(0.12) : (isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4)),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isActive ? themeColor.withOpacity(0.6) : AppColors.getGlassBorder(context),
                        width: isActive ? 1.5 : 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                phase['period'] as String,
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: themeColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: themeColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  phase['status'] as String,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: themeColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          phase['mahadasha'] as String,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          phase['summary'] as String,
                          style: TextStyle(fontSize: 13, color: AppColors.getTextSecondary(context), height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.star_outline_rounded, color: AppColors.getPrimary(context), size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Favorable for: ${phase['favorableFor']}',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.getPrimary(context)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
