import 'package:astrosaathi/core/theme/app_theme.dart';
import 'package:astrosaathi/features/astrology/presentation/screens/saturn_return_screen.dart';
import 'package:astrosaathi/features/subscription/presentation/screens/payment_status_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const widths = <double>[360, 390, 412, 430];

  for (final width in widths) {
    testWidgets(
      'secondary detail shell has no overflow at ${width.toInt()}px',
      (tester) async {
        tester.view.physicalSize = Size(width, 780);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: const SaturnReturnScreen(),
          ),
        );
        await tester.pump();

        expect(find.text('Saturn return'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('payment result has no overflow at ${width.toInt()}px', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const PaymentSuccessScreen(
            amount: 199,
            planName: 'Annual PRO Pass',
            transactionId: 'pay_test_123456789',
            dateStr: '02 Oct 2026',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('You’re all set'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
