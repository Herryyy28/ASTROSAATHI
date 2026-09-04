import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';

// Feature screens
import '../../../panchang/presentation/screens/panchang_screen.dart';
import '../../../muhurat/presentation/screens/muhurat_screen.dart';
import '../../../horoscope/presentation/screens/horoscope_screen.dart';
import '../../../remedies/presentation/screens/remedy_hub_screen.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../astrology/presentation/screens/numerology_screen.dart';
import '../../../astrology/presentation/screens/transits_screen.dart';

import '../../../home/presentation/screens/main_screen.dart';
import '../../../kundli/presentation/screens/kundli_screen.dart';
import '../../../astrology/presentation/screens/transit_center_screen.dart';
import '../../../matching/presentation/screens/chart_comparison_screen.dart';
import '../../../astrology/presentation/screens/astro_decision_engine_screen.dart';
import '../../../astrology/presentation/screens/astro_scenario_simulator_screen.dart';
import '../../../astrology/presentation/screens/future_event_radar_screen.dart';
import '../../../workspace/presentation/screens/astro_workspace_screen.dart';
import '../../../family/presentation/screens/family_astrology_dashboard_screen.dart';
import '../../../astrology/presentation/screens/returns_center_screen.dart';
import '../../../astrology/presentation/screens/saturn_return_screen.dart';
import '../../../astrology/presentation/screens/sky_now_ephemeris_screen.dart';
import '../../../astrology/presentation/screens/chart_patterns_screen.dart';
import '../../../divination/presentation/screens/human_design_screen.dart';
import '../../../astrology/presentation/screens/astro_research_screen.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';
import '../../../reports/presentation/screens/custom_pdf_report_builder_screen.dart';
import 'astro_academy_screen.dart';
import 'sky_now_screen.dart';
import 'year_ahead_screen.dart';
import 'future_radar_screen.dart';
import 'personal_timing_engine_screen.dart';
import 'synastry_composite_screen.dart';
import 'astrocartography_screen.dart';

enum ExploreViewMode { grid, list, folder }

