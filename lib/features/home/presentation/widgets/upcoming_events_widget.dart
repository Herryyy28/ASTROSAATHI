import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class UpcomingEventsWidget extends StatelessWidget {
  const UpcomingEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final events = [
      {'time': 'In 2 days', 'title': '🌙 Moon enters Mrigashira Nakshatra', 'type': 'Favorable'},
      {'time': 'In 6 days', 'title': '🪐 Saturn Retrograde Shadow Phase begins', 'type': 'Caution'},
      {'time': 'In 12 days', 'title': '💼 Jupiter Trine 10th House (Peak Career)', 'type': 'Favorable'},
      {'time': 'In 20 days', 'title': '📿 Recommended Gemstone Fasting Period', 'type': 'Remedy'},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.glassBorder),
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
              const Text(
                'What\'s Coming Up',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...events.map((e) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 76,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.glassBorder),
                    ),
                    child: Center(
                      child: Text(
                        e['time']!,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      e['title']!,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimaryDark),
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
