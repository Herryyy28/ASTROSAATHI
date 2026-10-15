import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../widgets/birth_chart_card.dart';

/// Existing Explore entry point retained for navigation compatibility.
class ChartPatternsScreen extends StatelessWidget {
  const ChartPatternsScreen({super.key});

  @override
  Widget build(BuildContext context) => const CurrentChartScreen(initialTab: 1);
}

/// Provider-backed home for the current chart and any detected chart patterns.
class CurrentChartScreen extends ConsumerStatefulWidget {
  const CurrentChartScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  ConsumerState<CurrentChartScreen> createState() => _CurrentChartScreenState();
}

class _CurrentChartScreenState extends ConsumerState<CurrentChartScreen> {
  late int _tab = widget.initialTab.clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final chart = ref.watch(birthChartProvider);
    final profile = ref.watch(activeProfileProvider);

    return AstroDetailScaffold(
      title: 'Current Chart',
      subtitle: 'Your calculated chart, aspect patterns and elemental themes.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ChartContextCard(profileName: profile.name),
          const SizedBox(height: 16),
          _SegmentedTabs(
            selected: _tab,
            onChanged: (value) => setState(() => _tab = value),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: KeyedSubtree(
              key: ValueKey(_tab),
              child: chart.when(
                loading: () =>
                    const AstroLoadingState(label: 'Reading your chart'),
                error: (error, _) => AstroErrorState(
                  message: 'Your chart could not be loaded.',
                  onRetry: () => ref.invalidate(birthChartProvider),
                ),
                data: (data) => _tab == 0
                    ? const _CurrentChartView()
                    : _PatternsView(chartData: data),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartContextCard extends StatelessWidget {
  const _ChartContextCard({required this.profileName});

  final String profileName;

  @override
  Widget build(BuildContext context) => AstroCard(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        const AstroGlyphIcon(
          glyph: '◎',
          semanticLabel: 'Current natal chart',
          emphasized: true,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CHART TYPE',
                style: TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 3),
              const Text(
                'Natal planets',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                profileName.isEmpty ? 'Active profile' : profileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.verified_outlined,
          color: AppColors.primaryLightMode,
          size: 20,
        ),
      ],
    ),
  );
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.secondaryBackground,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Row(
      children: ['Chart', 'Patterns'].asMap().entries.map((entry) {
        final active = selected == entry.key;
        return Expanded(
          child: Semantics(
            selected: active,
            button: true,
            child: InkWell(
              onTap: () => onChanged(entry.key),
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 190),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: active ? AppColors.secondary : Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  entry.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? Colors.white : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

class _CurrentChartView extends StatelessWidget {
  const _CurrentChartView();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const AstroSectionHeader(title: 'Natal chart'),
      const SizedBox(height: 4),
      const Text(
        'House positions and calculated planetary placements',
        style: TextStyle(color: AppColors.textSecondaryLight),
      ),
      const SizedBox(height: 12),
      const RepaintBoundary(child: BirthChartCard())
          .animate()
          .fadeIn(duration: 360.ms)
          .scaleXY(begin: .98, end: 1, curve: Curves.easeOutCubic),
      const SizedBox(height: 12),
      const AstroInsightCard(
        child: Text(
          'Aspect lines, angles and degree labels appear when the chart provider includes those fields.',
          style: TextStyle(height: 1.45, color: AppColors.textSecondaryLight),
        ),
      ),
    ],
  );
}

class _PatternsView extends StatelessWidget {
  const _PatternsView({required this.chartData});

  final Map<String, dynamic> chartData;

  @override
  Widget build(BuildContext context) {
    final patterns = _mapList(
      chartData['patterns'] ?? chartData['chartPatterns'],
    );
    final elements = _numberMap(chartData['elements']);
    final modalities = _numberMap(
      chartData['modalities'] ?? chartData['modes'],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (patterns.isEmpty)
          const AstroCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: AstroEmptyState(
                icon: Icons.hub_outlined,
                title: 'No chart patterns detected',
                subtitle:
                    'Patterns will appear when the chart calculation returns aspect formations such as a trine, square or stellium.',
              ),
            ),
          )
        else
          ...patterns.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _PatternCard(pattern: entry.value, index: entry.key),
            ),
          ),
        const SizedBox(height: 12),
        const AstroSectionHeader(title: 'Themes & elements'),
        const SizedBox(height: 4),
        const Text(
          'Elemental and modality balance from your chart data',
          style: TextStyle(color: AppColors.textSecondaryLight),
        ),
        const SizedBox(height: 12),
        if (elements.isEmpty && modalities.isEmpty)
          const AstroCard(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: AstroEmptyState(
                icon: Icons.donut_large_rounded,
                title: 'Element analytics unavailable',
                subtitle:
                    'Your current chart response does not include element or modality strengths.',
              ),
            ),
          )
        else
          _ThemeAnalytics(elements: elements, modalities: modalities),
      ],
    );
  }
}

class _PatternCard extends StatelessWidget {
  const _PatternCard({required this.pattern, required this.index});

  final Map<String, dynamic> pattern;
  final int index;

