import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/presentation/screens/main_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';

/// Provider that checks if the user has completed onboarding.
final onboardingCompleteProvider = FutureProvider<bool>((ref) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    return name != null && name.isNotEmpty;
  } catch (_) {
    return false;
  }
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<bool>>(
      onboardingCompleteProvider,
      (previous, next) {
        notifyListeners();
      },
    );
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final onboardingAsync = _ref.read(onboardingCompleteProvider);

    return onboardingAsync.when(
      data: (isDone) {
        final isOnboardingLocation = state.matchedLocation == '/onboarding';
        if (!isDone && !isOnboardingLocation) {
          return '/onboarding';
        }
        if (isDone && isOnboardingLocation) {
          return '/';
        }
        return null;
      },
      loading: () => null,
      error: (_, __) => null,
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    refreshListenable: notifier,
    redirect: notifier.redirect,
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
