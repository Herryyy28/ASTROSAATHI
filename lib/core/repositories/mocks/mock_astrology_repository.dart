import '../../models/birth_details.dart';
import '../../models/astrology_models.dart';
import '../../network/api_result.dart';
import '../astrology_repository.dart';

class MockAstrologyRepository implements IAstrologyRepository {
  @override
  Future<ApiResult<KundliData>> generateKundli(BirthDetails details, {String chartType = 'D1'}) async {
    details.validate();

    // Deterministic planetary positions based on date
    final planets = [
      const PlanetPosition(name: 'Sun', sign: 'Leo', signIndex: 5, degree: 14.5, house: 1, dignity: 'Own Sign'),
      const PlanetPosition(name: 'Moon', sign: 'Taurus', signIndex: 2, degree: 22.1, house: 10, dignity: 'Exalted'),
      const PlanetPosition(name: 'Mars', sign: 'Capricorn', signIndex: 10, degree: 18.0, house: 6, dignity: 'Exalted'),
      const PlanetPosition(name: 'Mercury', sign: 'Virgo', signIndex: 6, degree: 11.4, house: 2, dignity: 'Exalted'),
      const PlanetPosition(name: 'Jupiter', sign: 'Sagittarius', signIndex: 9, degree: 05.2, house: 5, dignity: 'Own Sign'),
      const PlanetPosition(name: 'Venus', sign: 'Pisces', signIndex: 12, degree: 27.8, house: 8, dignity: 'Exalted'),
      const PlanetPosition(name: 'Saturn', sign: 'Aquarius', signIndex: 11, degree: 12.3, house: 7, dignity: 'Moolatrikona'),
      const PlanetPosition(name: 'Rahu', sign: 'Taurus', signIndex: 2, degree: 15.6, house: 10, dignity: 'Exalted'),
      const PlanetPosition(name: 'Ketu', sign: 'Scorpio', signIndex: 8, degree: 15.6, house: 4, dignity: 'Debilitated'),
    ];

    final houses = List.generate(12, (index) {
      final hNum = index + 1;
      final signIdx = ((5 + index - 1) % 12) + 1; // Leo Ascendant
      final signNames = [
        'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
        'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces'
      ];
      final signName = signNames[signIdx - 1];
      final planetsInHouse = planets.where((p) => p.house == hNum).map((p) => p.name).toList();

      return HouseData(
        houseNumber: hNum,
        sign: signName,
        signIndex: signIdx,
        degree: 15.0,
        lord: 'Lord_$signName',
        planets: planetsInHouse,
      );
    });

    final dashas = [
      const DashaData(planet: 'Jupiter', startDate: '2020-01-01', endDate: '2036-01-01', level: 1),
      const DashaData(planet: 'Saturn', startDate: '2036-01-01', endDate: '2055-01-01', level: 1),
      const DashaData(planet: 'Mercury', startDate: '2055-01-01', endDate: '2072-01-01', level: 1),
    ];

    final kundli = KundliData(
      birthDetails: details,
      ascendantSign: 'Leo',
      ascendantSignIndex: 5,
      ascendantDegree: 14.5,
      planets: planets,
      houses: houses,
      currentDasha: dashas.first,
      dashas: dashas,
      chartType: chartType,
      generatedAt: DateTime.now(),
    );

    return Success(kundli);
  }

  @override
  Future<ApiResult<List<PlanetPosition>>> getPlanetaryPositions(BirthDetails details) async {
    final kundliResult = await generateKundli(details);
    return switch (kundliResult) {
      Success(data: final k) => Success(k.planets),
      Failure(exception: final e) => Failure(e),
    };
  }

  @override
  Future<ApiResult<List<DashaData>>> getDashaTimeline(BirthDetails details) async {
    final kundliResult = await generateKundli(details);
    return switch (kundliResult) {
      Success(data: final k) => Success(k.dashas),
      Failure(exception: final e) => Failure(e),
    };
  }

  @override
  Future<ApiResult<String>> getHoroscope(String sign, {String timeframe = 'daily', String languageCode = 'en'}) async {
    return Success(
      'The cosmic alignment brings immense clarity and creative vigor to $sign today. Favorable planetary aspects support professional decisions and spiritual meditation.',
    );
  }
}
