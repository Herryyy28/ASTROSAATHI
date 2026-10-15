import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/engine/models/game_plan_data.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../astrology/presentation/screens/numerology_screen.dart';
import '../../../astrology/presentation/screens/transit_center_screen.dart';
import '../../../kundli/presentation/screens/kundli_screen.dart';
import '../../../matching/presentation/screens/chart_comparison_screen.dart';
import '../../../profile/presentation/widgets/profile_switcher_modal.dart';
import '../widgets/daily_guidance_hero.dart';
import 'main_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _askController = TextEditingController();
  @override
  void dispose() {
    _askController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(activeProfileProvider);
    final plan = ref.watch(dailyGamePlanProvider);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    return Material(
      color: AppColors.backgroundLight,
      child: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.secondary,
          onRefresh: () async => ref.refresh(dailyGamePlanProvider.future),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 21,
                          backgroundColor: AppColors.softLavender,
                          child: Text(
                            profile.name.isEmpty
                                ? 'A'
                                : profile.name[0].toUpperCase(),
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLightMode,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                greeting,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondaryLight,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      profile.name.isEmpty
                                          ? 'AstroSaathi'
                                          : profile.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimaryLight,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  AstroProfileSwitcher(
                                    name: profile.relationship,
                                    onTap: () =>
                                        ProfileSwitcherModal.show(context),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.primaryLightMode,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.surfaceLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Personalized for You',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        height: 1.1,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLightMode,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Birth-chart guidance, today’s priorities and the cosmic patterns shaping your day.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.4,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    plan.when(
                      loading: () => const DailyGuidanceHeroSkeleton(),
                      error: (e, _) => SizedBox(
                        height: 180,
                        child: AstroErrorState(
                          message: 'Your daily insight could not be loaded.',
                          onRetry: () => ref.invalidate(dailyGamePlanProvider),
                        ),
                      ),
                      data: _dailyHero,
                    ),
                    const SizedBox(height: 16),
                    plan.when(
                      loading: () => const SizedBox.shrink(),
                      error: (_, _) => const SizedBox.shrink(),
                      data: _focusAvoid,
                    ),
                    const SizedBox(height: 24),
                    const AstroSectionHeader(
                      title: 'Daily recommendation',
                      action: 'Details',
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 82,
                      child: plan.when(
                        loading: () => Row(
                          children: List.generate(
                            2,
                            (index) => Expanded(
                              child: Container(
                                margin: EdgeInsets.only(
                                  right: index == 0 ? 9 : 0,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondaryBackground,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        error: (_, _) => const SizedBox.shrink(),
                        data: (p) => ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _recommendation(
                              'Clarity',
                              '${p.dayScore.round()}%',
                            ),
                            _recommendation(
                              'Best Time',
                              '${p.bestWindow.start}–${p.bestWindow.end}',
                            ),
                            if (p.doList.isNotEmpty)
                              _recommendation('Focus', p.doList.first),
                            if (p.practicalAction?.trim().isNotEmpty ?? false)
                              _recommendation(
                                'Action',
                                p.practicalAction!.trim(),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 26),
                    const AstroSectionHeader(title: 'Ask AstroSaathi'),
                    const SizedBox(height: 10),
                    AstroInput(
                      controller: _askController,
                      hintText: 'Ask AstroSaathi anything…',
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(5),
                        child: IconButton(
                          onPressed: _openAsk,
                          icon: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.actionPurple,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _homePrompts(profile.focusAreas)
                          .map(
                            (q) => ActionChip(
                              label: Text(q),
                              onPressed: () {
                                _askController.text = q;
                                _openAsk();
                              },
                              backgroundColor: AppColors.surfaceLight,
                              side: const BorderSide(
                                color: AppColors.borderLight,
                              ),
                              labelStyle: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.textSecondaryLight,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 26),
                    const AstroSectionHeader(title: 'Planetary detail'),
                    const SizedBox(height: 10),
                    plan.when(
                      loading: () => const SizedBox(
                        height: 120,
                        child: AstroLoadingState(
                          label: 'Reading today’s transits…',
                        ),
                      ),
                      error: (_, _) => const AstroEmptyState(
                        title: 'Planetary detail unavailable',
                        subtitle:
                            'Your daily guidance remains available above.',
                      ),
                      data: _planetaryDetail,
                    ),
                    const SizedBox(height: 26),
                    const AstroSectionHeader(title: 'Quick tools'),
                    const SizedBox(height: 10),
                    _quickTools(),
                    const SizedBox(height: 26),
                    AstroSectionHeader(
                      title: 'Reports for you',
                      action: 'See all',
                      onAction: () =>
                          ref.read(mainNavIndexProvider.notifier).state = 3,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 118,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children:
                            [
                                  'Love & Marriage',
                                  'Career',
                                  'Money',
                                  'Health & Self',
                                  'Yearly Forecast',
                                ]
                                .map(
                                  (title) => Container(
                                    width: 145,
                                    margin: const EdgeInsets.only(right: 10),
                                    child: AstroReportCard(
                                      title: title,
                                      onTap: () =>
                                          ref
                                                  .read(
                                                    mainNavIndexProvider
                                                        .notifier,
                                                  )
                                                  .state =
                                              3,
                                    ),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAsk() => ref.read(mainNavIndexProvider.notifier).state = 2;

  List<String> _homePrompts(List<String> focusAreas) {
    const prompts = <String, String>{
      'Love & Relationships': 'How can I strengthen relationships?',
      'Marriage': 'What should I know about marriage?',
      'Career': 'How is my career period?',
      'Money & Wealth': 'What is my money focus?',
      'Health & Wellness': 'What supports my wellbeing?',
      'Family': 'What is the family theme today?',
      'Education': 'What supports learning today?',
      'Business': 'What should I prioritize in business?',
      'Spiritual Growth': 'What supports spiritual growth?',
      'Life Purpose': 'What guides my life purpose?',
      'Personal Growth': 'Where can I grow today?',
      'Timing & Decisions': 'What timing supports decisions?',
    };
    final values =
        focusAreas.map((area) => prompts[area]).whereType<String>().toList()
          ..addAll(const [
            'What should I focus on today?',
            'How is the current transit affecting me?',
          ]);
    return values.toSet().take(3).toList();
  }

  Widget _dailyHero(GamePlanData plan) {
    final score = (plan.dayScore <= 1 ? plan.dayScore * 100 : plan.dayScore)
        .round()
        .clamp(0, 100);
    final practicalAction = plan.practicalAction?.trim();
    final interpretation = plan.vedicInterpretation?.trim();
    final insight = practicalAction?.isNotEmpty == true
        ? practicalAction
        : interpretation?.isNotEmpty == true
        ? interpretation
        : null;
    final windowStart = plan.bestWindow.start.trim();
    final windowEnd = plan.bestWindow.end.trim();

    return DailyGuidanceHero(
      date: DateTime.now(),
      insight: insight,
      clarityPercent: plan.dayScore.isFinite ? score : null,
      bestWindowStart: windowStart.isEmpty ? null : windowStart,
      bestWindowEnd: windowEnd.isEmpty ? null : windowEnd,
      focus: plan.doList.isEmpty ? null : plan.doList.first,
      onGuidanceTap: () => ref.read(mainNavIndexProvider.notifier).state = 1,
    );
  }

  Widget _focusAvoid(GamePlanData plan) {
    final focus = plan.doList.isEmpty
        ? ['Creativity', 'Important conversations', 'Planning']
        : plan.doList.take(3).toList();
    final avoid = plan.avoidList.isEmpty
        ? ['Impulsive decisions', 'Overthinking', 'Arguments']
        : plan.avoidList.take(3).toList();
    return AstroCard(
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _miniList('FOCUS', focus, AppColors.successLight)),
          Container(width: 1, height: 138, color: AppColors.softLavender),
          Expanded(child: _miniList('AVOID', avoid, AppColors.pink)),
        ],
      ),
    );
  }

  Widget _planetaryDetail(GamePlanData plan) => AstroInsightCard(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const AstroGlyphIcon(
              glyph: '☉',
              size: 50,
              emphasized: true,
              semanticLabel: 'Planetary influence',
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.planetFactor ?? 'Current planetary influence',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plan.transitFactor ??
                        plan.vedicInterpretation ??
                        'Open Calendar to explore today’s active transit pattern.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => ref.read(mainNavIndexProvider.notifier).state = 1,
            icon: const Icon(Icons.arrow_forward_rounded, size: 16),
            label: const Text('Explore in Calendar'),
          ),
        ),
      ],
    ),
  );

  Widget _miniList(String title, List<String> items, Color color) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: .6,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color)),
                Expanded(
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
  Widget _recommendation(String label, String value) => Container(
    width: 112,
    margin: const EdgeInsets.only(right: 9),
    child: AstroCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 9.5,
              color: AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryLightMode,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _quickTools() {
    final tools = <(IconData, String, VoidCallback)>[
      (
        Icons.wb_sunny_outlined,
        'Kundli',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const KundliScreen()),
        ),
      ),
      (
        Icons.favorite_border_rounded,
        'Compatibility',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChartComparisonScreen()),
        ),
      ),
      (
        Icons.filter_7_rounded,
        'Numerology',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NumerologyScreen()),
        ),
      ),
      (
        Icons.calendar_month_outlined,
        'Calendar',
        () => ref.read(mainNavIndexProvider.notifier).state = 1,
      ),
      (
        Icons.public_rounded,
        'Transits',
        () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TransitCenterScreen()),
        ),
      ),
      (
        Icons.description_outlined,
        'Reports',
        () => ref.read(mainNavIndexProvider.notifier).state = 3,
      ),
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tools.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (_, i) {
        final item = tools[i];
        return AstroCard(
          onTap: item.$3,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.$1, color: AppColors.secondary, size: 24),
              const SizedBox(height: 7),
              Text(
                item.$2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
