import '../../models/consultation_models.dart';
import '../../network/api_result.dart';
import '../consultation_repository.dart';

class MockConsultationRepository implements IConsultationRepository {
  final List<Astrologer> _astrologers = [
    const Astrologer(
      id: 'astro_001',
      name: 'Acharya Vidyadhar',
      title: 'Jyotish Shiromani & Vastu Expert',
      specialties: ['Vedic Astrology', 'Kundli Analysis', 'Career & Business'],
      rating: 4.9,
      reviewCount: 3420,
      experienceYears: 18,
      perMinuteRate: 35.0,
      isOnline: true,
      languages: ['Hindi', 'English', 'Sanskrit'],
      bio: 'Gold Medalist from Sampurnanand Sanskrit Vishwavidyalaya with over 18 years guiding individuals through complex planetary Dashas.',
    ),
    const Astrologer(
      id: 'astro_002',
      name: 'Pandit Raghavan Shastri',
      title: 'KP System & Nadi Astrologer',
      specialties: ['KP Astrology', 'Marriage Matching', 'Gemstone Remedies'],
      rating: 4.8,
      reviewCount: 2190,
      experienceYears: 14,
      perMinuteRate: 28.0,
      isOnline: true,
      languages: ['Hindi', 'Tamil', 'English'],
      bio: 'Specialist in sub-lord timing of events using Krishnamurti Paddhati and ancient South Indian Nadi texts.',
    ),
    const Astrologer(
      id: 'astro_003',
      name: 'Dr. Sunita Sharma',
      title: 'Numerology & Tarot Reader',
      specialties: ['Numerology', 'Tarot Divination', 'Relationship Healing'],
      rating: 4.9,
      reviewCount: 1850,
      experienceYears: 12,
      perMinuteRate: 30.0,
      isOnline: false,
      languages: ['Hindi', 'English'],
      bio: 'Combining Pythagorean & Chaldean numerology with intuitively channeled Tarot insights for practical life solutions.',
    ),
  ];

  @override
  Future<ApiResult<List<Astrologer>>> getAstrologers({String? specialty}) async {
    if (specialty == null || specialty.isEmpty) {
      return Success(_astrologers);
    }
    final filtered = _astrologers
        .where((a) => a.specialties.any((s) => s.toLowerCase().contains(specialty.toLowerCase())))
        .toList();
    return Success(filtered);
  }

  @override
  Future<ApiResult<Astrologer>> getAstrologerById(String id) async {
    final astro = _astrologers.firstWhere(
      (a) => a.id == id,
      orElse: () => _astrologers.first,
    );
    return Success(astro);
  }

  @override
  Future<ApiResult<ConsultationSession>> initiateSession({
    required String astrologerId,
    required String seekerId,
    required ConsultationType type,
  }) async {
    final astro = await getAstrologerById(astrologerId);
    final session = ConsultationSession(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      astrologerId: astrologerId,
      astrologerName: astro.dataOrNull?.name ?? 'Astrologer',
      seekerId: seekerId,
      type: type,
      status: ConsultationStatus.active,
      startTime: DateTime.now(),
      durationSeconds: 0,
      totalCost: 0.0,
    );
    return Success(session);
  }

  @override
  Future<ApiResult<ConsultationSession>> endSession(String sessionId) async {
    final session = ConsultationSession(
      id: sessionId,
      astrologerId: 'astro_001',
      astrologerName: 'Acharya Vidyadhar',
      seekerId: 'seeker_001',
      type: ConsultationType.chat,
      status: ConsultationStatus.completed,
      startTime: DateTime.now().subtract(const Duration(minutes: 15)),
      durationSeconds: 900,
      totalCost: 525.0,
    );
    return Success(session);
  }
}
