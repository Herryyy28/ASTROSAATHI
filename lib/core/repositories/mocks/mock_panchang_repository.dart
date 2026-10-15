import '../../models/panchang_models.dart';
import '../../network/api_result.dart';
import '../../utils/vedic_astronomy_utils.dart';
import '../panchang_repository.dart';

class MockPanchangRepository implements IPanchangRepository {
  @override
  Future<ApiResult<PanchangData>> getDailyPanchang({
    required DateTime date,
    required double latitude,
    required double longitude,
    String timezone = '5.5',
    String languageCode = 'en',
  }) async {
    final formattedDate =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    final calc = VedicAstronomyUtils.calculatePanchang(
      date: date,
      latitude: latitude,
      longitude: longitude,
    );

    final rahu = calc['rahuKaal'] as Map<String, String>;
    final yama = calc['yamaganda'] as Map<String, String>;
    final guli = calc['gulika'] as Map<String, String>;
    final abhijit = calc['abhijit'] as Map<String, String>;

    final panchang = PanchangData(
      date: formattedDate,
      vara: calc['vara'] as String,
      tithi: Tithi(
        name: calc['tithi'] as String,
        number: calc['tithiNumber'] as int,
        paksha: calc['paksha'] as String,
        endTime: '04:15 PM',
      ),
      nakshatra: Nakshatra(
        name: calc['nakshatraName'] as String,
        number: 8,
        lord: calc['nakshatraLord'] as String,
        endTime: '06:40 PM',
      ),
      yoga: Yoga(name: calc['yoga'] as String, number: 21, endTime: '02:10 PM'),
      karana: Karana(name: calc['karana'] as String, number: 3, endTime: '04:15 PM'),
      sunriseSunset: SunriseSunset(
        sunrise: calc['sunrise'] as String,
        sunset: calc['sunset'] as String,
        moonrise: calc['moonrise'] as String,
        moonset: calc['moonset'] as String,
      ),
      rahuKaal: TimeRange(start: rahu['start']!, end: rahu['end']!),
      yamaghanta: TimeRange(start: yama['start']!, end: yama['end']!),
      gulika: TimeRange(start: guli['start']!, end: guli['end']!),
      abhijitMuhurat: TimeRange(start: abhijit['start']!, end: abhijit['end']!),
      rasiSun: 'Simha (Leo)',
      rasiMoon: 'Karka (Cancer)',
      specialYogas: const ['Amrit Siddhi Yoga', 'Sarvartha Siddhi Yoga'],
    );

    return Success(panchang);
  }

  @override
  Future<ApiResult<List<PanchangData>>> getMonthlyPanchang({
    required int year,
    required int month,
    required double latitude,
    required double longitude,
  }) async {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final list = <PanchangData>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final res = await getDailyPanchang(
        date: DateTime(year, month, day),
        latitude: latitude,
        longitude: longitude,
      );
      if (res is Success<PanchangData>) {
        list.add(res.data);
      }
    }

    return Success(list);
  }
}
