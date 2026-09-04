import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum PlanTier { free, weeklyVip, monthlyVip, yearlyVip }

extension PlanTierX on PlanTier {
  bool get isProTier => this == PlanTier.yearlyVip;
  bool get isVipTier =>
      this == PlanTier.weeklyVip || this == PlanTier.monthlyVip;

  String get displayName {
    switch (this) {
      case PlanTier.free:
        return 'Free Plan';
      case PlanTier.weeklyVip:
        return 'Weekly VIP Pass';
      case PlanTier.monthlyVip:
        return 'Monthly VIP Pass';
      case PlanTier.yearlyVip:
        return 'Annual PRO Pass';
    }
  }

  String get badgeLabel {
    switch (this) {
      case PlanTier.yearlyVip:
        return 'PRO 💎';
      case PlanTier.weeklyVip:
      case PlanTier.monthlyVip:
        return 'VIP 💎';
      case PlanTier.free:
        return 'FREE';
    }
  }

  String get priceText {
    switch (this) {
      case PlanTier.free:
        return 'Free';
      case PlanTier.weeklyVip:
        return '₹19 / wk';
      case PlanTier.monthlyVip:
        return '₹49 / mo';
      case PlanTier.yearlyVip:
        return '₹199 / yr';
    }
  }

  String get savingsText {
    switch (this) {
      case PlanTier.yearlyVip:
        return 'Save 60%';
      case PlanTier.weeklyVip:
        return 'Trial Pass';
      default:
        return '';
    }
  }
}

class SubscriptionState {
  final bool isPremium;
  final PlanTier tier;
  final DateTime? purchaseDate;
  final int aiQueriesToday;
  final String lastQueryDate;

  const SubscriptionState({
    required this.isPremium,
    required this.tier,
    this.purchaseDate,
    required this.aiQueriesToday,
    required this.lastQueryDate,
  });

  SubscriptionState copyWith({
    bool? isPremium,
    PlanTier? tier,
    DateTime? purchaseDate,
    int? aiQueriesToday,
    String? lastQueryDate,
  }) {
    return SubscriptionState(
      isPremium: isPremium ?? this.isPremium,
      tier: tier ?? this.tier,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      aiQueriesToday: aiQueriesToday ?? this.aiQueriesToday,
      lastQueryDate: lastQueryDate ?? this.lastQueryDate,
    );
  }
}

class SubscriptionNotifier extends StateNotifier<SubscriptionState> {
  static const int freeAiQueryLimit = 1;
  static const int freeProfileLimit = 5;

  SubscriptionNotifier()
    : super(
        const SubscriptionState(
          isPremium: false,
          tier: PlanTier.free,
          aiQueriesToday: 0,
          lastQueryDate: '',
        ),
      ) {
    _loadState();
  }

  String get _todayDateString {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final isPrem = prefs.getBool('is_premium') ?? false;
    final tierStr = prefs.getString('subscription_tier') ?? PlanTier.free.name;
    final purchaseStr = prefs.getString('subscription_purchase_date');
    final queries = prefs.getInt('ai_queries_today') ?? 0;
    final lastDate = prefs.getString('ai_queries_last_date') ?? '';

    PlanTier loadedTier = PlanTier.free;
    for (final t in PlanTier.values) {
      if (t.name == tierStr) {
        loadedTier = t;
        break;
      }
    }

    final today = _todayDateString;
    final int currentQueries = (lastDate == today) ? queries : 0;
    final purchaseDate = purchaseStr != null
        ? DateTime.tryParse(purchaseStr)
        : null;

    bool finalIsPremium = isPrem;
    if (finalIsPremium && purchaseDate != null && loadedTier != PlanTier.free) {
      final exp = _calculateExpirationDate(loadedTier, purchaseDate);
      if (exp != null && DateTime.now().isAfter(exp)) {
        finalIsPremium = false;
        loadedTier = PlanTier.free;
        await prefs.setBool('is_premium', false);
        await prefs.setString('subscription_tier', PlanTier.free.name);
      }
    }

    state = SubscriptionState(
      isPremium: finalIsPremium,
      tier: finalIsPremium ? loadedTier : PlanTier.free,
      purchaseDate: finalIsPremium ? purchaseDate : null,
      aiQueriesToday: currentQueries,
      lastQueryDate: today,
    );
  }

