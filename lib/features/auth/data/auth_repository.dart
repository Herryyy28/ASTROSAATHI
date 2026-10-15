import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final userSessionProvider =
    StateNotifierProvider<UserSessionNotifier, UserSessionState>(
      (ref) => UserSessionNotifier(ref.watch(authRepositoryProvider)),
    );

class UserSessionState {
  const UserSessionState({
    this.isAuthenticated = false,
    this.userId,
    this.email,
    this.name,
    this.token,
    this.photoUrl,
  });

  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? name;
  final String? token;
  final String? photoUrl;
}

class UserSessionNotifier extends StateNotifier<UserSessionState> {
  UserSessionNotifier(this._repository) : super(const UserSessionState()) {
    _loadSession();
  }

  final AuthRepository _repository;

  Future<void> _loadSession() async {
    final session = await _repository.readSession();
    if (session != null) state = session;
  }

  Future<bool> login(String email, String password) async {
    final result = await _repository.signInWithEmail(email, password);
    return _accept(result);
  }

  Future<bool> register(String name, String email, String password) async {
    await _repository.signUpWithEmail(name, email, password);
    final result = await _repository.signInWithEmail(
      email,
      password,
      displayName: name,
    );
    return _accept(result);
  }

  Future<bool> loginWithGoogle({
    String? customEmail,
    String? customName,
  }) async {
    final result = await _repository.signInWithGoogle(
      customEmail: customEmail,
      customName: customName,
    );
    return _accept(result);
  }

  Future<bool> _accept(Map<String, dynamic> result) async {
    if (result['success'] != true) return false;
    final session = UserSessionState(
      isAuthenticated: true,
      token: result['token'] as String?,
      email: result['email'] as String?,
      name: result['name'] as String?,
      userId: result['userId'] as String?,
      photoUrl: result['photoUrl'] as String?,
    );
    await _repository.persistLocalSession(session);
    state = session;
    return true;
  }

  Future<void> logout() async {
    await _repository.clearLocalSession();
    state = const UserSessionState();
  }
}

/// Local-only demo authentication and onboarding persistence.
class AuthRepository {
  static const _sessionKey = 'demo_auth_session_v1';

  Future<Map<String, dynamic>> signInWithGoogle({
    String? customEmail,
    String? customName,
  }) async {
    final email = customEmail ?? 'demo@astrosaathi.local';
    return _demoResult(
      email: email,
      name: customName ?? 'AstroSaathi Demo',
      provider: 'google-preview',
    );
  }

  Future<Map<String, dynamic>> signInWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    return _demoResult(
      email: email.trim().isEmpty ? 'demo@astrosaathi.local' : email.trim(),
      name: displayName ?? _displayNameFromEmail(email),
      provider: 'email-preview',
    );
  }

  Future<Map<String, dynamic>> signUpWithEmail(
    String name,
    String email,
    String password,
  ) async => const {'success': true, 'message': 'Demo account ready'};

  Map<String, dynamic> _demoResult({
    required String email,
    required String name,
    required String provider,
  }) => {
    'success': true,
    'token': 'frontend_demo_session',
    'userId': 'demo_${email.hashCode.abs()}',
    'email': email,
    'name': name,
    'provider': provider,
  };

  String _displayNameFromEmail(String email) {
    final local = email.split('@').first.trim();
    if (local.isEmpty) return 'AstroSaathi Demo';
    return local
        .split(RegExp(r'[._-]+'))
        .where((part) => part.isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
        .join(' ');
  }

  Future<void> signInAnonymously() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('demo_guest_session', true);
  }

  Future<void> persistLocalSession(UserSessionState session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _sessionKey,
      jsonEncode({
        'userId': session.userId,
        'email': session.email,
        'name': session.name,
        'token': session.token,
        'photoUrl': session.photoUrl,
      }),
    );
  }

  Future<UserSessionState?> readSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return UserSessionState(
        isAuthenticated: true,
        userId: json['userId'] as String?,
        email: json['email'] as String?,
        name: json['name'] as String?,
        token: json['token'] as String?,
        photoUrl: json['photoUrl'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearLocalSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove('demo_guest_session');
  }

  Future<void> saveProfileData({
    required String name,
    required String dob,
    required String time,
    required String place,
    required double latitude,
    required double longitude,
    required String timeZone,
    required Map<String, double> focusWeights,
    String? gender,
    String? astrologyPreference,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_dob', dob);
    await prefs.setString('user_time', time);
    await prefs.setString('user_place', place);
    await prefs.setDouble('user_lat', latitude);
    await prefs.setDouble('user_lon', longitude);
    await prefs.setString('user_tz', timeZone);
    await prefs.setStringList('user_focus_areas', focusWeights.keys.toList());
    if (gender != null) await prefs.setString('user_gender', gender);
    if (astrologyPreference != null) {
      await prefs.setString('user_astrology_preference', astrologyPreference);
    }
  }

  Future<String?> getAuthToken() async => (await readSession())?.token;
}
