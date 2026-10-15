import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/home/presentation/widgets/daily_guidance_hero.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpHero(
    WidgetTester tester, {
    required double width,
    int? clarity = 78,
    String? insight = 'Make the most of your golden window today.',
    String? windowStart = '11:15 AM',
    String? windowEnd = '1:20 PM',
    double textScale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 844),
              textScaler: TextScaler.linear(textScale),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: DailyGuidanceHero(
                date: DateTime(2026, 10, 3),
                insight: insight,
                clarityPercent: clarity,
                bestWindowStart: windowStart,
                bestWindowEnd: windowEnd,
                focus: 'Communication',
                onGuidanceTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.clearAllTestValues();
  });

  for (final width in <double>[360, 390, 412, 430]) {
    testWidgets('renders without overflow at ${width.toInt()}px', (
      tester,
    ) async {
      await pumpHero(tester, width: width);

      expect(find.text('Your day\nin the stars'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
      expect(find.text('Best window'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final clarity in <int>[0, 9, 100]) {
    testWidgets('renders $clarity percent clarity accurately', (tester) async {
      await pumpHero(tester, width: 390, clarity: clarity);

      expect(find.text('$clarity%'), findsOneWidget);
      expect(
        find.bySemanticsLabel('Daily clarity, $clarity percent'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('long insight and increased text scale remain overflow-safe', (
    tester,
  ) async {
    await pumpHero(
      tester,
      width: 360,
      textScale: 1.45,
      insight:
          'This is an intentionally long provider-backed daily insight that '
          'continues across several lines so the premium hero can preserve its '
          'editorial hierarchy without clipping controls or overflowing.',
    );

    expect(find.textContaining('intentionally long'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing timing hides the best-window capsule', (tester) async {
    await pumpHero(tester, width: 390, windowStart: null, windowEnd: null);

    expect(find.text('Best window'), findsNothing);
    expect(find.text('Focus today'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('missing clarity shows an accessible unavailable state', (
    tester,
  ) async {
    await pumpHero(tester, width: 390, clarity: null);

    expect(find.text('Clarity\nunavailable'), findsOneWidget);
    expect(find.bySemanticsLabel('Daily clarity unavailable'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('structured skeleton renders without a generic spinner', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 844);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: DailyGuidanceHeroSkeleton(),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.bySemanticsLabel('Loading daily guidance'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
