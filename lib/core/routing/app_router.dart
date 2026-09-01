import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../providers/profile_provider.dart';

/// Provider that checks if the user has completed onboarding.
final onboardingCompleteProvider = Provider<bool>((ref) {
  final profiles = ref.watch(profilesListProvider);
  return profiles.any((p) => p.isPrimary && p.name.isNotEmpty);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<bool>(
      onboardingCompleteProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final isDone = _ref.read(onboardingCompleteProvider);

    final isSplashLocation = state.matchedLocation == '/splash';
    if (isSplashLocation) return null; // Allow splash screen to show initially

    final isOnboardingLocation = state.matchedLocation == '/onboarding';
    if (!isDone && !isOnboardingLocation) {
      return '/onboarding';
    }
    return null;
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: notifier.redirect,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),
    ],
  );
});

