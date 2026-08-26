import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

/// Provider that checks if the user has completed onboarding.
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final name = prefs.getString('user_name');
  return name != null && name.isNotEmpty;
});

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingDone = ref.watch(onboardingCompleteProvider);

  // Determine initial location based on onboarding status
  final initialLocation = onboardingDone.whenOrNull(
    data: (done) => done ? '/' : '/onboarding',
  ) ?? '/onboarding';

  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
});
