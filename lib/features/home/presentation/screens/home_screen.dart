import '../../../astrology/presentation/widgets/birth_chart_card.dart';
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
import '../../../../core/theme/design_tokens.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../core/engine/models/game_plan_data.dart';
import '../../../../core/widgets/why_this_bottom_sheet.dart';

import '../../../../core/widgets/admob_banner_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../search/presentation/widgets/astro_command_center_modal.dart';
import '../widgets/what_changed_today_card.dart';
import '../widgets/daily_check_in_widget.dart';
import '../widgets/daily_routine_widget.dart';
import '../widgets/upcoming_events_widget.dart';
import '../../../../core/providers/gamification_provider.dart';
import '../../../muhurat/presentation/screens/muhurat_screen.dart';
import '../../../profile/presentation/widgets/profile_switcher_modal.dart';
import '../widgets/personal_cosmic_calendar_widget.dart';
import '../widgets/shareable_cosmic_card_modal.dart';
import 'main_screen.dart';


import '../../../kundli/presentation/screens/kundli_screen.dart';
import '../../../matching/presentation/screens/matching_screen.dart';
import '../../../reports/presentation/screens/custom_pdf_report_builder_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePlanAsync = ref.watch(dailyGamePlanProvider);

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
            child: gamePlanAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: ShimmerLoader(itemCount: 5, itemHeight: 100),
              ),
              error: (error, stack) => ErrorStateWidget(
                message: error.toString().replaceFirst('Exception: ', ''),
                onRetry: () => ref.invalidate(dailyGamePlanProvider),
              ),
              data: (plan) => _buildGamePlanUI(context, ref, plan),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGamePlanUI(BuildContext context, WidgetRef ref, GamePlanData plan) {
    final hPad = context.responsive<double>(
      mobile: 20,
      tablet: 32,
      desktop: 40,
    );
    final isWide = !context.isMobile;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              hPad,
              context.responsive(mobile: 16, tablet: 24, desktop: 24),
              hPad,
              100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Greeting
                _buildGreeting().fadeSlideUp(),
                const SizedBox(height: 16),

                // 2. Today's main astrology insight
                if (isWide) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: const BirthChartCard(),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildEnergyCard(context, plan).fadeSlideUp(delay: 60.ms),
                      ),
                    ],
                  ),
                ] else ...[
                  const BirthChartCard(),
                  const SizedBox(height: 16),
                  _buildEnergyCard(context, plan).fadeSlideUp(delay: 60.ms),
                ],
                const SizedBox(height: 16),

                // 3. Quick Actions
                _buildQuickActions(context, ref).fadeSlideUp(delay: 80.ms),
                const SizedBox(height: 16),

                // 4. Daily Check-In
                const DailyCheckInWidget().fadeSlideUp(delay: 100.ms),
                const SizedBox(height: 16),

                // 5. Daily Game Plan / Routine
                const DailyRoutineWidget().fadeSlideUp(delay: 120.ms),
                const SizedBox(height: 16),

                // 6. Upcoming Events & Best Windows
                const UpcomingEventsWidget().fadeSlideUp(delay: 140.ms),
                const SizedBox(height: 16),
                _buildBestWindow(plan).fadeSlideUp(delay: 160.ms),
                const SizedBox(height: 16),

                // 7. Astro Baba Prompt
                _buildAstroBabaPrompt().fadeSlideUp(delay: 180.ms),
                const SizedBox(height: 16),

                // 8. Premium / Deeper Reports & Tools
                WhatChangedTodayCard(gamePlan: plan).fadeSlideUp(delay: 200.ms),
                const SizedBox(height: 16),
                const PersonalCosmicCalendarWidget().fadeSlideUp(delay: 220.ms),
                const SizedBox(height: 16),
                _buildCategories(context, plan).fadeSlideUp(delay: 240.ms),
                const SizedBox(height: 16),
                const AdMobBannerWidget(),
                const SizedBox(height: 16),

                // Do / Careful / Avoid Reference
                Consumer(
                  builder: (context, ref, _) {
                    final l10n = AppLocalizations.of(context, ref);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildActionSection(
                          context,
                          l10n.doTitle,
                          plan.doList,
                          AppColors.success,
                          Icons.check_circle_rounded,
                          260,
                        ),
                        const SizedBox(height: 16),
                        _buildActionSection(
                          context,
                          l10n.beCarefulTitle,
                          plan.beCarefulList,
                          AppColors.warning,
                          Icons.warning_rounded,
                          280,
                        ),
                        const SizedBox(height: 16),
                        _buildActionSection(
                          context,
                          l10n.avoidTitle,
                          plan.avoidList,
                          AppColors.error,
                          Icons.cancel_rounded,
                          300,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    final actions = [
      {
        'title': 'Kundli',
        'icon': Icons.auto_awesome_rounded,
        'color': AppColors.primary,
        'onTap': () => ref.read(mainNavIndexProvider.notifier).state = 1,
      },
      {
        'title': 'Gun Milan',
        'icon': Icons.favorite_rounded,
        'color': AppColors.secondary,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchingScreen())),
      },
      {
        'title': 'Muhurat',
        'icon': Icons.schedule_rounded,
        'color': AppColors.infoDark,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MuhuratScreen())),
      },
      {
        'title': 'PDF Report',
        'icon': Icons.picture_as_pdf_rounded,
        'color': AppColors.successDark,
        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomPdfReportBuilderScreen())),
      },
    ];

    return Row(
      children: [
        for (int i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: actions[i]['onTap'] as VoidCallback,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                ),
                child: Column(
                  children: [
                    Icon(actions[i]['icon'] as IconData, color: actions[i]['color'] as Color, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      actions[i]['title'] as String,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.getTextPrimary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    return Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context, ref);
        final lang = ref.watch(localeProvider);

        if (hour < 12) {
          greeting = l10n.goodMorning;
        } else if (hour < 17) {
          greeting = l10n.goodAfternoon;
        } else {
          greeting = l10n.goodEvening;
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.14),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary.withOpacity(0.28), width: 1.0),
                  ),
                  child: const Icon(
                    Icons.wb_sunny_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayGreeting,
                    style: GoogleFonts.outfit(
                      fontSize: context.responsive<double>(
                        mobile: 20,
                        tablet: 24,
                        desktop: 28,
                      ),
                      fontWeight: FontWeight.w800,
                      color: AppColors.getTextPrimary(context),
                      letterSpacing: -0.3,
                      height: 1.1,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceElevated(context),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                    ),
                    child: Icon(
                      Icons.share_rounded,
                      color: AppColors.getPrimary(context),
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    final plan = ref.read(dailyGamePlanProvider).value;
                    if (plan != null) {
                      ShareableCosmicCardModal.show(context, plan);
                    }
                  },
                ),
                const SizedBox(width: 8),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getSurfaceElevated(context),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.getPrimary(context),
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    AstroCommandCenterModal.show(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: GestureDetector(
                    onTap: () => ProfileSwitcherModal.show(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.getPrimary(context).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.getPrimary(context).withOpacity(0.4), width: 1.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 13,
                            color: AppColors.getPrimary(context),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              activeProfile.name.isNotEmpty ? activeProfile.name : 'Profile',
                              style: GoogleFonts.outfit(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.getPrimary(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.swap_vert_rounded, size: 14, color: AppColors.getPrimary(context)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final gameState = ref.watch(gamificationProvider);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.warning.withOpacity(0.35)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 11)),
                          const SizedBox(width: 3),
                          Text(
                            '${gameState.streakDays}d',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.warning),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _formatDate(lang),
                    textAlign: TextAlign.end,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.getTextSecondary(context),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _formatDate(AppLanguage lang) {
    final now = DateTime.now();
    List<String> days;
    List<String> months;

    if (lang == AppLanguage.hindi) {
      days = ['सोमवार', 'मंगलवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार', 'रविवार'];
      months = ['जनवरी', 'फरवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'];
    } else if (lang == AppLanguage.gujarati) {
      days = ['સોમવાર', 'મંગળવાર', 'બુધવાર', 'ગુરુવાર', 'શુક્રવાર', 'શનિવાર', 'રવિવાર'];
      months = ['જાન્યુઆરી', 'ફેબ્રુઆરી', 'માર્ચ', 'એપ્રિલ', 'મે', 'જૂન', 'જુલાઇ', 'ઓગસ્ટ', 'સપ્ટેમ્બર', 'ઓક્ટોબર', 'નવેમ્બર', 'ડિસેમ્બર'];
    } else {
      days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    }
    return '${days[(now.weekday - 1) % 7]} · ${now.day} ${months[(now.month - 1) % 12]}';
  }


  Widget _buildEnergyCard(BuildContext context, GamePlanData plan) {
    return GlassCard(
      padding: context.cardPadding,
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
          const SizedBox(height: 16),

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
              color: AppColors.getPrimary(context),
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'out of 10',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.getTextSecondary(context),
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
                  color: AppColors.getTextSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              );
            },
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: AppSpacing.md),
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
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.getPrimary(context),
                  size: 16,
                ),
                label: Text(
                  l10n.whyThis,
                  style: TextStyle(
                    color: AppColors.getPrimary(context),
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
    BuildContext context,
    String title,
    List<String> items,
    Color color,
    IconData icon,
    int delayMs,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.accentCard(accentColor: color, context: context),
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
          const SizedBox(height: 12),
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
                      fontSize: 14.5,
                      color: AppColors.getTextPrimary(context),
                      height: 1.45,
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
                  color: AppColors.getTextPrimary(context),
                ),
              ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.getTextMuted(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategories(BuildContext context, GamePlanData plan) {
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
                    style: TextStyle(
                      color: AppColors.getTextSecondary(context),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
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
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                  const SizedBox(height: 8),
                  // Mini progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: e.value / 10,
                      backgroundColor: AppColors.getSurfaceSecondary(context),
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
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.getTextPrimary(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.getTextMuted(context),
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
