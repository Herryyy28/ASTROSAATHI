import 'package:flutter_test/flutter_test.dart';
import 'package:astrosaathi/core/models/birth_details.dart';
import 'package:astrosaathi/core/models/astrology_models.dart';
import 'package:astrosaathi/core/models/matchmaking_models.dart';
import 'package:astrosaathi/core/errors/app_exceptions.dart';
import 'package:astrosaathi/core/repositories/mocks/mock_auth_repository.dart';
import 'package:astrosaathi/core/repositories/mocks/mock_astrology_repository.dart';
import 'package:astrosaathi/core/repositories/mocks/mock_panchang_repository.dart';
import 'package:astrosaathi/core/repositories/mocks/mock_matchmaking_repository.dart';
import 'package:astrosaathi/core/repositories/mocks/mock_subscription_repository.dart';

void main() {
  group('📐 AstroSaathi Foundation & Architecture Test Suite', () {
    test('1. BirthDetails validation guarantees valid seeker coordinates & DOB', () {
      const valid = BirthDetails(
        name: 'Arjun Verma',
        dob: '1992-11-20',
        birthTime: '14:30',
        birthPlace: 'Varanasi, Uttar Pradesh',
        latitude: 25.3176,
        longitude: 82.9739,
      );

      expect(valid.isValid, isTrue);
      expect(() => valid.validate(), returnsNormally);

      const invalidDate = BirthDetails(
        name: 'Arjun Verma',
        dob: '1992/11/20', // Invalid format
        birthTime: '14:30',
        birthPlace: 'Varanasi',
        latitude: 25.3176,
        longitude: 82.9739,
      );

      expect(invalidDate.isValid, isFalse);
      expect(() => invalidDate.validate(), throwsA(isA<ValidationException>()));

      const invalidCoords = BirthDetails(
        name: 'Arjun Verma',
        dob: '1992-11-20',
        birthTime: '14:30',
        birthPlace: 'Varanasi',
        latitude: 195.0, // Invalid latitude (> 90)
        longitude: 82.9739,
      );

      expect(invalidCoords.isValid, isFalse);
      expect(() => invalidCoords.validate(), throwsA(isA<ValidationException>()));
    });

    test('2. KundliData correctly formats planet house map for VedicChartPainter', () {
      final planets = [
        const PlanetPosition(name: 'Sun', sign: 'Leo', signIndex: 5, degree: 10.0, house: 1),
        const PlanetPosition(name: 'Jupiter', sign: 'Leo', signIndex: 5, degree: 12.0, house: 1),
        const PlanetPosition(name: 'Moon', sign: 'Taurus', signIndex: 2, degree: 20.0, house: 10),
      ];

      final houses = List.generate(
        12,
        (i) => HouseData(
          houseNumber: i + 1,
          sign: 'Sign_${i + 1}',
          signIndex: i + 1,
          lord: 'Lord_${i + 1}',
          planets: const [],
        ),
      );

      final kundli = KundliData(
        birthDetails: BirthDetails.defaultDelhi,
        ascendantSign: 'Leo',
        ascendantSignIndex: 5,
        ascendantDegree: 10.0,
        planets: planets,
        houses: houses,
        generatedAt: DateTime.now(),
      );

      final houseMap = kundli.toHousePlanetsMap();
      expect(houseMap.length, 12);
      expect(houseMap[1], contains('Su'));
      expect(houseMap[1], contains('Ju'));
      expect(houseMap[10], contains('Mo'));
      expect(houseMap[2], isEmpty);
    });

    test('3. MockAstrologyRepository returns deterministic KundliData', () async {
      final repo = MockAstrologyRepository();
      final result = await repo.generateKundli(BirthDetails.defaultDelhi);

      expect(result.isSuccess, isTrue);
      final kundli = result.dataOrNull!;
      expect(kundli.ascendantSign, equals('Leo'));
      expect(kundli.planets.length, equals(9));
      expect(kundli.houses.length, equals(12));
      expect(kundli.dashas.isNotEmpty, isTrue);
    });

    test('4. MockPanchangRepository provides full daily Tithi, Nakshatra, and Muhurat data', () async {
      final repo = MockPanchangRepository();
      final result = await repo.getDailyPanchang(
        date: DateTime(2026, 10, 2),
        latitude: 28.6139,
        longitude: 77.2090,
      );

      expect(result.isSuccess, isTrue);
      final panchang = result.dataOrNull!;
      expect(panchang.tithi.name, isNotEmpty);
      expect(panchang.nakshatra.name, isNotEmpty);
      expect(panchang.yoga.name, isNotEmpty);
      expect(panchang.karana.name, isNotEmpty);
      expect(panchang.rahuKaal, isNotNull);
      expect(panchang.abhijitMuhurat, isNotNull);
    });

    test('5. MockMatchmakingRepository calculates 36-point Ashtakoota compatibility', () async {
      final repo = MockMatchmakingRepository();
      const boy = MatchProfile(
        id: 'boy_01',
        name: 'Rohan',
        gender: 'male',
        birthDetails: BirthDetails.defaultDelhi,
      );
      const girl = MatchProfile(
        id: 'girl_01',
        name: 'Aanya',
        gender: 'female',
        birthDetails: BirthDetails(
          name: 'Aanya',
          dob: '1996-03-24',
          birthTime: '09:15',
          birthPlace: 'Jaipur, Rajasthan',
          latitude: 26.9124,
          longitude: 75.7873,
        ),
      );

      final result = await repo.calculateCompatibility(first: boy, second: girl);
      expect(result.isSuccess, isTrue);
      final match = result.dataOrNull!;
      expect(match.gunas.length, equals(8));
      expect(match.maxScore, equals(36.0));
      expect(match.totalScore, greaterThanOrEqualTo(18.0));
      expect(match.isCompatible, isTrue);
    });

    test('6. MockAuthRepository & MockSubscriptionRepository flow verification', () async {
      final authRepo = MockAuthRepository();
      final userResult = await authRepo.signInWithEmail('seeker@astrosaathi.app', 'password123');
      expect(userResult.isSuccess, isTrue);
      expect(userResult.dataOrNull!.email, equals('seeker@astrosaathi.app'));

      final subRepo = MockSubscriptionRepository();
      final plansResult = await subRepo.getPlans();
      expect(plansResult.isSuccess, isTrue);
      expect(plansResult.dataOrNull!.length, greaterThanOrEqualTo(3));

      final upgradeResult = await subRepo.purchasePlan('plan_gold');
      expect(upgradeResult.isSuccess, isTrue);
      expect(upgradeResult.dataOrNull!.isPremium, isTrue);
    });
  });
}
