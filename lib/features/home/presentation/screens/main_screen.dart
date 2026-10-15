import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../calendar/presentation/screens/astro_calendar_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../reports/presentation/screens/predictions_reports_screen.dart';
import 'home_screen.dart';

final mainNavIndexProvider = StateProvider<int>((ref) => 0);

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const _screens = <Widget>[
    HomeScreen(),
    AstroCalendarScreen(),
    AstroBabaScreen(),
    PredictionsReportsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rawIndex = ref.watch(mainNavIndexProvider);
    final index = rawIndex.clamp(0, _screens.length - 1);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: IndexedStack(index: index, children: _screens),
      bottomNavigationBar: AstroBottomNav(
        currentIndex: index,
        onTap: (value) => ref.read(mainNavIndexProvider.notifier).state = value,
      ),
    );
  }
}
