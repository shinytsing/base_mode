import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_model.freezed.dart';
part 'app_model.g.dart';

@freezed
class AppModel with _$AppModel {
  const factory AppModel({
    required String id,
    required String name,
    required String description,
    required String category,
    required String icon,
    required String color,
    @Default('1.0.0') String version,
    @Default(true) bool isActive,
    @Default([]) List<String> features,
    @Default([]) List<String> screenshots,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AppModel;

  factory AppModel.fromJson(Map<String, dynamic> json) => _$AppModelFromJson(json);
}

@freezed
class MembershipPlan with _$MembershipPlan {
  const factory MembershipPlan({
    required String id,
    required String name,
    required String description,
    required double price,
    required String currency,
    required int duration,
    required int maxApps,
    @Default([]) List<String> features,
    @Default(true) bool isActive,
  }) = _MembershipPlan;

  factory MembershipPlan.fromJson(Map<String, dynamic> json) => _$MembershipPlanFromJson(json);
}

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String userId,
    required String planId,
    required String status,
    required DateTime startDate,
    required DateTime endDate,
    @Default(true) bool autoRenew,
    required String paymentMethod,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String userId,
    required String planId,
    required double amount,
    required String currency,
    required String paymentMethod,
    String? returnUrl,
    String? cancelUrl,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
  
  Map<String, dynamic> toJson() => _$PaymentRequestToJson(this);
}

@freezed
class PaymentResponse with _$PaymentResponse {
  const factory PaymentResponse({
    required String id,
    required String status,
    required String paymentUrl,
    required String clientSecret,
    required double amount,
    required String currency,
    required DateTime createdAt,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => _$PaymentResponseFromJson(json);
}
