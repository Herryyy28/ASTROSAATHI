import '../models/panchang_models.dart';
import '../network/api_result.dart';

abstract class IPanchangRepository {
  /// Fetch complete daily Panchang for a specific date and coordinates
  Future<ApiResult<PanchangData>> getDailyPanchang({
    required DateTime date,
    required double latitude,
    required double longitude,
    String timezone = '5.5',
    String languageCode = 'en',
  });

  /// Fetch monthly Hindu calendar festival dates and tithi summary
  Future<ApiResult<List<PanchangData>>> getMonthlyPanchang({
    required int year,
    required int month,
    required double latitude,
    required double longitude,
  });
}
