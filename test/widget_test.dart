import 'package:flutter_test/flutter_test.dart';
import 'package:astrosaathi/core/utils/zodiac_sign_utils.dart';
import 'package:astrosaathi/core/providers/profile_provider.dart';
import 'package:astrosaathi/features/astrology/services/pdf_report_generator.dart';
import 'package:astrosaathi/l10n/app_language.dart';

void main() {
  group('AstroSaathi Unit & Business Logic Tests', () {
    test('ZodiacSignUtils auto-detects Nam Rashi based on name initial', () {
      final aries = ZodiacSignUtils.getZodiacFromName('Aarav Sharma');
      expect(aries, isNotNull);
      expect(aries!.englishName, equals('Aries'));
      expect(aries.hindiName, equals('मेष'));

      final taurus = ZodiacSignUtils.getZodiacFromName('Bhavna Patel');
      expect(taurus, isNotNull);
      expect(taurus!.englishName, equals('Taurus'));

      final sagittarius = ZodiacSignUtils.getZodiacFromName('Bharat Kumar');
      expect(sagittarius, isNotNull);
      expect(sagittarius!.englishName, equals('Sagittarius'));

      final capitalized = ZodiacSignUtils.capitalizeName('john doe');
      expect(capitalized, equals('John Doe'));
    });

    test('ProfilesNotifier enforces max 5 family member profiles capacity', () async {
      final notifier = ProfilesNotifier();

      // Clear any loaded state for deterministic test
      for (var i = 1; i <= 5; i++) {
        final added = await notifier.addProfile(
          BirthProfileData(
            id: 'p-$i',
            name: 'Member $i',
            relationship: 'Family',
            dob: '1990-01-0$i',
            birthTime: '08:00 AM',
            birthPlace: 'Delhi',
            latitude: 28.6,
            longitude: 77.2,
            timezone: '5.5',
          ),
        );
        if (i <= 5) {
          expect(added, isTrue, reason: 'Profile $i should be added successfully');
        }
      }

      // 6th profile attempt must be rejected
      final overflowAdded = await notifier.addProfile(
        BirthProfileData(
          id: 'p-6',
          name: 'Member 6',
          relationship: 'Friend',
          dob: '1995-05-05',
          birthTime: '10:00 AM',
          birthPlace: 'Mumbai',
          latitude: 19.0,
          longitude: 72.8,
          timezone: '5.5',
        ),
      );
      expect(overflowAdded, isFalse, reason: '6th profile must be rejected under 5 capacity limit');
    });

    test('PdfReportGenerator creates multi-language Kundli reports', () {
      final reportEn = PdfReportGenerator.generateLocalizedReport(
        userName: 'Prajapati Herry',
        dob: '1998-05-15',
        birthTime: '07:30 AM',
        birthPlace: 'New Delhi, India',
        language: AppLanguage.english,
      );

      expect(reportEn.userName, equals('Prajapati Herry'));
      expect(reportEn.reportTitle, contains('Authentic Vedic Kundli'));
      expect(reportEn.keyInterpretations.length, greaterThanOrEqualTo(3));
      expect(reportEn.recommendedRemedies.length, greaterThanOrEqualTo(3));

      final reportHi = PdfReportGenerator.generateLocalizedReport(
        userName: 'प्रजापति',
        dob: '1998-05-15',
        birthTime: '07:30 AM',
        birthPlace: 'नई दिल्ली',
        language: AppLanguage.hindi,
      );

      expect(reportHi.reportTitle, contains('वैदिक जन्म कुंडली'));
    });
  });
}
