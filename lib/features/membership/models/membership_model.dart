import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_model.freezed.dart';
part 'membership_model.g.dart';

// ==================== 会员体系数据模型 ====================

@freezed
class MembershipState with _$MembershipState {
  const factory MembershipState({
    MembershipPlan? currentPlan,
    @Default([]) List<MembershipPlan> availablePlans,
    @Default([]) List<PaymentHistory> paymentHistory,
    @Default(0) int monthlyUsage,
    @Default(0) int remainingQuota,
    @Default(0) int storageUsed,
    @Default(0) int apiCalls,
    @Default(false) bool isLoading,
    String? error,
  }) = _MembershipState;
}

@freezed
class MembershipPlan with _$MembershipPlan {
  const factory MembershipPlan({
    required String id,
    required String name,
    required String description,
    required double price,
    required String period,
    required String type,
    required List<String> features,
    @Default({}) Map<String, dynamic> limits,
    @Default({}) Map<String, dynamic> metadata,
    String? expiresAt,
    @Default(false) bool isExpiringSoon,
  }) = _MembershipPlan;

  factory MembershipPlan.fromJson(Map<String, dynamic> json) =>
      _$MembershipPlanFromJson(json);
      
  Map<String, dynamic> toJson() => _$MembershipPlanToJson(this);
}

@freezed
class PaymentHistory with _$PaymentHistory {
  const factory PaymentHistory({
    required String id,
    required String planId,
    required String planName,
    required double amount,
    required String status,
    required String paymentMethod,
    required DateTime createdAt,
    DateTime? expiresAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _PaymentHistory;

  factory PaymentHistory.fromJson(Map<String, dynamic> json) =>
      _$PaymentHistoryFromJson(json);
}

// ==================== API 请求响应模型 ====================

@freezed
class SubscribeRequest with _$SubscribeRequest {
  const factory SubscribeRequest({
    required String planId,
    required String paymentMethod,
    @Default({}) Map<String, dynamic> paymentData,
  }) = _SubscribeRequest;

  factory SubscribeRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscribeRequestFromJson(json);
}

@freezed
class SubscribeResponse with _$SubscribeResponse {
  const factory SubscribeResponse({
    required String subscriptionId,
    required String status,
    required String paymentUrl,
    DateTime? expiresAt,
  }) = _SubscribeResponse;

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) =>
      _$SubscribeResponseFromJson(json);
}

@freezed
class GetMembershipResponse with _$GetMembershipResponse {
  const factory GetMembershipResponse({
    required MembershipPlan currentPlan,
    required List<MembershipPlan> availablePlans,
    required Map<String, dynamic> usageStats,
  }) = _GetMembershipResponse;

  factory GetMembershipResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMembershipResponseFromJson(json);
}

@freezed
class GetPaymentHistoryResponse with _$GetPaymentHistoryResponse {
  const factory GetPaymentHistoryResponse({
    required List<PaymentHistory> payments,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _GetPaymentHistoryResponse;

  factory GetPaymentHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPaymentHistoryResponseFromJson(json);
}

@freezed
class CancelSubscriptionRequest with _$CancelSubscriptionRequest {
  const factory CancelSubscriptionRequest({
    required String subscriptionId,
    String? reason,
  }) = _CancelSubscriptionRequest;

  factory CancelSubscriptionRequest.fromJson(Map<String, dynamic> json) =>
      _$CancelSubscriptionRequestFromJson(json);
}

@freezed
class CancelSubscriptionResponse with _$CancelSubscriptionResponse {
  const factory CancelSubscriptionResponse({
    required String status,
    DateTime? expiresAt,
  }) = _CancelSubscriptionResponse;

  factory CancelSubscriptionResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelSubscriptionResponseFromJson(json);
}

@freezed
class UpgradePlanRequest with _$UpgradePlanRequest {
  const factory UpgradePlanRequest({
    required String newPlanId,
    required String paymentMethod,
    @Default({}) Map<String, dynamic> paymentData,
  }) = _UpgradePlanRequest;

  factory UpgradePlanRequest.fromJson(Map<String, dynamic> json) =>
      _$UpgradePlanRequestFromJson(json);
}

@freezed
class UpgradePlanResponse with _$UpgradePlanResponse {
  const factory UpgradePlanResponse({
    required String subscriptionId,
    required String status,
    required MembershipPlan newPlan,
    DateTime? expiresAt,
  }) = _UpgradePlanResponse;

  factory UpgradePlanResponse.fromJson(Map<String, dynamic> json) =>
      _$UpgradePlanResponseFromJson(json);
}

@freezed
class GetUsageStatsResponse with _$GetUsageStatsResponse {
  const factory GetUsageStatsResponse({
    required Map<String, dynamic> monthlyStats,
    required Map<String, dynamic> dailyStats,
    required Map<String, dynamic> limits,
    required Map<String, dynamic> usage,
  }) = _GetUsageStatsResponse;

  factory GetUsageStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUsageStatsResponseFromJson(json);
}

@freezed
class CreateCouponRequest with _$CreateCouponRequest {
  const factory CreateCouponRequest({
    required String code,
    required String type,
    required double value,
    required DateTime expiresAt,
    @Default(1) int maxUses,
    @Default({}) Map<String, dynamic> metadata,
  }) = _CreateCouponRequest;

  factory CreateCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCouponRequestFromJson(json);
}

@freezed
class Coupon with _$Coupon {
  const factory Coupon({
    required String id,
    required String code,
    required String type,
    required double value,
    required DateTime expiresAt,
    required int maxUses,
    required int usedCount,
    @Default({}) Map<String, dynamic> metadata,
  }) = _Coupon;

  factory Coupon.fromJson(Map<String, dynamic> json) =>
      _$CouponFromJson(json);
}

@freezed
class ApplyCouponRequest with _$ApplyCouponRequest {
  const factory ApplyCouponRequest({
    required String couponCode,
    required String planId,
  }) = _ApplyCouponRequest;

  factory ApplyCouponRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplyCouponRequestFromJson(json);
}

@freezed
class ApplyCouponResponse with _$ApplyCouponResponse {
  const factory ApplyCouponResponse({
    required Coupon coupon,
    required double discountAmount,
    required double finalPrice,
  }) = _ApplyCouponResponse;

  factory ApplyCouponResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplyCouponResponseFromJson(json);
}
