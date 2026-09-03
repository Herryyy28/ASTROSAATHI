import 'package:flutter_test/flutter_test.dart';
import 'package:astrosaathi/core/utils/zodiac_sign_utils.dart';

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
  });
}
