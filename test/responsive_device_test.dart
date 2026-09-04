import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:AstroSaathi/core/theme/utils/responsive.dart';
import 'package:AstroSaathi/core/widgets/responsive_layout.dart';

void main() {
  group('📐 Responsive Device Viewport & Layout Test Suite', () {
    testWidgets('1. Small Mobile (320px x 568px) viewport classification', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(320, 568);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Scaffold(
                body: SafeText(
                  'Small Mobile Layout Testing Text That Might Wrap Or Ellipsis',
                  style: AppTextStyles.of(context).body,
                ),
              );
            },
          ),
        ),
      );

      expect(capturedContext.isMobile, isTrue);
      expect(capturedContext.isSmallMobile, isTrue);
      expect(capturedContext.isTablet, isFalse);
      expect(capturedContext.isDesktop, isFalse);
      expect(find.byType(SafeText), findsOneWidget);
    });

    testWidgets('2. Standard Tablet (768px x 1024px) viewport classification', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late BuildContext capturedContext;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return Scaffold(
                body: ResponsiveLayout(
                  child: Text(
                    'Tablet Viewport Content',
                    style: AppTextStyles.of(context).h1,
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(capturedContext.isMobile, isFalse);
      expect(capturedContext.isTablet, isTrue);
      expect(capturedContext.gridColumns, equals(2));
      expect(find.byType(ResponsiveLayout), findsOneWidget);
    });

    testWidgets(
      '3. Desktop / Web (1280px x 800px) max content width constraint',
      (tester) async {
        tester.view.physicalSize = const Size(1280, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return Scaffold(
                  body: ResponsiveLayout(
                    child: Text(
                      'Desktop Constrained Content',
                      style: AppTextStyles.of(context).display,
                    ),
                  ),
                );
              },
            ),
          ),
        );

        expect(capturedContext.isDesktop, isTrue);
        expect(capturedContext.maxContentWidth, equals(960.0));
        expect(capturedContext.gridColumns, equals(3));
      },
    );

    testWidgets(
      '4. SafeText & FlexText overflow safety without RenderFlex errors',
      (tester) async {
        tester.view.physicalSize = const Size(320, 400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  const Icon(Icons.star),
                  FlexText(
                    'Extremely Long Celestial Transit Milestone Description Text Designed To Overflow Unconstrained Containers',
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
        expect(find.byType(FlexText), findsOneWidget);
      },
    );
  });
}
