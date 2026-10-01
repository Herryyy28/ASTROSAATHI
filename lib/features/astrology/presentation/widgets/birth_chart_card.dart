import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class BirthChartCard extends ConsumerStatefulWidget {
  const BirthChartCard({super.key});

  @override
  ConsumerState<BirthChartCard> createState() => _BirthChartCardState();
}

class _BirthChartCardState extends ConsumerState<BirthChartCard> {
  String? selectedLagna;
  bool isSouthIndianChart = false;
  int? selectedHouse;
  String? selectedPlanet;

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

  final Map<int, String> houseNames = {
    1: '1st House (Lagna / Tanu Bhava)',
    2: '2nd House (Dhana Bhava)',
    3: '3rd House (Sahaja Bhava)',
    4: '4th House (Sukha Bhava)',
    5: '5th House (Putra Bhava)',
    6: '6th House (Ripu Bhava)',
    7: '7th House (Kalatra Bhava)',
    8: '8th House (Ayur Bhava)',
    9: '9th House (Bhagya Bhava)',
    10: '10th House (Karma Bhava)',
    11: '11th House (Labha Bhava)',
    12: '12th House (Vyaya Bhava)',
  };

  final Map<int, String> houseMeanings = {
    1: 'Vitality, physical health, personality, self-image, and soul purpose.',
    2: 'Family wealth, speech quality, liquid assets, food habits, and values.',
    3: 'Inner courage, younger siblings, short travels, communication, and skills.',
    4: 'Home environment, mother, landed property, vehicles, and peace of mind.',
    5: 'Intelligence, past life karma (Purva Punya), romance, creativity, and children.',
    6: 'Daily work routine, health immunity against disease, debts, and competitive edge.',
    7: 'Marriage partner, long-term business contracts, public relations, and harmony.',
    8: 'Longevity, unearned wealth, sudden transformations, research, and occult wisdom.',
    9: 'Divine luck, higher wisdom, father, pilgrimages, higher education, and guru.',
    10: 'Executive career, public status, authority, ambition, and professional duties.',
    11: 'Financial gains, fulfillment of long-term desires, elder siblings, and networks.',
    12: 'Moksha (Liberation), foreign residence, subconscious mind, expenses, and devotion.',
  };

  final Map<String, String> planetSignifications = {
    'sun': 'Sun (Surya): Vitality, leadership, self-confidence, fatherly blessings, and soul authority.',
    'moon': 'Moon (Chandra): Emotional balance, mental peace, motherly care, intuition, and public rapport.',
    'mars': 'Mars (Mangal): Physical strength, courage, ambition, property, energy, and sibling support.',
    'mercury': 'Mercury (Budh): Intellect, business analysis, communication, logic, and fast learning.',
    'jupiter': 'Jupiter (Guru): Supreme wisdom, divine grace, higher spirituality, wealth, and children.',
    'venus': 'Venus (Shukra): Creative harmony, aesthetic elegance, love partnerships, luxury, and art.',
    'saturn': 'Saturn (Shani): Discipline, endurance, structure, karmic lessons, and career longevity.',
    'rahu': 'Rahu (North Node): Ambition, worldly expansion, innovation, technology, and unconventional mastery.',
    'ketu': 'Ketu (South Node): Moksha, spiritual detachment, occult perception, intuition, and subtle wisdom.',
  };

  final Map<String, String> planetLordships = {
    'sun': 'Rules 5th House (Simha / Leo)',
    'moon': 'Rules 4th House (Karka / Cancer)',
    'mars': 'Rules 1st House (Mesha) & 8th House (Vrischika)',
    'mercury': 'Rules 3rd House (Mithuna) & 6th House (Kanya)',
    'jupiter': 'Rules 9th House (Dhanu) & 12th House (Meena)',
    'venus': 'Rules 2nd House (Vrishabha) & 7th House (Tula)',
    'saturn': 'Rules 10th House (Makara) & 11th House (Kumbha)',
    'rahu': 'Co-rules 11th House (Kumbha / Aquarius)',
    'ketu': 'Co-rules 8th House (Vrischika / Scorpio)',
  };

