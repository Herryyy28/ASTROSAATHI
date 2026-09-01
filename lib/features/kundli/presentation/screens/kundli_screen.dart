import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../astrology/presentation/widgets/birth_chart_card.dart';

/// Provider for selected kundli tab index
final kundliTabProvider = StateProvider<int>((ref) => 0);

class KundliScreen extends ConsumerWidget {
  const KundliScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context, ref);
    final chartAsync = ref.watch(birthChartProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final selectedTab = ref.watch(kundliTabProvider);

    final tabs = [
      l10n.tabOverview,
      l10n.tabPlanets,
      l10n.tabHouses,
      l10n.tabDasha,
      l10n.tabYogas,
      l10n.tabRemedies,
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: Column(
              children: [
                // ── Header ─────────────────────────────────
                _buildHeader(context, activeProfile, l10n),

                // ── Tab Selector ───────────────────────────
                _buildTabSelector(context, ref, tabs, selectedTab),

                // ── Content ────────────────────────────────
                Expanded(
                  child: chartAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(24),
                      child: ShimmerLoader(itemCount: 4, itemHeight: 100),
                    ),
                    error: (error, stack) => ErrorStateWidget(
                      message: error.toString().replaceFirst('Exception: ', ''),
                      onRetry: () => ref.invalidate(birthChartProvider),
                    ),
                    data: (chartData) => _buildTabContent(
                      context, ref, selectedTab, chartData, l10n,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    BirthProfileData profile,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldGradient,
              boxShadow: AppColors.goldGlowShadow,
            ),
            child: Center(
              child: Text(
                profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '✦',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kundliTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  profile.name.isNotEmpty
                      ? '${profile.name} • ${profile.dob}'
                      : 'Create your Kundli to begin',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabSelector(
    BuildContext context,
    WidgetRef ref,
    List<String> tabs,
    int selectedTab,
  ) {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isActive = selectedTab == index;
          return GestureDetector(
            onTap: () => ref.read(kundliTabProvider.notifier).state = index,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.glassSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isActive
                      ? AppColors.primary.withOpacity(0.5)
                      : AppColors.glassBorder,
                  width: isActive ? 1 : 0.5,
                ),
              ),
              child: Text(
                tabs[index],
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondaryDark,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent(
    BuildContext context,
    WidgetRef ref,
    int tab,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    switch (tab) {
      case 0:
        return _buildOverviewTab(context, chartData, l10n);
      case 1:
        return _buildPlanetsTab(context, chartData, l10n);
      case 2:
        return _buildHousesTab(context, chartData, l10n);
      case 3:
        return _buildDashaTab(context, chartData, l10n);
      case 4:
        return _buildYogasTab(context, chartData, l10n);
      case 5:
        return _buildRemediesTab(context, chartData, l10n);
      default:
        return _buildOverviewTab(context, chartData, l10n);
    }
  }

  // ── Overview Tab ──────────────────────────────────
  Widget _buildOverviewTab(
    BuildContext context,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    final planets = (chartData['planets'] as List<dynamic>?) ?? [];

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Birth Chart Visual
                const BirthChartCard(),
                const SizedBox(height: 20),

                // Ascendant Summary Card
                _buildAscendantCard(chartData).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 16),

                // Key Planets Summary
                Text(
                  '${l10n.tabPlanets} ${l10n.tabOverview}',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const SizedBox(height: 12),

                ...planets.take(5).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final planet = entry.value as Map<String, dynamic>;
                  return _buildPlanetSummaryCard(planet, l10n, index);
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAscendantCard(Map<String, dynamic> chartData) {
    final ascendant = chartData['ascendant'] as String? ?? 'Aries';
    final ascendantLord = chartData['ascendantLord'] as String? ?? 'Mars';

    return GlassCard(
      borderRadius: 20,
      glowColor: AppColors.goldGlow,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.goldSubtleGradient,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.4),
              ),
            ),
            child: Center(
              child: Text(
                AppColors.zodiacEmojis[ascendant] ?? '♈',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ascendant / Lagna',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textTertiaryDark,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$ascendant Rising',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  'Lord: $ascendantLord',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.auto_awesome,
            color: AppColors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ── Progressive Disclosure Planet Card ─────────────
  Widget _buildPlanetSummaryCard(
    Map<String, dynamic> planet,
    AppLocalizations l10n,
    int index,
  ) {
    final name = planet['name'] as String? ?? 'Planet';
    final house = planet['house'] as int? ?? 1;
    final sign = planet['sign'] as String? ?? 'Aries';
    final degree = planet['degree'] as num? ?? 0;
    final nakshatra = planet['nakshatra'] as String? ?? '';
    final retrograde = planet['retrograde'] as bool? ?? false;
    final strength = planet['strength'] as String? ?? 'Moderate';
    final meaning = planet['meaning'] as String? ?? 'This planet influences your life path.';

    return _ProgressiveDisclosureCard(
      title: '$name • ${house}th House',
      badge: strength,
      badgeColor: strength == 'Strong'
          ? AppColors.success
          : (strength == 'Weak' ? AppColors.warning : AppColors.tertiary),
      subtitle: '$sign ${retrograde ? '℞' : ''} · ${degree.toStringAsFixed(1)}°',
      meaningText: meaning,
      technicalDetails: nakshatra.isNotEmpty
          ? 'Nakshatra: $nakshatra • Degree: ${degree.toStringAsFixed(2)}° • Strength: $strength'
          : 'Degree: ${degree.toStringAsFixed(2)}° • Strength: $strength',
      whatThisMeansLabel: l10n.whatThisMeans,
      viewDetailsLabel: l10n.viewTechnicalDetails,
      index: index,
    );
  }

  // ── Planets Tab ───────────────────────────────────
  Widget _buildPlanetsTab(
    BuildContext context,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    final planets = (chartData['planets'] as List<dynamic>?) ?? [];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: planets.length,
      itemBuilder: (context, index) {
        final planet = planets[index] as Map<String, dynamic>;
        return _buildPlanetSummaryCard(planet, l10n, index);
      },
    );
  }

  // ── Houses Tab ────────────────────────────────────
  Widget _buildHousesTab(
    BuildContext context,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    final houses = (chartData['houses'] as List<dynamic>?) ?? [];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: houses.length,
      itemBuilder: (context, index) {
        final house = houses[index] as Map<String, dynamic>;
        final houseNum = house['number'] as int? ?? (index + 1);
        final sign = house['sign'] as String? ?? 'Aries';
        final lord = house['lord'] as String? ?? '';
        final planets = (house['planets'] as List<dynamic>?) ?? [];
        final meaning = house['meaning'] as String? ?? 'This house governs aspects of your life.';

        return _ProgressiveDisclosureCard(
          title: 'House $houseNum • $sign',
          badge: planets.isNotEmpty ? '${planets.length} Planet${planets.length > 1 ? 's' : ''}' : 'Empty',
          badgeColor: planets.isNotEmpty ? AppColors.success : AppColors.textTertiaryDark,
          subtitle: 'Lord: $lord${planets.isNotEmpty ? ' • ${planets.join(", ")}' : ''}',
          meaningText: meaning,
          technicalDetails: 'Sign: $sign • Lord: $lord • Planets: ${planets.isNotEmpty ? planets.join(", ") : "None"}',
          whatThisMeansLabel: l10n.whatThisMeans,
          viewDetailsLabel: l10n.viewTechnicalDetails,
          index: index,
        );
      },
    );
  }

  // ── Dasha Tab ─────────────────────────────────────
  Widget _buildDashaTab(
    BuildContext context,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    final dasha = (chartData['dasha'] as Map<String, dynamic>?) ?? {};
    final mahadasha = dasha['mahadasha'] as String? ?? 'Jupiter';
    final antardasha = dasha['antardasha'] as String? ?? 'Venus';
    final startDate = dasha['startDate'] as String? ?? '';
    final endDate = dasha['endDate'] as String? ?? '';
    final progress = (dasha['progress'] as num?)?.toDouble() ?? 0.45;
    final meaning = dasha['meaning'] as String? ?? 'This period influences your overall life direction and fortune.';

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current Dasha Card
                GlassCard(
                  borderRadius: 20,
                  glowColor: AppColors.purpleGlow,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.currentPeriod.toUpperCase(),
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$mahadasha Mahadasha',
                        style: GoogleFonts.outfit(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$antardasha Antardasha',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      if (startDate.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '$startDate → $endDate',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textTertiaryDark,
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: AppColors.surfaceHighlightDark,
                          color: AppColors.secondary,
                          minHeight: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).toInt()}% Complete',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textTertiaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Meaning
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.secondary.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              color: AppColors.secondary,
                              size: 16,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                meaning,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryDark,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Yogas Tab ─────────────────────────────────────
  Widget _buildYogasTab(
    BuildContext context,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    final yogas = (chartData['yogas'] as List<dynamic>?) ?? [];
    final doshas = (chartData['doshas'] as List<dynamic>?) ?? [];

    final allItems = [
      ...yogas.map((y) => {'type': 'yoga', 'data': y}),
      ...doshas.map((d) => {'type': 'dosha', 'data': d}),
    ];

    if (allItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 48),
              const SizedBox(height: 16),
              Text(
                'Yoga & Dosha analysis will appear here',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.textSecondaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: allItems.length,
      itemBuilder: (context, index) {
        final item = allItems[index];
        final isYoga = item['type'] == 'yoga';
        final data = item['data'] as Map<String, dynamic>;
        final name = data['name'] as String? ?? (isYoga ? 'Yoga' : 'Dosha');
        final description = data['description'] as String? ?? '';
        final present = data['present'] as bool? ?? false;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            borderColor: present
                ? (isYoga ? AppColors.success.withOpacity(0.4) : AppColors.warning.withOpacity(0.4))
                : AppColors.glassBorder,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: present
                        ? (isYoga ? AppColors.success.withOpacity(0.15) : AppColors.warning.withOpacity(0.15))
                        : AppColors.surfaceHighlightDark,
                  ),
                  child: Icon(
                    isYoga ? Icons.star_rounded : Icons.warning_amber_rounded,
                    color: present
                        ? (isYoga ? AppColors.success : AppColors.warning)
                        : AppColors.textTertiaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: present
                        ? (isYoga ? AppColors.success.withOpacity(0.15) : AppColors.warning.withOpacity(0.15))
                        : AppColors.surfaceHighlightDark,
                  ),
                  child: Text(
                    present ? (isYoga ? 'Active' : 'Present') : 'Absent',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: present
                          ? (isYoga ? AppColors.success : AppColors.warning)
                          : AppColors.textTertiaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 60 * index)),
        );
      },
    );
  }

  // ── Remedies Tab ──────────────────────────────────
  Widget _buildRemediesTab(
    BuildContext context,
    Map<String, dynamic> chartData,
    AppLocalizations l10n,
  ) {
    final remedies = (chartData['remedies'] as List<dynamic>?) ?? [];

    if (remedies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.diamond_rounded, color: AppColors.primary, size: 48),
              const SizedBox(height: 16),
              Text(
                'Personalized remedies based on your Kundli will appear here',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  color: AppColors.textSecondaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      physics: const BouncingScrollPhysics(),
      itemCount: remedies.length,
      itemBuilder: (context, index) {
        final remedy = remedies[index] as Map<String, dynamic>;
        final name = remedy['name'] as String? ?? 'Remedy';
        final type = remedy['type'] as String? ?? 'Mantra';
        final description = remedy['description'] as String? ?? '';

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            borderRadius: 18,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.goldSubtleGradient,
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        type,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: 60 * index)),
        );
      },
    );
  }
}

// ── Progressive Disclosure Card Widget ───────────────
class _ProgressiveDisclosureCard extends StatefulWidget {
  final String title;
  final String badge;
  final Color badgeColor;
  final String subtitle;
  final String meaningText;
  final String technicalDetails;
  final String whatThisMeansLabel;
  final String viewDetailsLabel;
  final int index;

  const _ProgressiveDisclosureCard({
    required this.title,
    required this.badge,
    required this.badgeColor,
    required this.subtitle,
    required this.meaningText,
    required this.technicalDetails,
    required this.whatThisMeansLabel,
    required this.viewDetailsLabel,
    required this.index,
  });

  @override
  State<_ProgressiveDisclosureCard> createState() =>
      _ProgressiveDisclosureCardState();
}

class _ProgressiveDisclosureCardState extends State<_ProgressiveDisclosureCard> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 18,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Primary View ────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: widget.badgeColor.withOpacity(0.15),
                            ),
                            child: Text(
                              widget.badge,
                              style: GoogleFonts.outfit(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: widget.badgeColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── "What this means" summary ───────────────
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.15),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.whatThisMeansLabel,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.meaningText,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondaryDark,
                            height: 1.4,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Expandable Technical Details ────────────
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => setState(() => _showDetails = !_showDetails),
              child: Row(
                children: [
                  Icon(
                    _showDetails
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: AppColors.textTertiaryDark,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.viewDetailsLabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textTertiaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlightDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.technicalDetails,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: AppColors.textTertiaryDark,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              crossFadeState: _showDetails
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: 60 * widget.index),
        );
  }
}
