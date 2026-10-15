import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/ai/presentation/screens/astro_baba_screen.dart';
import 'package:astrosaathi/features/astrology/presentation/screens/numerology_screen.dart';
import 'package:astrosaathi/features/astrology/presentation/screens/chart_patterns_screen.dart';
import 'package:astrosaathi/features/astrology/presentation/screens/transit_center_screen.dart';
import 'package:astrosaathi/features/calendar/presentation/screens/astro_calendar_screen.dart';
import 'package:astrosaathi/features/home/presentation/screens/home_screen.dart';
import 'package:astrosaathi/features/horoscope/presentation/screens/horoscope_screen.dart';
import 'package:astrosaathi/features/kundli/presentation/screens/kundli_screen.dart';
import 'package:astrosaathi/features/matching/presentation/screens/chart_comparison_screen.dart';
import 'package:astrosaathi/features/matching/presentation/screens/matching_screen.dart';
import 'package:astrosaathi/features/profile/presentation/screens/settings/saved_insights_screen.dart';
import 'package:astrosaathi/features/auth/presentation/screens/auth_screen.dart';
import 'package:astrosaathi/features/muhurat/presentation/screens/muhurat_screen.dart';
import 'package:astrosaathi/features/panchang/presentation/screens/panchang_screen.dart';
import 'package:astrosaathi/features/profile/presentation/screens/profile_screen.dart';
import 'package:astrosaathi/features/reports/presentation/screens/predictions_reports_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const widths = <double>[360, 390, 412, 430];
  final surfaces = <(String, Widget)>[
    ('Ask AstroSaathi', const AstroBabaScreen()),
    ('Home', const HomeScreen()),
    ('Calendar', const AstroCalendarScreen()),
    ('Kundli', const KundliScreen()),
    ('Panchang', const PanchangScreen()),
    ('Muhurat', const MuhuratScreen()),
    ('Transits', const TransitCenterScreen()),
    ('Current Chart', const CurrentChartScreen()),
    ('Chart Patterns', const ChartPatternsScreen()),
    ('Horoscope', const HoroscopeScreen()),
    ('Retrograde Calendar', const RetrogradeCalendarScreen()),
    ('Numerology', const NumerologyScreen()),
    ('Synastry', const ChartComparisonScreen()),
    ('Reports', const PredictionsReportsScreen()),
    ('Profile', const ProfileScreen()),
    ('Matching', const MatchingScreen()),
    ('Saved insights', const SavedInsightsScreen()),
    ('Login', const AuthScreen()),
  ];

  for (final width in widths) {
    testWidgets(
      'core runtime surfaces render without Material or overflow errors at ${width.toInt()}px',
      (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);

        for (final surface in surfaces) {
          await tester.pumpWidget(
            ProviderScope(
              child: MaterialApp(theme: AppTheme.lightTheme, home: surface.$2),
            ),
          );
          await tester.pump(const Duration(milliseconds: 700));
          expect(
            tester.takeException(),
            isNull,
            reason: '${surface.$1} failed at ${width.toInt()}px',
          );
        }

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 500));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Ask composer remains valid with a 360px keyboard inset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: const MediaQuery(
            data: MediaQueryData(
              size: Size(360, 844),
              viewInsets: EdgeInsets.only(bottom: 300),
            ),
            child: AstroBabaScreen(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('astrology reference tabs render without runtime exceptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);

    Future<void> pumpSurface(Widget surface) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(theme: AppTheme.lightTheme, home: surface),
        ),
      );
      await tester.pump(const Duration(milliseconds: 800));
      expect(tester.takeException(), isNull);
    }

    await pumpSurface(const ChartPatternsScreen());
    expect(find.text('Patterns'), findsWidgets);

    await pumpSurface(const AstroCalendarScreen());
    await tester.tap(find.text('Month'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Special Calendars'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Moon').first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Transits').first);
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    await pumpSurface(const HoroscopeScreen());
    await tester.tap(find.text('Weekly'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Monthly'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });
}
