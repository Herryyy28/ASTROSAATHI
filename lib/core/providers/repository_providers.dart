import 'package:flutter_riverpod/flutter_riverpod.dart';

// Contracts
import '../repositories/auth_repository.dart';
import '../repositories/profile_repository.dart';
import '../repositories/astrology_repository.dart';
import '../repositories/panchang_repository.dart';
import '../repositories/matchmaking_repository.dart';
import '../repositories/consultation_repository.dart';
import '../repositories/ai_kundli_repository.dart';
import '../repositories/subscription_repository.dart';

// Mocks
import '../repositories/mocks/mock_auth_repository.dart';
import '../repositories/mocks/mock_profile_repository.dart';
import '../repositories/mocks/mock_astrology_repository.dart';
import '../repositories/mocks/mock_panchang_repository.dart';
import '../repositories/mocks/mock_matchmaking_repository.dart';
import '../repositories/mocks/mock_consultation_repository.dart';
import '../repositories/mocks/mock_ai_kundli_repository.dart';
import '../repositories/mocks/mock_subscription_repository.dart';

// Global flag to toggle between mock mode and real NestJS API mode
final useMockRepositoriesProvider = StateProvider<bool>((ref) => true);

final authRepoProvider = Provider<IAuthRepository>((ref) {
  return MockAuthRepository();
});

final profileRepoProvider = Provider<IProfileRepository>((ref) {
  return MockProfileRepository();
});

final astrologyRepoProvider = Provider<IAstrologyRepository>((ref) {
  return MockAstrologyRepository();
});

final panchangRepoProvider = Provider<IPanchangRepository>((ref) {
  return MockPanchangRepository();
});

final matchmakingRepoProvider = Provider<IMatchmakingRepository>((ref) {
  return MockMatchmakingRepository();
});

final consultationRepoProvider = Provider<IConsultationRepository>((ref) {
  return MockConsultationRepository();
});

final aiKundliRepoProvider = Provider<IAiKundliRepository>((ref) {
  return MockAiKundliRepository();
});

final subscriptionRepoProvider = Provider<ISubscriptionRepository>((ref) {
  return MockSubscriptionRepository();
});