  @override
  Widget build(BuildContext context) {
    final name = _text(pattern['name'] ?? pattern['type'], 'Chart pattern');
    final modality = _text(pattern['modality'], 'Calculated formation');
    final planets = _stringList(pattern['planets']);
    final interpretation = _text(
      pattern['interpretation'] ?? pattern['meaning'],
      '',
    );

    return AstroCard(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                modality.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10.5,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                name,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLightMode,
                ),
              ),
              if (planets.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: planets
                      .map(
                        (planet) => Chip(
                          avatar: Text(
                            AstroSymbols.planet(planet),
                            style: GoogleFonts.notoSansSymbols2(
                              color: AppColors.primaryLightMode,
                            ),
                          ),
                          label: Text(planet),
                          side: BorderSide.none,
                          backgroundColor: AppColors.softLavender,
                        ),
                      )
                      .toList(),
                ),
              ],
              const SizedBox(height: 18),
              AspectRatio(
                aspectRatio: 1.65,
                child: CustomPaint(
                  painter: _PatternGeometryPainter(
                    pointCount: math.max(3, planets.length),
                  ),
                ),
              ),
              if (interpretation.isNotEmpty) ...[
                const SizedBox(height: 16),
                Material(
                  color: Colors.transparent,
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: const EdgeInsets.only(bottom: 8),
                    title: const Text(
                      'More info',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    children: [
                      Text(
                        interpretation,
                        style: const TextStyle(
                          height: 1.55,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        )
        .animate(delay: (index * 60).ms)
        .fadeIn(duration: 260.ms)
        .slideY(begin: .04);
  }
}

class _ThemeAnalytics extends StatelessWidget {
  const _ThemeAnalytics({required this.elements, required this.modalities});

  final Map<String, double> elements;
  final Map<String, double> modalities;

  @override
  Widget build(BuildContext context) => AstroCard(
    padding: const EdgeInsets.all(18),
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final chart = SizedBox(
          width: compact ? 150 : 170,
          height: compact ? 150 : 170,
          child: CustomPaint(painter: _ElementDonutPainter(elements)),
        );
        final legend = _AnalyticsLegend(
          elements: elements,
          modalities: modalities,
        );
        return compact
            ? Column(children: [chart, const SizedBox(height: 18), legend])
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  chart,
                  const SizedBox(width: 20),
                  Expanded(child: legend),
                ],
              );
      },
    ),
  );
}

class _AnalyticsLegend extends StatelessWidget {
  const _AnalyticsLegend({required this.elements, required this.modalities});

  final Map<String, double> elements;
  final Map<String, double> modalities;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ...elements.entries.map((entry) => _analyticsRow(entry.key, entry.value)),
      if (modalities.isNotEmpty) ...[
        const Divider(height: 24, color: AppColors.softLavender),
        const Text(
          'MODALITIES',
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: 1,
            fontWeight: FontWeight.w700,
            color: AppColors.secondary,
          ),
        ),
        const SizedBox(height: 8),
        ...modalities.entries.map(
          (entry) => _analyticsRow(entry.key, entry.value),
        ),
      ],
    ],
  );

  Widget _analyticsRow(String label, double value) {
    final normalized = value > 1 ? value / 100 : value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${(normalized * 100).round()}%',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.primaryLightMode,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PatternGeometryPainter extends CustomPainter {
  const _PatternGeometryPainter({required this.pointCount});

  final int pointCount;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) * .38;
    final ring = Paint()
      ..color = AppColors.softLavender
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius, ring);

    final count = pointCount.clamp(3, 8);
    final points = List.generate(count, (index) {
      final angle = -math.pi / 2 + index * math.pi * 2 / count;
      return Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
    });
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );
    for (final point in points) {
      canvas.drawCircle(point, 5, Paint()..color = AppColors.primaryLightMode);
    }
  }

  @override
  bool shouldRepaint(covariant _PatternGeometryPainter oldDelegate) =>
      oldDelegate.pointCount != pointCount;
}

class _ElementDonutPainter extends CustomPainter {
  const _ElementDonutPainter(this.values);

  final Map<String, double> values;

  static const colors = [
    AppColors.actionPurple,
    AppColors.primaryLightMode,
    AppColors.secondary,
    AppColors.pink,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final total = values.values.fold<double>(0, (sum, value) => sum + value);
    if (total <= 0) return;
    var start = -math.pi / 2;
    for (final entry in values.entries.toList().asMap().entries) {
      final sweep = math.pi * 2 * entry.value.value / total;
      canvas.drawArc(
        rect.deflate(size.width * .16),
        start,
        sweep,
        false,
        Paint()
          ..color = colors[entry.key % colors.length]
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * .18
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _ElementDonutPainter oldDelegate) =>
      oldDelegate.values != values;
}

List<Map<String, dynamic>> _mapList(dynamic value) {
  if (value is! List) return const [];
  return value
      .whereType<Map>()
      .map((item) => Map<String, dynamic>.from(item))
      .toList();
}

Map<String, double> _numberMap(dynamic value) {
  if (value is! Map) return const {};
  return value.map((key, item) {
    final number = item is num
        ? item.toDouble()
        : double.tryParse('$item') ?? 0;
    return MapEntry('$key', number);
  });
}

List<String> _stringList(dynamic value) {
  if (value is! List) return const [];
  return value
      .map((item) {
        if (item is Map) return _text(item['name'] ?? item['planet'], '');
        return '$item';
      })
      .where((item) => item.isNotEmpty)
      .toList();
}

String _text(dynamic value, String fallback) {
  final text = value?.toString().trim() ?? '';
  return text.isEmpty ? fallback : text;
}
