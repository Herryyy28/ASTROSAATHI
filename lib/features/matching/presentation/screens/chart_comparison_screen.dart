import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../kundli/presentation/widgets/biwheel_chart_painter.dart';
import '../../../profile/presentation/widgets/add_family_member_modal.dart';

enum RelationshipType {
  couple('Couple', Icons.favorite_outline_rounded, AppColors.pink),
  friendship('Friendship', Icons.groups_outlined, AppColors.secondary),
  parentChild(
    'Parent / Child',
    Icons.family_restroom_outlined,
    AppColors.primaryLightMode,
  ),
  siblings('Siblings', Icons.people_outline_rounded, AppColors.actionPurple),
  business(
    'Business Partners',
    Icons.handshake_outlined,
    AppColors.primaryLightMode,
  );

  final String label;
  final IconData icon;
  final Color color;

  const RelationshipType(this.label, this.icon, this.color);
}

class ChartComparisonScreen extends ConsumerStatefulWidget {
  const ChartComparisonScreen({super.key});

  @override
  ConsumerState<ChartComparisonScreen> createState() =>
      _ChartComparisonScreenState();
}

class _ChartComparisonScreenState extends ConsumerState<ChartComparisonScreen> {
  RelationshipType _selectedType = RelationshipType.couple;
  int _view = 0;
  BirthProfileData? _profile1;
  BirthProfileData? _profile2;

