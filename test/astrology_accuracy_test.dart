import 'package:flutter_test/flutter_test.dart';
import 'package:astrosaathi/core/utils/zodiac_sign_utils.dart';
import 'package:astrosaathi/core/engine/models/astrology_validation.dart';

void main() {
  group('🪐 Flutter Astrology Accuracy Engine Test Suite', () {
    test('1. Rashi & Nakshatra mapping determinism', () {
      final aries = ZodiacSignUtils.getZodiacFromName('Aarav');
      expect(aries, isNotNull);
      expect(aries!.englishName, equals('Aries'));
      expect(aries.hindiName, equals('मेष'));
      expect(aries.gujaratiName, equals('મેષ'));

      final scorpio = ZodiacSignUtils.getZodiacFromName('Nitin');
      expect(scorpio, isNotNull);
      expect(scorpio!.englishName, equals('Scorpio'));

      final pisces = ZodiacSignUtils.getZodiacFromName('Deepak');
      expect(pisces, isNotNull);
      expect(pisces!.englishName, equals('Pisces'));
    });

    test('2. Multi-language name formatting & capitalization', () {
      expect(ZodiacSignUtils.capitalizeName('shiva kumar'), equals('Shiva Kumar'));
      expect(ZodiacSignUtils.capitalizeName('ASTRO BABA'), equals('Astro Baba'));
      expect(ZodiacSignUtils.capitalizeName(''), equals(''));
    });

    test('3. Date parsing & validation boundary tests', () {
      expect(AstrologyValidator.parseDate('1996-09-15'), equals(DateTime(1996, 9, 15)));
      expect(AstrologyValidator.parseDate('15/09/1996'), equals(DateTime(1996, 9, 15)));

      expect(() => AstrologyValidator.validateDate('1750-01-01'), throwsA(isA<AstrologyValidationException>()));
      expect(() => AstrologyValidator.validateDate('2099-12-31'), returnsNormally);
    });

    test('4. Time parsing & coordinate boundary tests', () {
      expect(() => AstrologyValidator.validateTime('07:30 AM'), returnsNormally);
      expect(() => AstrologyValidator.validateTime('14:30'), returnsNormally);
      expect(() => AstrologyValidator.validateTime('25:99'), throwsA(isA<AstrologyValidationException>()));

      expect(() => AstrologyValidator.validateCoordinates(28.6139, 77.2090, 5.5), returnsNormally);
      expect(() => AstrologyValidator.validateCoordinates(-33.8688, 151.2093, 10.0), returnsNormally); // Southern Hemisphere
      expect(() => AstrologyValidator.validateCoordinates(95.0, 77.0, 5.5), throwsA(isA<AstrologyValidationException>()));
    });

    test('5. Birth chart output integrity validation', () {
      final validChart = {
        'lagna': 'Aries',
        'planets': [
          {'name': 'Sun', 'house': 10},
          {'name': 'Moon', 'house': 1},
        ],
      };
      expect(() => AstrologyValidator.validateBirthChartOutput(validChart), returnsNormally);

      final emptyChart = <String, dynamic>{};
      expect(() => AstrologyValidator.validateBirthChartOutput(emptyChart), throwsA(isA<AstrologyValidationException>()));

      final duplicatePlanetChart = {
        'lagna': 'Taurus',
        'planets': [
          {'name': 'Sun', 'house': 1},
          {'name': 'Sun', 'house': 2},
        ],
      };
      expect(() => AstrologyValidator.validateBirthChartOutput(duplicatePlanetChart), throwsA(isA<AstrologyValidationException>()));
    });
  });
}

