import 'package:freezed_annotation/freezed_annotation.dart';

part 'fittracker_model.freezed.dart';
part 'fittracker_model.g.dart';

// ==================== 健身中心模型 ====================

@freezed
class TrainingPlan with _$TrainingPlan {
  const factory TrainingPlan({
    required String id,
    required String name,
    required String description,
    required String difficulty,
    required int duration,
    required List<Exercise> exercises,
    required String category,
    @Default([]) List<String> tags,
    @Default(0) int likes,
    @Default(0) int completions,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TrainingPlan;

  factory TrainingPlan.fromJson(Map<String, dynamic> json) =>
      _$TrainingPlanFromJson(json);
}

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required String name,
    required String description,
    required String category,
    required String muscleGroup,
    required String equipment,
    required int sets,
    required int reps,
    required int duration,
    required String instructions,
    required String imageUrl,
    @Default([]) List<String> tips,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

@freezed
class TrainingSession with _$TrainingSession {
  const factory TrainingSession({
    required String id,
    required String planId,
    required String userId,
    required DateTime startTime,
    DateTime? endTime,
    required String status,
    required List<ExerciseLog> exerciseLogs,
    @Default(0) int totalDuration,
    @Default(0) int caloriesBurned,
    @Default({}) Map<String, dynamic> metrics,
    DateTime? createdAt,
  }) = _TrainingSession;

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionFromJson(json);
}

@freezed
class ExerciseLog with _$ExerciseLog {
  const factory ExerciseLog({
    required String id,
    required String exerciseId,
    required String exerciseName,
    required int sets,
    required int reps,
    required double weight,
    required int duration,
    @Default({}) Map<String, dynamic> metrics,
  }) = _ExerciseLog;

  factory ExerciseLog.fromJson(Map<String, dynamic> json) =>
      _$ExerciseLogFromJson(json);
}

// ==================== BMI计算器模型 ====================

@freezed
class BMICalculation with _$BMICalculation {
  const factory BMICalculation({
    required String id,
    required double height,
    required double weight,
    required double bmi,
    required String category,
    required String healthStatus,
    required List<String> recommendations,
    DateTime? calculatedAt,
  }) = _BMICalculation;

  factory BMICalculation.fromJson(Map<String, dynamic> json) =>
      _$BMICalculationFromJson(json);
}

@freezed
class HealthAssessment with _$HealthAssessment {
  const factory HealthAssessment({
    required String id,
    required double bmi,
    required double bodyFat,
    required double muscleMass,
    required String overallHealth,
    required List<HealthMetric> metrics,
    required List<String> recommendations,
    DateTime? assessedAt,
  }) = _HealthAssessment;

  factory HealthAssessment.fromJson(Map<String, dynamic> json) =>
      _$HealthAssessmentFromJson(json);
}

@freezed
class HealthMetric with _$HealthMetric {
  const factory HealthMetric({
    required String name,
    required double value,
    required String unit,
    required String status,
    required String description,
  }) = _HealthMetric;

  factory HealthMetric.fromJson(Map<String, dynamic> json) =>
      _$HealthMetricFromJson(json);
}

// ==================== 营养计算器模型 ====================

@freezed
class CalorieCalculation with _$CalorieCalculation {
  const factory CalorieCalculation({
    required String id,
    required double bmr,
    required double tdee,
    required double targetCalories,
    required String goal,
    required List<MacroBreakdown> macros,
    DateTime? calculatedAt,
  }) = _CalorieCalculation;

  factory CalorieCalculation.fromJson(Map<String, dynamic> json) =>
      _$CalorieCalculationFromJson(json);
}

@freezed
class MacroBreakdown with _$MacroBreakdown {
  const factory MacroBreakdown({
    required String name,
    required double grams,
    required double calories,
    required double percentage,
  }) = _MacroBreakdown;

  factory MacroBreakdown.fromJson(Map<String, dynamic> json) =>
      _$MacroBreakdownFromJson(json);
}

@freezed
class NutritionAnalysis with _$NutritionAnalysis {
  const factory NutritionAnalysis({
    required String id,
    required List<FoodItem> foods,
    required NutritionSummary summary,
    required List<String> recommendations,
    DateTime? analyzedAt,
  }) = _NutritionAnalysis;

  factory NutritionAnalysis.fromJson(Map<String, dynamic> json) =>
      _$NutritionAnalysisFromJson(json);
}

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String name,
    required double quantity,
    required String unit,
    required NutritionInfo nutrition,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}

@freezed
class NutritionInfo with _$NutritionInfo {
  const factory NutritionInfo({
    required int calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required double sugar,
    required double sodium,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}

@freezed
class NutritionSummary with _$NutritionSummary {
  const factory NutritionSummary({
    required int totalCalories,
    required double totalProtein,
    required double totalCarbs,
    required double totalFat,
    required double totalFiber,
    required double totalSugar,
    required double totalSodium,
  }) = _NutritionSummary;

  factory NutritionSummary.fromJson(Map<String, dynamic> json) =>
      _$NutritionSummaryFromJson(json);
}

@freezed
class DietRecommendations with _$DietRecommendations {
  const factory DietRecommendations({
    required String id,
    required List<MealPlan> mealPlans,
    required List<String> tips,
    required List<String> foodsToAvoid,
    required List<String> foodsToInclude,
    DateTime? generatedAt,
  }) = _DietRecommendations;

  factory DietRecommendations.fromJson(Map<String, dynamic> json) =>
      _$DietRecommendationsFromJson(json);
}

@freezed
class MealPlan with _$MealPlan {
  const factory MealPlan({
    required String meal,
    required List<FoodItem> foods,
    required NutritionInfo nutrition,
    required String description,
  }) = _MealPlan;

  factory MealPlan.fromJson(Map<String, dynamic> json) =>
      _$MealPlanFromJson(json);
}

@freezed
class FoodLog with _$FoodLog {
  const factory FoodLog({
    required String id,
    required String userId,
    required String meal,
    required List<FoodItem> foods,
    required NutritionSummary nutrition,
    DateTime? loggedAt,
  }) = _FoodLog;

  factory FoodLog.fromJson(Map<String, dynamic> json) =>
      _$FoodLogFromJson(json);
}

// ==================== 签到日历模型 ====================

@freezed
class CheckIn with _$CheckIn {
  const factory CheckIn({
    required String id,
    required String userId,
    required String habitId,
    required String habitName,
    required DateTime checkInTime,
    @Default({}) Map<String, dynamic> data,
  }) = _CheckIn;

  factory CheckIn.fromJson(Map<String, dynamic> json) =>
      _$CheckInFromJson(json);
}

@freezed
class CheckInCalendar with _$CheckInCalendar {
  const factory CheckInCalendar({
    required int year,
    required int month,
    required List<CheckInDay> days,
    required HabitStatistics statistics,
  }) = _CheckInCalendar;

  factory CheckInCalendar.fromJson(Map<String, dynamic> json) =>
      _$CheckInCalendarFromJson(json);
}

@freezed
class CheckInDay with _$CheckInDay {
  const factory CheckInDay({
    required int day,
    required bool isCheckedIn,
    required List<String> habits,
    @Default({}) Map<String, dynamic> data,
  }) = _CheckInDay;

  factory CheckInDay.fromJson(Map<String, dynamic> json) =>
      _$CheckInDayFromJson(json);
}

@freezed
class HabitStatistics with _$HabitStatistics {
  const factory HabitStatistics({
    required int totalDays,
    required int checkedInDays,
    required int currentStreak,
    required int longestStreak,
    required double completionRate,
    required List<HabitTrend> trends,
  }) = _HabitStatistics;

  factory HabitStatistics.fromJson(Map<String, dynamic> json) =>
      _$HabitStatisticsFromJson(json);
}

@freezed
class HabitTrend with _$HabitTrend {
  const factory HabitTrend({
    required String period,
    required int count,
    required double rate,
  }) = _HabitTrend;

  factory HabitTrend.fromJson(Map<String, dynamic> json) =>
      _$HabitTrendFromJson(json);
}

// ==================== 运动追踪模型 ====================

@freezed
class ExerciseLogEntry with _$ExerciseLogEntry {
  const factory ExerciseLogEntry({
    required String id,
    required String userId,
    required String exerciseType,
    required String exerciseName,
    required DateTime startTime,
    required DateTime endTime,
    required int duration,
    required double caloriesBurned,
    required Map<String, dynamic> metrics,
    @Default({}) Map<String, dynamic> data,
  }) = _ExerciseLogEntry;

  factory ExerciseLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ExerciseLogEntryFromJson(json);
}

@freezed
class ExerciseStatistics with _$ExerciseStatistics {
  const factory ExerciseStatistics({
    required String period,
    required int totalSessions,
    required int totalDuration,
    required double totalCalories,
    required List<ExerciseTypeStats> typeStats,
    required List<ExerciseTrend> trends,
  }) = _ExerciseStatistics;

  factory ExerciseStatistics.fromJson(Map<String, dynamic> json) =>
      _$ExerciseStatisticsFromJson(json);
}

@freezed
class ExerciseTypeStats with _$ExerciseTypeStats {
  const factory ExerciseTypeStats({
    required String type,
    required int sessions,
    required int duration,
    required double calories,
  }) = _ExerciseTypeStats;

  factory ExerciseTypeStats.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTypeStatsFromJson(json);
}

@freezed
class ExerciseTrend with _$ExerciseTrend {
  const factory ExerciseTrend({
    required String period,
    required int sessions,
    required int duration,
    required double calories,
  }) = _ExerciseTrend;

  factory ExerciseTrend.fromJson(Map<String, dynamic> json) =>
      _$ExerciseTrendFromJson(json);
}

@freezed
class ExerciseGoal with _$ExerciseGoal {
  const factory ExerciseGoal({
    required String id,
    required String userId,
    required String type,
    required String name,
    required int targetValue,
    required String unit,
    required int currentValue,
    required DateTime targetDate,
    required String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExerciseGoal;

  factory ExerciseGoal.fromJson(Map<String, dynamic> json) =>
      _$ExerciseGoalFromJson(json);
}

// ==================== 健康监测模型 ====================

@freezed
class HeartRateRecord with _$HeartRateRecord {
  const factory HeartRateRecord({
    required String id,
    required String userId,
    required int heartRate,
    required String status,
    required DateTime recordedAt,
    @Default({}) Map<String, dynamic> context,
  }) = _HeartRateRecord;

  factory HeartRateRecord.fromJson(Map<String, dynamic> json) =>
      _$HeartRateRecordFromJson(json);
}

@freezed
class SleepRecord with _$SleepRecord {
  const factory SleepRecord({
    required String id,
    required String userId,
    required DateTime bedTime,
    required DateTime wakeTime,
    required int totalSleep,
    required int deepSleep,
    required int lightSleep,
    required int remSleep,
    required int awakenings,
    required double sleepQuality,
    @Default({}) Map<String, dynamic> data,
  }) = _SleepRecord;

  factory SleepRecord.fromJson(Map<String, dynamic> json) =>
      _$SleepRecordFromJson(json);
}

@freezed
class StressRecord with _$StressRecord {
  const factory StressRecord({
    required String id,
    required String userId,
    required int stressLevel,
    required String status,
    required List<String> triggers,
    required List<String> copingStrategies,
    required DateTime recordedAt,
    @Default({}) Map<String, dynamic> data,
  }) = _StressRecord;

  factory StressRecord.fromJson(Map<String, dynamic> json) =>
      _$StressRecordFromJson(json);
}

@freezed
class HealthTrends with _$HealthTrends {
  const factory HealthTrends({
    required String period,
    required List<HealthTrend> heartRateTrends,
    required List<HealthTrend> sleepTrends,
    required List<HealthTrend> stressTrends,
    required List<HealthTrend> weightTrends,
    required HealthInsights insights,
  }) = _HealthTrends;

  factory HealthTrends.fromJson(Map<String, dynamic> json) =>
      _$HealthTrendsFromJson(json);
}

@freezed
class HealthTrend with _$HealthTrend {
  const factory HealthTrend({
    required String date,
    required double value,
    required String unit,
    required String status,
  }) = _HealthTrend;

  factory HealthTrend.fromJson(Map<String, dynamic> json) =>
      _$HealthTrendFromJson(json);
}

@freezed
class HealthInsights with _$HealthInsights {
  const factory HealthInsights({
    required List<String> recommendations,
    required List<String> warnings,
    required List<String> achievements,
    required String overallStatus,
  }) = _HealthInsights;

  factory HealthInsights.fromJson(Map<String, dynamic> json) =>
      _$HealthInsightsFromJson(json);
}

@freezed
class HealthReport with _$HealthReport {
  const factory HealthReport({
    required String id,
    required String userId,
    required String period,
    required HealthSummary summary,
    required List<HealthMetric> metrics,
    required HealthInsights insights,
    required List<String> recommendations,
    DateTime? generatedAt,
  }) = _HealthReport;

  factory HealthReport.fromJson(Map<String, dynamic> json) =>
      _$HealthReportFromJson(json);
}

@freezed
class HealthSummary with _$HealthSummary {
  const factory HealthSummary({
    required double overallScore,
    required String status,
    required int totalDays,
    required int activeDays,
    required double averageSleep,
    required double averageHeartRate,
    required double averageStress,
  }) = _HealthSummary;

  factory HealthSummary.fromJson(Map<String, dynamic> json) =>
      _$HealthSummaryFromJson(json);
}

// ==================== 社区互动模型 ====================

@freezed
class FitnessPost with _$FitnessPost {
  const factory FitnessPost({
    required String id,
    required String userId,
    required String userName,
    required String userAvatar,
    required String content,
    required String type,
    required List<String> images,
    required List<String> videos,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(false) bool isLiked,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FitnessPost;

  factory FitnessPost.fromJson(Map<String, dynamic> json) =>
      _$FitnessPostFromJson(json);
}

@freezed
class PostComment with _$PostComment {
  const factory PostComment({
    required String id,
    required String postId,
    required String userId,
    required String userName,
    required String userAvatar,
    required String content,
    @Default(0) int likes,
    @Default(false) bool isLiked,
    DateTime? createdAt,
  }) = _PostComment;

  factory PostComment.fromJson(Map<String, dynamic> json) =>
      _$PostCommentFromJson(json);
}

@freezed
class FitnessChallenge with _$FitnessChallenge {
  const factory FitnessChallenge({
    required String id,
    required String title,
    required String description,
    required String type,
    required String difficulty,
    required int targetValue,
    required String unit,
    required DateTime startDate,
    required DateTime endDate,
    required int participants,
    required int completions,
    required String status,
    required String creatorId,
    required String creatorName,
    @Default([]) List<String> tags,
    @Default([]) List<String> rewards,
    DateTime? createdAt,
  }) = _FitnessChallenge;

  factory FitnessChallenge.fromJson(Map<String, dynamic> json) =>
      _$FitnessChallengeFromJson(json);
}

@freezed
class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required String userId,
    required String userName,
    required String userAvatar,
    required double score,
    required int rank,
    required String type,
    @Default({}) Map<String, dynamic> stats,
  }) = _LeaderboardEntry;

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardEntryFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String avatar,
    required String bio,
    @Default(0) int followers,
    @Default(0) int following,
    @Default(0) int posts,
    @Default(false) bool isFollowing,
    @Default([]) List<String> badges,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}

// ==================== 请求响应模型 ====================

@freezed
class CreateTrainingPlanRequest with _$CreateTrainingPlanRequest {
  const factory CreateTrainingPlanRequest({
    required String name,
    required String description,
    required String difficulty,
    required int duration,
    required List<String> exerciseIds,
    required String category,
    @Default([]) List<String> tags,
  }) = _CreateTrainingPlanRequest;

  factory CreateTrainingPlanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTrainingPlanRequestFromJson(json);
}

@freezed
class StartTrainingRequest with _$StartTrainingRequest {
  const factory StartTrainingRequest({
    required String planId,
    @Default({}) Map<String, dynamic> settings,
  }) = _StartTrainingRequest;

  factory StartTrainingRequest.fromJson(Map<String, dynamic> json) =>
      _$StartTrainingRequestFromJson(json);
}

@freezed
class EndTrainingRequest with _$EndTrainingRequest {
  const factory EndTrainingRequest({
    required List<ExerciseLog> exerciseLogs,
    @Default({}) Map<String, dynamic> metrics,
  }) = _EndTrainingRequest;

  factory EndTrainingRequest.fromJson(Map<String, dynamic> json) =>
      _$EndTrainingRequestFromJson(json);
}

@freezed
class BMICalculationRequest with _$BMICalculationRequest {
  const factory BMICalculationRequest({
    required double height,
    required double weight,
    required int age,
    required String gender,
  }) = _BMICalculationRequest;

  factory BMICalculationRequest.fromJson(Map<String, dynamic> json) =>
      _$BMICalculationRequestFromJson(json);
}

@freezed
class HealthAssessmentRequest with _$HealthAssessmentRequest {
  const factory HealthAssessmentRequest({
    required double height,
    required double weight,
    required int age,
    required String gender,
    @Default({}) Map<String, dynamic> additionalData,
  }) = _HealthAssessmentRequest;

  factory HealthAssessmentRequest.fromJson(Map<String, dynamic> json) =>
      _$HealthAssessmentRequestFromJson(json);
}

@freezed
class CalorieCalculationRequest with _$CalorieCalculationRequest {
  const factory CalorieCalculationRequest({
    required double height,
    required double weight,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) = _CalorieCalculationRequest;

  factory CalorieCalculationRequest.fromJson(Map<String, dynamic> json) =>
      _$CalorieCalculationRequestFromJson(json);
}

@freezed
class NutritionAnalysisRequest with _$NutritionAnalysisRequest {
  const factory NutritionAnalysisRequest({
    required List<FoodItem> foods,
    @Default({}) Map<String, dynamic> options,
  }) = _NutritionAnalysisRequest;

  factory NutritionAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$NutritionAnalysisRequestFromJson(json);
}

@freezed
class DietRecommendationsRequest with _$DietRecommendationsRequest {
  const factory DietRecommendationsRequest({
    required String goal,
    required double targetCalories,
    required List<String> preferences,
    required List<String> allergies,
    @Default({}) Map<String, dynamic> options,
  }) = _DietRecommendationsRequest;

  factory DietRecommendationsRequest.fromJson(Map<String, dynamic> json) =>
      _$DietRecommendationsRequestFromJson(json);
}

@freezed
class LogFoodRequest with _$LogFoodRequest {
  const factory LogFoodRequest({
    required String meal,
    required List<FoodItem> foods,
    @Default({}) Map<String, dynamic> data,
  }) = _LogFoodRequest;

  factory LogFoodRequest.fromJson(Map<String, dynamic> json) =>
      _$LogFoodRequestFromJson(json);
}

@freezed
class CheckInRequest with _$CheckInRequest {
  const factory CheckInRequest({
    required String habitId,
    @Default({}) Map<String, dynamic> data,
  }) = _CheckInRequest;

  factory CheckInRequest.fromJson(Map<String, dynamic> json) =>
      _$CheckInRequestFromJson(json);
}

@freezed
class LogExerciseRequest with _$LogExerciseRequest {
  const factory LogExerciseRequest({
    required String exerciseType,
    required String exerciseName,
    required DateTime startTime,
    required DateTime endTime,
    @Default({}) Map<String, dynamic> metrics,
    @Default({}) Map<String, dynamic> data,
  }) = _LogExerciseRequest;

  factory LogExerciseRequest.fromJson(Map<String, dynamic> json) =>
      _$LogExerciseRequestFromJson(json);
}

@freezed
class SetExerciseGoalRequest with _$SetExerciseGoalRequest {
  const factory SetExerciseGoalRequest({
    required String type,
    required String name,
    required int targetValue,
    required String unit,
    required DateTime targetDate,
  }) = _SetExerciseGoalRequest;

  factory SetExerciseGoalRequest.fromJson(Map<String, dynamic> json) =>
      _$SetExerciseGoalRequestFromJson(json);
}

@freezed
class RecordHeartRateRequest with _$RecordHeartRateRequest {
  const factory RecordHeartRateRequest({
    required int heartRate,
    @Default({}) Map<String, dynamic> context,
  }) = _RecordHeartRateRequest;

  factory RecordHeartRateRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordHeartRateRequestFromJson(json);
}

@freezed
class RecordSleepRequest with _$RecordSleepRequest {
  const factory RecordSleepRequest({
    required DateTime bedTime,
    required DateTime wakeTime,
    @Default({}) Map<String, dynamic> data,
  }) = _RecordSleepRequest;

  factory RecordSleepRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordSleepRequestFromJson(json);
}

@freezed
class RecordStressRequest with _$RecordStressRequest {
  const factory RecordStressRequest({
    required int stressLevel,
    required List<String> triggers,
    required List<String> copingStrategies,
    @Default({}) Map<String, dynamic> data,
  }) = _RecordStressRequest;

  factory RecordStressRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordStressRequestFromJson(json);
}

@freezed
class GenerateHealthReportRequest with _$GenerateHealthReportRequest {
  const factory GenerateHealthReportRequest({
    required String period,
    @Default({}) Map<String, dynamic> options,
  }) = _GenerateHealthReportRequest;

  factory GenerateHealthReportRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateHealthReportRequestFromJson(json);
}

@freezed
class CreateFitnessPostRequest with _$CreateFitnessPostRequest {
  const factory CreateFitnessPostRequest({
    required String content,
    required String type,
    @Default([]) List<String> images,
    @Default([]) List<String> videos,
    @Default([]) List<String> tags,
  }) = _CreateFitnessPostRequest;

  factory CreateFitnessPostRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateFitnessPostRequestFromJson(json);
}

@freezed
class CommentPostRequest with _$CommentPostRequest {
  const factory CommentPostRequest({
    required String content,
  }) = _CommentPostRequest;

  factory CommentPostRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentPostRequestFromJson(json);
}

@freezed
class CreateChallengeRequest with _$CreateChallengeRequest {
  const factory CreateChallengeRequest({
    required String title,
    required String description,
    required String type,
    required String difficulty,
    required int targetValue,
    required String unit,
    required DateTime startDate,
    required DateTime endDate,
    @Default([]) List<String> tags,
    @Default([]) List<String> rewards,
  }) = _CreateChallengeRequest;

  factory CreateChallengeRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChallengeRequestFromJson(json);
}

@freezed
class FollowUserRequest with _$FollowUserRequest {
  const factory FollowUserRequest({
    required String userId,
  }) = _FollowUserRequest;

  factory FollowUserRequest.fromJson(Map<String, dynamic> json) =>
      _$FollowUserRequestFromJson(json);
}

// ==================== 列表响应模型 ====================

@freezed
class TrainingPlanListResponse with _$TrainingPlanListResponse {
  const factory TrainingPlanListResponse({
    required List<TrainingPlan> plans,
    required int total,
    required int page,
    required int limit,
  }) = _TrainingPlanListResponse;

  factory TrainingPlanListResponse.fromJson(Map<String, dynamic> json) =>
      _$TrainingPlanListResponseFromJson(json);
}

@freezed
class TrainingSessionListResponse with _$TrainingSessionListResponse {
  const factory TrainingSessionListResponse({
    required List<TrainingSession> sessions,
    required int total,
    required int page,
    required int limit,
  }) = _TrainingSessionListResponse;

  factory TrainingSessionListResponse.fromJson(Map<String, dynamic> json) =>
      _$TrainingSessionListResponseFromJson(json);
}

@freezed
class BMIHistoryResponse with _$BMIHistoryResponse {
  const factory BMIHistoryResponse({
    required List<BMICalculation> history,
    required int total,
    required int page,
    required int limit,
  }) = _BMIHistoryResponse;

  factory BMIHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$BMIHistoryResponseFromJson(json);
}

@freezed
class FoodLogListResponse with _$FoodLogListResponse {
  const factory FoodLogListResponse({
    required List<FoodLog> logs,
    required int total,
    required int page,
    required int limit,
  }) = _FoodLogListResponse;

  factory FoodLogListResponse.fromJson(Map<String, dynamic> json) =>
      _$FoodLogListResponseFromJson(json);
}

@freezed
class ExerciseLogListResponse with _$ExerciseLogListResponse {
  const factory ExerciseLogListResponse({
    required List<ExerciseLog> logs,
    required int total,
    required int page,
    required int limit,
  }) = _ExerciseLogListResponse;

  factory ExerciseLogListResponse.fromJson(Map<String, dynamic> json) =>
      _$ExerciseLogListResponseFromJson(json);
}

@freezed
class ExerciseGoalListResponse with _$ExerciseGoalListResponse {
  const factory ExerciseGoalListResponse({
    required List<ExerciseGoal> goals,
    required int total,
  }) = _ExerciseGoalListResponse;

  factory ExerciseGoalListResponse.fromJson(Map<String, dynamic> json) =>
      _$ExerciseGoalListResponseFromJson(json);
}

@freezed
class HeartRateHistoryResponse with _$HeartRateHistoryResponse {
  const factory HeartRateHistoryResponse({
    required List<HeartRateRecord> history,
    required int total,
    required int page,
    required int limit,
  }) = _HeartRateHistoryResponse;

  factory HeartRateHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$HeartRateHistoryResponseFromJson(json);
}

@freezed
class SleepHistoryResponse with _$SleepHistoryResponse {
  const factory SleepHistoryResponse({
    required List<SleepRecord> history,
    required int total,
    required int page,
    required int limit,
  }) = _SleepHistoryResponse;

  factory SleepHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$SleepHistoryResponseFromJson(json);
}

@freezed
class StressHistoryResponse with _$StressHistoryResponse {
  const factory StressHistoryResponse({
    required List<StressRecord> history,
    required int total,
    required int page,
    required int limit,
  }) = _StressHistoryResponse;

  factory StressHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$StressHistoryResponseFromJson(json);
}

@freezed
class FitnessPostListResponse with _$FitnessPostListResponse {
  const factory FitnessPostListResponse({
    required List<FitnessPost> posts,
    required int total,
    required int page,
    required int limit,
  }) = _FitnessPostListResponse;

  factory FitnessPostListResponse.fromJson(Map<String, dynamic> json) =>
      _$FitnessPostListResponseFromJson(json);
}

@freezed
class PostCommentListResponse with _$PostCommentListResponse {
  const factory PostCommentListResponse({
    required List<PostComment> comments,
    required int total,
    required int page,
    required int limit,
  }) = _PostCommentListResponse;

  factory PostCommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$PostCommentListResponseFromJson(json);
}

@freezed
class FitnessChallengeListResponse with _$FitnessChallengeListResponse {
  const factory FitnessChallengeListResponse({
    required List<FitnessChallenge> challenges,
    required int total,
    required int page,
    required int limit,
  }) = _FitnessChallengeListResponse;

  factory FitnessChallengeListResponse.fromJson(Map<String, dynamic> json) =>
      _$FitnessChallengeListResponseFromJson(json);
}

@freezed
class LeaderboardResponse with _$LeaderboardResponse {
  const factory LeaderboardResponse({
    required List<LeaderboardEntry> entries,
    required int total,
    required String period,
    required String type,
  }) = _LeaderboardResponse;

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardResponseFromJson(json);
}

@freezed
class UserListResponse with _$UserListResponse {
  const factory UserListResponse({
    required List<User> users,
    required int total,
    required int page,
    required int limit,
  }) = _UserListResponse;

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);
}