  Future<void> grantPremiumAccess(PlanTier tier, String orderId) async {
    // Only called after real server-side verification succeeds
    await upgradeToTier(tier);
  }

  Future<void> upgradeToTier(PlanTier tier) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    await prefs.setBool('is_premium', true);
    await prefs.setString('subscription_tier', tier.name);
    await prefs.setString('subscription_purchase_date', now.toIso8601String());

    state = state.copyWith(isPremium: true, tier: tier, purchaseDate: now);
  }

  Future<void> cancelSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_premium', false);
    await prefs.setString('subscription_tier', PlanTier.free.name);

    state = state.copyWith(isPremium: false, tier: PlanTier.free);
  }

  Future<void> togglePremiumMock() async {
    if (state.isPremium) {
      await cancelSubscription();
    } else {
      await upgradeToTier(PlanTier.yearlyVip);
    }
  }

  bool canAskAiQuery() {
    _checkDateReset();
    if (state.isPremium) return true;
    final today = _todayDateString;
    final currentQueries = (state.lastQueryDate == today)
        ? state.aiQueriesToday
        : 0;
    return currentQueries < freeAiQueryLimit;
  }

  int get remainingFreeAiQueries {
    _checkDateReset();
    if (state.isPremium) return 999;
    final today = _todayDateString;
    final currentQueries = (state.lastQueryDate == today)
        ? state.aiQueriesToday
        : 0;
    final rem = freeAiQueryLimit - currentQueries;
    return rem < 0 ? 0 : rem;
  }

  Future<void> recordAiQuery() async {
    if (state.isPremium) return;

    final today = _todayDateString;
    final currentQueries = (state.lastQueryDate == today)
        ? state.aiQueriesToday
        : 0;
    final newCount = currentQueries + 1;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ai_queries_today', newCount);
    await prefs.setString('ai_queries_last_date', today);

    state = state.copyWith(aiQueriesToday: newCount, lastQueryDate: today);
  }

  void _checkDateReset() {
    final today = _todayDateString;
    if (state.lastQueryDate != today) {
      state = state.copyWith(aiQueriesToday: 0, lastQueryDate: today);
    }
  }

  bool canAddProfile(int currentProfileCount) {
    if (state.isPremium) return true;
    return currentProfileCount < freeProfileLimit;
  }

  DateTime? _calculateExpirationDate(PlanTier tier, DateTime purchaseDate) {
    switch (tier) {
      case PlanTier.weeklyVip:
        return purchaseDate.add(const Duration(days: 7));
      case PlanTier.monthlyVip:
        return purchaseDate.add(const Duration(days: 30));
      case PlanTier.yearlyVip:
        return purchaseDate.add(const Duration(days: 365));
      default:
        return null;
    }
  }

  int get remainingDaysOfSubscription {
    if (!state.isPremium ||
        state.purchaseDate == null ||
        state.tier == PlanTier.free)
      return 0;
    final exp = _calculateExpirationDate(state.tier, state.purchaseDate!);
    if (exp == null) return 0;
    final diffSeconds = exp.difference(DateTime.now()).inSeconds;
    if (diffSeconds <= 0) return 0;
    final diffDays = exp.difference(DateTime.now()).inDays;
    return diffDays <= 0 ? 1 : diffDays;
  }
}

final subscriptionProvider =
    StateNotifierProvider<SubscriptionNotifier, SubscriptionState>((ref) {
      return SubscriptionNotifier();
    });

final isPremiumProvider = Provider<bool>((ref) {
  return ref.watch(subscriptionProvider).isPremium;
});
