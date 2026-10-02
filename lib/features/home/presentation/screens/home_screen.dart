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
import '../../../../core/widgets/nine_languages_modal.dart';
import '../../../consult/presentation/widgets/astrosage_consult_home_section.dart';
import '../../../consult/presentation/screens/talk_to_ai_astrologers_screen.dart';
import '../../../consult/presentation/screens/chat_with_astrologers_screen.dart';
import '../widgets/astrosage_classic_grid_view.dart';
import '../../../reports/presentation/screens/predictions_reports_screen.dart';
import '../../../panchang/presentation/screens/monthly_panchang_screen.dart';
import '../../../kundli/presentation/screens/new_kundli_input_screen.dart';
import '../../../explore/presentation/screens/explore_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: Column(
          children: [
            _buildAstroSageTopBar(context),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: const BouncingScrollPhysics(),
                children: [
                  // Tab 0: Structured HOME Dashboard
                  _buildHomeDashboard(context),
                  // Tab 1: 100+ Free Reports Hub (Image 3)
                  const PredictionsReportsScreen(isEmbedded: true),
                  // Tab 2: Detailed Monthly Panchang (Image 2)
                  const MonthlyPanchangScreen(isEmbedded: true),
                  // Tab 3: Horoscope & Kundli Input (Image 5)
                  const NewKundliInputScreen(isEmbedded: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAstroSageTopBar(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      color: const Color(0xFFF5A623), // AstroSage Golden Yellow
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AstroSaathi Kundli',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_rounded, color: Colors.black87, size: 24),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No new notifications.')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.search_rounded, color: Colors.black87, size: 26),
                    onPressed: () => AstroCommandCenterModal.show(context),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded, color: Colors.black87, size: 26),
                    color: isLight ? Colors.white : AppColors.surfaceDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    offset: const Offset(0, 50),
                    onSelected: (value) {
                      if (value == 'all_features') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ExploreScreen()),
                        );
                      } else if (value == 'settings') {
                        ref.read(mainNavIndexProvider.notifier).state = 4;
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'all_features',
                        child: Row(
                          children: [
                            Icon(Icons.grid_view_rounded, size: 20, color: AppColors.getTextPrimary(context)),
                            const SizedBox(width: 12),
                            Text('All Features', style: GoogleFonts.inter(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings_rounded, size: 20, color: AppColors.getTextPrimary(context)),
                            const SizedBox(width: 12),
                            Text('Settings', style: GoogleFonts.inter(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      PopupMenuItem<String>(
                        value: 'language',
                        child: Row(
                          children: [
                            Icon(Icons.language_rounded, size: 20, color: AppColors.getTextPrimary(context)),
                            const SizedBox(width: 12),
                            Text('Language', style: GoogleFonts.inter(color: AppColors.getTextPrimary(context), fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorColor: Colors.black87,
              indicatorWeight: 3.0,
              labelColor: Colors.black87,
              unselectedLabelColor: Colors.black54,
              labelStyle: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
              unselectedLabelStyle: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
              tabs: const [
                Tab(text: 'HOME'),
                Tab(text: 'REPORTS'),
                Tab(text: 'PANCHANG'),
                Tab(text: 'HOROSCOPE'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeDashboard(BuildContext context) {
    final gamePlanAsync = ref.watch(dailyGamePlanProvider);

    return ResponsiveLayout(
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
    );
  }

  Widget _buildActiveProfileHeader(BuildContext context, WidgetRef ref) {
    final activeProfile = ref.watch(activeProfileProvider);
    final userName = activeProfile.name.isNotEmpty ? activeProfile.name : 'Seeker';
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLight ? const Color(0xFFEEEEEE) : AppColors.borderDark,
          width: 0.8,
        ),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Color(0xFFE65100),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        userName,
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.getTextPrimary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Simha Lagna',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  activeProfile.birthPlace.isNotEmpty
                      ? activeProfile.birthPlace
                      : 'Kundli active for today',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.getTextSecondary(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => ProfileSwitcherModal.show(context),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.4), width: 0.8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Switch',
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.swap_vert_rounded, size: 14, color: Color(0xFFE65100)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamePlanUI(BuildContext context, WidgetRef ref, GamePlanData plan) {
    final hPad = context.responsive<double>(
      mobile: 16,
      tablet: 24,
      desktop: 32,
    );

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 12, hPad, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Active Profile Header Bar (Image 5 & AstroSage Header)
                _buildActiveProfileHeader(context, ref),
                const SizedBox(height: 12),

                // 2. AstroSage Consult Section with 3 Primary Big Buttons & 3x4 Grid inside middleWidget (Image 2 & 4)
                AstrosageConsultHomeSection(
                  middleWidget: Column(
                    children: [
                      // 3 Large Action Cards: Kundli | Matching | Horoscope (Image 2)
                      AstrosagePrimaryActionCards(
                        onSelectTab: (idx) => _tabController.animateTo(idx),
                      ),
                      const SizedBox(height: 14),

                      // 3x4 Classic Tools Grid (Image 4)
                      AstrosageClassicGridView(
                        onSelectTab: (idx) => _tabController.animateTo(idx),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 3. Section Title: Today's Personal Cosmic Game Plan
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5A623),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "TODAY'S COSMIC GAME PLAN",
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.getTextPrimary(context),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 4. Energy Score & Cosmic Alignment
                _buildEnergyCard(context, plan).fadeSlideUp(delay: 50.ms),
                const SizedBox(height: 14),

                // 5. Auspicious Muhurat Window
                _buildBestWindow(plan).fadeSlideUp(delay: 70.ms),
                const SizedBox(height: 14),

                // 6. Daily Check-In & Routine
                const DailyCheckInWidget().fadeSlideUp(delay: 90.ms),
                const SizedBox(height: 14),
                const DailyRoutineWidget().fadeSlideUp(delay: 110.ms),
                const SizedBox(height: 14),

                // 7. Actionable Guidelines (Do / Be Careful / Avoid)
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
                          130,
                        ),
                        const SizedBox(height: 14),
                        _buildActionSection(
                          context,
                          l10n.beCarefulTitle,
                          plan.beCarefulList,
                          AppColors.warning,
                          Icons.warning_rounded,
                          150,
                        ),
                        const SizedBox(height: 14),
                        _buildActionSection(
                          context,
                          l10n.avoidTitle,
                          plan.avoidList,
                          AppColors.error,
                          Icons.cancel_rounded,
                          170,
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
                          .withValues(alpha: 0.5),
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
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
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
                      color: color.withValues(alpha: 0.5),
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
                  color: AppColors.primary.withValues(alpha: 0.12),
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
          borderColor: AppColors.secondary.withValues(alpha: 0.4),
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
                  color: AppColors.secondary.withValues(alpha: 0.15),
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
