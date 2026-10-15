import '../core/engine/mock_astrology_engine.dart';
import '../core/engine/models/ai_data.dart';

/// The single local data source for the frontend-only showcase.
///
/// Values produced by this engine are sample/demo content. It performs no HTTP,
/// Firebase, authentication, payment, or remote astrology requests.
class DemoAstrologyEngine extends MockAstrologyEngine {
  @override
  Future<AstroBabaResponse> askAstroBaba(
    String question,
    String date,
    String location, {
    String languageCode = 'en',
  }) async {
    final response = await super.askAstroBaba(
      question,
      date,
      location,
      languageCode: languageCode,
    );
    return AstroBabaResponse(
      answer: 'Demo response\n\n${response.answer}',
      confidence: response.confidence,
      actions: response.actions,
      warnings: response.warnings,
    );
  }
}
