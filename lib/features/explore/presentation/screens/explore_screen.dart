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
import 'astro_academy_screen.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context, ref);
    final isLight = Theme.of(context).brightness == Brightness.light;

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
                // ── Sleek Header ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Pill
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                              const Icon(Icons.explore_rounded, color: AppColors.primary, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                'VEDIC EXPLORE HUB',
                                style: GoogleFonts.inter(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
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
                          'Discover ancient astrological wisdom & daily timing tools',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.05),
                ),

                // ── Hero Featured Card ──────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: _buildFeaturedHeroCard(context, ref, l10n),
                  ).animate().fadeIn(delay: 100.ms).scale(begin: const Offset(0.97, 0.97)),
                ),

                // ── Section 1 Header ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: _buildSectionHeader(context, 'DAILY EPHEMERIS & TIMINGS', Icons.wb_twilight_rounded),
                  ),
                ),

                // ── Section 1 Grid ──────────────────────────────
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
                      childAspectRatio: 1.32,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildCategoryCard(
                        context: context,
                        index: 0,
                        emoji: '🌅',
                        title: l10n.explorePanchang,
                        subtitle: 'Tithi • Nakshatra • Yoga',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PanchangScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 1,
                        emoji: '⏱️',
                        title: l10n.exploreMuhurat,
                        subtitle: 'Abhijit • Rahu Kaal',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3A1C71), Color(0xFFD76D77)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MuhuratScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 2,
                        emoji: '♋',
                        title: l10n.exploreHoroscope,
                        subtitle: 'Daily • Weekly • Yearly',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HoroscopeScreen()),
                        ),
                      ),
                    ]),
                  ),
                ),

                // ── Section 2 Header ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: _buildSectionHeader(context, 'ANALYSIS & COMPATIBILITY', Icons.auto_awesome_rounded),
                  ),
                ),

                // ── Section 2 Grid ──────────────────────────────
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
                      childAspectRatio: 1.32,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildCategoryCard(
                        context: context,
                        index: 3,
                        emoji: '⚡',
                        title: l10n.exploreDosha,
                        subtitle: 'Mangal • Kaal Sarp • Yoga',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF512F), Color(0xFFDD2476)],
                        ),
                        onTap: () {
                          ref.read(kundliTabProvider.notifier).update((_) => 4);
                          ref.read(mainNavIndexProvider.notifier).update((_) => 1);
                        },
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 4,
                        emoji: '💞',
                        title: l10n.exploreCompatibility,
                        subtitle: '36 Gun Milan Analysis',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF833AB4), Color(0xFFFD1D1D)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MatchingScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 5,
                        emoji: '🪐',
                        title: 'Transit & Sade Sati',
                        subtitle: 'Live Saturn & Gochar Impact',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4776E6), Color(0xFF8E54E9)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TransitCenterScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 6,
                        emoji: '👥',
                        title: 'Chart Synastry',
                        subtitle: 'Compare Any Two Profiles',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD9901A), Color(0xFFE5A63C)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ChartComparisonScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 7,
                        emoji: '📖',
                        title: 'Astro Academy',
                        subtitle: 'Glossary & Beginner Mode',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AstroAcademyScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 8,
                        emoji: '🎯',
                        title: 'Astro Decision Engine',
                        subtitle: 'Best Time & Show Me Math',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AstroDecisionEngineScreen()),
                        ),
                      ),
                    ]),
                  ),
                ),

                // ── Section 3 Header ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                    child: _buildSectionHeader(context, 'REMEDIES & NUMEROLOGY', Icons.diamond_rounded),
                  ),
                ),

                // ── Section 3 Grid ──────────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.responsive<int>(
                        mobile: 2,
                        tablet: 3,
                        desktop: 4,
                      ),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.32,
                    ),
                    delegate: SliverChildListDelegate([
                      _buildCategoryCard(
                        context: context,
                        index: 6,
                        emoji: '💎',
                        title: l10n.exploreRemedies,
                        subtitle: 'Gemstones & Mantras',
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RemedyHubScreen()),
                        ),
                      ),
                      _buildCategoryCard(
                        context: context,
                        index: 7,
                        emoji: '🔢',
                        title: l10n.exploreNumerology,
                        subtitle: 'Life Path & Destiny',
                        gradient: const LinearGradient(
                          colors: [Color(0xFFF7971E), Color(0xFFFFD200)],
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NumerologyScreen()),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: AppColors.goldGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 14,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                '🌞',
                style: TextStyle(fontSize: 26),
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
  }) {
    return GlassCard(
      onTap: onTap,
      borderRadius: 18,
      borderColor: gradient.colors.last.withOpacity(0.25),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: gradient,
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.last.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.35) ??
                    Colors.white30,
                size: 12,
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).textTheme.titleMedium?.color ?? AppColors.textPrimaryDark,
              height: 1.15,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Theme.of(context).textTheme.bodySmall?.color ?? AppColors.textTertiaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 350.ms, delay: Duration(milliseconds: 50 * index))
        .scale(begin: const Offset(0.96, 0.96), duration: 350.ms, delay: Duration(milliseconds: 50 * index));
  }
}
