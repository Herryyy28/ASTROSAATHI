import '../models/ai_models.dart';
import '../models/birth_details.dart';
import '../network/api_result.dart';

abstract class IAiKundliRepository {
  /// Fetch available AI Astrologer personas (Astro Baba, Tarot Diviner, etc.)
  Future<ApiResult<List<AiAstrologerPersona>>> getPersonas();

  /// Ask a question to an AI Astrologer with user birth context
  Future<ApiResult<AiMessage>> askAstrologer({
    required String personaId,
    required String question,
    required BirthDetails birthDetails,
    String languageCode = 'en',
  });
}
