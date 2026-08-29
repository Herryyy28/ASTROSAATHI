import 'dart:convert';
import 'package:flutter/foundation.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

class AuthRepository {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final String baseUrl = kIsWeb
      ? 'http://localhost:3000/api/v1'
      : 'http://10.0.2.2:3000/api/v1';

  /// Ensure the user is signed in anonymously and synced with the backend
  Future<void> signInAnonymously() async {
    try {
      // UserCredential userCredential = await _auth.signInAnonymously();
      // String? token = await userCredential.user?.getIdToken();
      String token = "dummy_token";
      await _syncUserWithBackend(token);
    } catch (e) {
      debugPrint('Error signing in anonymously: $e');
      rethrow;
    }
  }

  /// Syncs the Firebase Auth token to create/verify the user in Postgres
  Future<void> _syncUserWithBackend(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/sync'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to sync user with backend: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error in _syncUserWithBackend: $e');
    }
  }

  /// Save profile data (including birth details and focus weights)
  Future<void> saveProfileData({
    required String name,
    required String dob,
    required String time,
    required String place,
    required double latitude,
    required double longitude,
    required String timeZone,
    required Map<String, double> focusWeights,
  }) async {
    try {
      String token = "dummy_token";

      final response = await http.post(
        Uri.parse('$baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'dob': dob,
          'birthTime': time,
          'birthLatitude': latitude,
          'birthLongitude': longitude,
          'birthTimeZone': timeZone,
          'focusWeights': focusWeights,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to save profile: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error saving profile data: $e');
    }
  }

  /// Helper to get auth token for other API calls (like Astrology endpoints)
  Future<String?> getAuthToken() async {
    return "dummy_token";
  }
}
