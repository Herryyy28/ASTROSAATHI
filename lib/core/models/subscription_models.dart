import 'package:flutter/foundation.dart';

enum SubscriptionTier { free, silver, gold, vip }

@immutable
class SubscriptionPlan {
  final String id;
  final String name;
  final SubscriptionTier tier;
  final double price;
  final String currency; // 'INR', 'USD'
  final String interval; // 'month', 'year', 'lifetime'
  final List<String> features;
  final bool isPopular;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.tier,
    required this.price,
    this.currency = 'INR',
    this.interval = 'month',
    required this.features,
    this.isPopular = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tier': tier.name,
        'price': price,
        'currency': currency,
        'interval': interval,
        'features': features,
        'isPopular': isPopular,
      };

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as String? ?? 'free',
      name: json['name'] as String? ?? 'Free Plan',
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] as String? ?? 'INR',
      interval: json['interval'] as String? ?? 'month',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isPopular: json['isPopular'] as bool? ?? false,
    );
  }
}

@immutable
class UserEntitlement {
  final bool isPremium;
  final SubscriptionTier tier;
  final DateTime? expiresAt;
  final List<String> featuresUnlocked;

  const UserEntitlement({
    required this.isPremium,
    this.tier = SubscriptionTier.free,
    this.expiresAt,
    this.featuresUnlocked = const [],
  });

  static const UserEntitlement freeDefault = UserEntitlement(
    isPremium: false,
    tier: SubscriptionTier.free,
    featuresUnlocked: ['daily_horoscope', 'basic_panchang'],
  );

  bool hasFeature(String featureKey) {
    if (tier == SubscriptionTier.vip) return true;
    return featuresUnlocked.contains(featureKey);
  }

  Map<String, dynamic> toJson() => {
        'isPremium': isPremium,
        'tier': tier.name,
        'expiresAt': expiresAt?.toIso8601String(),
        'featuresUnlocked': featuresUnlocked,
      };

  factory UserEntitlement.fromJson(Map<String, dynamic> json) {
    return UserEntitlement(
      isPremium: json['isPremium'] as bool? ?? false,
      tier: SubscriptionTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => SubscriptionTier.free,
      ),
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
      featuresUnlocked: (json['featuresUnlocked'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['daily_horoscope', 'basic_panchang'],
    );
  }
}
