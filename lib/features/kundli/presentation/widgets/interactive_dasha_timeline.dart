import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/explain_chart_modal.dart';

class DashaPeriodItem {
  final String planet;
  final String durationText;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final bool isCompleted;
  final List<DashaPeriodItem> subPeriods;

  DashaPeriodItem({
    required this.planet,
    required this.durationText,
    required this.startDate,
    required this.endDate,
    this.isActive = false,
    this.isCompleted = false,
    this.subPeriods = const [],
  });
}

class InteractiveDashaTimeline extends StatefulWidget {
  const InteractiveDashaTimeline({super.key});

  @override
  State<InteractiveDashaTimeline> createState() => _InteractiveDashaTimelineState();
}

class _InteractiveDashaTimelineState extends State<InteractiveDashaTimeline> {
  int? _expandedIndex = 0; // Default expand active Mahadasha (Index 0)

  final List<DashaPeriodItem> _mahadashas = [
    DashaPeriodItem(
      planet: 'Jupiter (Guru)',
      durationText: '2018 – 2034 (16 Years)',
      startDate: DateTime(2018, 5, 12),
      endDate: DateTime(2034, 5, 12),
      isActive: true,
      subPeriods: [
        DashaPeriodItem(
          planet: 'Jupiter – Jupiter',
          durationText: 'May 2018 – Jul 2020',
          startDate: DateTime(2018, 5, 12),
          endDate: DateTime(2020, 7, 1),
          isCompleted: true,
        ),
        DashaPeriodItem(
          planet: 'Jupiter – Saturn',
          durationText: 'Jul 2020 – Jan 2023',
          startDate: DateTime(2020, 7, 1),
          endDate: DateTime(2023, 1, 15),
          isCompleted: true,
        ),
        DashaPeriodItem(
          planet: 'Jupiter – Mercury',
          durationText: 'Jan 2023 – Apr 2025',
          startDate: DateTime(2023, 1, 15),
          endDate: DateTime(2025, 4, 20),
          isActive: true,
        ),
        DashaPeriodItem(
          planet: 'Jupiter – Ketu',
          durationText: 'Apr 2025 – Mar 2026',
          startDate: DateTime(2025, 4, 20),
          endDate: DateTime(2026, 3, 25),
        ),
        DashaPeriodItem(
          planet: 'Jupiter – Venus',
          durationText: 'Mar 2026 – Nov 2028',
          startDate: DateTime(2026, 3, 25),
          endDate: DateTime(2028, 11, 10),
        ),
      ],
    ),
    DashaPeriodItem(
      planet: 'Saturn (Shani)',
      durationText: '2034 – 2053 (19 Years)',
      startDate: DateTime(2034, 5, 12),
      endDate: DateTime(2053, 5, 12),
      subPeriods: [
        DashaPeriodItem(
          planet: 'Saturn – Saturn',
          durationText: 'May 2034 – May 2037',
          startDate: DateTime(2034, 5, 12),
          endDate: DateTime(2037, 5, 12),
        ),
      ],
    ),
    DashaPeriodItem(
      planet: 'Mercury (Budh)',
      durationText: '2053 – 2070 (17 Years)',
      startDate: DateTime(2053, 5, 12),
      endDate: DateTime(2070, 5, 12),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.account_tree_rounded, color: Colors.black, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'INTERACTIVE DASHA TIMELINE',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            color: AppColors.getPrimary(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Vimshottari Dasha Tree (Mahadasha → Antardasha)',
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
              IconButton(
                icon: const Icon(Icons.help_outline_rounded, size: 18, color: AppColors.primary),
                onPressed: () {
                  ExplainChartModal.show(
                    context,
                    term: 'Vimshottari Dasha System',
                    title: 'What is a Dasha?',
                    simpleExplanation: 'Vimshottari Dasha is the planetary timeline of your life. It divides a 120-year cycle into major periods (Mahadashas) ruled by specific planets that dictate which area of your life is highlighted.',
                    technicalDetail: 'Based on the exact Nakshatra of your natal Moon at birth. Mahadashas range from 6 years (Sun) to 20 years (Venus).',
                    keyTakeaway: 'Your active Mahadasha lord sets the theme of your current life chapter (e.g. Jupiter = wisdom & expansion).',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Timeline Tree List
          ..._mahadashas.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isExpanded = _expandedIndex == idx;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: item.isActive
                    ? AppColors.getPrimary(context).withOpacity(0.12)
                    : AppColors.getSurfaceSecondary(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.isActive
                      ? AppColors.getPrimary(context)
                      : AppColors.getGlassBorder(context),
                  width: item.isActive ? 1.5 : 0.6,
                ),
              ),
              child: Column(
                children: [
                  // Parent Mahadasha Header Tile
                  ListTile(
                    onTap: () {
                      setState(() {
                        _expandedIndex = isExpanded ? null : idx;
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.isActive ? AppColors.getPrimary(context) : AppColors.getSurfaceElevated(context),
                      ),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 16,
                        color: item.isActive ? Colors.black : AppColors.getTextSecondary(context),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.planet,
                            style: GoogleFonts.outfit(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                        ),
                        if (item.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.getPrimary(context),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'ACTIVE NOW',
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.black),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Text(
                      item.durationText,
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context)),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: AppColors.getTextSecondary(context),
                    ),
                  ),

                  // Sub-periods (Antardashas) when expanded
                  if (isExpanded && item.subPeriods.isNotEmpty) ...[
                    const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ANTARDASHA SUB-PERIODS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.getTextMuted(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...item.subPeriods.map((sub) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: sub.isActive
                                          ? AppColors.getPrimary(context)
                                          : (sub.isCompleted ? AppColors.getGlassBorder(context) : AppColors.getTextMuted(context)),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      sub.planet,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: sub.isActive ? FontWeight.bold : FontWeight.w500,
                                        color: sub.isActive ? AppColors.getPrimary(context) : AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    sub.durationText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.getTextSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