  final Map<int, String> houseRulers = {
    1: 'Mars', 2: 'Venus', 3: 'Mercury', 4: 'Moon',
    5: 'Sun', 6: 'Mercury', 7: 'Venus', 8: 'Mars',
    9: 'Jupiter', 10: 'Saturn', 11: 'Saturn', 12: 'Jupiter'
  };

  // ── Polished Planet Details Bottom Sheet ─────────────────────────────
  void _showPlanetDetailsBottomSheet(
    BuildContext context,
    String planetName,
    Map<String, dynamic>? planetData,
    int? houseNumber,
  ) {
    HapticFeedback.selectionClick();

    setState(() {
      selectedPlanet = planetName;
      selectedHouse = houseNumber;
    });

    final lower = planetName.toLowerCase();
    String signification = 'Vedic planetary energy influencing this house placement.';
    for (final entry in planetSignifications.entries) {
      if (lower.contains(entry.key)) {
        signification = entry.value;
        break;
      }
    }

    String? lordship;
    for (final entry in planetLordships.entries) {
      if (lower.contains(entry.key)) {
        lordship = entry.value;
        break;
      }
    }

    final sign = planetData?['sign'] as String? ?? planetData?['rashi'] as String?;
    final house = houseNumber ?? (planetData?['house'] as num?)?.toInt();
    final degree = planetData?['degree'] != null
        ? '${(planetData!['degree'] as num).toStringAsFixed(1)}°'
        : null;
    final nakshatra = planetData?['nakshatra'] as String?;
    final pada = planetData?['pada']?.toString();
    final isRetrograde = planetData?['retrograde'] as bool? ?? false;
    final isCombust = planetData?['combust'] as bool? ?? false;
    final dignity = planetData?['dignity'] as String? ?? planetData?['status'] as String?;

    final l10n = AppLocalizations.of(context, ref);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (ctx) {
        final isLight = AppColors.isLight(ctx);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.getSurface(ctx).withOpacity(0.96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: AppColors.getGlassBorder(ctx), width: 1.0),
            ),
            boxShadow: AppColors.goldGlowShadow,
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: AppColors.getTextMuted(ctx).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title & Symbol Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.15),
                              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  planetName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(ctx),
                                  ),
                                ),
                                if (house != null)
                                  Text(
                                    '${l10n.houseNumber(house)} • ${sign ?? 'Vedic Position'}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.getTextSecondary(ctx),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(ctx)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Key Metric Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (house != null)
                      _InfoChip(
                        label: l10n.houses,
                        value: l10n.houseNumber(house),
                        icon: Icons.home_rounded,
                      ),
                    if (sign != null && sign.isNotEmpty)
                      _InfoChip(
                        label: l10n.signs,
                        value: sign,
                        icon: Icons.brightness_auto_rounded,
                      ),
                    if (degree != null)
                      _InfoChip(
                        label: l10n.degree,
                        value: degree,
                        icon: Icons.straighten_rounded,
                      ),
                    if (nakshatra != null && nakshatra.isNotEmpty)
                      _InfoChip(
                        label: l10n.nakshatra,
                        value: pada != null ? '$nakshatra (P$pada)' : nakshatra,
                        icon: Icons.brightness_3_rounded,
                      ),
                    if (isRetrograde)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.warning.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.rotate_left_rounded, size: 13, color: AppColors.warning),
                            const SizedBox(width: 4),
                            Text(
                              l10n.retrograde,
                              style: GoogleFonts.outfit(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (isCombust)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.error.withOpacity(0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.local_fire_department_rounded, size: 13, color: AppColors.error),
                            const SizedBox(width: 4),
                            Text(
                              l10n.combust,
                              style: GoogleFonts.outfit(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (dignity != null && dignity.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                        ),
                        child: Text(
                          dignity,
                          style: GoogleFonts.outfit(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),

                // Planetary Lordship
                if (lordship != null) ...[
                  Text(
                    'Vedic Lordship',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                    ),
                    child: Text(
                      lordship,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(ctx),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Astrological Signification
                Text(
                  l10n.whatThisMeans,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.surfaceSecondaryLight
                        : AppColors.surfaceSecondaryDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.getGlassBorder(ctx)),
                  ),
                  child: Text(
                    signification,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.getTextPrimary(ctx),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          selectedPlanet = null;
          selectedHouse = null;
        });
      }
    });
  }

  // ── Polished House Details Bottom Sheet ──────────────────────────────
  void _showHouseDetailsBottomSheet(
    BuildContext context,
    int houseNumber,
    Map<int, List<String>> activePlanets,
    List<dynamic>? rawPlanetsList,
  ) {
    HapticFeedback.selectionClick();

    setState(() {
      selectedHouse = houseNumber;
      selectedPlanet = null;
    });

    final planets = activePlanets[houseNumber] ?? [];
    final houseTitle = houseNames[houseNumber] ?? 'House $houseNumber';
    final houseMeaning = houseMeanings[houseNumber] ?? 'Vedic house governing life energies.';
    final houseLord = houseRulers[houseNumber] ?? 'Mars';
    final l10n = AppLocalizations.of(context, ref);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      builder: (ctx) {
        final isLight = AppColors.isLight(ctx);
        return Container(
          decoration: BoxDecoration(
            color: AppColors.getSurface(ctx).withOpacity(0.96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(
              top: BorderSide(color: AppColors.getGlassBorder(ctx), width: 1.0),
            ),
            boxShadow: AppColors.goldGlowShadow,
          ),
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(ctx).viewInsets.bottom + MediaQuery.of(ctx).padding.bottom + 24,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4.5,
                    decoration: BoxDecoration(
                      color: AppColors.getTextMuted(ctx).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title & House Lord Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            houseTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${l10n.lord}: $houseLord',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.getTextSecondary(ctx),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(ctx)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // House Signification Description
                Text(
                  l10n.houseSignifications,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(ctx),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.surfaceSecondaryLight
                        : AppColors.surfaceSecondaryDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.getGlassBorder(ctx)),
                  ),
                  child: Text(
                    houseMeaning,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.getTextPrimary(ctx),
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Residing Planetary Energies or Clear Empty State
                Text(
                  '${l10n.planetaryPositions} (${planets.length}):',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(ctx),
                  ),
                ),
                const SizedBox(height: 8),

                if (planets.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: planets.map((p) {
                      return ActionChip(
                        avatar: const Icon(Icons.info_outline_rounded, size: 14, color: AppColors.primary),
                        backgroundColor: AppColors.primary.withOpacity(0.15),
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.4),
                        ),
                        label: Text(
                          p,
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          Map<String, dynamic>? matchingPlanet;
                          if (rawPlanetsList != null) {
                            for (final item in rawPlanetsList) {
                              if (item is Map) {
                                final pName = (item['name'] ?? item['code'] ?? '').toString().toLowerCase();
                                if (pName.contains(p.toLowerCase()) || p.toLowerCase().contains(pName)) {
                                  matchingPlanet = Map<String, dynamic>.from(item);
                                  break;
                                }
                              }
                            }
                          }
                          _showPlanetDetailsBottomSheet(context, p, matchingPlanet, houseNumber);
                        },
                      );
                    }).toList(),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.nightlight_round, size: 16, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.noPlanetInHouse,
                            style: GoogleFonts.inter(
                              fontSize: 12.5,
                              color: AppColors.getTextSecondary(ctx),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          selectedHouse = null;
          selectedPlanet = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final birthChartAsync = ref.watch(birthChartProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final l10n = AppLocalizations.of(context, ref);

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: birthChartAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 36),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
        error: (e, st) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded, color: AppColors.error, size: 36),
                const SizedBox(height: 10),
                Text(
                  l10n.unableToLoadChart,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: AppColors.getTextPrimary(context),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  e.toString().replaceFirst('Exception: ', ''),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: AppColors.getTextSecondary(context),
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => ref.invalidate(birthChartProvider),
                  icon: const Icon(Icons.refresh_rounded, size: 16),
                  label: Text(
                    l10n.retry,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (chartData) {
          final isCanonical = chartData.containsKey('profileId') &&
              chartData.containsKey('lagna') &&
              chartData['lagna'] is Map;

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
                                    isExploring ? 'Lagna Explorer' : l10n.birthChart,
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
                                        child: Text(l10n.close),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                            _InfoChip(label: l10n.ascendantLagna, value: lagna.split(' ').first, icon: Icons.explore_rounded),
                            _InfoChip(label: 'Rashi', value: rashiName, icon: Icons.auto_awesome_rounded),
                            _InfoChip(label: l10n.nakshatra, value: '$nakshatra P$pada', icon: Icons.brightness_3_rounded),
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
                        const SizedBox(height: 12),
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
                            l10n.generatePdfReport,
                            style: GoogleFonts.outfit(fontSize: 12.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSouthIndianChart = !isSouthIndianChart;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSouthIndianChart ? Icons.grid_view_rounded : Icons.diamond_outlined,
                                color: AppColors.primary,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isSouthIndianChart ? 'South Indian' : 'North Indian',
                                style: GoogleFonts.inter(
                                  color: AppColors.primary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Tooltip(
                        message: 'Interactive Kundli Chart. Tap any planet or house cell.',
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app_rounded, color: AppColors.primary, size: 12),
                              const SizedBox(width: 3),
                              Text(
                                'Interactive',
                                style: GoogleFonts.inter(color: AppColors.primary, fontSize: 9.5, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Interactive Chart Canvas with Accessibility Semantics ────────
              AspectRatio(
                aspectRatio: 1.0,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final chartSize = Size(constraints.maxWidth, constraints.maxHeight);
                    final chartStyle = isSouthIndianChart
                        ? VedicChartStyle.southIndian
                        : VedicChartStyle.northIndian;

                    return Semantics(
                      label: 'Interactive Vedic Birth Chart for ${activeProfile.name}. Lagna ${lagna.split(' ').first}, Rashi $rashiName. Double tap houses or planets to inspect astrological details.',
                      button: true,
                      child: GestureDetector(
                        onTapUp: (details) {
                          final local = details.localPosition;

                          // 1. First test if user tapped a Planet directly!
                          final tappedPlanet = VedicChartGeometry.hitTestPlanet(
                            localPosition: local,
                            size: chartSize,
                            style: chartStyle,
                            lagnaSignIndex: lagnaIndex,
                            housePlanets: activePlanets,
                          );

                          if (tappedPlanet != null) {
                            Map<String, dynamic>? matchingPlanet;
                            int? pHouse;
                            if (rawPlanets is List) {
                              for (final item in rawPlanets) {
                                if (item is Map) {
                                  final pName = (item['name'] ?? item['code'] ?? '').toString().toLowerCase();
                                  if (pName.contains(tappedPlanet.toLowerCase()) ||
                                      tappedPlanet.toLowerCase().contains(pName)) {
                                    matchingPlanet = Map<String, dynamic>.from(item);
                                    pHouse = (item['house'] as num?)?.toInt();
                                    break;
                                  }
                                }
                              }
                            }
                            _showPlanetDetailsBottomSheet(
                              context,
                              tappedPlanet,
                              matchingPlanet,
                              pHouse,
                            );
                            return;
                          }

                          // 2. Otherwise test if user tapped a House!
                          final tappedHouse = VedicChartGeometry.hitTestHouse(
                            localPosition: local,
                            size: chartSize,
                            style: chartStyle,
                            lagnaSignIndex: lagnaIndex,
                          );

                          if (tappedHouse > 0) {
                            _showHouseDetailsBottomSheet(
                              context,
                              tappedHouse,
                              activePlanets,
                              rawPlanets is List ? rawPlanets : null,
                            );
                          }
                        },
                        child: CustomPaint(
                          painter: VedicChartPainter(
                            housePlanets: activePlanets,
                            context: context,
                            style: chartStyle,
                            lagnaSignIndex: lagnaIndex,
                            selectedHouse: selectedHouse,
                            selectedPlanet: selectedPlanet,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
                  .animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(
                    duration: 3000.ms,
                    color: AppColors.primaryLight.withOpacity(0.15),
                  ),
              const SizedBox(height: 16),
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
