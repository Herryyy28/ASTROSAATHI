import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

class CosmicCalendarDay {
  final DateTime date;
  final String dayName;
  final String dayNumber;
  final String energyLevel; // High, Auspicious, Neutral, Caution
  final Color badgeColor;
  final String nakshatra;
  final String yoga;
  final String transitHighlight;
  final String rahuKaal;
  final String bestWindow;
  final String recommendation;

  CosmicCalendarDay({
    required this.date,
    required this.dayName,
    required this.dayNumber,
    required this.energyLevel,
    required this.badgeColor,
    required this.nakshatra,
    required this.yoga,
    required this.transitHighlight,
    required this.rahuKaal,
    required this.bestWindow,
    required this.recommendation,
  });
}

class PersonalCosmicCalendarWidget extends StatefulWidget {
  const PersonalCosmicCalendarWidget({super.key});

  @override
  State<PersonalCosmicCalendarWidget> createState() => _PersonalCosmicCalendarWidgetState();
}

class _PersonalCosmicCalendarWidgetState extends State<PersonalCosmicCalendarWidget> {
  int _selectedIndex = 3; // Default to Today (Index 3)

  late final List<CosmicCalendarDay> _days;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _days = List.generate(7, (index) {
      final date = now.add(Duration(days: index - 3));
      final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final dayName = dayNames[date.weekday - 1];
      final dayNum = date.day.toString().padLeft(2, '0');

      switch (index) {
        case 0:
          return CosmicCalendarDay(
            date: date,
            dayName: dayName,
            dayNumber: dayNum,
            energyLevel: 'Balanced',
            badgeColor: AppColors.secondary,
            nakshatra: 'Pushya Nakshatra',
            yoga: 'Siddha Yoga',
            transitHighlight: 'Moon enters Cancer • Emotional Clarity',
            rahuKaal: '07:30 AM - 09:00 AM',
            bestWindow: '10:15 AM - 12:30 PM',
            recommendation: 'Ideal day for team meetings and long-term planning.',
          );
        case 1:
          return CosmicCalendarDay(
            date: date,
            dayName: dayName,
            dayNumber: dayNum,
            energyLevel: 'Auspicious',
            badgeColor: AppColors.success,
            nakshatra: 'Ashlesha Nakshatra',
            yoga: 'Amrit Siddhi Yoga',
            transitHighlight: 'Mercury Aspecting 10th House • Speech Luck',
            rahuKaal: '03:00 PM - 04:30 PM',
            bestWindow: '09:00 AM - 11:15 AM',
            recommendation: 'Execute contract signings, client pitches & negotiations.',
          );
        case 2:
          return CosmicCalendarDay(
            date: date,
            dayName: dayName,
            dayNumber: dayNum,
            energyLevel: 'Caution',
            badgeColor: AppColors.error,
            nakshatra: 'Magha Nakshatra',
            yoga: 'Vyatipata Yoga',
            transitHighlight: 'Mars-Rahu Square Aspect • High Temperament',
            rahuKaal: '12:00 PM - 01:30 PM',
            bestWindow: '04:00 PM - 05:30 PM',
            recommendation: 'Avoid major financial commitments or heated arguments.',
          );
        case 3: // Today
          return CosmicCalendarDay(
            date: date,
            dayName: 'TODAY',
            dayNumber: dayNum,
            energyLevel: 'Peak Energy ✦',
            badgeColor: AppColors.primary,
            nakshatra: 'Purva Phalguni Nakshatra',
            yoga: 'Gajakesari Yoga Active',
            transitHighlight: 'Jupiter Trine Moon • Peak Financial Alignment',
            rahuKaal: '01:30 PM - 03:00 PM',
            bestWindow: '08:45 AM - 11:30 AM',
            recommendation: 'Launch new initiatives, buy assets, or seek promotions.',
          );
        case 4:
          return CosmicCalendarDay(
            date: date,
            dayName: dayName,
            dayNumber: dayNum,
            energyLevel: 'Auspicious',
            badgeColor: AppColors.success,
            nakshatra: 'Uttara Phalguni',
            yoga: 'Shubha Yoga',
            transitHighlight: 'Venus Conjunction in 11th House • Relationship Growth',
            rahuKaal: '10:30 AM - 12:00 PM',
            bestWindow: '02:00 PM - 04:30 PM',
            recommendation: 'Plan social gatherings, romantic dates or creative projects.',
          );
        case 5:
          return CosmicCalendarDay(
            date: date,
            dayName: dayName,
            dayNumber: dayNum,
            energyLevel: 'Peaceful',
            badgeColor: AppColors.secondary,
            nakshatra: 'Hasta Nakshatra',
            yoga: 'Brahma Yoga',
            transitHighlight: 'Sun Trine Saturn • Discipline & Recognition',
            rahuKaal: '09:00 AM - 10:30 AM',
            bestWindow: '06:30 AM - 08:30 AM',
            recommendation: 'Great for spiritual practices, meditation & body detox.',
          );
        default:
          return CosmicCalendarDay(
            date: date,
            dayName: dayName,
            dayNumber: dayNum,
            energyLevel: 'High Focus',
            badgeColor: AppColors.primaryLight,
            nakshatra: 'Chitra Nakshatra',
            yoga: 'Indra Yoga',
            transitHighlight: 'Moon Trine Mars • High Vitality & Courage',
            rahuKaal: '04:30 PM - 06:00 PM',
            bestWindow: '11:00 AM - 01:15 PM',
            recommendation: 'Focus on physical workouts, sports & tough decision making.',
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = _days[_selectedIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.85),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.glassBorder, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.goldGradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_month_rounded, color: Colors.black, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    final l10n = AppLocalizations.of(context, ref);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.cosmicCalendarTitle,
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.cosmicCalendarSub,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textSecondaryDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: selectedDay.badgeColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selectedDay.badgeColor.withOpacity(0.5)),
                ),
                child: Text(
                  selectedDay.energyLevel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: selectedDay.badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Horizontal 7-day strip
          SizedBox(
            height: 76,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final day = _days[index];
                final isSelected = index == _selectedIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 58,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.goldGradient : null,
                      color: isSelected ? null : AppColors.glassSurface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.glassBorder,
                        width: isSelected ? 1.5 : 0.6,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.dayName,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.black : AppColors.textSecondaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.dayNumber,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? Colors.black : day.badgeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Selected Day Event Details Card
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(_selectedIndex),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.glassSurface.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.glassBorder, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Transit Highlight
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedDay.transitHighlight,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Nakshatra & Yoga Details
                  Row(
                    children: [
                      Expanded(
                        child: _buildDetailChip('Nakshatra', selectedDay.nakshatra, Icons.star_half_rounded),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDetailChip('Yoga', selectedDay.yoga, Icons.spa_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Timing Windows (Best Window & Rahu Kaal)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.success.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('✦ Best Window', style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(selectedDay.bestWindow, style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.error.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('⚠️ Rahu Kaal', style: TextStyle(fontSize: 10, color: AppColors.error, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Text(selectedDay.rahuKaal, style: const TextStyle(fontSize: 12, color: AppColors.textPrimaryDark, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Recommendation text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHighlightDark.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedDay.recommendation,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondaryDark,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ).fadeSlideUp(delay: 50.ms),
        ],
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textTertiaryDark)),
                Text(
                  value,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
