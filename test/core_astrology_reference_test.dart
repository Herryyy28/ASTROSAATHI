import 'package:astrosaathi/core/providers/astrology_provider.dart';
import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/astrology/presentation/screens/chart_patterns_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const widths = <double>[360, 390, 412, 430];

  for (final width in widths) {
    testWidgets(
      'provider-backed chart patterns and themes render at ${width.toInt()}px',
      (tester) async {
        tester.view.physicalSize = Size(width, 844);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              birthChartProvider.overrideWith((ref) async => _chartFixture),
            ],
            child: MaterialApp(
              theme: AppTheme.lightTheme,
              home: const ChartPatternsScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle(const Duration(milliseconds: 100));

        expect(find.text('Provider T-Square'), findsOneWidget);
        expect(find.text('Themes & elements'), findsOneWidget);
        expect(find.text('Fire'), findsOneWidget);
        expect(find.text('Cardinal'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle(const Duration(milliseconds: 100));
      },
    );
  }
}

final Map<String, dynamic> _chartFixture = {
  'lagna': {'rashi': 'Aries', 'ruler': 'Mars'},
  'rashi': {'name': 'Libra', 'rulingPlanet': 'Venus'},
  'nakshatra': 'Vishakha',
  'pada': 3,
  'planets': [
    {'name': 'Sun', 'code': 'Su', 'house': 7, 'rashi': 'Libra'},
    {'name': 'Mars', 'code': 'Ma', 'house': 1, 'rashi': 'Aries'},
    {'name': 'Jupiter', 'code': 'Ju', 'house': 10, 'rashi': 'Capricorn'},
  ],
  'patterns': [
    {
      'name': 'Provider T-Square',
      'modality': 'Cardinal',
      'planets': ['Sun', 'Mars', 'Jupiter'],
      'interpretation':
          'Test-only provider content used to verify the presentation layer.',
    },
  ],
  'elements': {'Fire': 30, 'Earth': 25, 'Air': 35, 'Water': 10},
  'modalities': {'Cardinal': 50, 'Fixed': 25, 'Mutable': 25},
};
