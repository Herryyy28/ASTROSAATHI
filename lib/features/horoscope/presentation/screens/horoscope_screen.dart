import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/engine/models/horoscope_data.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';
import '../../../../core/widgets/astro_components.dart';

final selectedSignProvider = StateProvider<String>((ref) {
  final profile = ref.read(activeProfileProvider);
  if (profile.name.isNotEmpty) {
    final zodiac = ZodiacSignUtils.getZodiacFromName(profile.name);
    if (zodiac != null) return zodiac.englishName;
  }
  return 'Aries';
});

final horoscopeProvider = FutureProvider.family<HoroscopeData, String>((
  ref,
  timeframe,
) async {
  final engine = ref.watch(astrologyEngineProvider);
  final sign = ref.watch(selectedSignProvider);
  return engine.getHoroscope(sign, timeframe);
});

class HoroscopeScreen extends ConsumerWidget {
  const HoroscopeScreen({super.key});

  static const signs = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTabController(
    length: 3,
    child: AstroScaffold(
      appBar: AstroAppBar(
        title: 'Horoscope',
        onBack: () => Navigator.maybePop(context),
        actions: [
          IconButton(
            tooltip: 'Retrograde calendar',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RetrogradeCalendarScreen(),
              ),
            ),
            icon: Text(
              '℞',
              style: GoogleFonts.notoSansSymbols2(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLightMode,
              ),
            ),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const AstroPrimaryHeader(
              eyebrow: 'Personal forecast',
              title: 'Daily Horoscope',
              subtitle: 'Guidance shaped by your selected zodiac sign',
              padding: EdgeInsets.fromLTRB(20, 14, 20, 10),
            ),
            _ZodiacSelector(ref: ref),
            const SizedBox(height: 14),
            const _HoroscopeTabs(),
            const SizedBox(height: 8),
            const Expanded(
              child: TabBarView(
                children: [
                  _HoroscopeTabView(timeframe: 'daily'),
                  _HoroscopeTabView(timeframe: 'weekly'),
                  _HoroscopeTabView(timeframe: 'monthly'),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ZodiacSelector extends StatelessWidget {
  const _ZodiacSelector({required this.ref});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedSignProvider);
    return SizedBox(
      height: 68,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: HoroscopeScreen.signs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final sign = HoroscopeScreen.signs[index];
          final active = selected == sign;
          return Semantics(
            button: true,
            selected: active,
            label: '$sign horoscope',
            child: InkWell(
              onTap: () => ref.read(selectedSignProvider.notifier).state = sign,
              borderRadius: BorderRadius.circular(18),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 190),
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: active ? AppColors.highlightSurface : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: active
                        ? AppColors.secondary
                        : AppColors.softLavender,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AstroSymbols.zodiac(sign),
                      style: GoogleFonts.notoSansSymbols2(
                        fontSize: 22,
                        height: 1,
                        color: AppColors.primaryLightMode,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      sign.substring(0, 3),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                        color: active
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
}

class _HoroscopeTabs extends StatelessWidget {
  const _HoroscopeTabs();

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.secondaryBackground,
      borderRadius: BorderRadius.circular(22),
    ),
    child: TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      splashBorderRadius: BorderRadius.circular(18),
      labelColor: Colors.white,
      unselectedLabelColor: AppColors.textSecondaryLight,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700),
      indicator: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(18),
      ),
      tabs: const [
        Tab(height: 42, text: 'Daily'),
        Tab(height: 42, text: 'Weekly'),
        Tab(height: 42, text: 'Monthly'),
      ],
    ),
  );
}

class _HoroscopeTabView extends ConsumerWidget {
  const _HoroscopeTabView({required this.timeframe});

  final String timeframe;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(horoscopeProvider(timeframe));
    final currentPlanets = timeframe == 'weekly'
        ? ref.watch(currentPlanetaryPositionsProvider)
        : null;
    return async.when(
      loading: () => const AstroLoadingState(label: 'Reading your horoscope'),
      error: (error, _) => AstroErrorState(
        message: 'Your horoscope is temporarily unavailable.',
        onRetry: () => ref.invalidate(horoscopeProvider(timeframe)),
      ),
      data: (data) => RefreshIndicator(
        color: AppColors.primaryLightMode,
        onRefresh: () async => ref.refresh(horoscopeProvider(timeframe).future),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            _InsightHero(
              data: data,
            ).animate().fadeIn(duration: 240.ms).slideY(begin: .04),
            const SizedBox(height: 18),
            const AstroSectionHeader(title: 'Personalized guidance'),
            const SizedBox(height: 10),
            AstroCard(
              padding: const EdgeInsets.all(18),
              child: Text(
                data.reading,
                style: const TextStyle(
                  fontSize: 14.5,
                  height: 1.65,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    glyph: '#',
                    label: 'Lucky number',
                    value: '${data.luckyNumber}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MetricCard(
                    glyph: '◉',
                    label: 'Lucky color',
                    value: data.luckyColor,
                  ),
                ),
              ],
            ),
            if (timeframe == 'weekly') ...[
              const SizedBox(height: 24),
              const AstroSectionHeader(title: 'Weekly planetary overview'),
              const SizedBox(height: 10),
              _WeeklyPlanetaryOverview(planets: currentPlanets!),
            ],
            if (timeframe == 'daily') ...[
              const SizedBox(height: 24),
              const AstroSectionHeader(title: 'Retrograde calendar'),
              const SizedBox(height: 10),
              _RetrogradePreview(
                onOpen: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RetrogradeCalendarScreen(),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeeklyPlanetaryOverview extends StatelessWidget {
  const _WeeklyPlanetaryOverview({required this.planets});

  final AsyncValue<List<Map<String, dynamic>>> planets;

  @override
  Widget build(BuildContext context) => planets.when(
    loading: () => const AstroLoadingState(label: 'Reading current planets'),
    error: (_, _) => const AstroCard(
      child: AstroEmptyState(
        icon: Icons.blur_circular_rounded,
        title: 'Planetary positions unavailable',
        subtitle: 'Current planetary positions could not be loaded.',
      ),
    ),
    data: (values) {
      if (values.isEmpty) {
        return const AstroCard(
          child: AstroEmptyState(
            icon: Icons.blur_circular_rounded,
            title: 'Planetary positions unavailable',
            subtitle:
                'The current provider does not expose exact planet positions.',
          ),
        );
      }
      return AstroCard(
        padding: const EdgeInsets.all(14),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: values.map((planet) {
            final name = planet['name']?.toString() ?? 'Planet';
            final sign = (planet['sign'] ?? planet['rashi'])?.toString() ?? '—';
            final degree = (planet['degree'] as num?)?.toDouble();
            final retrograde =
                planet['retrograde'] == true || planet['isRetrograde'] == true;
            return SizedBox(
              width: 138,
              child: AstroInsightCard(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AstroGlyphIcon(
                          glyph: AstroSymbols.planet(name),
                          size: 34,
                          semanticLabel: name,
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ),
                        if (retrograde)
                          const Text(
                            '℞',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.pink,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    Text(
                      degree == null
                          ? sign
                          : '${degree.toStringAsFixed(1)}° $sign',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}

class _InsightHero extends StatelessWidget {
  const _InsightHero({required this.data});

  final HoroscopeData data;

  @override
  Widget build(BuildContext context) => AstroInsightCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AstroGlyphIcon(
          glyph: AstroSymbols.zodiac(data.sign),
          semanticLabel: data.sign,
          emphasized: true,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${data.timeframe.toUpperCase()} INSIGHT',
                style: const TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                data.sign,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLightMode,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Your provider-backed forecast',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.glyph,
    required this.label,
    required this.value,
  });

  final String glyph;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => AstroCard(
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        AstroGlyphIcon(glyph: glyph, size: 38, semanticLabel: label),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _RetrogradePreview extends StatelessWidget {
  const _RetrogradePreview({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) => AstroCard(
    child: Column(
      children: [
        const AstroEmptyState(
          icon: Icons.replay_rounded,
          title: 'No retrograde data available',
          subtitle:
              'Planet, sign, station and direct dates will appear when supplied by the astrology provider.',
        ),
        const SizedBox(height: 14),
        AstroSecondaryButton(
          label: 'Open calendar',
          icon: Icons.calendar_month_outlined,
          onPressed: onOpen,
        ),
      ],
    ),
  );
}

class RetrogradeCalendarScreen extends StatelessWidget {
  const RetrogradeCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) => const AstroDetailScaffold(
    title: 'Retrograde Calendar',
    subtitle: 'Planetary stations and direct-motion dates',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AstroPageIntro(
          tag: 'PLANETARY MOTION',
          title: 'Retrograde cycles',
          subtitle:
              'A clear timeline for retrograde starts, stations and direct dates.',
          icon: Icons.replay_rounded,
        ),
        SizedBox(height: 18),
        AstroCard(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: AstroEmptyState(
              icon: Icons.replay_circle_filled_outlined,
              title: 'No retrograde planets available',
              subtitle:
                  'The current provider response does not include retrograde calendar dates. No sample dates have been inserted.',
            ),
          ),
        ),
      ],
    ),
  );
}
