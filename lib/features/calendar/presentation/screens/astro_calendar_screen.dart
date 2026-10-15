import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/engine/demo_calendar_engine.dart';
import '../../../../core/engine/models/panchang_data.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class AstroCalendarScreen extends ConsumerStatefulWidget {
  const AstroCalendarScreen({super.key});
  @override
  ConsumerState<AstroCalendarScreen> createState() =>
      _AstroCalendarScreenState();
}

class _AstroCalendarScreenState extends ConsumerState<AstroCalendarScreen> {
  int _tab = 0;
  int _calendarCategory = 0;
  int _selectedDay = DateTime.now().day;
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.backgroundLight,
    child: SafeArea(
      bottom: false,
      child: Column(
        children: [
          const AstroPrimaryHeader(
            eyebrow: 'Personal timing',
            title: 'Astro Calendar',
            subtitle: 'Your daily, lunar and planetary rhythm',
          ),
          _tabs(),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: [_today(), _monthView(), _moon(), _transits()][_tab],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _tabs() => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.secondaryBackground,
      borderRadius: BorderRadius.circular(24),
    ),
    child: Row(
      children: List.generate(4, (i) {
        const labels = ['Today', 'Month', 'Moon', 'Transits'];
        final active = _tab == i;
        return Expanded(
          child: InkWell(
            onTap: () => setState(() => _tab = i),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.secondary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                labels[i],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: active ? Colors.white : AppColors.textSecondaryLight,
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );

  Widget _page({required List<Widget> children}) => SingleChildScrollView(
    key: ValueKey(_tab),
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );

  Widget _heading(String title, [String? subtitle]) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 27,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryLightMode,
        ),
      ),
      if (subtitle != null)
        Text(
          subtitle,
          style: const TextStyle(color: AppColors.textSecondaryLight),
        ),
      const SizedBox(height: 16),
    ],
  );

  Widget _today() {
    final asyncPlan = ref.watch(dailyGamePlanProvider);
    return asyncPlan.when(
      loading: () => const AstroLoadingState(),
      error: (error, _) => AstroErrorState(
        message: 'Unable to load today’s astrology.',
        onRetry: () => ref.invalidate(dailyGamePlanProvider),
      ),
      data: (plan) {
        final score = (plan.dayScore <= 1 ? plan.dayScore * 100 : plan.dayScore)
            .round()
            .clamp(0, 100);
        final focus = plan.doList.take(3).toList();
        final avoid = plan.avoidList.take(3).toList();
        final influences = <String>[
          if (plan.planetFactor?.trim().isNotEmpty ?? false)
            plan.planetFactor!.trim(),
          if (plan.houseFactor?.trim().isNotEmpty ?? false)
            plan.houseFactor!.trim(),
          if (plan.transitFactor?.trim().isNotEmpty ?? false)
            plan.transitFactor!.trim(),
        ];
        return _page(
          children: [
            _heading(
              "Today's Astro",
              DateFormat('d MMMM yyyy').format(DateTime.now()),
            ),
            AstroInsightCard(
              child: Column(
                children: [
                  const Text(
                    'DAILY CLARITY',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: .8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 190,
                    height: 100,
                    child: CustomPaint(
                      painter: _ClarityPainter(score / 100),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Text(
                            '$score%',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 35,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryLightMode,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    plan.practicalAction?.trim().isNotEmpty ?? false
                        ? plan.practicalAction!.trim()
                        : 'Personal guidance is not available for this date.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _listCard(
                    'FOCUS',
                    focus,
                    AppColors.successLight,
                    Icons.adjust_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _listCard(
                    'AVOID',
                    avoid,
                    AppColors.pink,
                    Icons.error_outline_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _metric(
                    'Best Time',
                    '${plan.bestWindow.start} – ${plan.bestWindow.end}',
                    Icons.schedule_rounded,
                  ),
                ),
                if (plan.planetFactor?.trim().isNotEmpty ?? false) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _metric(
                      'Planetary Influence',
                      plan.planetFactor!.trim(),
                      Icons.blur_circular_rounded,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            const AstroSectionHeader(title: "Today's Cosmic Events"),
            const SizedBox(height: 10),
            if (influences.isEmpty)
              const AstroCard(
                child: AstroEmptyState(
                  icon: Icons.auto_awesome_outlined,
                  title: 'No cosmic events available',
                  subtitle:
                      'Planetary events will appear when included in today’s provider response.',
                ),
              )
            else
              ...influences.map(
                (influence) => _event(
                  influence,
                  'Today',
                  plan.vedicInterpretation?.trim().isNotEmpty ?? false
                      ? plan.vedicInterpretation!.trim()
                      : 'No additional interpretation is available.',
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _listCard(
    String title,
    List<String> items,
    Color color,
    IconData icon,
  ) => AstroCard(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text(
            'No guidance available',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
          ),
        ...items.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    e,
                    style: const TextStyle(
                      fontSize: 13,
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
  Widget _metric(String label, String value, IconData icon) => AstroCard(
    padding: const EdgeInsets.all(12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: AppColors.secondary),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: AppColors.textSecondaryLight,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    ),
  );
  Widget _event(String title, String time, String body) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: AstroCalendarCard(
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.softLavender,
            child: Icon(
              Icons.auto_awesome,
              size: 18,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _monthView() {
    final profile = ref.watch(activeProfileProvider);
    final overview = DemoCalendarEngine.monthlyOverview(
      profile: profile,
      year: _month.year,
      month: _month.month,
    );
    final days = DateUtils.getDaysInMonth(_month.year, _month.month);
    final offset = DateTime(_month.year, _month.month, 1).weekday % 7;
    final today = DateTime.now();
    return _page(
      children: [
        const AstroPageIntro(
          tag: 'MONTHLY TIMING',
          title: 'Special Calendars',
          subtitle:
              'Moon, transit, relationship, career and wellness timing in one clear view.',
          icon: Icons.calendar_month_outlined,
        ),
        const SizedBox(height: 16),
        _calendarCategories(),
        const SizedBox(height: 16),
        AstroCalendarCard(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Previous month',
                    onPressed: () => _changeMonth(-1),
                    icon: const Icon(
                      Icons.chevron_left,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      DateFormat('MMMM yyyy').format(_month),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryLightMode,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Next month',
                    onPressed: () => _changeMonth(1),
                    icon: const Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  for (final d in [
                    'Sun',
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ])
                    Expanded(
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: offset + days,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: .9,
                ),
                itemBuilder: (_, i) {
                  if (i < offset) return const SizedBox.shrink();
                  final day = i - offset + 1;
                  final selected = day == _selectedDay;
                  final selectedCategory = [
                    'Transit',
                    'Moon',
                    'Beauty',
                    'Health',
                    'Activity',
                  ][_calendarCategory];
                  final markers = overview
                      .categoriesForDay(day)
                      .where((category) => category == selectedCategory)
                      .toList();
                  final isToday =
                      day == today.day &&
                      _month.month == today.month &&
                      _month.year == today.year;
                  return Semantics(
                    button: true,
                    selected: selected,
                    label:
                        '$day ${DateFormat('MMMM yyyy').format(_month)}${isToday ? ', today' : ''}',
                    child: InkWell(
                      onTap: () {
                        final selectedDate = DateTime(
                          _month.year,
                          _month.month,
                          day,
                        );
                        setState(() => _selectedDay = day);
                        ref.read(selectedPanchangDateProvider.notifier).state =
                            selectedDate;
                      },
                      borderRadius: BorderRadius.circular(13),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.highlightSurface
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(
                            color: selected
                                ? AppColors.primaryLightMode
                                : isToday
                                ? AppColors.secondary
                                : Colors.transparent,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$day',
                              style: TextStyle(
                                color: selected
                                    ? AppColors.primaryLightMode
                                    : AppColors.textPrimaryLight,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                            if (markers.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: markers
                                      .take(3)
                                      .map(
                                        (category) => Container(
                                          width: 4,
                                          height: 4,
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _categoryColor(category),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              )
                            else if (isToday)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    margin: const EdgeInsets.only(top: 3),
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              const Divider(color: AppColors.softLavender),
              _markerLegend(),
              const SizedBox(height: 4),
              Text(
                '${['Transit', 'Moon', 'Beauty', 'Health', 'Activity'][_calendarCategory]} timing is highlighted from your offline demo profile.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.4,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _selectedDateDetails(profile),
        const SizedBox(height: 20),
        const AstroSectionHeader(title: 'Monthly Overview'),
        const SizedBox(height: 10),
        _monthlyOverview(overview),
        const SizedBox(height: 20),
        const AstroSectionHeader(title: 'Demo Cosmic Highlights'),
        const SizedBox(height: 10),
        ...overview.cosmicEvents.map(
          (event) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: AstroCalendarCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AstroGlyphIcon(
                    glyph: event.glyph,
                    semanticLabel: event.title,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                event.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimaryLight,
                                ),
                              ),
                            ),
                            Text(
                              '${event.day} ${DateFormat('MMM').format(_month)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${event.category} · ${event.impact}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryLightMode,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          event.summary,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _calendarCategories() {
    const categories = <(String, IconData)>[
      ('Transit', Icons.blur_circular_rounded),
      ('Moon', Icons.nightlight_round),
      ('Beauty', Icons.auto_awesome_outlined),
      ('Health', Icons.favorite_border_rounded),
      ('Activity', Icons.directions_run_rounded),
    ];
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = _calendarCategory == index;
          return Semantics(
            button: true,
            selected: selected,
            label: '${category.$1} calendar',
            child: InkWell(
              onTap: () => setState(() => _calendarCategory = index),
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 190),
                width: 76,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white
                      : AppColors.secondaryBackground,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? AppColors.secondary
                        : AppColors.softLavender,
                  ),
                  boxShadow: selected
                      ? const [
                          BoxShadow(
                            color: Color(0x147668D8),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      category.$2,
                      size: 22,
                      color: selected
                          ? AppColors.primaryLightMode
                          : AppColors.textSecondaryLight,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.$1,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? AppColors.primaryLightMode
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _selectedDateDetails(BirthProfileData profile) {
    final selectedDate = DateTime(_month.year, _month.month, _selectedDay);
    final detail = DemoCalendarEngine.dailyDetail(
      profile: profile,
      date: selectedDate,
    );
    final panchang = ref.watch(panchangProvider);
    return AstroCalendarCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('d MMMM yyyy').format(selectedDate),
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLightMode,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            detail.summary,
            style: const TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _PanchangChip(
                label: 'Overall energy',
                value: '${detail.clarity.round()}%',
              ),
              _PanchangChip(label: 'Influence', value: detail.primaryInfluence),
              _PanchangChip(
                label: 'Career',
                value: '${detail.career.round()}%',
              ),
              _PanchangChip(
                label: 'Relationships',
                value: '${detail.relationships.round()}%',
              ),
              _PanchangChip(
                label: 'Health',
                value: '${detail.health.round()}%',
              ),
              _PanchangChip(
                label: 'Spirituality',
                value: '${detail.spirituality.round()}%',
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _listCard(
                  'FOCUS',
                  detail.focus,
                  AppColors.secondary,
                  Icons.adjust_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _listCard(
                  'AVOID',
                  detail.avoid,
                  AppColors.pink,
                  Icons.error_outline_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'PANCHANG',
            style: TextStyle(
              fontSize: 10.5,
              letterSpacing: .8,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 8),
          panchang.when(
            loading: () =>
                const AstroLoadingState(label: 'Loading selected day'),
            error: (error, _) => AstroErrorState(
              message: 'Selected-day Panchang is unavailable.',
              onRetry: () => ref.invalidate(panchangProvider),
            ),
            data: (data) => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PanchangChip(label: 'Tithi', value: data.tithi),
                _PanchangChip(label: 'Nakshatra', value: data.nakshatra),
                _PanchangChip(label: 'Yoga', value: data.yoga),
                _PanchangChip(label: 'Sunrise', value: data.sunrise),
                _PanchangChip(label: 'Sunset', value: data.sunset),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthlyOverview(MonthlyAstroOverview overview) => AstroCalendarCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: overview.overallScore / 100,
                    strokeWidth: 7,
                    color: AppColors.secondary,
                    backgroundColor: AppColors.softLavender,
                  ),
                  Text(
                    '${overview.overallScore.round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLightMode,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overall month energy',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'A deterministic offline timing overview based on the selected profile and month.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.35,
                      color: AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _overviewRow('Best days', overview.bestDays),
        _overviewRow('Careful days', overview.carefulDays),
        _overviewRow('Career', overview.careerDays),
        _overviewRow('Relationships', overview.relationshipDays),
        _overviewRow('Health & Wellness', overview.healthDays),
        _overviewRow('Spiritual', overview.spiritualDays, divider: false),
      ],
    ),
  );

  Widget _overviewRow(String label, List<int> days, {bool divider = true}) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 9),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
                Text(
                  days.join(', '),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          if (divider) const Divider(height: 1, color: AppColors.softLavender),
        ],
      );

  Widget _markerLegend() {
    const categories = ['Transit', 'Moon', 'Beauty', 'Health', 'Activity'];
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10,
      runSpacing: 6,
      children: categories
          .map(
            (category) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _categoryColor(category),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 9.5,
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          )
          .toList(),
    );
  }

  Color _categoryColor(String category) => switch (category) {
    'Moon' => AppColors.primaryLightMode,
    'Beauty' => AppColors.pink,
    'Health' => AppColors.actionPurple,
    'Activity' => AppColors.secondary,
    _ => AppColors.textSecondaryLight,
  };

  void _changeMonth(int delta) {
    final next = DateTime(_month.year, _month.month + delta);
    setState(() {
      _month = next;
      _selectedDay = DemoCalendarEngine.clampDay(
        year: next.year,
        month: next.month,
        day: _selectedDay,
      );
    });
    ref.read(selectedPanchangDateProvider.notifier).state = DateTime(
      next.year,
      next.month,
      _selectedDay,
    );
  }

  Widget _moon() {
    final panchang = ref.watch(panchangProvider);
    return panchang.when(
      loading: () => const AstroLoadingState(label: 'Reading the Moon'),
      error: (error, _) => AstroErrorState(
        message: 'Lunar context is unavailable.',
        onRetry: () => ref.invalidate(panchangProvider),
      ),
      data: (data) => _page(
        children: [
          AstroInsightCard(
            child: Column(
              children: [
                const AstroGlyphIcon(
                  glyph: '☽',
                  size: 72,
                  emphasized: true,
                  semanticLabel: 'Moon',
                ),
                const SizedBox(height: 14),
                Text(
                  data.tithi,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryLightMode,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.nakshatra,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondaryLight),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const AstroSectionHeader(title: 'Moon phase details'),
          const SizedBox(height: 10),
          _moonProviderDetails(data),
        ],
      ),
    );
  }

  Widget _moonProviderDetails(PanchangData data) => AstroCalendarCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _PanchangChip(label: 'Tithi', value: data.tithi),
            _PanchangChip(label: 'Nakshatra', value: data.nakshatra),
            _PanchangChip(label: 'Yoga', value: data.yoga),
            _PanchangChip(label: 'Karana', value: data.karana),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Moon Insights uses the locally supported Panchang rhythm. Astronomical phase, illumination and lunar-age claims are intentionally omitted.',
          style: TextStyle(
            fontSize: 12,
            height: 1.4,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    ),
  );

  Widget _transits() {
    final plan = ref.watch(dailyGamePlanProvider);
    return plan.when(
      loading: () => const AstroLoadingState(label: 'Reading current transits'),
      error: (error, _) => AstroErrorState(
        message: 'Transit interpretation is unavailable.',
        onRetry: () => ref.invalidate(dailyGamePlanProvider),
      ),
      data: (data) {
        final values = <(String, String)>[
          if (data.planetFactor?.trim().isNotEmpty ?? false)
            ('Planetary influence', data.planetFactor!.trim()),
          if (data.transitFactor?.trim().isNotEmpty ?? false)
            ('Transit interpretation', data.transitFactor!.trim()),
          if (data.houseFactor?.trim().isNotEmpty ?? false)
            ('House focus', data.houseFactor!.trim()),
        ];
        return _page(
          children: [
            _heading(
              'Current Transits',
              'Provider-backed influences for your active profile',
            ),
            if (values.isEmpty)
              const AstroCalendarCard(
                child: AstroEmptyState(
                  icon: Icons.blur_circular_rounded,
                  title: 'No transit interpretation available',
                  subtitle:
                      'Transit cards will appear when planetary and house factors are returned.',
                ),
              )
            else
              ...values.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AstroCalendarCard(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AstroGlyphIcon(
                          glyph: '◎',
                          semanticLabel: 'Transit',
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.$1.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  letterSpacing: .8,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.secondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                entry.$2,
                                style: const TextStyle(
                                  height: 1.45,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (data.practicalAction?.trim().isNotEmpty ?? false) ...[
              const SizedBox(height: 10),
              const AstroSectionHeader(title: 'Best action'),
              const SizedBox(height: 10),
              AstroInsightCard(
                child: Text(
                  data.practicalAction!.trim(),
                  style: const TextStyle(
                    height: 1.5,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _ClarityPainter extends CustomPainter {
  const _ClarityPainter(this.value);
  final double value;
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(8, 10, size.width - 16, size.height * 1.6);
    final bg = Paint()
      ..color = AppColors.softLavender
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..shader = AppColors.purpleGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 3.14, 3.14, false, bg);
    canvas.drawArc(rect, 3.14, 3.14 * value, false, fg);
  }

  @override
  bool shouldRepaint(covariant _ClarityPainter oldDelegate) =>
      oldDelegate.value != value;
}

class _PanchangChip extends StatelessWidget {
  const _PanchangChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    constraints: const BoxConstraints(minWidth: 112),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.secondaryBackground,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 9.5,
            letterSpacing: .7,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    ),
  );
}
