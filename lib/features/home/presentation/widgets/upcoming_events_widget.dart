import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';

class UpcomingEventsWidget extends StatelessWidget {
  const UpcomingEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isLight = Theme.of(context).brightness == Brightness.light;
    final events = [
      {'days': 2, 'title': '🌙 Moon enters Mrigashira Nakshatra', 'type': 'Favorable'},
      {'days': 6, 'title': 'ðŸª Saturn Retrograde Shadow Phase begins', 'type': 'Caution'},
      {'days': 12, 'title': '💼 Jupiter Trine 10th House (Peak Career)', 'type': 'Favorable'},
      {'days': 20, 'title': '📿 Recommended Gemstone Fasting Period', 'type': 'Remedy'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.getBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.goldGlow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'What\'s Coming Up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.getTextPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...events.asMap().entries.map((entry) {
            final index = entry.key;
            final e = entry.value;
            final days = e['days'] as int;
            final targetDate = now.add(Duration(days: days));
            final dateStr = DateFormat('MMM d').format(targetDate);
            final isLast = index == events.length - 1;

            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: Row(
                children: [
                  Container(
                    width: 78,
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                      color: isLight ? AppColors.getSurfaceSecondary(context) : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.getBorder(context)),
                    ),
                    child: Center(
                      child: Text(
                        '$dateStr (+${days}d)',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.bold,
                          color: isLight ? AppColors.primaryLightMode : AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

