import '../models/subscription_models.dart';
import '../network/api_result.dart';

abstract class ISubscriptionRepository {
  /// Fetch available subscription plans
  Future<ApiResult<List<SubscriptionPlan>>> getPlans();

  /// Retrieve current user entitlement and active tier
  Future<ApiResult<UserEntitlement>> getEntitlement();

  /// Purchase or upgrade subscription plan
  Future<ApiResult<UserEntitlement>> purchasePlan(String planId);

  /// Restore purchases from app store / play store receipt
  Future<ApiResult<UserEntitlement>> restorePurchases();
}
