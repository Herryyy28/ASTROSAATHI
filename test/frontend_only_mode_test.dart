import 'package:astrosaathi/core/config/app_config.dart';
import 'package:astrosaathi/core/providers/astrology_provider.dart';
import 'package:astrosaathi/demo/demo_astrology_engine.dart';
import 'package:astrosaathi/demo/demo_payment_gateway.dart';
import 'package:astrosaathi/features/auth/data/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('frontend-only mode selects the local demo astrology engine', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(AppConfig.frontendOnly, isTrue);
    expect(container.read(astrologyEngineProvider), isA<DemoAstrologyEngine>());
  });

  test(
    'demo authentication persists and restores without remote auth',
    () async {
      final repository = AuthRepository();
      final result = await repository.signInWithGoogle();
      expect(result['success'], isTrue);
      expect(result['token'], 'frontend_demo_session');

      await repository.persistLocalSession(
        UserSessionState(
          isAuthenticated: true,
          userId: result['userId'] as String,
          email: result['email'] as String,
          name: result['name'] as String,
          token: result['token'] as String,
        ),
      );

      final restored = await repository.readSession();
      expect(restored?.isAuthenticated, isTrue);
      expect(restored?.email, 'demo@astrosaathi.local');
    },
  );

  test('AI and premium actions are explicitly marked as demo', () async {
    final engine = DemoAstrologyEngine();
    final response = await engine.askAstroBaba(
      'What should I focus on?',
      '2026-10-03',
      '23.0225,72.5714,5.5',
    );
    expect(response.answer, startsWith('Demo response'));

    final order = await RazorpayService.instance.createRazorpayOrder(
      const RazorpayPaymentRequest(
        amount: 199,
        planName: 'Annual PRO Pass',
        userId: 'demo',
        userEmail: 'demo@astrosaathi.local',
        paymentMethod: 'Demo preview',
      ),
    );
    expect(order['success'], isTrue);
    expect(order['demoOnly'], isTrue);
    expect(order['orderId'], startsWith('DEMO_ORDER_'));
  });
}
