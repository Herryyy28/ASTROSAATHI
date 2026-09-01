import 'package:AstroSaathi/features/astrology/presentation/widgets/birth_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/engine/models/game_plan_data.dart';
import '../../../../core/widgets/why_this_bottom_sheet.dart';
import '../../../../core/widgets/data_freshness_badge.dart';
import '../../../../core/widgets/iphone_glass_menu.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../search/presentation/screens/astrology_search_screen.dart';
import '../../../muhurat/presentation/screens/muhurat_screen.dart';
import '../../../subscription/presentation/widgets/vip_badge_button.dart';
import '../widgets/personal_cosmic_calendar_widget.dart';
import 'main_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePlanAsync = ref.watch(dailyGamePlanProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: gamePlanAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: ShimmerLoader(itemCount: 5, itemHeight: 100),
              ),
              error: (error, stack) => ErrorStateWidget(
                message: error.toString().replaceFirst('Exception: ', ''),
                onRetry: () => ref.invalidate(dailyGamePlanProvider),
              ),
              data: (plan) => _buildGamePlanUI(context, plan),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGamePlanUI(BuildContext context, GamePlanData plan) {
    final hPad = context.responsive<double>(
      mobile: 20,
      tablet: 32,
      desktop: 40,
    );
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Greeting ──────────────────────────────────────
                _buildGreeting().fadeSlideUp(),
                const SizedBox(height: 24),

                // ── Visual Birth Chart ─────────────────────────────
                BirthChartCard(),
                const SizedBox(height: 32),

                // ── Energy Score Card ─────────────────────────────
                _buildEnergyCard(context, plan).fadeSlideUp(delay: 100.ms),
                const SizedBox(height: 28),

                // ── Personal Cosmic Calendar ──────────────────────
                const PersonalCosmicCalendarWidget().fadeSlideUp(delay: 120.ms),
                const SizedBox(height: 20),

                // ── Ad / Sponsored Banner UI ───────────────────────

                // ── Do / Careful / Avoid ──────────────────────────
                Consumer(
                  builder: (context, ref, _) {
                    final l10n = AppLocalizations.of(context, ref);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionSection(
                          l10n.doTitle,
                          plan.doList,
                          AppColors.success,
                          Icons.check_circle_rounded,
                          200,
                        ),
                        const SizedBox(height: 16),
                        _buildActionSection(
                          l10n.beCarefulTitle,
                          plan.beCarefulList,
                          AppColors.warning,
                          Icons.warning_rounded,
                          280,
                        ),
                        const SizedBox(height: 16),
                        _buildActionSection(
                          l10n.avoidTitle,
                          plan.avoidList,
                          AppColors.error,
                          Icons.cancel_rounded,
                          360,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // ── Best Window ───────────────────────────────────
                _buildBestWindow(plan).fadeSlideUp(delay: 440.ms),
                const SizedBox(height: 28),

                // ── Categories ────────────────────────────────────
                _buildCategories(plan).fadeSlideUp(delay: 520.ms),
                const SizedBox(height: 28),

                // ── Ask Astro Baba ────────────────────────────────
                _buildAstroBabaPrompt().fadeSlideUp(delay: 600.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;
    return Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context, ref);
        if (hour < 12) {
          greeting = l10n.goodMorning;
          emoji = '☀️';
        } else if (hour < 17) {
          greeting = l10n.goodAfternoon;
          emoji = '🌤️';
        } else {
          greeting = l10n.goodEvening;
          emoji = '🌙';
        }

        final activeProfile = ref.watch(activeProfileProvider);
        final userName = activeProfile.name;
        final displayGreeting = userName.isNotEmpty
            ? '$greeting, $userName'
            : greeting;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    displayGreeting,
                    style: GoogleFonts.outfit(
                      fontSize: context.responsive<double>(
                        mobile: 19,
                        tablet: 24,
                        desktop: 28,
                      ),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                      letterSpacing: -0.3,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AstrologySearchScreen(),
                      ),
                    );
                  },
                ),
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 0.8,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    onPressed: () {
                      IPhoneGlassMenu.show(context, ref);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _formatDate(),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondaryDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                DataFreshnessBadge(
                  timeString:
                      'Calculated at ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]} · ${now.day} ${months[now.month - 1]}';
  }

  Widget _buildEnergyCard(BuildContext context, GamePlanData plan) {
    return GlassCard(
      padding: context.cardPadding,
      glowColor: AppColors.goldGlow,
      gradient: AppColors.premiumGradient,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text('TODAY\'S ENERGY', style: AppDecorations.sectionHeader()),
            ],
          ),
          const SizedBox(height: 24),

          // Dynamic Animated Score display (60 FPS)
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: plan.dayScore),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 124,
                    height: 124,
                    child: CircularProgressIndicator(
                      value: animatedValue / 10,
                      strokeWidth: 7,
                      backgroundColor: AppColors.surfaceHighlightDark
                          .withOpacity(0.5),
                      color: AppColors.primary,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        animatedValue.toStringAsFixed(1),
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'out of 10',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, _) {
              final lang = ref.watch(localeProvider);
              return Text(
                _getEnergyLabel(plan.dayScore, lang),
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.textSecondaryDark,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          // AI Generated Tag Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_awesome,
                  color: AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 6),
                Consumer(
                  builder: (context, ref, _) {
                    final lang = ref.watch(localeProvider);
                    String text = 'AI Generated Cosmic Insight';
                    if (lang == AppLanguage.hindi) {
                      text =
                          'एआई जनरेटेड कॉस्मिक स्कोर (${plan.dayScore} / 10)';
                    } else if (lang == AppLanguage.gujarati) {
                      text =
                          'એઆઈ જનરેટેડ કોસ્મિક સ્કોર (${plan.dayScore} / 10)';
                    } else {
                      text =
                          'AI Generated Cosmic Score (${plan.dayScore} / 10)';
                    }
                    return Flexible(
                      child: Text(
                        text,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 12),
          Consumer(
            builder: (context, ref, _) {
              final l10n = AppLocalizations.of(context, ref);
              return OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary, width: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  WhyThisBottomSheet.show(
                    context,
                    title: 'Daily Energy Alignment: ${plan.dayScore}/10',
                    planetFactor:
                        plan.planetFactor ?? 'Jupiter Transiting Benefic House',
                    houseFactor:
                        plan.houseFactor ?? '1st Lagna & 10th Karma Axis',
                    transitFactor:
                        plan.transitFactor ?? 'Moon Nakshatra Transit',
                    vedicInterpretation:
                        plan.vedicInterpretation ??
                        'Benefic transit over key astrological axes provides high executive clarity and decision confidence.',
                    practicalAction:
                        plan.practicalAction ??
                        'Capitalize on the Golden Window (11:15 AM - 1:20 PM) for critical negotiations or client discussions.',
                  );
                },
                icon: const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                label: Text(
                  l10n.whyThis,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getEnergyLabel(double score, AppLanguage lang) {
    if (lang == AppLanguage.hindi) {
      if (score >= 8) return 'आज आपकी ऊर्जा उत्कृष्ट स्थिति में है ✨';
      if (score >= 6) return 'आज का दिन आपके लिए अनुकूल है';
      if (score >= 4) return 'आज का दिन संतुलित रहने की संभावना है';
      return 'आज का दिन शांतिपूर्वक व्यतीत करें';
    } else if (lang == AppLanguage.gujarati) {
      if (score >= 8) return 'આજે તમારી ઊર્જા ઉત્કૃષ્ટ સ્થિતિમાં છે ✨';
      if (score >= 6) return 'આજનો દિવસ તમારા માટે સાનુકૂળ છે';
      if (score >= 4) return 'આજનો દિવસ સંતુલિત રહેશે';
      return 'આજે શાંતિથી દિવસ વિતાવો';
    } else {
      if (score >= 8) return 'Excellent energy today ✨';
      if (score >= 6) return 'Your day looks favorable';
      if (score >= 4) return 'A balanced day ahead';
      return 'Take it easy today';
    }
  }

  Widget _buildActionSection(
    String title,
    List<String> items,
    Color color,
    IconData icon,
    int delayMs,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.accentCard(accentColor: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textPrimaryDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).fadeSlideUp(delay: Duration(milliseconds: delayMs));
  }

  Widget _buildBestWindow(GamePlanData plan) {
    return Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context, ref);
        return GlassCard(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MuhuratScreen()),
            );
          },
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.wb_sunny_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.bestWindow.toUpperCase(),
                      style: AppDecorations.sectionHeader(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${plan.bestWindow.start} — ${plan.bestWindow.end}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textTertiaryDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategories(GamePlanData plan) {
    final entries = plan.categories.entries.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: entries.map((e) {
          return Container(
            width: 105,
            margin: const EdgeInsets.only(right: 12),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
              child: Column(
                children: [
                  Text(
                    e.key.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.value.toStringAsFixed(0),
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mini progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: e.value / 10,
                      backgroundColor: AppColors.surfaceHighlightDark,
                      color: _getCategoryColor(e.value),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getCategoryColor(double score) {
    if (score >= 7) return AppColors.success;
    if (score >= 5) return AppColors.primary;
    return AppColors.warning;
  }

  Widget _buildAstroBabaPrompt() {
    return Consumer(
      builder: (context, ref, _) {
        return GlassCard(
          onTap: () {
            ref.read(mainNavIndexProvider.notifier).state =
                3; // Navigate to Astro AI tab (Index 3)
          },
          borderColor: AppColors.secondary.withOpacity(0.4),
          glowColor: AppColors.purpleGlow,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context, ref).askAstroBabaBtn,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textTertiaryDark,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
