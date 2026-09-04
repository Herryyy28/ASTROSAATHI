import 'package:flutter_test/flutter_test.dart';
import 'package:AstroSaathi/core/providers/subscription_provider.dart';

void main() {
  group('💳 Subscription & Real-Time Payment Flow Verification', () {
    test('1. Default free state capabilities & limits', () {
      final state = const SubscriptionState(
        isPremium: false,
        tier: PlanTier.free,
        aiQueriesToday: 0,
        lastQueryDate: '2026-09-04',
      );

      expect(state.isPremium, isFalse);
      expect(state.tier, equals(PlanTier.free));
      expect(state.tier.displayName, equals('Free Plan'));
    });

    test('2. Payment status state transitions', () {
      final state = const SubscriptionState(
        isPremium: false,
        tier: PlanTier.free,
        aiQueriesToday: 0,
        lastQueryDate: '2026-09-04',
      );

      final processing = state.copyWith();

      final success = processing.copyWith(
        isPremium: true,
        tier: PlanTier.yearlyVip,
      );
      expect(success.isPremium, isTrue);
      expect(success.tier.isProTier, isTrue);
    });

    test('3. VIP Plan tier pricing and badge formatting', () {
      expect(PlanTier.weeklyVip.badgeLabel, equals('VIP 💎'));
      expect(PlanTier.yearlyVip.badgeLabel, equals('PRO 💎'));
      expect(PlanTier.weeklyVip.priceText, equals('₹19 / wk'));
      expect(PlanTier.monthlyVip.priceText, equals('₹49 / mo'));
      expect(PlanTier.yearlyVip.priceText, equals('₹199 / yr'));
    });
  });
}
