import '../providers/profile_provider.dart';

class DemoCosmicEvent {
  const DemoCosmicEvent({
    required this.day,
    required this.title,
    required this.category,
    required this.summary,
    required this.impact,
    required this.glyph,
  });

  final int day;
  final String title;
  final String category;
  final String summary;
  final String impact;
  final String glyph;
}

class MonthlyAstroOverview {
  const MonthlyAstroOverview({
    required this.overallScore,
    required this.bestDays,
    required this.carefulDays,
    required this.careerDays,
    required this.relationshipDays,
    required this.healthDays,
    required this.spiritualDays,
    required this.cosmicEvents,
  });

  final double overallScore;
  final List<int> bestDays;
  final List<int> carefulDays;
  final List<int> careerDays;
  final List<int> relationshipDays;
  final List<int> healthDays;
  final List<int> spiritualDays;
  final List<DemoCosmicEvent> cosmicEvents;

  Set<String> categoriesForDay(int day) {
    final categories = <String>{};
    if (careerDays.contains(day)) categories.add('Activity');
    if (relationshipDays.contains(day)) categories.add('Beauty');
    if (healthDays.contains(day)) categories.add('Health');
    if (spiritualDays.contains(day)) categories.add('Moon');
    if (cosmicEvents.any((event) => event.day == day)) {
      categories.add('Transit');
    }
    return categories;
  }
}

class DailyAstroDetail {
  const DailyAstroDetail({
    required this.clarity,
    required this.focus,
    required this.avoid,
    required this.career,
    required this.relationships,
    required this.health,
    required this.spirituality,
    required this.primaryInfluence,
    required this.summary,
  });

  final double clarity;
  final List<String> focus;
  final List<String> avoid;
  final double career;
  final double relationships;
  final double health;
  final double spirituality;
  final String primaryInfluence;
  final String summary;
}

/// Deterministic, explicitly demo-only timing data for the offline showcase.
/// It never claims astronomical precision and never uses randomness.
abstract final class DemoCalendarEngine {
  static int clampDay({
    required int year,
    required int month,
    required int day,
  }) => day.clamp(1, DateTime(year, month + 1, 0).day);

  static MonthlyAstroOverview monthlyOverview({
    required BirthProfileData profile,
    required int year,
    required int month,
  }) {
    final days = DateTime(year, month + 1, 0).day;
    final seed = _seed(
      '${profile.id}|${profile.dob}|${profile.focusAreas.join('|')}|$year-$month',
    );
    final best = _days(seed + 11, days, 5);
    final careful = _days(seed + 29, days, 4, excluded: best.toSet());
    final career = _days(seed + 47, days, 4);
    final relationships = _days(seed + 71, days, 4);
    final health = _days(seed + 89, days, 4);
    final spiritual = _days(seed + 113, days, 3);
    final eventDays = _days(seed + 137, days, 4);
    const definitions = <(String, String, String, String, String)>[
      (
        'Moon reflection theme',
        'Moon',
        'A quiet checkpoint for reviewing emotions, habits and personal rhythm.',
        'Reflective',
        '☽',
      ),
      (
        'Mercury clarity theme',
        'Transit',
        'A useful demo window for organizing conversations, notes and decisions.',
        'Focused',
        '☿',
      ),
      (
        'Venus harmony theme',
        'Beauty',
        'Prioritize balance, thoughtful connection and restorative routines.',
        'Supportive',
        '♀',
      ),
      (
        'Mars momentum theme',
        'Activity',
        'Channel energy into one practical priority and avoid scattered effort.',
        'Active',
        '♂',
      ),
    ];
    final events = <DemoCosmicEvent>[
      for (var index = 0; index < eventDays.length; index++)
        DemoCosmicEvent(
          day: eventDays[index],
          title: definitions[index].$1,
          category: definitions[index].$2,
          summary: definitions[index].$3,
          impact: definitions[index].$4,
          glyph: definitions[index].$5,
        ),
    ]..sort((a, b) => a.day.compareTo(b.day));

    return MonthlyAstroOverview(
      overallScore: (64 + seed % 28).toDouble(),
      bestDays: best,
      carefulDays: careful,
      careerDays: career,
      relationshipDays: relationships,
      healthDays: health,
      spiritualDays: spiritual,
      cosmicEvents: events,
    );
  }

  static DailyAstroDetail dailyDetail({
    required BirthProfileData profile,
    required DateTime date,
  }) {
    final seed = _seed(
      '${profile.id}|${profile.name}|${profile.dob}|${date.year}-${date.month}-${date.day}',
    );
    const influences = [
      'Mercury clarity',
      'Venus balance',
      'Mars momentum',
      'Jupiter perspective',
      'Saturn discipline',
      'Moon reflection',
    ];
    const focusOptions = [
      'Clear communication',
      'One meaningful priority',
      'Thoughtful planning',
      'Restorative routines',
      'Patient collaboration',
      'Creative problem-solving',
    ];
    const avoidOptions = [
      'Rushed commitments',
      'Scattered attention',
      'Unnecessary comparison',
      'Reactive conversations',
      'Skipping recovery time',
      'Overcomplicating decisions',
    ];
    final focusArea = profile.focusAreas.isEmpty
        ? 'Personal Growth'
        : profile.focusAreas[seed % profile.focusAreas.length];
    final influence = influences[seed % influences.length];
    final focus = <String>[focusOptions[seed % focusOptions.length], focusArea];
    final avoid = <String>[
      avoidOptions[(seed ~/ 3) % avoidOptions.length],
      avoidOptions[(seed ~/ 11 + 2) % avoidOptions.length],
    ];
    double score(int offset) => (55 + ((seed + offset) % 41)).toDouble();

    return DailyAstroDetail(
      clarity: score(0),
      focus: focus,
      avoid: avoid,
      career: score(7),
      relationships: score(13),
      health: score(19),
      spirituality: score(23),
      primaryInfluence: influence,
      summary:
          '$influence favors steady choices around $focusArea. Use the day to simplify priorities and act with intention.',
    );
  }

  static List<int> _days(
    int seed,
    int daysInMonth,
    int count, {
    Set<int> excluded = const {},
  }) {
    final result = <int>{};
    var cursor = seed.abs();
    while (result.length < count &&
        result.length + excluded.length < daysInMonth) {
      cursor = (cursor * 1103515245 + 12345) & 0x7fffffff;
      final day = cursor % daysInMonth + 1;
      if (!excluded.contains(day)) result.add(day);
    }
    return result.toList()..sort();
  }

  static int _seed(String value) {
    var hash = 2166136261;
    for (final unit in value.codeUnits) {
      hash ^= unit;
      hash = (hash * 16777619) & 0x7fffffff;
    }
    return hash;
  }
}
