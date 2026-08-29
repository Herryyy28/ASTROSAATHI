import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

class AuthRepository {
  /// Local-only mode: no backend sync required.
  Future<void> signInAnonymously() async {}

  /// Local-only mode: profile is stored on-device via profile providers.
  Future<void> saveProfileData({
    required String name,
    required String dob,
    required String time,
    required String place,
    required double latitude,
    required double longitude,
    required String timeZone,
    required Map<String, double> focusWeights,
  }) async {}

  Future<String?> getAuthToken() async => null;
}
