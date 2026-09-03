import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/explain_chart_modal.dart';

class AcademyTopic {
  final String title;
  final String category;
  final IconData icon;
  final String simpleExplanation;
  final String technicalDetail;
  final String keyTakeaway;

  AcademyTopic({
    required this.title,
    required this.category,
    required this.icon,
    required this.simpleExplanation,
    required this.technicalDetail,
    required this.keyTakeaway,
  });
}

class AstroAcademyScreen extends StatefulWidget {
  const AstroAcademyScreen({super.key});

  @override
  State<AstroAcademyScreen> createState() => _AstroAcademyScreenState();
}

class _AstroAcademyScreenState extends State<AstroAcademyScreen> {
  bool _isExpertMode = false;

  final List<AcademyTopic> _topics = [
    AcademyTopic(
      title: 'What is a Kundli (Birth Chart)?',
      category: 'Foundations',
      icon: Icons.auto_awesome_rounded,
      simpleExplanation: 'A Kundli is a snapshot of the sky at the exact second you were born. It maps planet locations to show your natural strengths, career path, and life challenges.',
      technicalDetail: 'Combines 12 Bhavas (Houses), 12 Rashis (Zodiac Signs), 9 Grahas (Planets), and 27 Nakshatras based on Swiss Ephemeris coordinates.',
      keyTakeaway: 'Your Kundli is your cosmic blueprint; transits represent current daily weather.',
    ),
    AcademyTopic(
      title: 'What is Lagna (Ascendant)?',
      category: 'Foundations',
      icon: Icons.brightness_high_rounded,
      simpleExplanation: 'Lagna is the zodiac sign rising on the eastern horizon at your birth moment. It represents your physical body, personality, and core life perspective.',
      technicalDetail: 'The 1st House of your natal chart. Changes every 2 hours, making birth time precision crucial for accurate house division.',
      keyTakeaway: 'Your Lagna is far more personal and predictive than your Sun sign.',
    ),
    AcademyTopic(
      title: 'What is a Rashi (Moon Sign)?',
      category: 'Foundations',
      icon: Icons.bedtime_rounded,
      simpleExplanation: 'Your Rashi is the zodiac sign where the Moon was positioned when you were born. It governs your emotions, mind, intuition, and daily energy.',
      technicalDetail: 'Vedic astrology calculates daily transits (Gochar) and Ashtakoota compatibility primarily from your Moon sign.',
      keyTakeaway: 'Moon sign determines how you process feelings and respond to stress.',
    ),
    AcademyTopic(
      title: 'What is a Nakshatra (Lunar Mansion)?',
      category: 'Vedic Depth',
      icon: Icons.star_border_rounded,
      simpleExplanation: 'Vedic astrology divides the zodiac into 27 Star Constellations (Nakshatras). They reveal deep personality nuances, innate talents, and life themes.',
      technicalDetail: 'Each Nakshatra spans 13°20\' and is divided into 4 Padas (quarters). Your birth Nakshatra determines your starting Mahadasha.',
      keyTakeaway: 'Nakshatras explain why two people of the same Moon sign behave differently.',
    ),
    AcademyTopic(
      title: 'What is Vimshottari Dasha?',
      category: 'Timelines',
      icon: Icons.timeline_rounded,
      simpleExplanation: 'A 120-year planetary timeline that dictates which area of your life (Career, Relationship, Wealth) is active during a given period.',
      technicalDetail: 'Sequentially ruled by 9 planets starting from your Moon Nakshatra lord. Divided into Mahadasha, Antardasha, and Pratyantardasha.',
      keyTakeaway: 'Dasha reveals *when* events are destined to manifest.',
    ),
    AcademyTopic(
      title: 'What is Gochar (Planetary Transits)?',
      category: 'Timelines',
      icon: Icons.rotate_right_rounded,
      simpleExplanation: 'Gochar refers to the current real-time movement of planets through the zodiac and how they interact with your natal birth chart.',
      technicalDetail: 'Slow planets like Saturn (2.5 yrs/sign) and Jupiter (1 yr/sign) create major multi-year life trends.',
      keyTakeaway: 'Transits represent current cosmic energy triggering your natal promises.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Astrology Academy & Glossary',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'Master Vedic concepts in plain language',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Beginner vs Expert Mode Toggle Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              _isExpertMode ? Icons.psychology_rounded : Icons.child_care_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _isExpertMode ? 'Expert Mode Active' : 'Beginner Mode Active',
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _isExpertMode ? 'Shows degrees, house lords & Sanskrit terms' : 'Translates terms into simple everyday English',
                                    style: GoogleFonts.inter(
                                      fontSize: 10.5,
                                      color: AppColors.getTextSecondary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: _isExpertMode,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isExpertMode = val),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Topics Grid / List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _topics.length,
                  itemBuilder: (context, index) {
                    final topic = _topics[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () {
                          ExplainChartModal.show(
                            context,
                            term: topic.category,
                            title: topic.title,
                            simpleExplanation: topic.simpleExplanation,
                            technicalDetail: topic.technicalDetail,
                            keyTakeaway: topic.keyTakeaway,
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.getPrimary(context).withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(topic.icon, color: AppColors.getPrimary(context), size: 20),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic.title,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _isExpertMode ? topic.technicalDetail : topic.simpleExplanation,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.getTextSecondary(context),
                                      height: 1.35,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: AppColors.getTextMuted(context),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
