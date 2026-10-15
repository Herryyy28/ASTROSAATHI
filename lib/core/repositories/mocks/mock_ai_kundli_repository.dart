import '../../models/ai_models.dart';
import '../../models/birth_details.dart';
import '../../network/api_result.dart';
import '../ai_kundli_repository.dart';

class MockAiKundliRepository implements IAiKundliRepository {
  final List<AiAstrologerPersona> _personas = const [
    AiAstrologerPersona(
      id: 'baba',
      name: 'Astro Baba',
      title: 'Vedic Kundli Oracle',
      description: 'Ancient Himalayan wisdom blended with precise mathematical Jyotish algorithms.',
      avatarAsset: 'assets/images/astro_baba.png',
      specialty: 'Kundli & Life Path',
    ),
    AiAstrologerPersona(
      id: 'divina',
      name: 'Guru Maa Divina',
      title: 'Relationship & Karma Guide',
      description: 'Specializes in relationship healing, past-life karma, and soul contracts.',
      avatarAsset: 'assets/images/guru_maa.png',
      specialty: 'Love & Karma',
    ),
    AiAstrologerPersona(
      id: 'kuber',
      name: 'Acharya Kuber',
      title: 'Wealth & Career Strategist',
      description: 'Astrological financial timing and career advancement based on the 10th and 11th houses.',
      avatarAsset: 'assets/images/acharya_kuber.png',
      specialty: 'Finance & Career',
    ),
  ];

  @override
  Future<ApiResult<List<AiAstrologerPersona>>> getPersonas() async {
    return Success(_personas);
  }

  @override
  Future<ApiResult<AiMessage>> askAstrologer({
    required String personaId,
    required String question,
    required BirthDetails birthDetails,
    String languageCode = 'en',
  }) async {
    birthDetails.validate();

    final responseText =
        'Based on your birth chart (${birthDetails.name}, DOB: ${birthDetails.dob}), '
        'the planetary transits indicate that $question is directly influenced by your active Dasha period. '
        'Favorable Jupiterian aspects suggest positive movement if you proceed with patience and chant the Gayatri Mantra daily.';

    final message = AiMessage(
      id: 'ai_msg_${DateTime.now().millisecondsSinceEpoch}',
      text: responseText,
      isUser: false,
      timestamp: DateTime.now(),
      suggestions: const [
        'When will my career transition happen?',
        'Which gemstone is recommended for me?',
        'How is my upcoming Sade Sati phase?',
      ],
    );

    return Success(message);
  }
}
