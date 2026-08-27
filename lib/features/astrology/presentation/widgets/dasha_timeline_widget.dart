import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class DashaTimelineWidget extends StatelessWidget {
  const DashaTimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashaList = [
      {'planet': 'Jupiter (Guru)', 'type': 'Mahadasha', 'period': '2020 - 2036', 'active': true, 'color': AppColors.primary},
      {'planet': 'Saturn (Shani)', 'type': 'Antardasha', 'period': '2024 - 2026', 'active': true, 'color': AppColors.secondary},
      {'planet': 'Mercury (Budh)', 'type': 'Pratyantar', 'period': 'Oct 2026 - Feb 2027', 'active': false, 'color': AppColors.tertiary},
      {'planet': 'Ketu', 'type': 'Pratyantar', 'period': 'Feb 2027 - May 2027', 'active': false, 'color': AppColors.textSecondaryDark},
      {'planet': 'Venus (Shukra)', 'type': 'Antardasha', 'period': '2027 - 2030', 'active': false, 'color': AppColors.textSecondaryDark},
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
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.timeline_rounded, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Vimshottari Dasha Timeline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                ),
                child: const Text(
                  'Active: Guru - Shani',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: dashaList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final dasha = dashaList[index];
                final isActive = dasha['active'] as bool;
                final Color planetColor = dasha['color'] as Color;

                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive ? planetColor.withOpacity(0.15) : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? planetColor.withOpacity(0.6) : AppColors.glassBorder,
                      width: isActive ? 1.5 : 1.0,
                    ),
                    boxShadow: isActive
                        ? [BoxShadow(color: planetColor.withOpacity(0.2), blurRadius: 10)]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: planetColor,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              dasha['planet'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isActive ? AppColors.textPrimaryDark : AppColors.textSecondaryDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dasha['type'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          color: planetColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dasha['period'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textTertiaryDark,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
