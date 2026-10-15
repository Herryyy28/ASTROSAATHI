import '../models/matchmaking_models.dart';
import '../network/api_result.dart';

abstract class IMatchmakingRepository {
  /// Calculate Ashtakoota 36-guna compatibility between two profiles
  Future<ApiResult<CompatibilityResult>> calculateCompatibility({
    required MatchProfile first,
    required MatchProfile second,
    String languageCode = 'en',
  });

  /// Check detailed Manglik Dosha compatibility
  Future<ApiResult<String>> checkManglikDosha({
    required MatchProfile first,
    required MatchProfile second,
  });
}