  @override
  void initState() {
    super.initState();
    final profiles = ref.read(profilesListProvider);
    if (profiles.isNotEmpty) {
      _profile1 = profiles.firstWhere(
        (p) => p.isPrimary,
        orElse: () => profiles.first,
      );
      if (profiles.length > 1) {
        _profile2 = profiles.firstWhere(
          (p) => p.id != _profile1?.id,
          orElse: () => profiles.last,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profilesListProvider);
    final providerSynastry = _profile1 == null || _profile2 == null
        ? null
        : ref.watch(
            synastryDataProvider(SynastryRequest(_profile1!.id, _profile2!.id)),
          );
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    tooltip: 'Back',
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                      color: AppColors.primaryLightMode,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.surfaceLight,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          'Synastry',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLightMode,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Explore the potential and dynamics\nof your relationship.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.35,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
                physics: const BouncingScrollPhysics(),
                children: [
                  AstroCard(
                    color: AppColors.highlightSurface,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PROFILE COMPARISON',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .9,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildProfileDropdown(
                                context,
                                label: 'You',
                                selected: _profile1,
                                profiles: profiles,
                                onChanged: (p) => setState(() => _profile1 = p),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: AstroGlyphIcon(
                                glyph: '↔',
                                size: 38,
                                semanticLabel: 'compared with',
                              ),
                            ),
                            Expanded(
                              child: _buildProfileDropdown(
                                context,
                                label: 'Partner / Friend',
                                selected: _profile2,
                                profiles: profiles,
                                onChanged: (p) => setState(() => _profile2 = p),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    'RELATIONSHIP DYNAMIC',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: RelationshipType.values.map((type) {
                        final isSel = type == _selectedType;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedType = type),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppColors.highlightSurface
                                  : AppColors.surfaceLight,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isSel
                                    ? AppColors.primaryLightMode
                                    : AppColors.borderLight,
                                width: isSel ? 1.5 : 0.6,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  type.icon,
                                  size: 14,
                                  color: isSel
                                      ? AppColors.primaryLightMode
                                      : AppColors.textSecondaryLight,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  type.label,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSel
                                        ? AppColors.primaryLightMode
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _viewTabs(),
                  const SizedBox(height: 18),

                  Builder(
                    builder: (context) {
                      final synastry = _computeSynastry();
                      if (synastry['ready'] == false) {
                        return AstroEmptyState(
                          icon: Icons.people_outline_rounded,
                          title: 'Add another profile',
                          subtitle: synastry['summary'] as String,
                          actionLabel: 'Add Profile',
                          onAction: () => AddFamilyMemberModal.show(context),
                        );
                      }

                      if (_view != 0) {
                        return _providerSynastryView(providerSynastry!, _view);
                      }

                      return Column(
                        children: [
                          const AstroSectionHeader(
                            title: 'Compatibility overview',
                          ),
                          const SizedBox(height: 10),
                          _buildCompatibilityScoreBanner(
                            context,
                            overallScore: synastry['overall'] as double,
                            summary: synastry['summary'] as String,
                          ),
                          const SizedBox(height: 16),

                          _buildMetricCard(
                            context,
                            title: 'Communication Harmony',
                            score: synastry['commScore'] as double,
                            icon: Icons.forum_rounded,
                            text: synastry['commText'] as String,
                          ),
                          const SizedBox(height: 10),
                          _buildMetricCard(
                            context,
                            title: 'Emotional & Mental Depth',
                            score: synastry['emotionalScore'] as double,
                            icon: Icons.favorite_border_rounded,
                            text: synastry['emotionalText'] as String,
                          ),
                          const SizedBox(height: 10),
                          _buildMetricCard(
                            context,
                            title: 'Shared Values & Long-term Goals',
                            score: synastry['valuesScore'] as double,
                            icon: Icons.flag_rounded,
                            text: synastry['valuesText'] as String,
                          ),
                          const SizedBox(height: 10),
                          _buildMetricCard(
                            context,
                            title: 'Potential Friction & Conflict Areas',
                            score: synastry['frictionScore'] as double,
                            icon: Icons.warning_amber_rounded,
                            text: synastry['frictionText'] as String,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _providerSynastryView(
    AsyncValue<SynastryData> asyncData,
    int view,
  ) => asyncData.when(
    loading: () => const AstroLoadingState(label: 'Calculating synastry'),
    error: (_, _) => const AstroErrorState(
      message: 'Calculated synastry data is unavailable.',
    ),
    data: (data) {
      if (data.aspects.isEmpty) {
        return const AstroEmptyState(
          icon: Icons.hub_outlined,
          title: 'No calculated synastry aspects',
          subtitle:
              'Exact planetary degrees are required from both birth charts.',
        );
      }
      if (view == 3) {
        final first = _biWheelPlanets(data.firstPlanets, false);
        final second = _biWheelPlanets(data.secondPlanets, true);
        if (first.isEmpty || second.isEmpty) {
          return const AstroEmptyState(
            icon: Icons.donut_large_rounded,
            title: 'Bi-wheel data unavailable',
            subtitle: 'Exact longitudes are required for both profiles.',
          );
        }
        return BiWheelChartWidget(
          innerTitle: _profile1?.name ?? 'You',
          outerTitle: _profile2?.name ?? 'Partner',
          innerPlanets: first,
          outerPlanets: second,
          aspectLines: data.aspects.map((aspect) {
            final type = aspect['aspectName']?.toString() ?? '';
            return BiWheelAspectLine(
              p1Name: aspect['planet1']?.toString() ?? '',
              p2Name: aspect['planet2']?.toString() ?? '',
              aspectType: type,
              color: type == 'Square' || type == 'Opposition'
                  ? AppColors.pink
                  : AppColors.secondary,
            );
          }).toList(),
        );
      }
      return Column(
        children: data.aspects.map((aspect) {
          final first = aspect['planet1']?.toString() ?? '';
          final second = aspect['planet2']?.toString() ?? '';
          final type = aspect['aspectName']?.toString() ?? 'Aspect';
          final orb = (aspect['orb'] as num?)?.toDouble();
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AstroCard(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  AstroGlyphIcon(
                    glyph: AstroSymbols.planet(first),
                    size: 38,
                    semanticLabel: first,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$first ↔ $second',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          orb == null
                              ? type
                              : '$type · ${orb.toStringAsFixed(2)}° orb',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AstroGlyphIcon(
                    glyph: AstroSymbols.planet(second),
                    size: 38,
                    semanticLabel: second,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    },
  );

  List<BiWheelPlanet> _biWheelPlanets(
    List<Map<String, dynamic>> values,
    bool outer,
  ) => values
      .map((planet) {
        final longitude = (planet['longitude'] as num?)?.toDouble();
        if (longitude == null) return null;
        return BiWheelPlanet(
          name: planet['name']?.toString() ?? '',
          longitude: longitude,
          sign: (planet['sign'] ?? planet['rashi'])?.toString() ?? '',
          isOuter: outer,
        );
      })
      .whereType<BiWheelPlanet>()
      .toList();

  Widget _viewTabs() {
    const labels = ['Overview', 'Planets', 'Aspects', 'Chart'];
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final selected = _view == index;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _view = index),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? AppColors.surfaceLight : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: selected
                      ? Border.all(color: AppColors.highlightSurface)
                      : null,
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? AppColors.primaryLightMode
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Map<String, dynamic> _computeSynastry() {
    if (_profile1 == null || _profile2 == null) {
      return {
        'ready': false,
        'overall': 0.0,
        'summary':
            'Please select two birth profiles above to calculate personalized synastry.',
        'commScore': 0.0,
        'commText': '',
        'emotionalScore': 0.0,
        'emotionalText': '',
        'valuesScore': 0.0,
        'valuesText': '',
        'frictionScore': 0.0,
        'frictionText': '',
      };
    }

    final p1 = ZodiacSignUtils.calculateAstroProfile(
      name: _profile1!.name,
      dob: _profile1!.dob,
      birthTime: _profile1!.birthTime,
    );
    final p2 = ZodiacSignUtils.calculateAstroProfile(
      name: _profile2!.name,
      dob: _profile2!.dob,
      birthTime: _profile2!.birthTime,
    );

    String getElement(String rashi) {
      const fire = ['Aries', 'Leo', 'Sagittarius'];
      const earth = ['Taurus', 'Virgo', 'Capricorn'];
      const air = ['Gemini', 'Libra', 'Aquarius'];
      if (fire.contains(rashi)) return 'Fire';
      if (earth.contains(rashi)) return 'Earth';
      if (air.contains(rashi)) return 'Air';
      return 'Water';
    }

    final e1 = getElement(p1.rashiEn);
    final e2 = getElement(p2.rashiEn);

    double elementScore = 7.5;
    String elementDesc = '$e1 and $e2 elemental alignment.';
    if (e1 == e2) {
      elementScore = 8.8;
      elementDesc =
          'Shared $e1 element creates natural resonance and instinctive mutual understanding.';
    } else if ((e1 == 'Fire' && e2 == 'Air') || (e1 == 'Air' && e2 == 'Fire')) {
      elementScore = 9.2;
      elementDesc =
          'Fire-Air synergy sparks creative inspiration, enthusiastic dialogue, and mutual motivation.';
    } else if ((e1 == 'Earth' && e2 == 'Water') ||
        (e1 == 'Water' && e2 == 'Earth')) {
      elementScore = 9.4;
      elementDesc =
          'Earth-Water combination provides emotional nourishment rooted in practical stability and security.';
    } else if ((e1 == 'Fire' && e2 == 'Water') ||
        (e1 == 'Water' && e2 == 'Fire')) {
      elementScore = 6.4;
      elementDesc =
          'Steam dynamic: passionate feelings require conscious tempering and thoughtful communication.';
    } else {
      elementScore = 7.0;
      elementDesc =
          'Distinct elemental perspectives ($e1 & $e2) offer fruitful complementary growth.';
    }

    final diffDeg = (p1.moonLongitude - p2.moonLongitude).abs();
    final aspectDiff = diffDeg > 180 ? 360 - diffDeg : diffDeg;
    double commScore = 7.5;
    String commText = 'Steady Mercurial alignment for daily dialogue.';
    if (aspectDiff < 30 || (aspectDiff >= 110 && aspectDiff <= 130)) {
      commScore = 9.1;
      commText =
          'Trine Moon resonance creates intuitive understanding where words flow effortlessly.';
    } else if (aspectDiff >= 80 && aspectDiff <= 100) {
      commScore = 6.8;
      commText =
          'Square tension indicates differing viewpoints; patience during debates is recommended.';
    } else if (aspectDiff >= 170 && aspectDiff <= 190) {
      commScore = 8.5;
      commText =
          'Opposition aspect generates magnetic intellectual attraction and complete perspective balance.';
    }

    final emotionalScore =
        (elementScore * 0.6 + (10.0 - (aspectDiff / 36.0)) * 0.4).clamp(
          5.0,
          9.8,
        );
    final emotionalText =
        'Moon in ${p1.rashiEn} (${p1.nakshatra}) meets Moon in ${p2.rashiEn} (${p2.nakshatra}): $elementDesc';

    final isSameLagna = p1.lagnaEn == p2.lagnaEn;
    final valuesScore = isSameLagna
        ? 9.2
        : ((p1.rulingPlanet == p2.rulingPlanet) ? 8.9 : 8.0);
    final valuesText =
        'Lagna Lords (${p1.rulingPlanet} & ${p2.rulingPlanet}) foster shared life aspirations.';

    final frictionScore = (10.5 - (elementScore * 0.4 + commScore * 0.4)).clamp(
      4.5,
      8.5,
    );
    final frictionText = frictionScore > 6.5
        ? 'Complementary planetary angles minimize major friction; maintain open transparent conversations.'
        : 'Occasional tempo differences between fire/water temperaments require active patience.';

    double overall = 7.8;
    switch (_selectedType) {
      case RelationshipType.couple:
        overall =
            (emotionalScore * 0.35 +
            valuesScore * 0.3 +
            commScore * 0.25 +
            (10 - frictionScore) * 0.1);
        break;
      case RelationshipType.friendship:
        overall = (commScore * 0.4 + emotionalScore * 0.3 + valuesScore * 0.3);
        break;
      case RelationshipType.business:
        overall =
            (valuesScore * 0.4 + commScore * 0.4 + (10 - frictionScore) * 0.2);
        break;
      case RelationshipType.parentChild:
      case RelationshipType.siblings:
        overall =
            (emotionalScore * 0.4 + valuesScore * 0.35 + commScore * 0.25);
        break;
    }
    overall = double.parse(overall.clamp(5.0, 9.8).toStringAsFixed(1));

    return {
      'ready': true,
      'overall': overall,
      'summary': overall >= 8.5
          ? 'Exceptional ${_selectedType.label} synergy! Harmonious cosmic vibrations for enduring cooperation.'
          : (overall >= 7.5
                ? 'Positive ${_selectedType.label} alignment with healthy dynamic growth opportunities.'
                : 'Moderate compatibility with valuable lessons in conscious communication and patience.'),
      'commScore': double.parse(commScore.toStringAsFixed(1)),
      'commText': commText,
      'emotionalScore': double.parse(emotionalScore.toStringAsFixed(1)),
      'emotionalText': emotionalText,
      'valuesScore': double.parse(valuesScore.toStringAsFixed(1)),
      'valuesText': valuesText,
      'frictionScore': double.parse(frictionScore.toStringAsFixed(1)),
      'frictionText': frictionText,
    };
  }

  Widget _buildProfileDropdown(
    BuildContext context, {
    required String label,
    required BirthProfileData? selected,
    required List<BirthProfileData> profiles,
    required ValueChanged<BirthProfileData?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.getSurfaceSecondary(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.getGlassBorder(context),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: AppColors.getTextMuted(context),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<BirthProfileData>(
              value: selected,
              isExpanded: true,
              dropdownColor: AppColors.getSurfaceElevated(context),
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.getTextPrimary(context),
              ),
              items: profiles.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(
                    p.name.isNotEmpty ? p.name : 'Unnamed Profile',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompatibilityScoreBanner(
    BuildContext context, {
    required double overallScore,
    required String summary,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderColor: _selectedType.color.withValues(alpha: 0.5),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
              boxShadow: AppColors.goldGlowShadow,
            ),
            child: Center(
              child: Text(
                '$overallScore',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _selectedType.icon,
                      size: 16,
                      color: _selectedType.color,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${_selectedType.label} Compatibility',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: _selectedType.color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  summary,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.getTextSecondary(context),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required double score,
    required IconData icon,
    required String text,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(icon, size: 16, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(score * 10).toInt()}%',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: (score / 10.0).clamp(0, 1)),
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: AppColors.secondaryBackground,
                color: AppColors.secondary,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: AppColors.getTextSecondary(context),
            ),
          ),
        ],
      ),
    );
  }
}
