import '../../models/auth_models.dart';
import '../../network/api_result.dart';
import '../auth_repository.dart';

class MockAuthRepository implements IAuthRepository {
  AuthUser? _currentUser = const AuthUser(
    id: 'mock_seeker_001',
    email: 'seeker@astrosaathi.app',
    displayName: 'Dev Seeker',
    isAnonymous: false,
    token: 'mock_jwt_token_sample',
  );

  @override
  Future<AuthUser?> getCurrentUser() async {
    return _currentUser;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _currentUser != null;
  }

  @override
  Future<ApiResult<AuthUser>> signInAnonymously() async {
    final guest = AuthUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      email: '',
      displayName: 'Guest Seeker',
      isAnonymous: true,
      token: 'guest_token_${DateTime.now().millisecondsSinceEpoch}',
    );
    _currentUser = guest;
    return Success(guest);
  }

  @override
  Future<ApiResult<AuthUser>> signInWithEmail(String email, String password) async {
    final user = AuthUser(
      id: 'mock_${email.hashCode.abs()}',
      email: email,
      displayName: email.split('@').first,
      token: 'jwt_mock_${DateTime.now().millisecondsSinceEpoch}',
    );
    _currentUser = user;
    return Success(user);
  }

  @override
  Future<ApiResult<AuthUser>> signUpWithEmail(String name, String email, String password) async {
    final user = AuthUser(
      id: 'mock_${email.hashCode.abs()}',
      email: email,
      displayName: name,
      token: 'jwt_mock_${DateTime.now().millisecondsSinceEpoch}',
    );
    _currentUser = user;
    return Success(user);
  }

  @override
  Future<ApiResult<AuthUser>> signInWithGoogle() async {
    final user = AuthUser(
      id: 'google_mock_user_123',
      email: 'cosmic.seeker@gmail.com',
      displayName: 'Cosmic Seeker',
      token: 'google_mock_token_123',
    );
    _currentUser = user;
    return Success(user);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
