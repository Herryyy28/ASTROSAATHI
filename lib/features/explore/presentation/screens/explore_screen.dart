import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
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

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context, ref);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Header ──────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: AppColors.purpleGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.secondary.withOpacity(0.3),
                                    blurRadius: 12,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.explore_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.exploreTitle,
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimaryDark,
                                    ),
                                  ),
                                  Text(
                                    'Discover ancient wisdom, modern tools',
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
                      ],
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
                ),

                // ── Category Grid ──────────────────────────
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.responsive<int>(
                        mobile: 2,
                        tablet: 3,
                        desktop: 4,
                      ),
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    delegate: SliverChildListDelegate(
                      _buildCategoryItems(context, l10n),
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

  List<Widget> _buildCategoryItems(BuildContext context, AppLocalizations l10n) {
    final categories = [
      _ExploreCategory(
        emoji: '🌅',
        title: l10n.explorePanchang,
        subtitle: 'Tithi • Nakshatra • Yoga',
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF3498DB)],
        ),
        icon: Icons.wb_twilight_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PanchangScreen()),
        ),
      ),
      _ExploreCategory(
        emoji: '⏱️',
        title: l10n.exploreMuhurat,
        subtitle: 'Abhijit • Rahu Kaal',
        gradient: const LinearGradient(
          colors: [Color(0xFF2D1B69), Color(0xFF7B61FF)],
        ),
        icon: Icons.timer_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MuhuratScreen()),
        ),
      ),
      _ExploreCategory(
        emoji: '♋',
        title: l10n.exploreHoroscope,
        subtitle: 'Daily • Weekly • Monthly',
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A2A), Color(0xFF34C759)],
        ),
        icon: Icons.auto_awesome_mosaic_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HoroscopeScreen()),
        ),
      ),
      _ExploreCategory(
        emoji: '⚡',
        title: l10n.exploreDosha,
        subtitle: 'Mangal • Kaal Sarp • Yoga',
        gradient: const LinearGradient(
          colors: [Color(0xFF3A1A0A), Color(0xFFFF9500)],
        ),
        icon: Icons.bolt_rounded,
        onTap: () {}, // Routes to existing dosha screen if available
      ),
      _ExploreCategory(
        emoji: '💎',
        title: l10n.exploreRemedies,
        subtitle: 'Gemstones • Mantras • Upay',
        gradient: const LinearGradient(
          colors: [Color(0xFF0D2B1A), Color(0xFF27AE60)],
        ),
        icon: Icons.diamond_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RemedyHubScreen()),
        ),
      ),
      _ExploreCategory(
        emoji: '💞',
        title: l10n.exploreCompatibility,
        subtitle: 'Gun Milan • Matching',
        gradient: const LinearGradient(
          colors: [Color(0xFF3A0A1A), Color(0xFFFF3B30)],
        ),
        icon: Icons.favorite_rounded,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MatchingScreen()),
        ),
      ),
      _ExploreCategory(
        emoji: '🔢',
        title: l10n.exploreNumerology,
        subtitle: 'Life Path • Destiny',
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A3A), Color(0xFF4A90E2)],
        ),
        icon: Icons.pin_rounded,
        onTap: () {}, // Future feature
      ),
      _ExploreCategory(
        emoji: '🪐',
        title: l10n.exploreTransits,
        subtitle: 'Gochar • Current Transits',
        gradient: const LinearGradient(
          colors: [Color(0xFF2A1A3A), Color(0xFF9B59B6)],
        ),
        icon: Icons.public_rounded,
        onTap: () {}, // Future feature
      ),
    ];

    return categories.asMap().entries.map((entry) {
      final index = entry.key;
      final cat = entry.value;
      return _buildCategoryCard(cat, index);
    }).toList();
  }

  Widget _buildCategoryCard(_ExploreCategory category, int index) {
    return GlassCard(
      onTap: category.onTap,
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon with gradient background
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: category.gradient,
              boxShadow: [
                BoxShadow(
                  color: category.gradient.colors.last.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                category.emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const Spacer(),
          // Title
          Text(
            category.title,
            style: GoogleFonts.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryDark,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            category.subtitle,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textTertiaryDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 80 * index))
        .slideY(begin: 0.15, duration: 400.ms, delay: Duration(milliseconds: 80 * index));
  }
}

class _ExploreCategory {
  final String emoji;
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _ExploreCategory({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });
}
