import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_model.freezed.dart';
part 'analytics_model.g.dart';

// ==================== 数据分析模型 ====================

@freezed
class AnalyticsState with _$AnalyticsState {
  const factory AnalyticsState({
    @Default(0) int totalUsers,
    @Default(0) int activeUsers,
    @Default(0) int paidUsers,
    @Default(0.0) double monthlyRevenue,
    @Default([]) List<DataPoint> usageTrend,
    @Default([]) List<FeatureUsage> featureUsage,
    @Default(0) int avgSessionDuration,
    @Default(0) int pageViews,
    @Default(0.0) double bounceRate,
    @Default(0.0) double conversionRate,
    @Default(0.0) double retentionRate,
    @Default(0.0) double referralRate,
    @Default(0) int avgResponseTime,
    @Default(0.0) double errorRate,
    @Default(0.0) double availability,
    @Default(0) int throughput,
    @Default(false) bool isLoading,
    String? error,
  }) = _AnalyticsState;
}

@freezed
class DataPoint with _$DataPoint {
  const factory DataPoint({
    required double x,
    required double y,
  }) = _DataPoint;

  factory DataPoint.fromJson(Map<String, dynamic> json) =>
      _$DataPointFromJson(json);
}

@freezed
class FeatureUsage with _$FeatureUsage {
  const factory FeatureUsage({
    required String name,
    required double usage,
    @Default(0) int count,
  }) = _FeatureUsage;

  factory FeatureUsage.fromJson(Map<String, dynamic> json) =>
      _$FeatureUsageFromJson(json);
}

// ==================== API 请求响应模型 ====================

@freezed
class GetAnalyticsRequest with _$GetAnalyticsRequest {
  const factory GetAnalyticsRequest({
    required String period,
    @Default({}) Map<String, dynamic> filters,
  }) = _GetAnalyticsRequest;

  factory GetAnalyticsRequest.fromJson(Map<String, dynamic> json) =>
      _$GetAnalyticsRequestFromJson(json);
}

@freezed
class GetAnalyticsResponse with _$GetAnalyticsResponse {
  const factory GetAnalyticsResponse({
    required Map<String, dynamic> overview,
    required List<DataPoint> usageTrend,
    required List<FeatureUsage> featureUsage,
    required Map<String, dynamic> userBehavior,
    required Map<String, dynamic> performance,
  }) = _GetAnalyticsResponse;

  factory GetAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnalyticsResponseFromJson(json);
}

@freezed
class GetUserAnalyticsResponse with _$GetUserAnalyticsResponse {
  const factory GetUserAnalyticsResponse({
    required Map<String, dynamic> userStats,
    required List<DataPoint> activityTrend,
    required List<FeatureUsage> featureUsage,
    required Map<String, dynamic> behavior,
  }) = _GetUserAnalyticsResponse;

  factory GetUserAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetUserAnalyticsResponseFromJson(json);
}

@freezed
class GetRevenueAnalyticsResponse with _$GetRevenueAnalyticsResponse {
  const factory GetRevenueAnalyticsResponse({
    required Map<String, dynamic> revenueStats,
    required List<DataPoint> revenueTrend,
    required List<PaymentMethodStats> paymentMethods,
    required Map<String, dynamic> subscriptionStats,
  }) = _GetRevenueAnalyticsResponse;

  factory GetRevenueAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRevenueAnalyticsResponseFromJson(json);
}

@freezed
class PaymentMethodStats with _$PaymentMethodStats {
  const factory PaymentMethodStats({
    required String method,
    required double amount,
    required int count,
    @Default(0.0) double percentage,
  }) = _PaymentMethodStats;

  factory PaymentMethodStats.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodStatsFromJson(json);
}

@freezed
class GetPerformanceAnalyticsResponse with _$GetPerformanceAnalyticsResponse {
  const factory GetPerformanceAnalyticsResponse({
    required Map<String, dynamic> performanceStats,
    required List<DataPoint> responseTimeTrend,
    required List<DataPoint> errorRateTrend,
    required Map<String, dynamic> availabilityStats,
  }) = _GetPerformanceAnalyticsResponse;

  factory GetPerformanceAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPerformanceAnalyticsResponseFromJson(json);
}

@freezed
class CreateReportRequest with _$CreateReportRequest {
  const factory CreateReportRequest({
    required String type,
    required String period,
    @Default({}) Map<String, dynamic> filters,
    @Default('pdf') String format,
  }) = _CreateReportRequest;

  factory CreateReportRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReportRequestFromJson(json);
}

@freezed
class CreateReportResponse with _$CreateReportResponse {
  const factory CreateReportResponse({
    required String reportId,
    required String downloadUrl,
    required String status,
    DateTime? generatedAt,
  }) = _CreateReportResponse;

  factory CreateReportResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateReportResponseFromJson(json);
}

@freezed
class GetReportResponse with _$GetReportResponse {
  const factory GetReportResponse({
    required String reportId,
    required String status,
    String? downloadUrl,
    DateTime? generatedAt,
    String? error,
  }) = _GetReportResponse;

  factory GetReportResponse.fromJson(Map<String, dynamic> json) =>
      _$GetReportResponseFromJson(json);
}

@freezed
class SetAnalyticsGoalRequest with _$SetAnalyticsGoalRequest {
  const factory SetAnalyticsGoalRequest({
    required String metric,
    required double target,
    required DateTime targetDate,
    @Default({}) Map<String, dynamic> metadata,
  }) = _SetAnalyticsGoalRequest;

  factory SetAnalyticsGoalRequest.fromJson(Map<String, dynamic> json) =>
      _$SetAnalyticsGoalRequestFromJson(json);
}

@freezed
class AnalyticsGoal with _$AnalyticsGoal {
  const factory AnalyticsGoal({
    required String id,
    required String metric,
    required double target,
    required double current,
    required DateTime targetDate,
    required DateTime createdAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _AnalyticsGoal;

  factory AnalyticsGoal.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsGoalFromJson(json);
}

@freezed
class GetAnalyticsGoalsResponse with _$GetAnalyticsGoalsResponse {
  const factory GetAnalyticsGoalsResponse({
    required List<AnalyticsGoal> goals,
    @Default(0) int total,
  }) = _GetAnalyticsGoalsResponse;

  factory GetAnalyticsGoalsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetAnalyticsGoalsResponseFromJson(json);
}

@freezed
class GetRealTimeAnalyticsResponse with _$GetRealTimeAnalyticsResponse {
  const factory GetRealTimeAnalyticsResponse({
    required int activeUsers,
    required int currentRequests,
    required double currentResponseTime,
    required double currentErrorRate,
    required List<DataPoint> realTimeData,
  }) = _GetRealTimeAnalyticsResponse;

  factory GetRealTimeAnalyticsResponse.fromJson(Map<String, dynamic> json) =>
      _$GetRealTimeAnalyticsResponseFromJson(json);
}
