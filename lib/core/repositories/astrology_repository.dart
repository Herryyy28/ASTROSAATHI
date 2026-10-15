import '../models/birth_details.dart';
import '../models/astrology_models.dart';
import '../network/api_result.dart';

abstract class IAstrologyRepository {
  /// Generate a full Vedic Kundli (D1, D9, Planets, Houses, Dashas) from birth details
  Future<ApiResult<KundliData>> generateKundli(BirthDetails details, {String chartType = 'D1'});

  /// Fetch planetary positions for given birth details or current transit
  Future<ApiResult<List<PlanetPosition>>> getPlanetaryPositions(BirthDetails details);

  /// Fetch Vimshottari Dasha periods
  Future<ApiResult<List<DashaData>>> getDashaTimeline(BirthDetails details);

  /// Fetch daily or periodic horoscope prediction for a zodiac sign
  Future<ApiResult<String>> getHoroscope(String sign, {String timeframe = 'daily', String languageCode = 'en'});
}
