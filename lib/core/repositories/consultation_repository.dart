import '../models/consultation_models.dart';
import '../network/api_result.dart';

abstract class IConsultationRepository {
  /// Fetch list of verified human astrologers
  Future<ApiResult<List<Astrologer>>> getAstrologers({String? specialty});

  /// Get details for a specific astrologer
  Future<ApiResult<Astrologer>> getAstrologerById(String id);

  /// Initiate consultation session (chat or audio call)
  Future<ApiResult<ConsultationSession>> initiateSession({
    required String astrologerId,
    required String seekerId,
    required ConsultationType type,
  });

  /// End and finalize active consultation session
  Future<ApiResult<ConsultationSession>> endSession(String sessionId);
}
