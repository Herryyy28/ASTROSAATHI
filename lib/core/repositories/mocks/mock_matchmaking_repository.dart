import '../../models/matchmaking_models.dart';
import '../../network/api_result.dart';
import '../../utils/vedic_astronomy_utils.dart';
import '../matchmaking_repository.dart';

class MockMatchmakingRepository implements IMatchmakingRepository {
  @override
  Future<ApiResult<CompatibilityResult>> calculateCompatibility({
    required MatchProfile first,
    required MatchProfile second,
    String languageCode = 'en',
  }) async {
    first.birthDetails.validate();
    second.birthDetails.validate();

    final result = VedicAstronomyUtils.calculateCompatibility(
      first: first,
      second: second,
    );

    return Success(result);
  }

  @override
  Future<ApiResult<String>> checkManglikDosha({
    required MatchProfile first,
    required MatchProfile second,
  }) async {
    final result = VedicAstronomyUtils.calculateCompatibility(
      first: first,
      second: second,
    );
    return Success(result.manglikStatus);
  }
}
