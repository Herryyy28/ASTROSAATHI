import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../l10n/app_localizations.dart';
import '../../services/pdf_report_generator.dart';
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
                color: AppColors.getSurface(context).withOpacity(0.95),
                border: Border(
                  top: BorderSide(color: AppColors.getGlassBorder(context), width: 0.5),
                ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'House $house Vedic Insights',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.close_rounded,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.getTextPrimary(context),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (planets.isNotEmpty) ...[
                      Text(
                        'Residing Planetary Energies:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.getTextSecondary(context),
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
                      Text(
                        'No planet residing in this house currently.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.getTextMuted(context),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
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
    final activeProfile = ref.watch(activeProfileProvider);

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: birthChartAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
            error: (e, st) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    e.toString().replaceFirst('Exception: ', ''),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],
              ),
            ),
            data: (chartData) {
              final isCanonical = chartData.containsKey('profileId') && chartData.containsKey('lagna') && chartData['lagna'] is Map;
              
              final rawLagna = isCanonical 
                  ? (chartData['lagna']['rashi'] ?? 'Aries')
                  : (chartData['lagna'] as String? ?? chartData['ascendant'] as String? ?? 'Aries');
              
              String getNormalizedLagna(String lagna) {
                final l = lagna.toLowerCase();
                for (final item in lagnaList) {
                  if (item.toLowerCase().contains(l) || l.contains(item.toLowerCase().split(' ')[0])) {
                    return item;
                  }
                }
                return lagnaList.contains(lagna) ? lagna : 'Aries (Mesha)';
              }

              final lagna = getNormalizedLagna(rawLagna);
              final currentLagna = selectedLagna ?? lagna;
              final isExploring = selectedLagna != null && selectedLagna != lagna;

              final moonPlanet = () {
                final list = chartData['planets'];
                if (list is List) {
                  for (final p in list) {
                    if (p is Map) {
                      final name = (p['name'] ?? p['code'] ?? p['id'] ?? '').toString().toLowerCase();
                      if (name.contains('moon') || name == 'mo') return p;
                    }
                  }
                }
                return null;
              }();
              final nakshatra = moonPlanet?['nakshatra'] as String? ?? chartData['nakshatra'] as String? ?? '—';
              final pada = moonPlanet?['pada']?.toString() ?? chartData['pada']?.toString() ?? '—';

              String getRashiName() {
                if (chartData['rashi'] is Map && chartData['rashi']['name'] != null) {
                  return chartData['rashi']['name'].toString();
                }
                if (chartData['rashi'] is String && (chartData['rashi'] as String).isNotEmpty) {
                  return chartData['rashi'].toString();
                }
                if (chartData['moonSign'] != null && chartData['moonSign'].toString().isNotEmpty) {
                  return chartData['moonSign'].toString();
                }
                if (moonPlanet != null && (moonPlanet['rashi'] != null || moonPlanet['sign'] != null)) {
                  final s = (moonPlanet['rashi'] ?? moonPlanet['sign']).toString();
                  if (s.isNotEmpty) return s;
                }
                if (nakshatra.isNotEmpty && nakshatra != '—') {
                  final n = nakshatra.toLowerCase();
                  if (n.contains('ashwini') || n.contains('bharani')) return 'Aries (Mesha)';
                  if (n.contains('rohini') || n.contains('krittika')) return 'Taurus (Vrishabha)';
                  if (n.contains('ardra') || n.contains('mrigashira')) return 'Gemini (Mithuna)';
                  if (n.contains('pushya') || n.contains('ashlesha')) return 'Cancer (Karka)';
                  if (n.contains('magha') || n.contains('phalguni')) return 'Leo (Simha)';
                  if (n.contains('hasta') || n.contains('chitra')) return 'Virgo (Kanya)';
                  if (n.contains('swati') || n.contains('vishakha')) return 'Libra (Tula)';
                  if (n.contains('anuradha') || n.contains('jyeshtha')) return 'Scorpio (Vrishchika)';
                  if (n.contains('mula') || n.contains('ashadha')) return 'Sagittarius (Dhanu)';
                  if (n.contains('shravana') || n.contains('dhanishta')) return 'Capricorn (Makara)';
                  if (n.contains('shatabhisha') || n.contains('bhadrapada')) return 'Aquarius (Kumbha)';
                  if (n.contains('revati')) return 'Pisces (Meena)';
                }
                if (activeProfile.name.isNotEmpty) {
                  final z = ZodiacSignUtils.getZodiacFromName(activeProfile.name);
                  if (z != null) return '${z.englishName} (${z.hindiName})';
                }
                return 'Aries (Mesha)';
              }

              final rashiName = getRashiName();
              final calculatedAt = chartData['metadata']?['calculatedAt'] as String? ?? chartData['calculatedAt'] as String?;

              int getSignIndex(String signName) {
                final s = signName.toLowerCase();
                if (s.contains('aries') || s.contains('mesha')) return 1;
                if (s.contains('taurus') || s.contains('vrishabha')) return 2;
                if (s.contains('gemini') || s.contains('mithuna')) return 3;
                if (s.contains('cancer') || s.contains('karka')) return 4;
                if (s.contains('leo') || s.contains('simha')) return 5;
                if (s.contains('virgo') || s.contains('kanya')) return 6;
                if (s.contains('libra') || s.contains('tula')) return 7;
                if (s.contains('scorpio') || s.contains('vrishchika')) return 8;
                if (s.contains('sagittarius') || s.contains('dhanu')) return 9;
                if (s.contains('capricorn') || s.contains('makara')) return 10;
                if (s.contains('aquarius') || s.contains('kumbha')) return 11;
                if (s.contains('pisces') || s.contains('meena')) return 12;
                return 1;
              }

              final lagnaIndex = getSignIndex(currentLagna);

              // Map planets to houses based on the selected lagna (or actual lagna)
              Map<int, List<String>> activePlanets = {};
              
              final rawPlanets = chartData['planets'];
              if (rawPlanets is List) {
                for (var p in rawPlanets) {
                  if (p is Map) {
                    final planetName = (p['name'] ?? p['code'] ?? 'Planet').toString();
                    final planetSign = p['rashi'] as String? ?? p['sign'] as String?;
                    int house = (p['house'] as num?)?.toInt() ?? 1;
                    
                    if (planetSign != null) {
                      final planetSignIndex = getSignIndex(planetSign);
                      house = ((planetSignIndex - lagnaIndex) % 12) + 1;
                      if (house <= 0) house += 12;
                    }
                    
                    if (!activePlanets.containsKey(house)) {
                      activePlanets[house] = [];
                    }
                    activePlanets[house]!.add(planetName);
                  }
                }
              } else if (rawPlanets is Map) {
                rawPlanets.forEach((key, value) {
                  if (value is Map) {
                    final planetSign = value['sign'] as String? ?? value['rashi'] as String?;
                    int house = 1;
                    if (planetSign != null) {
                      final planetSignIndex = getSignIndex(planetSign);
                      house = ((planetSignIndex - lagnaIndex) % 12) + 1;
                      if (house <= 0) house += 12;
                    } else {
                      house = (value['house'] as num?)?.toInt() ?? 1;
                    }

                    if (!activePlanets.containsKey(house)) {
                      activePlanets[house] = [];
                    }
                    activePlanets[house]!.add(key.toString());
                  }
                });
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isExploring ? 'Lagna Explorer' : 'Vedic Birth Chart',
                                        style: GoogleFonts.outfit(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isExploring ? AppColors.secondary : AppColors.getTextPrimary(context),
                                          height: 1.25,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Precision planetary alignment & house positions',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.5,
                                          color: AppColors.getTextSecondary(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  icon: Icon(Icons.bug_report, color: AppColors.getTextMuted(context), size: 18),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        backgroundColor: AppColors.cardSurface,
                                        title: const Text('Kundli Data Inspector', style: TextStyle(color: AppColors.primary)),
                                        content: SingleChildScrollView(
                                          child: SelectableText(chartData.toString(), style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context), 
                                            child: const Text('Close')
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                ),
                              ],
                            ),
                            if (activeProfile.name.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                activeProfile.name,
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                _InfoChip(label: 'Lagna', value: lagna.split(' ').first, icon: Icons.explore_rounded),
                                _InfoChip(label: 'Rashi', value: rashiName, icon: Icons.auto_awesome_rounded),
                                _InfoChip(label: 'Nakshatra', value: '$nakshatra P$pada', icon: Icons.brightness_3_rounded),
                              ],
                            ),
                            if (calculatedAt != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _formatCalculatedAt(calculatedAt),
                                style: GoogleFonts.inter(
                                  color: AppColors.getTextMuted(context),
                                  fontSize: 11,
                                  height: 1.35,
                                ),
                              ),
                            ],
                            const SizedBox(height: 14),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary, width: 1.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: () async {
                                final currentLang = ref.read(localeProvider);
                                await PdfReportGenerator.downloadAndPrintPdf(
                                  userName: activeProfile.name,
                                  dob: activeProfile.dob,
                                  birthTime: activeProfile.birthTime,
                                  birthPlace: activeProfile.birthPlace,
                                  language: currentLang,
                                );
                              },
                              icon: const Icon(Icons.picture_as_pdf_rounded, size: 16),
                              label: Text(
                                AppLocalizations.of(context, ref).generatePdfReport,
                                style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: 'Interactive Kundli Chart. Tap any house cell for details.',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Tap House',
                                style: GoogleFonts.inter(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, height: 1.2),
                              ),
                            ],
                          ),
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
                          context: context,
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
    );
  }

  String _formatCalculatedAt(String iso) {
    if (iso.startsWith('Calculated')) return iso;
    try {
      final dt = DateTime.parse(iso).toLocal();
      final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final m = dt.minute.toString().padLeft(2, '0');
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      return 'Calculated on ${dt.day}/${dt.month}/${dt.year} at $h:$m $ampm';
    } catch (_) {
      return iso.contains('Calculated') ? iso : 'Calculated at $iso';
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;

  const _InfoChip({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: AppColors.primary),
            const SizedBox(width: 5),
          ],
          Text(
            '$label: ',
            style: GoogleFonts.inter(
              color: AppColors.getTextSecondary(context),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                color: AppColors.primary,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
