import 'package:astrosaathi/core/engine/astrology_data_enricher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AstrologyDataEnricher', () {
    test('unwraps backend data and preserves exact planetary fields', () {
      final enriched = AstrologyDataEnricher.enrichBirthChart({
        'success': true,
        'data': {
          'planets': [
            {
              'name': 'Sun',
              'rashi': 'Aries',
              'degree': 10.0,
              'retrograde': false,
            },
            {
              'name': 'Moon',
              'rashi': 'Leo',
              'degree': 10.0,
              'retrograde': false,
            },
            {
              'name': 'Jupiter',
              'rashi': 'Sagittarius',
              'degree': 10.0,
              'retrograde': true,
            },
          ],
        },
      });

      final planets = enriched['planets'] as List<Map<String, dynamic>>;
      expect(planets.first['longitude'], 10.0);
      expect(planets.last['longitude'], 250.0);
      expect(planets.last['retrograde'], isTrue);
      expect(enriched['aspects'], hasLength(3));
      expect(
        (enriched['patterns'] as List).any(
          (pattern) => (pattern as Map)['name'] == 'Grand Trine',
        ),
        isTrue,
      );
    });

    test('calculates element and modality percentages from signs', () {
      final enriched = AstrologyDataEnricher.enrichBirthChart({
        'planets': [
          {'name': 'Sun', 'rashi': 'Aries'},
          {'name': 'Moon', 'rashi': 'Taurus'},
          {'name': 'Mercury', 'rashi': 'Gemini'},
          {'name': 'Venus', 'rashi': 'Cancer'},
          {'name': 'Rahu', 'rashi': 'Leo'},
        ],
      });

      expect(enriched['elements'], {
        'Fire': 25.0,
        'Earth': 25.0,
        'Air': 25.0,
        'Water': 25.0,
      });
      expect(enriched['modalities'], {
        'Cardinal': 50.0,
        'Fixed': 25.0,
        'Mutable': 25.0,
      });
      expect(enriched['aspects'], isNull);
    });

    test('calculates cross-chart aspects only from exact positions', () {
      final first = AstrologyDataEnricher.normalizePlanets([
        {'name': 'Sun', 'rashi': 'Aries', 'degree': 5},
      ]);
      final second = AstrologyDataEnricher.normalizePlanets([
        {'name': 'Moon', 'rashi': 'Libra', 'degree': 7},
      ]);
      final aspects = AstrologyDataEnricher.calculateAspects(first, second);

      expect(aspects, hasLength(1));
      expect(aspects.single['aspectName'], 'Opposition');
      expect(aspects.single['orb'], 2.0);
    });
  });

  group('NumerologyCalculator', () {
    test('calculates all four core numbers from saved profile fields', () {
      final result = NumerologyCalculator.calculate(
        name: 'John Doe',
        dob: '1990-01-15',
      );

      expect(result.lifePath, 8);
      expect(result.destiny, 7);
      expect(result.soulUrge, 1);
      expect(result.birthday, 6);
    });

    test('does not manufacture numbers for missing inputs', () {
      final result = NumerologyCalculator.calculate(name: '', dob: '');

      expect(result.lifePath, isNull);
      expect(result.destiny, isNull);
      expect(result.soulUrge, isNull);
      expect(result.birthday, isNull);
    });
  });
}
