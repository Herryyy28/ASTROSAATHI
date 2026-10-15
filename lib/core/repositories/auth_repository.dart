import '../models/auth_models.dart';
import '../network/api_result.dart';

abstract class IAuthRepository {
  /// Stream or current session user
  Future<AuthUser?> getCurrentUser();

  /// Sign in anonymously for instant guest preview
  Future<ApiResult<AuthUser>> signInAnonymously();

  /// Authenticate with email & password
  Future<ApiResult<AuthUser>> signInWithEmail(String email, String password);

  /// Register new user account
  Future<ApiResult<AuthUser>> signUpWithEmail(String name, String email, String password);

  /// Authenticate with Google
  Future<ApiResult<AuthUser>> signInWithGoogle();

  /// Terminate session and clear tokens
  Future<void> signOut();

  /// Check whether an active session token exists
  Future<bool> isAuthenticated();
}
