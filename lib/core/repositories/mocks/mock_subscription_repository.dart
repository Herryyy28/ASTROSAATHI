import '../../models/subscription_models.dart';
import '../../network/api_result.dart';
import '../subscription_repository.dart';

class MockSubscriptionRepository implements ISubscriptionRepository {
  UserEntitlement _entitlement = UserEntitlement.freeDefault;

  final List<SubscriptionPlan> _plans = const [
    SubscriptionPlan(
      id: 'plan_silver',
      name: 'Silver Seeker',
      tier: SubscriptionTier.silver,
      price: 199.0,
      currency: 'INR',
      interval: 'month',
      features: [
        'Unlimited Kundli Charts (D1 & D9)',
        'Detailed Daily Panchang & Muhurat',
        'Basic Kundli Matching (36 Gunas)',
      ],
    ),
    SubscriptionPlan(
      id: 'plan_gold',
      name: 'Gold Astrologer',
      tier: SubscriptionTier.gold,
      price: 499.0,
      currency: 'INR',
      interval: 'month',
      isPopular: true,
      features: [
        'All Silver Features',
        'Custom PDF Export with Vedic Insights',
        'Vimshottari Dasha 120-Year Timeline',
        'Ashtakoota & Manglik Dosha Analysis',
        '10 Free AI Kundli Questions / month',
      ],
    ),
    SubscriptionPlan(
      id: 'plan_vip',
      name: 'VIP Cosmic Divinity',
      tier: SubscriptionTier.vip,
      price: 1499.0,
      currency: 'INR',
      interval: 'year',
      features: [
        'All Gold Features',
        'Unlimited AI Kundli Consultations',
        '1 Free 15-Minute Human Astrologer Call / month',
        'Family Hub: Up to 10 Birth Profiles',
        'Priority 24/7 Astrological Support',
      ],
    ),
  ];

  @override
  Future<ApiResult<List<SubscriptionPlan>>> getPlans() async {
    return Success(_plans);
  }

  @override
  Future<ApiResult<UserEntitlement>> getEntitlement() async {
    return Success(_entitlement);
  }

  @override
  Future<ApiResult<UserEntitlement>> purchasePlan(String planId) async {
    final plan = _plans.firstWhere(
      (p) => p.id == planId,
      orElse: () => _plans[1],
    );

    _entitlement = UserEntitlement(
      isPremium: true,
      tier: plan.tier,
      expiresAt: DateTime.now().add(const Duration(days: 30)),
      featuresUnlocked: [
        'unlimited_charts',
        'pdf_export',
        'dasha_timeline',
        'ai_unlimited',
        'matching_full',
      ],
    );

    return Success(_entitlement);
  }

  @override
  Future<ApiResult<UserEntitlement>> restorePurchases() async {
    return Success(_entitlement);
  }
}
