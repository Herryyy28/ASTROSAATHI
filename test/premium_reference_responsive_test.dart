import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/astrology/presentation/screens/numerology_screen.dart';
import 'package:astrosaathi/features/matching/presentation/screens/chart_comparison_screen.dart';
import 'package:astrosaathi/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const widths = <double>[360, 390, 412, 430];

  for (final width in widths) {
    testWidgets(
      'reference screens have no initial overflow at ${width.toInt()}px',
      (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);

        for (final screen in <Widget>[
          const NumerologyScreen(),
          const ChartComparisonScreen(),
          const OnboardingScreen(),
        ]) {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(theme: AppTheme.lightTheme, home: screen),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();
      },
    );
  }
}
