import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/support/presentation/screens/trust_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpTrustCenter(
    WidgetTester tester, {
    double width = 390,
    double textScale = 1,
  }) async {
    tester.view.physicalSize = Size(width, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          home: MediaQuery(
            data: MediaQueryData(
              size: Size(width, 844),
              textScaler: TextScaler.linear(textScale),
            ),
            child: const TrustCenterScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openTab(WidgetTester tester, String label) async {
    final dragDistance = switch (label) {
      'Privacy & Safety' => -180.0,
      'Account Deletion' => -520.0,
      'Help & Support' => -1000.0,
      _ => 1000.0,
    };
    if (dragDistance != 0) {
      await tester.drag(find.byType(ListView).first, Offset(dragDistance, 0));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets('all four tabs render truthful visible content', (tester) async {
    await pumpTrustCenter(tester);

    expect(find.text('How It Works'), findsOneWidget);
    expect(find.text('Privacy & Safety'), findsOneWidget);
    expect(find.text('Trusted Astrology Foundation'), findsOneWidget);
    expect(find.text('How your chart is calculated'), findsOneWidget);

    await openTab(tester, 'Privacy & Safety');
    expect(find.text('Your data stays close'), findsOneWidget);
    expect(find.text('Your profile data'), findsOneWidget);

    await openTab(tester, 'Account Deletion');
    expect(find.text('Clear local app data'), findsOneWidget);
    expect(find.text('What will be removed'), findsOneWidget);

    await openTab(tester, 'Help & Support');
    expect(find.text('Frequently Asked Questions'), findsOneWidget);
    expect(
      find.text('How does AstroSaathi personalize my experience?'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FAQ expands and collapses without hiding its question', (
    tester,
  ) async {
    await pumpTrustCenter(tester, width: 360);
    await openTab(tester, 'Help & Support');

    const question = 'How does AstroSaathi personalize my experience?';
    const answerFragment =
        'The demo uses the profile, birth details, selected focus areas';
    await tester.tap(find.text(question));
    await tester.pumpAndSettle();
    expect(find.textContaining(answerFragment), findsOneWidget);
    expect(find.text(question), findsOneWidget);

    await tester.tap(find.text(question));
    await tester.pumpAndSettle();
    expect(find.textContaining(answerFragment), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('issue labels are visible and selection reveals local form', (
    tester,
  ) async {
    await pumpTrustCenter(tester, width: 360);
    await openTab(tester, 'Help & Support');

    await tester.scrollUntilVisible(
      find.text('Rashi Calculation'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('Kundli'), findsOneWidget);
    expect(find.text('Calendar'), findsOneWidget);
    expect(find.text('Numerology'), findsOneWidget);
    expect(find.text('Synastry'), findsOneWidget);
    expect(find.text('UI / App Bug'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -420));
    await tester.pumpAndSettle();
    await tester.tap(find.text('UI / App Bug'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('issue-description-field')),
      findsOneWidget,
    );
    expect(find.text('Prepare Support Report'), findsOneWidget);
    expect(find.textContaining('local clipboard draft'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final width in <double>[360, 390, 412, 430]) {
    testWidgets('Trust Center has no overflow at ${width.toInt()}px', (
      tester,
    ) async {
      await pumpTrustCenter(tester, width: width);
      expect(tester.takeException(), isNull);

      await openTab(tester, 'Help & Support');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('long FAQ copy and scaled text remain overflow-free', (
    tester,
  ) async {
    await pumpTrustCenter(tester, width: 360, textScale: 1.45);
    await openTab(tester, 'Help & Support');
    await tester.tap(
      find.text('How does AstroSaathi personalize my experience?'),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
