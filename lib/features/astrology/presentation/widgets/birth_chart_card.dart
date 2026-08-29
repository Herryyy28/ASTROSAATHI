import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/user_profile_provider.dart';
import 'vedic_chart_painter.dart';
import 'dasha_timeline_widget.dart';
import 'dart:ui';

class BirthChartCard extends ConsumerStatefulWidget {
  const BirthChartCard({Key? key}) : super(key: key);

  @override
  ConsumerState<BirthChartCard> createState() => _BirthChartCardState();
}

class _BirthChartCardState extends ConsumerState<BirthChartCard> {
  String? selectedLagna;

  final List<String> lagnaList = [
    'Aries (Mesha)',
    'Taurus (Vrishabha)',
    'Gemini (Mithuna)',
    'Cancer (Karka)',
    'Leo (Simha)',
    'Virgo (Kanya)',
    'Libra (Tula)',
    'Scorpio (Vrishchika)',
    'Sagittarius (Dhanu)',
    'Capricorn (Makara)',
    'Aquarius (Kumbha)',
    'Pisces (Meena)',
  ];

  final Map<int, String> houseMeanings = {
    1: '1st House (Lagna / Tanu): Vitality, physical health, personality, and soul purpose.',
    2: '2nd House (Dhana): Family wealth, speech quality, liquid assets, and eating habits.',
    3: '3rd House (Sahaja): Inner courage, younger siblings, short travels, and communications.',
    4: '4th House (Sukha): Home environment, mother, lands, vehicles, and peace of mind.',
    5: '5th House (Putra): Intelligence, past life karma (Purva Punya), romance, and children.',
    6: '6th House (Ripu): Daily work routine, immunity against disease, debts, and competitive strength.',
    7: '7th House (Kalatra): Marriage partner, long-term business contracts, and public interactions.',
    8: '8th House (Ayur): Longevity, unearned wealth, sudden transformations, and occult wisdom.',
    9: '9th House (Bhagya): Divine luck, higher wisdom, father, pilgrimage, and spiritual guru.',
    10: '10th House (Karma): Executive career, professional status, ambition, and leadership.',
    11: '11th House (Labha): Financial gains, fulfillment of long-term desires, and influential network.',
    12: '12th House (Vyaya): Moksha (Liberation), foreign residence, subconscious mind, and spiritual devotion.',
  };

  void _showHouseDetails(
    BuildContext context,
    int house,
    Map<int, List<String>> activePlanets,
  ) {
    final planets = activePlanets[house] ?? [];
    final description = houseMeanings[house] ?? 'House Details';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withOpacity(0.95),
                border: const Border(
                  top: BorderSide(color: AppColors.glassBorder, width: 0.5),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'House $house Vedic Insights',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimaryDark,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (planets.isNotEmpty) ...[
                    const Text(
                      'Residing Planetary Energies:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: planets.map((p) {
                        return Chip(
                          backgroundColor: AppColors.primary.withOpacity(0.15),
                          side: BorderSide(
                            color: AppColors.primary.withOpacity(0.4),
                          ),
                          label: Text(
                            p,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    const Text(
                      'No planet residing in this house currently.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textTertiaryDark,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final birthChartAsync = ref.watch(birthChartProvider);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceHighlightDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: birthChartAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (e, st) => Center(
              child: Text(
                'Error loading chart: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            data: (chartData) {
              final lagna = chartData['lagna'] as String? ?? 'Aries (Mesha)';
              final currentLagna = selectedLagna ?? lagna;
              final planetsMap =
                  chartData['planets'] as Map<String, dynamic>? ?? {};

              // Convert the API data format to the UI format {house: ['Planet']}
              Map<int, List<String>> activePlanets = {};
              planetsMap.forEach((key, value) {
                final house = value['house'] as int? ?? 1;
                if (!activePlanets.containsKey(house)) {
                  activePlanets[house] = [];
                }
                activePlanets[house]!.add(key);
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Authentic Kundli Bhavishyavani',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            DropdownButton<String>(
                              value: currentLagna,
                              isDense: true,
                              underline: const SizedBox.shrink(),
                              dropdownColor: AppColors.surfaceDark,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              items: lagnaList.map((l) {
                                return DropdownMenuItem<String>(
                                  value: l,
                                  child: Text(l),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => selectedLagna = val);
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.touch_app_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AspectRatio(
                        aspectRatio: 1.0,
                        child: GestureDetector(
                          onTapUp: (details) {
                            final RenderBox box =
                                context.findRenderObject() as RenderBox;
                            final size = box.size;
                            final local = details.localPosition;
                            final dx = local.dx / size.width;
                            final dy = local.dy / size.height;

                            int house = 1;
                            if (dy < 0.33) {
                              if (dx < 0.33)
                                house = 2;
                              else if (dx > 0.66)
                                house = 12;
                              else
                                house = 1;
                            } else if (dy > 0.66) {
                              if (dx < 0.33)
                                house = 6;
                              else if (dx > 0.66)
                                house = 8;
                              else
                                house = 7;
                            } else {
                              if (dx < 0.33)
                                house = 4;
                              else if (dx > 0.66)
                                house = 10;
                              else
                                house = 9;
                            }
                            _showHouseDetails(context, house, activePlanets);
                          },
                          child: CustomPaint(
                            painter: VedicChartPainter(
                              housePlanets: activePlanets,
                            ),
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(
                        duration: 3000.ms,
                        color: AppColors.primaryLight.withOpacity(0.2),
                      ),
                  const SizedBox(height: 24),
                  const DashaTimelineWidget(),
                ],
              );
            },
          ),
        ),
      ),
    ).animate().fade(duration: 800.ms).slideY(begin: 0.1);
  }
}
