import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../firebase_options.dart';

/// Centralized service for Firebase lifecycle, initialization, and auth instance access.
class FirebaseService {
  FirebaseService._privateConstructor();
  static final FirebaseService instance = FirebaseService._privateConstructor();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  /// Initializes Firebase once for the entire application.
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _isInitialized = true;
      debugPrint('Firebase successfully initialized with DefaultFirebaseOptions.');
    } catch (e) {
      _isInitialized = false;
      debugPrint('Firebase initialization warning/error: $e');
    }
  }

  /// Returns the singleton [FirebaseAuth] instance if Firebase is initialized.
  FirebaseAuth? get auth {
    if (_isInitialized || Firebase.apps.isNotEmpty) {
      try {
        return FirebaseAuth.instance;
      } catch (e) {
        debugPrint('Error accessing FirebaseAuth instance: $e');
      }
    }
    return null;
  }

  /// Stream of authentication state changes.
  Stream<User?> get authStateChanges {
    final instance = auth;
    if (instance != null) {
      return instance.authStateChanges();
    }
    return const Stream.empty();
  }
}