enum ExploreFilter { all, vipOnly, freeOnly }

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  ExploreViewMode _viewMode = ExploreViewMode.grid;
  ExploreFilter _filter = ExploreFilter.all;

  // Track expanded folder categories for Folder View
  final Set<String> _expandedFolders = {
    'DAILY EPHEMERIS & TIMINGS',
    'ANALYSIS & COMPATIBILITY',
    'PREMIUM VIP EXCLUSIVES',
    'REMEDIES & NUMEROLOGY',
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context, ref);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isPremium = ref.watch(subscriptionProvider).isPremium;

    // Feature items model
    final List<Map<String, dynamic>> allFeatures = [
      // Section 1: Ephemeris & Timings
      {
        'id': 0,
        'category': 'DAILY EPHEMERIS & TIMINGS',
        'emoji': '🌅',
        'title': l10n.explorePanchang,
        'subtitle': 'Tithi • Nakshatra • Yoga',
        'gradient': const LinearGradient(colors: [Color(0xFF1E3C72), Color(0xFF2A5298)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PanchangScreen())),
      },
      {
        'id': 1,
        'category': 'DAILY EPHEMERIS & TIMINGS',
        'emoji': '⏱️',
        'title': l10n.exploreMuhurat,
        'subtitle': 'Abhijit • Rahu Kaal',
        'gradient': const LinearGradient(colors: [Color(0xFF3A1C71), Color(0xFFD76D77)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MuhuratScreen())),
      },
      {
        'id': 2,
        'category': 'DAILY EPHEMERIS & TIMINGS',
        'emoji': '♋',
        'title': l10n.exploreHoroscope,
        'subtitle': 'Daily • Weekly • Yearly',
        'gradient': const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HoroscopeScreen())),
      },

      // Section 2: Analysis & Compatibility
      {
        'id': 3,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '⚡',
        'title': l10n.exploreDosha,
        'subtitle': 'Mangal • Kaal Sarp • Yoga',
        'gradient': const LinearGradient(colors: [Color(0xFFFF512F), Color(0xFFDD2476)]),
        'isVip': false,
        'action': () {
          ref.read(kundliTabProvider.notifier).update((_) => 4);
          ref.read(mainNavIndexProvider.notifier).update((_) => 1);
        },
      },
      {
        'id': 4,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '💞',
        'title': l10n.exploreCompatibility,
        'subtitle': '36 Gun Milan Analysis',
        'gradient': const LinearGradient(colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchingScreen())),
      },
      {
        'id': 5,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '🪐',
        'title': 'Transit & Sade Sati',
        'subtitle': 'Live Saturn & Gochar Impact',
        'gradient': const LinearGradient(colors: [Color(0xFF4776E6), Color(0xFF8E54E9)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TransitCenterScreen())),
      },
      {
        'id': 6,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '👥',
        'title': 'Chart Synastry',
        'subtitle': 'Compare Any Two Profiles',
        'gradient': const LinearGradient(colors: [Color(0xFFD9901A), Color(0xFFE5A63C)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChartComparisonScreen())),
      },
      {
        'id': 7,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '📖',
        'title': 'Astro Academy',
        'subtitle': 'Glossary & Beginner Mode',
        'gradient': const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroAcademyScreen())),
      },
      {
        'id': 8,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '🎯',
        'title': 'Astro Decision Engine',
        'subtitle': 'Muhurat & Quantitative Timing',
        'gradient': const LinearGradient(colors: [Color(0xFFE0A13A), Color(0xFFF9D38D)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroDecisionEngineScreen())),
      },
      {
        'id': 9,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '🧪',
        'title': 'Scenario Simulator',
        'subtitle': 'Location & Planetary Shift Test',
        'gradient': const LinearGradient(colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroScenarioSimulatorScreen())),
      },
      {
        'id': 10,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '🔭',
        'title': 'Future Event Radar',
        'subtitle': '90-Day Planetary Milestones',
        'gradient': const LinearGradient(colors: [Color(0xFFF857A6), Color(0xFFFF5858)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FutureEventRadarScreen())),
      },
      {
        'id': 11,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '🏢',
        'title': 'Astro Workspace',
        'subtitle': 'Executive Command Workspace',
        'gradient': const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFFA500)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroWorkspaceScreen())),
      },
      {
        'id': 12,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '👨‍👩‍👧‍👦',
        'title': 'Family Dashboard',
        'subtitle': 'Spouse, Kids & Partner Synergy',
        'gradient': const LinearGradient(colors: [Color(0xFFFF758C), Color(0xFFFF7EB3)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyAstrologyDashboardScreen())),
      },
      {
        'id': 13,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '⏱️',
        'title': 'Sky Now & Ephemeris',
        'subtitle': 'Live Celestial Clock & Tables',
        'gradient': const LinearGradient(colors: [Color(0xFF00ACC1), Color(0xFF00897B)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SkyNowScreen())),
      },
      {
        'id': 14,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '📐',
        'title': 'Aspect Patterns',
        'subtitle': 'Grand Trines & Dominance',
        'gradient': const LinearGradient(colors: [Color(0xFF43A047), Color(0xFF1B5E20)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChartPatternsScreen())),
      },
      {
        'id': 15,
        'category': 'ANALYSIS & COMPATIBILITY',
        'emoji': '🧬',
        'title': 'Human Design',
        'subtitle': 'BodyGraph & Sacral Authority',
        'gradient': const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFF9C27B0)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HumanDesignScreen())),
      },

      // Section 3: VIP Exclusives
      {
        'id': 16,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '☀️',
        'title': 'Solar & Lunar Returns',
        'subtitle': 'Annual & Monthly Forecasts',
        'gradient': const LinearGradient(colors: [Color(0xFFFFB300), Color(0xFFF57C00)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ReturnsCenterScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 17,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '🪐',
        'title': 'Saturn Return Center',
        'subtitle': '29.5-Year Maturity Tracker',
        'gradient': const LinearGradient(colors: [Color(0xFF8E24AA), Color(0xFFD81B60)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SaturnReturnScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 18,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '🔬',
        'title': 'Astro Research Mode',
        'subtitle': 'Raw Arc-Seconds & Notes',
        'gradient': const LinearGradient(colors: [Color(0xFF546E7A), Color(0xFF263238)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroResearchScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 19,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '📄',
        'title': 'Custom PDF Builder',
        'subtitle': 'Tailored VIP Report Export',
        'gradient': const LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF8C00)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomPdfReportBuilderScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 22,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '🗓️',
        'title': 'Personal Year Ahead',
        'subtitle': '12-Month Jan-Dec Forecast',
        'gradient': const LinearGradient(colors: [Color(0xFFD9901A), Color(0xFFE5A63C)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const YearAheadScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 23,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '📡',
        'title': '90-Day Future Radar',
        'subtitle': 'Visual Timeline & Events',
        'gradient': const LinearGradient(colors: [Color(0xFF00E5FF), Color(0xFF00897B)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FutureRadarScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 24,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '⏱️',
        'title': 'Personal Timing Engine',
        'subtitle': 'Date Comparison Scorecard',
        'gradient': const LinearGradient(colors: [Color(0xFFFF1744), Color(0xFFC62828)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PersonalTimingEngineScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 25,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '💞',
        'title': 'Synastry & Composite',
        'subtitle': 'Dual Chart & Aspect Matrix',
        'gradient': const LinearGradient(colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SynastryCompositeScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },
      {
        'id': 26,
        'category': 'PREMIUM VIP EXCLUSIVES',
        'emoji': '🌍',
        'title': 'Astrocartography',
        'subtitle': 'Global Power Lines & City Move',
        'gradient': const LinearGradient(colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
        'isVip': true,
        'action': () {
          if (isPremium) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AstrocartographyScreen()));
          } else {
            PremiumUpgradeModal.show(context);
          }
        },
      },

      // Section 4: Remedies & Numerology
      {
        'id': 20,
        'category': 'REMEDIES & NUMEROLOGY',
        'emoji': '💎',
        'title': l10n.exploreRemedies,
        'subtitle': 'Gemstones & Mantras',
        'gradient': const LinearGradient(colors: [Color(0xFF00B4DB), Color(0xFF0083B0)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RemedyHubScreen())),
      },
      {
        'id': 21,
        'category': 'REMEDIES & NUMEROLOGY',
        'emoji': '🔢',
        'title': l10n.exploreNumerology,
        'subtitle': 'Life Path & Destiny',
        'gradient': const LinearGradient(colors: [Color(0xFFF7971E), Color(0xFFFFD200)]),
        'isVip': false,
        'action': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NumerologyScreen())),
      },
    ];

    // Filter & Sort features alphabetically (A-Z)
    final filteredFeatures = allFeatures.where((item) {
      if (_filter == ExploreFilter.vipOnly) return item['isVip'] == true;
      if (_filter == ExploreFilter.freeOnly) return item['isVip'] == false;
      return true;
    }).toList()
      ..sort((a, b) => (a['title'] as String).toLowerCase().compareTo((b['title'] as String).toLowerCase()));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Sleek Header with View Mode & Filter Controls ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Category Pill with FittedBox
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primary.withOpacity(0.3),
                                        width: 0.8,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.explore_rounded, color: AppColors.primary, size: 13),
                                        const SizedBox(width: 5),
                                        Text(
                                          'VEDIC EXPLORE HUB',
                                          style: GoogleFonts.inter(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),

                            // Top Right View Mode & Filter Controls
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // View Mode Selector (Grid, List, Folder)
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: AppColors.getSurfaceElevated(context),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildViewIconButton(
                                        context,
                                        mode: ExploreViewMode.grid,
                                        icon: Icons.grid_view_rounded,
                                        tooltip: 'Grid View',
                                      ),
                                      _buildViewIconButton(
                                        context,
                                        mode: ExploreViewMode.list,
                                        icon: Icons.view_list_rounded,
                                        tooltip: 'List View',
                                      ),
                                      _buildViewIconButton(
                                        context,
                                        mode: ExploreViewMode.folder,
                                        icon: Icons.folder_copy_rounded,
                                        tooltip: 'Folder View',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),

                                // Filter Popup Menu Button
                                PopupMenuButton<ExploreFilter>(
                                  initialValue: _filter,
                                  onSelected: (val) => setState(() => _filter = val),
                                  tooltip: 'Filter Features',
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  color: isLight ? AppColors.surfaceLight : AppColors.surfaceDark,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Icon(
                                      Icons.filter_list_rounded,
                                      color: _filter != ExploreFilter.all
                                          ? AppColors.primary
                                          : AppColors.getTextSecondary(context),
                                      size: 18,
                                    ),
                                  ),
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(
                                      value: ExploreFilter.all,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.all_inclusive_rounded,
                                            size: 18,
                                            color: _filter == ExploreFilter.all ? AppColors.primary : AppColors.getTextSecondary(context),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            'All Features',
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              fontWeight: _filter == ExploreFilter.all ? FontWeight.bold : FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: ExploreFilter.vipOnly,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.workspace_premium_rounded, size: 18, color: Colors.amber),
                                          const SizedBox(width: 10),
                                          Text(
                                            'VIP Exclusives Only',
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              fontWeight: _filter == ExploreFilter.vipOnly ? FontWeight.bold : FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: ExploreFilter.freeOnly,
                                      child: Row(
                                        children: [
                                          Icon(Icons.bolt_rounded, size: 18, color: Colors.greenAccent),
                                          const SizedBox(width: 10),
                                          Text(
                                            'Free Tools Only',
                                            style: GoogleFonts.outfit(
                                              fontSize: 13,
                                              fontWeight: _filter == ExploreFilter.freeOnly ? FontWeight.bold : FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Text(
                          l10n.exploreTitle,
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textPrimaryDark,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vedic astrological intelligence & daily ephemeris',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms),
                ),

                // ── Hero Featured Card ──────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: _buildFeaturedHeroCard(context, ref, l10n),
                  ),
                ),

                // ── VIEW MODES ──────────────────────────────────
                if (_viewMode == ExploreViewMode.grid) ..._buildGridViewSlivers(context, filteredFeatures),
                if (_viewMode == ExploreViewMode.list) ..._buildListViewSlivers(context, filteredFeatures),
                if (_viewMode == ExploreViewMode.folder) ..._buildFolderViewSlivers(context, filteredFeatures),

                const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildViewIconButton(
    BuildContext context, {
    required ExploreViewMode mode,
    required IconData icon,
    required String tooltip,
  }) {
    final isSelected = _viewMode == mode;

    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () => setState(() => _viewMode = mode),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withOpacity(0.18) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: isSelected ? AppColors.primary : AppColors.getTextSecondary(context),
          ),
        ),
      ),
    );
  }

  // ── VIEW 1: GRID VIEW ──────────────────────────────────────────
  List<Widget> _buildGridViewSlivers(BuildContext context, List<Map<String, dynamic>> features) {
    final categories = features.map((f) => f['category'] as String).toSet().toList();

    List<Widget> slivers = [];
    for (final cat in categories) {
      final items = features.where((f) => f['category'] == cat).toList()
        ..sort((a, b) => (a['title'] as String).toLowerCase().compareTo((b['title'] as String).toLowerCase()));
      IconData catIcon = Icons.auto_awesome_rounded;
      if (cat.contains('EPHEMERIS')) catIcon = Icons.wb_twilight_rounded;
      if (cat.contains('PREMIUM')) catIcon = Icons.workspace_premium_rounded;
      if (cat.contains('REMEDIES')) catIcon = Icons.diamond_rounded;

      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: _buildSectionHeader(context, cat, catIcon),
          ),
        ),
      );

      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: context.responsive<int>(
                mobile: 2,
                tablet: 3,
                desktop: 4,
              ),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: context.responsive<double>(
                mobile: 1.15,
                tablet: 1.25,
                desktop: 1.35,
              ),
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = items[index];
                return _buildCategoryCard(
                  context: context,
                  index: index,
                  emoji: item['emoji'],
                  title: item['title'],
                  subtitle: item['subtitle'],
                  gradient: item['gradient'],
                  isVip: item['isVip'],
                  onTap: item['action'],
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      );
    }
    return slivers;
  }

  // ── VIEW 2: LIST VIEW ──────────────────────────────────────────
  List<Widget> _buildListViewSlivers(BuildContext context, List<Map<String, dynamic>> features) {
    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: _buildSectionHeader(context, 'ALL EXPLORE TOOLS (${features.length})', Icons.view_list_rounded),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = features[index];
              final LinearGradient gradient = item['gradient'];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: GlassCard(
                  borderRadius: 18,
                  padding: const EdgeInsets.all(14),
                  onTap: item['action'],
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          item['emoji'],
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    item['title'],
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.getTextPrimary(context),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (item['isVip'] == true) ...[
                                  const SizedBox(width: 8),
                                  AnimatedVipBadge(
                                    label: 'VIP',
                                    isProfessional: (item['title'] as String).contains('Sky') || (item['title'] as String).contains('Aspect'),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item['subtitle'],
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.getTextSecondary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 14),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: Duration(milliseconds: 30 * index)).slideX(begin: 0.05);
            },
            childCount: features.length,
          ),
        ),
      ),
    ];
  }

  // ── VIEW 3: FOLDER VIEW (CATEGORY ACCORDIONS) ──────────────────
  List<Widget> _buildFolderViewSlivers(BuildContext context, List<Map<String, dynamic>> features) {
    final categories = features.map((f) => f['category'] as String).toSet().toList();

    List<Widget> slivers = [];
    for (final cat in categories) {
      final items = features.where((f) => f['category'] == cat).toList();
      final isExpanded = _expandedFolders.contains(cat);

      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: GlassCard(
              borderRadius: 18,
              padding: EdgeInsets.zero,
              borderColor: AppColors.primary.withOpacity(0.3),
              child: Column(
                children: [
                  // Folder Header Tile
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: const Icon(
                      Icons.folder_open_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    title: Text(
                      cat,
                      style: GoogleFonts.outfit(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextPrimary(context),
                        letterSpacing: 0.6,
                      ),
                    ),
                    subtitle: Text(
                      '${items.length} Astrological Tools',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.getTextSecondary(context),
                      ),
                    ),
                    trailing: Icon(
                      isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    onTap: () {
                      setState(() {
                        if (isExpanded) {
                          _expandedFolders.remove(cat);
                        } else {
                          _expandedFolders.add(cat);
                        }
                      });
                    },
                  ),

                  // Folder Content Items (if expanded)
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Column(
                        children: items.map((item) {
                          final LinearGradient gradient = item['gradient'];
                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: AppColors.getSurfaceElevated(context),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.getBorder(context), width: 0.6),
                            ),
                            child: ListTile(
                              dense: true,
                              onTap: item['action'],
                              leading: Text(item['emoji'], style: const TextStyle(fontSize: 18)),
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'],
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.getTextPrimary(context),
                                      ),
                                    ),
                                  ),
                                  if (item['isVip'] == true)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                        gradient: AppColors.goldGradient,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'VIP',
                                        style: GoogleFonts.outfit(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              subtitle: Text(
                                item['subtitle'],
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.getTextSecondary(context),
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.primary),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ).animate().fadeIn(duration: 250.ms),
          ),
        ),
      );
    }
    return slivers;
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 14),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedHeroCard(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    return GlassCard(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      borderColor: AppColors.primary.withOpacity(0.35),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PanchangScreen()),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '🌞',
              style: TextStyle(fontSize: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'FEATURED TODAY',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Daily Drik Panchang',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).textTheme.titleLarge?.color ?? AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  'Tithi, Nakshatra, Rahu Kaal & Choghadiya',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textTertiaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.primary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required int index,
    required String emoji,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
    bool isVip = false,
  }) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 18,
      borderColor: isVip ? AppColors.primary.withOpacity(0.5) : gradient.colors.last.withOpacity(0.25),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 22),
              ),
              if (isVip)
                AnimatedVipBadge(
                  label: 'VIP',
                  isProfessional: title.contains('Sky') || title.contains('Aspect') || title.contains('Chart') || title.contains('Return'),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.35) ??
                      Colors.white30,
                  size: 11,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.textPrimaryDark,
                    height: 1.15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 9.0,
                    color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textTertiaryDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: 30 * index))
        .scale(begin: const Offset(0.96, 0.96), duration: 350.ms, delay: Duration(milliseconds: 30 * index));
  }
}

class AnimatedVipBadge extends StatelessWidget {
  final String label;
  final bool isProfessional;

  const AnimatedVipBadge({
    super.key,
    this.label = 'VIP',
    this.isProfessional = false,
  });

  @override
  Widget build(BuildContext context) {
    final textLabel = isProfessional ? 'PRO' : label;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
      decoration: BoxDecoration(
        gradient: isProfessional
            ? const LinearGradient(
                colors: [Color(0xFF00E5FF), Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : AppColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isProfessional ? const Color(0xFF00E5FF) : const Color(0xFFE0A13A)).withOpacity(0.4),
            blurRadius: 6,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.7),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            textLabel,
            style: GoogleFonts.outfit(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              color: isProfessional ? Colors.white : Colors.black,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 2.5),
          Icon(
            isProfessional ? Icons.verified_rounded : Icons.diamond_rounded,
            size: 10,
            color: isProfessional ? Colors.white : Colors.black87,
          ),
        ],
      ),
    )
    .animate(onPlay: (controller) => controller.repeat(reverse: true))
    .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.6))
    .scale(
      begin: const Offset(0.97, 0.97),
      end: const Offset(1.03, 1.03),
      duration: 1400.ms,
      curve: Curves.easeInOut,
    );
  }
}
