import 'package:freezed_annotation/freezed_annotation.dart';

part 'life_mode_model.freezed.dart';
part 'life_mode_model.g.dart';

// ==================== 生活模式模型 ====================

// 添加缺失的类定义
@freezed
class TravelDestination with _$TravelDestination {
  const factory TravelDestination({
    required String id,
    required String name,
    required String country,
    required String city,
    required String description,
    required List<String> images,
    required double rating,
    required int reviewCount,
    required Map<String, dynamic> coordinates,
    required List<String> attractions,
    required List<String> activities,
    required String bestTimeToVisit,
    required Map<String, dynamic> weather,
    required Map<String, dynamic> costs,
    required List<String> tips,
  }) = _TravelDestination;

  factory TravelDestination.fromJson(Map<String, dynamic> json) =>
      _$TravelDestinationFromJson(json);
}

@freezed
class TravelDay with _$TravelDay {
  const factory TravelDay({
    required int dayNumber,
    required String title,
    required String description,
    required List<TravelAttraction> attractions,
    required List<String> highlights,
    required List<String> tips,
    required Map<String, dynamic> schedule,
    required Map<String, dynamic> meals,
    required Map<String, dynamic> transportation,
  }) = _TravelDay;

  factory TravelDay.fromJson(Map<String, dynamic> json) =>
      _$TravelDayFromJson(json);
}

@freezed
class TravelAttraction with _$TravelAttraction {
  const factory TravelAttraction({
    required String id,
    required String name,
    required String description,
    required String type,
    required double rating,
    required int reviewCount,
    required Map<String, dynamic> location,
    required List<String> images,
    required Map<String, dynamic> openingHours,
    required Map<String, dynamic> prices,
    required List<String> features,
    required List<String> tips,
  }) = _TravelAttraction;

  factory TravelAttraction.fromJson(Map<String, dynamic> json) =>
      _$TravelAttractionFromJson(json);
}

@freezed
class TravelAccommodation with _$TravelAccommodation {
  const factory TravelAccommodation({
    required String id,
    required String name,
    required String type,
    required String description,
    required double rating,
    required int reviewCount,
    required Map<String, dynamic> location,
    required List<String> images,
    required Map<String, dynamic> amenities,
    required Map<String, dynamic> prices,
    required String checkIn,
    required String checkOut,
    required List<String> policies,
  }) = _TravelAccommodation;

  factory TravelAccommodation.fromJson(Map<String, dynamic> json) =>
      _$TravelAccommodationFromJson(json);
}

@freezed
class TravelTransportation with _$TravelTransportation {
  const factory TravelTransportation({
    required String id,
    required String type,
    required String name,
    required String description,
    required Map<String, dynamic> route,
    required Map<String, dynamic> schedule,
    required Map<String, dynamic> prices,
    required List<String> features,
    required Map<String, dynamic> booking,
  }) = _TravelTransportation;

  factory TravelTransportation.fromJson(Map<String, dynamic> json) =>
      _$TravelTransportationFromJson(json);
}

@freezed
class WeatherForecast with _$WeatherForecast {
  const factory WeatherForecast({
    required String date,
    required String condition,
    required double temperature,
    required double humidity,
    required double windSpeed,
    required String windDirection,
    required double precipitation,
    required Map<String, dynamic> hourly,
  }) = _WeatherForecast;

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);
}

@freezed
class TravelBudget with _$TravelBudget {
  const factory TravelBudget({
    required String id,
    required String destination,
    required String currency,
    required double totalBudget,
    required double dailyBudget,
    required int duration,
    required Map<String, dynamic> categories,
    required List<BudgetItem> breakdown,
    required List<String> tips,
  }) = _TravelBudget;

  factory TravelBudget.fromJson(Map<String, dynamic> json) =>
      _$TravelBudgetFromJson(json);
}

@freezed
class BudgetItem with _$BudgetItem {
  const factory BudgetItem({
    required String category,
    required double amount,
    required String description,
    required String priority,
    required Map<String, dynamic> details,
  }) = _BudgetItem;

  factory BudgetItem.fromJson(Map<String, dynamic> json) =>
      _$BudgetItemFromJson(json);
}

@freezed
class TravelPlan with _$TravelPlan {
  const factory TravelPlan({
    required String id,
    required String title,
    required String destination,
    required int duration,
    required List<TravelDay> days,
    required TravelBudget budget,
    required List<TravelAttraction> attractions,
    required List<TravelAccommodation> accommodations,
    required List<TravelTransportation> transportations,
    required Map<String, dynamic> weather,
    required Map<String, dynamic> culture,
    required List<String> tips,
    required DateTime createdAt,
  }) = _TravelPlan;

  factory TravelPlan.fromJson(Map<String, dynamic> json) =>
      _$TravelPlanFromJson(json);
}

@freezed
class MusicTrack with _$MusicTrack {
  const factory MusicTrack({
    required String id,
    required String title,
    required String artist,
    required String album,
    required int duration,
    required String genre,
    required String mood,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> metadata,
  }) = _MusicTrack;

  factory MusicTrack.fromJson(Map<String, dynamic> json) =>
      _$MusicTrackFromJson(json);
}

@freezed
class MeditationTrack with _$MeditationTrack {
  const factory MeditationTrack({
    required String id,
    required String title,
    required String description,
    required int duration,
    required String type,
    required String difficulty,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> instructions,
  }) = _MeditationTrack;

  factory MeditationTrack.fromJson(Map<String, dynamic> json) =>
      _$MeditationTrackFromJson(json);
}

@freezed
class RelaxationTrack with _$RelaxationTrack {
  const factory RelaxationTrack({
    required String id,
    required String title,
    required String description,
    required int duration,
    required String type,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> effects,
  }) = _RelaxationTrack;

  factory RelaxationTrack.fromJson(Map<String, dynamic> json) =>
      _$RelaxationTrackFromJson(json);
}

@freezed
class FocusTrack with _$FocusTrack {
  const factory FocusTrack({
    required String id,
    required String title,
    required String description,
    required int duration,
    required String type,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> benefits,
  }) = _FocusTrack;

  factory FocusTrack.fromJson(Map<String, dynamic> json) =>
      _$FocusTrackFromJson(json);
}

@freezed
class SleepTrack with _$SleepTrack {
  const factory SleepTrack({
    required String id,
    required String title,
    required String description,
    required int duration,
    required String type,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> sleepAids,
  }) = _SleepTrack;

  factory SleepTrack.fromJson(Map<String, dynamic> json) =>
      _$SleepTrackFromJson(json);
}

@freezed
class WorkoutTrack with _$WorkoutTrack {
  const factory WorkoutTrack({
    required String id,
    required String title,
    required String description,
    required int duration,
    required String intensity,
    required String type,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> workoutData,
  }) = _WorkoutTrack;

  factory WorkoutTrack.fromJson(Map<String, dynamic> json) =>
      _$WorkoutTrackFromJson(json);
}

@freezed
class MoodTrack with _$MoodTrack {
  const factory MoodTrack({
    required String id,
    required String title,
    required String description,
    required int duration,
    required String mood,
    required String url,
    required String imageUrl,
    required Map<String, dynamic> moodData,
  }) = _MoodTrack;

  factory MoodTrack.fromJson(Map<String, dynamic> json) =>
      _$MoodTrackFromJson(json);
}

@freezed
class MusicHistoryEntry with _$MusicHistoryEntry {
  const factory MusicHistoryEntry({
    required String id,
    required String trackId,
    required String userId,
    required DateTime playedAt,
    required int duration,
    required Map<String, dynamic> context,
  }) = _MusicHistoryEntry;

  factory MusicHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$MusicHistoryEntryFromJson(json);
}

@freezed
class LifeMode with _$LifeMode {
  const factory LifeMode({
    required String id,
    required String name,
    required String description,
    required String category,
    required String icon,
    required String color,
    @Default(true) bool isActive,
    @Default(0) int duration,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LifeMode;

  factory LifeMode.fromJson(Map<String, dynamic> json) => _$LifeModeFromJson(json);
}

// ==================== 娱乐活动模型 ====================

@freezed
class EntertainmentActivity with _$EntertainmentActivity {
  const factory EntertainmentActivity({
    required String id,
    required String name,
    required String description,
    required String type,
    required String category,
    required String icon,
    required String color,
    @Default(0) int duration,
    @Default(0) int difficulty,
    @Default(false) bool isCompleted,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _EntertainmentActivity;

  factory EntertainmentActivity.fromJson(Map<String, dynamic> json) => _$EntertainmentActivityFromJson(json);
}

// ==================== 生活记录模型 ====================

@freezed
class LifeRecord with _$LifeRecord {
  const factory LifeRecord({
    required String id,
    required String userId,
    required String type,
    required String title,
    required String content,
    @Default({}) Map<String, dynamic> data,
    @Default([]) List<String> images,
    @Default([]) List<String> tags,
    @Default(0) int mood,
    @Default(0) int energy,
    @Default(0) int productivity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LifeRecord;

  factory LifeRecord.fromJson(Map<String, dynamic> json) => _$LifeRecordFromJson(json);
}

// ==================== 生活统计模型 ====================

@freezed
class LifeStatistics with _$LifeStatistics {
  const factory LifeStatistics({
    required String id,
    required String userId,
    required String period,
    required Map<String, dynamic> data,
    @Default(0) int totalActivities,
    @Default(0) int completedActivities,
    @Default(0.0) double averageMood,
    @Default(0.0) double averageEnergy,
    @Default(0.0) double averageProductivity,
    @Default({}) Map<String, int> categoryStats,
    @Default({}) Map<String, int> tagStats,
    DateTime? generatedAt,
  }) = _LifeStatistics;

  factory LifeStatistics.fromJson(Map<String, dynamic> json) => _$LifeStatisticsFromJson(json);
}

// ==================== 生活目标模型 ====================

@freezed
class LifeGoal with _$LifeGoal {
  const factory LifeGoal({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String category,
    required String type,
    required String status,
    @Default(0) int targetValue,
    @Default(0) int currentValue,
    @Default(0) int progress,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> milestones,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? targetDate,
    DateTime? completedAt,
  }) = _LifeGoal;

  factory LifeGoal.fromJson(Map<String, dynamic> json) => _$LifeGoalFromJson(json);
}

// ==================== 生活提醒模型 ====================

@freezed
class LifeReminder with _$LifeReminder {
  const factory LifeReminder({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String type,
    required String frequency,
    required DateTime scheduledTime,
    @Default(false) bool isActive,
    @Default(false) bool isCompleted,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? completedAt,
  }) = _LifeReminder;

  factory LifeReminder.fromJson(Map<String, dynamic> json) => _$LifeReminderFromJson(json);
}

// ==================== 生活习惯模型 ====================

@freezed
class LifeHabit with _$LifeHabit {
  const factory LifeHabit({
    required String id,
    required String userId,
    required String name,
    required String description,
    required String category,
    required String frequency,
    @Default(0) int targetCount,
    @Default(0) int currentCount,
    @Default(0) int streak,
    @Default(false) bool isActive,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastCompletedAt,
  }) = _LifeHabit;

  factory LifeHabit.fromJson(Map<String, dynamic> json) => _$LifeHabitFromJson(json);
}

// ==================== 生活事件模型 ====================

@freezed
class LifeEvent with _$LifeEvent {
  const factory LifeEvent({
    required String id,
    required String userId,
    required String title,
    required String description,
    required String type,
    required String category,
    required DateTime startTime,
    required DateTime endTime,
    @Default({}) Map<String, dynamic> location,
    @Default([]) List<String> participants,
    @Default([]) List<String> tags,
    @Default(false) bool isAllDay,
    @Default(false) bool isRecurring,
    @Default({}) Map<String, dynamic> recurrence,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LifeEvent;

  factory LifeEvent.fromJson(Map<String, dynamic> json) => _$LifeEventFromJson(json);
}

// ==================== 生活笔记模型 ====================

@freezed
class LifeNote with _$LifeNote {
  const factory LifeNote({
    required String id,
    required String userId,
    required String title,
    required String content,
    required String category,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<String> tags,
    @Default([]) List<String> attachments,
    @Default(false) bool isFavorite,
    @Default(false) bool isPrivate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LifeNote;

  factory LifeNote.fromJson(Map<String, dynamic> json) => _$LifeNoteFromJson(json);
}

// ==================== 生活分享模型 ====================

@freezed
class LifeShare with _$LifeShare {
  const factory LifeShare({
    required String id,
    required String userId,
    required String content,
    required String type,
    @Default([]) List<String> images,
    @Default([]) List<String> videos,
    @Default([]) List<String> tags,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(false) bool isPublic,
    @Default(false) bool isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LifeShare;

  factory LifeShare.fromJson(Map<String, dynamic> json) => _$LifeShareFromJson(json);
}

// ==================== 生活评论模型 ====================

@freezed
class LifeComment with _$LifeComment {
  const factory LifeComment({
    required String id,
    required String shareId,
    required String userId,
    required String content,
    @Default([]) List<String> replies,
    @Default(0) int likes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _LifeComment;

  factory LifeComment.fromJson(Map<String, dynamic> json) => _$LifeCommentFromJson(json);
}

// ==================== 生活关注模型 ====================

@freezed
class LifeFollow with _$LifeFollow {
  const factory LifeFollow({
    required String id,
    required String followerId,
    required String followingId,
    @Default(false) bool isActive,
    DateTime? createdAt,
  }) = _LifeFollow;

  factory LifeFollow.fromJson(Map<String, dynamic> json) => _$LifeFollowFromJson(json);
}

// ==================== 生活通知模型 ====================

@freezed
class LifeNotification with _$LifeNotification {
  const factory LifeNotification({
    required String id,
    required String userId,
    required String title,
    required String content,
    required String type,
    @Default(false) bool isRead,
    @Default({}) Map<String, dynamic> data,
    DateTime? createdAt,
  }) = _LifeNotification;

  factory LifeNotification.fromJson(Map<String, dynamic> json) => _$LifeNotificationFromJson(json);
}

// ==================== 请求响应模型 ====================

// 创建生活模式请求
@freezed
class CreateLifeModeRequest with _$CreateLifeModeRequest {
  const factory CreateLifeModeRequest({
    required String name,
    required String description,
    required String category,
    required String icon,
    required String color,
    @Default(0) int duration,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> tags,
  }) = _CreateLifeModeRequest;

  factory CreateLifeModeRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeModeRequestFromJson(json);
}

// ==================== 食物随机器模型 ====================

@freezed
class FoodRecommendation with _$FoodRecommendation {
  const factory FoodRecommendation({
    required String id,
    required String name,
    required String description,
    required String category,
    required String cuisine,
    required double rating,
    required String imageUrl,
    required NutritionInfo nutrition,
    required List<String> ingredients,
    required List<String> allergens,
    required int prepTime,
    required int cookTime,
    required int servings,
    required String difficulty,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
  }) = _FoodRecommendation;

  factory FoodRecommendation.fromJson(Map<String, dynamic> json) =>
      _$FoodRecommendationFromJson(json);
}

@freezed
class RestaurantRecommendation with _$RestaurantRecommendation {
  const factory RestaurantRecommendation({
    required String id,
    required String name,
    required String description,
    required String cuisine,
    required double rating,
    required String address,
    required String phone,
    required String website,
    required List<String> images,
    required Map<String, dynamic> location,
    required List<String> features,
    required String priceRange,
    required List<String> openingHours,
    @Default([]) List<String> reviews,
  }) = _RestaurantRecommendation;

  factory RestaurantRecommendation.fromJson(Map<String, dynamic> json) =>
      _$RestaurantRecommendationFromJson(json);
}

@freezed
class Vitamin with _$Vitamin {
  const factory Vitamin({
    required String name,
    required double amount,
    required String unit,
    required double dailyValue,
  }) = _Vitamin;

  factory Vitamin.fromJson(Map<String, dynamic> json) =>
      _$VitaminFromJson(json);
}

@freezed
class Mineral with _$Mineral {
  const factory Mineral({
    required String name,
    required double amount,
    required String unit,
    required double dailyValue,
  }) = _Mineral;

  factory Mineral.fromJson(Map<String, dynamic> json) =>
      _$MineralFromJson(json);
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    required String name,
    required double amount,
    required String unit,
    String? notes,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}

@freezed
class CookingStep with _$CookingStep {
  const factory CookingStep({
    required int stepNumber,
    required String instruction,
    required int duration,
    String? temperature,
  }) = _CookingStep;

  factory CookingStep.fromJson(Map<String, dynamic> json) =>
      _$CookingStepFromJson(json);
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
    required double cholesterol,
    required List<Vitamin> vitamins,
    required List<Mineral> minerals,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}

@freezed
class FoodReview with _$FoodReview {
  const factory FoodReview({
    required String id,
    required String userId,
    required String foodId,
    required double rating,
    required String comment,
    required DateTime createdAt,
    @Default({}) Map<String, dynamic> metadata,
  }) = _FoodReview;

  factory FoodReview.fromJson(Map<String, dynamic> json) =>
      _$FoodReviewFromJson(json);
}

@freezed
class FavoriteFood with _$FavoriteFood {
  const factory FavoriteFood({
    required String id,
    required String userId,
    required String foodId,
    required String foodName,
    required String foodType,
    required String imageUrl,
    required DateTime addedAt,
    @Default({}) Map<String, dynamic> nutritionInfo,
  }) = _FavoriteFood;

  factory FavoriteFood.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFoodFromJson(json);
}

@freezed
class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    required String name,
    required String description,
    required List<Ingredient> ingredients,
    required List<CookingStep> steps,
    required int prepTime,
    required int cookTime,
    required int servings,
    required String difficulty,
    required String imageUrl,
    @Default([]) List<String> tags,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) =>
      _$RecipeFromJson(json);
}

@freezed
class FoodReviewsResponse with _$FoodReviewsResponse {
  const factory FoodReviewsResponse({
    required List<FoodReview> reviews,
    required double averageRating,
    required int totalReviews,
  }) = _FoodReviewsResponse;

  factory FoodReviewsResponse.fromJson(Map<String, dynamic> json) =>
      _$FoodReviewsResponseFromJson(json);
}

@freezed
class FavoriteFoodListResponse with _$FavoriteFoodListResponse {
  const factory FavoriteFoodListResponse({
    required List<FavoriteFood> foods,
    required int total,
    required int page,
    required int limit,
  }) = _FavoriteFoodListResponse;

  factory FavoriteFoodListResponse.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFoodListResponseFromJson(json);
}

// ==================== 旅行指南模型 ====================

@freezed
class TravelDestinationResponse with _$TravelDestinationResponse {
  const factory TravelDestinationResponse({
    required List<TravelDestination> destinations,
    required int total,
  }) = _TravelDestinationResponse;

  factory TravelDestinationResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelDestinationResponseFromJson(json);
}

@freezed
class TravelItinerary with _$TravelItinerary {
  const factory TravelItinerary({
    required String id,
    required String destination,
    required int duration,
    required List<TravelDay> days,
    required TravelBudget budget,
    required List<String> highlights,
    required Map<String, dynamic> weather,
    @Default([]) List<String> tips,
  }) = _TravelItinerary;

  factory TravelItinerary.fromJson(Map<String, dynamic> json) =>
      _$TravelItineraryFromJson(json);
}

@freezed
class TravelAttractionsResponse with _$TravelAttractionsResponse {
  const factory TravelAttractionsResponse({
    required List<TravelAttraction> attractions,
    required int total,
  }) = _TravelAttractionsResponse;

  factory TravelAttractionsResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelAttractionsResponseFromJson(json);
}

@freezed
class TravelAccommodationsResponse with _$TravelAccommodationsResponse {
  const factory TravelAccommodationsResponse({
    required List<TravelAccommodation> accommodations,
    required int total,
  }) = _TravelAccommodationsResponse;

  factory TravelAccommodationsResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelAccommodationsResponseFromJson(json);
}

@freezed
class TravelTransportationResponse with _$TravelTransportationResponse {
  const factory TravelTransportationResponse({
    required List<TravelTransportation> transportations,
    required int total,
  }) = _TravelTransportationResponse;

  factory TravelTransportationResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelTransportationResponseFromJson(json);
}

@freezed
class TravelWeatherResponse with _$TravelWeatherResponse {
  const factory TravelWeatherResponse({
    required String destination,
    required List<WeatherForecast> forecasts,
    required Map<String, dynamic> currentWeather,
  }) = _TravelWeatherResponse;

  factory TravelWeatherResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelWeatherResponseFromJson(json);
}

@freezed
class TravelCultureResponse with _$TravelCultureResponse {
  const factory TravelCultureResponse({
    required String destination,
    required List<String> customs,
    required List<String> traditions,
    required List<String> etiquette,
    required List<String> festivals,
    required List<String> languages,
    required Map<String, dynamic> culturalTips,
  }) = _TravelCultureResponse;

  factory TravelCultureResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelCultureResponseFromJson(json);
}

@freezed
class TravelBudgetResponse with _$TravelBudgetResponse {
  const factory TravelBudgetResponse({
    required TravelBudget budget,
    required List<BudgetItem> breakdown,
    required List<String> moneySavingTips,
  }) = _TravelBudgetResponse;

  factory TravelBudgetResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelBudgetResponseFromJson(json);
}

@freezed
class TravelPlanListResponse with _$TravelPlanListResponse {
  const factory TravelPlanListResponse({
    required List<TravelPlan> plans,
    required int total,
    required int page,
    required int limit,
  }) = _TravelPlanListResponse;

  factory TravelPlanListResponse.fromJson(Map<String, dynamic> json) =>
      _$TravelPlanListResponseFromJson(json);
}

// ==================== 音乐治疗模型 ====================

@freezed
class MusicRecommendationResponse with _$MusicRecommendationResponse {
  const factory MusicRecommendationResponse({
    required List<MusicTrack> tracks,
    required int total,
  }) = _MusicRecommendationResponse;

  factory MusicRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$MusicRecommendationResponseFromJson(json);
}

@freezed
class MeditationMusicResponse with _$MeditationMusicResponse {
  const factory MeditationMusicResponse({
    required List<MeditationTrack> tracks,
    required int total,
  }) = _MeditationMusicResponse;

  factory MeditationMusicResponse.fromJson(Map<String, dynamic> json) =>
      _$MeditationMusicResponseFromJson(json);
}

@freezed
class RelaxationMusicResponse with _$RelaxationMusicResponse {
  const factory RelaxationMusicResponse({
    required List<RelaxationTrack> tracks,
    required int total,
  }) = _RelaxationMusicResponse;

  factory RelaxationMusicResponse.fromJson(Map<String, dynamic> json) =>
      _$RelaxationMusicResponseFromJson(json);
}

@freezed
class FocusMusicResponse with _$FocusMusicResponse {
  const factory FocusMusicResponse({
    required List<FocusTrack> tracks,
    required int total,
  }) = _FocusMusicResponse;

  factory FocusMusicResponse.fromJson(Map<String, dynamic> json) =>
      _$FocusMusicResponseFromJson(json);
}

@freezed
class SleepMusicResponse with _$SleepMusicResponse {
  const factory SleepMusicResponse({
    required List<SleepTrack> tracks,
    required int total,
  }) = _SleepMusicResponse;

  factory SleepMusicResponse.fromJson(Map<String, dynamic> json) =>
      _$SleepMusicResponseFromJson(json);
}

@freezed
class WorkoutMusicResponse with _$WorkoutMusicResponse {
  const factory WorkoutMusicResponse({
    required List<WorkoutTrack> tracks,
    required int total,
  }) = _WorkoutMusicResponse;

  factory WorkoutMusicResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkoutMusicResponseFromJson(json);
}

@freezed
class MoodMusicResponse with _$MoodMusicResponse {
  const factory MoodMusicResponse({
    required List<MoodTrack> tracks,
    required int total,
  }) = _MoodMusicResponse;

  factory MoodMusicResponse.fromJson(Map<String, dynamic> json) =>
      _$MoodMusicResponseFromJson(json);
}

@freezed
class MusicPlayResponse with _$MusicPlayResponse {
  const factory MusicPlayResponse({
    required String sessionId,
    required String status,
    required String currentTrack,
    required int position,
  }) = _MusicPlayResponse;

  factory MusicPlayResponse.fromJson(Map<String, dynamic> json) =>
      _$MusicPlayResponseFromJson(json);
}

@freezed
class MusicHistoryResponse with _$MusicHistoryResponse {
  const factory MusicHistoryResponse({
    required List<MusicHistoryEntry> entries,
    required int total,
    required int page,
    required int limit,
  }) = _MusicHistoryResponse;

  factory MusicHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$MusicHistoryResponseFromJson(json);
}

// ==================== 请求模型 ====================

@freezed
class RandomFoodRequest with _$RandomFoodRequest {
  const factory RandomFoodRequest({
    @Default([]) List<String> excludeCategories,
    @Default([]) List<String> excludeAllergens,
    @Default({}) Map<String, dynamic> preferences,
  }) = _RandomFoodRequest;

  factory RandomFoodRequest.fromJson(Map<String, dynamic> json) =>
      _$RandomFoodRequestFromJson(json);
}

@freezed
class FoodPreferenceRequest with _$FoodPreferenceRequest {
  const factory FoodPreferenceRequest({
    required String cuisine,
    required String category,
    @Default([]) List<String> ingredients,
    @Default([]) List<String> allergens,
    @Default({}) Map<String, dynamic> preferences,
  }) = _FoodPreferenceRequest;

  factory FoodPreferenceRequest.fromJson(Map<String, dynamic> json) =>
      _$FoodPreferenceRequestFromJson(json);
}

@freezed
class NearbyRestaurantRequest with _$NearbyRestaurantRequest {
  const factory NearbyRestaurantRequest({
    required double latitude,
    required double longitude,
    @Default(5.0) double radius,
    @Default([]) List<String> cuisines,
    @Default({}) Map<String, dynamic> filters,
  }) = _NearbyRestaurantRequest;

  factory NearbyRestaurantRequest.fromJson(Map<String, dynamic> json) =>
      _$NearbyRestaurantRequestFromJson(json);
}

@freezed
class FoodNutritionRequest with _$FoodNutritionRequest {
  const factory FoodNutritionRequest({
    required String foodName,
    @Default(1.0) double quantity,
    @Default('serving') String unit,
  }) = _FoodNutritionRequest;

  factory FoodNutritionRequest.fromJson(Map<String, dynamic> json) =>
      _$FoodNutritionRequestFromJson(json);
}

@freezed
class FoodRecipeRequest with _$FoodRecipeRequest {
  const factory FoodRecipeRequest({
    required String foodName,
    @Default([]) List<String> ingredients,
    @Default({}) Map<String, dynamic> preferences,
  }) = _FoodRecipeRequest;

  factory FoodRecipeRequest.fromJson(Map<String, dynamic> json) =>
      _$FoodRecipeRequestFromJson(json);
}

@freezed
class FoodReviewsRequest with _$FoodReviewsRequest {
  const factory FoodReviewsRequest({
    required String foodName,
    @Default(10) int limit,
  }) = _FoodReviewsRequest;

  factory FoodReviewsRequest.fromJson(Map<String, dynamic> json) =>
      _$FoodReviewsRequestFromJson(json);
}

@freezed
class SaveFavoriteFoodRequest with _$SaveFavoriteFoodRequest {
  const factory SaveFavoriteFoodRequest({
    required String foodId,
    required String foodName,
    @Default({}) Map<String, dynamic> metadata,
  }) = _SaveFavoriteFoodRequest;

  factory SaveFavoriteFoodRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveFavoriteFoodRequestFromJson(json);
}

// 创建娱乐活动请求
@freezed
class CreateEntertainmentActivityRequest with _$CreateEntertainmentActivityRequest {
  const factory CreateEntertainmentActivityRequest({
    required String name,
    required String description,
    required String type,
    required String category,
    required String icon,
    required String color,
    @Default(0) int duration,
    @Default(0) int difficulty,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<String> tags,
  }) = _CreateEntertainmentActivityRequest;

  factory CreateEntertainmentActivityRequest.fromJson(Map<String, dynamic> json) => _$CreateEntertainmentActivityRequestFromJson(json);
}

// 创建生活记录请求
@freezed
class CreateLifeRecordRequest with _$CreateLifeRecordRequest {
  const factory CreateLifeRecordRequest({
    required String type,
    required String title,
    required String content,
    @Default({}) Map<String, dynamic> data,
    @Default([]) List<String> images,
    @Default([]) List<String> tags,
    @Default(0) int mood,
    @Default(0) int energy,
    @Default(0) int productivity,
  }) = _CreateLifeRecordRequest;

  factory CreateLifeRecordRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeRecordRequestFromJson(json);
}

// 创建生活目标请求
@freezed
class CreateLifeGoalRequest with _$CreateLifeGoalRequest {
  const factory CreateLifeGoalRequest({
    required String title,
    required String description,
    required String category,
    required String type,
    @Default(0) int targetValue,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> milestones,
    DateTime? targetDate,
  }) = _CreateLifeGoalRequest;

  factory CreateLifeGoalRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeGoalRequestFromJson(json);
}

// 创建生活提醒请求
@freezed
class CreateLifeReminderRequest with _$CreateLifeReminderRequest {
  const factory CreateLifeReminderRequest({
    required String title,
    required String description,
    required String type,
    required String frequency,
    required DateTime scheduledTime,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> tags,
  }) = _CreateLifeReminderRequest;

  factory CreateLifeReminderRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeReminderRequestFromJson(json);
}

// 创建生活习惯请求
@freezed
class CreateLifeHabitRequest with _$CreateLifeHabitRequest {
  const factory CreateLifeHabitRequest({
    required String name,
    required String description,
    required String category,
    required String frequency,
    @Default(0) int targetCount,
    @Default({}) Map<String, dynamic> settings,
    @Default([]) List<String> tags,
  }) = _CreateLifeHabitRequest;

  factory CreateLifeHabitRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeHabitRequestFromJson(json);
}

// 创建生活事件请求
@freezed
class CreateLifeEventRequest with _$CreateLifeEventRequest {
  const factory CreateLifeEventRequest({
    required String title,
    required String description,
    required String type,
    required String category,
    required DateTime startTime,
    required DateTime endTime,
    @Default({}) Map<String, dynamic> location,
    @Default([]) List<String> participants,
    @Default([]) List<String> tags,
    @Default(false) bool isAllDay,
    @Default(false) bool isRecurring,
    @Default({}) Map<String, dynamic> recurrence,
  }) = _CreateLifeEventRequest;

  factory CreateLifeEventRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeEventRequestFromJson(json);
}

// 创建生活笔记请求
@freezed
class CreateLifeNoteRequest with _$CreateLifeNoteRequest {
  const factory CreateLifeNoteRequest({
    required String title,
    required String content,
    required String category,
    @Default({}) Map<String, dynamic> metadata,
    @Default([]) List<String> tags,
    @Default([]) List<String> attachments,
    @Default(false) bool isPrivate,
  }) = _CreateLifeNoteRequest;

  factory CreateLifeNoteRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeNoteRequestFromJson(json);
}

// 创建生活分享请求
@freezed
class CreateLifeShareRequest with _$CreateLifeShareRequest {
  const factory CreateLifeShareRequest({
    required String content,
    required String type,
    @Default([]) List<String> images,
    @Default([]) List<String> videos,
    @Default([]) List<String> tags,
    @Default(false) bool isPublic,
  }) = _CreateLifeShareRequest;

  factory CreateLifeShareRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeShareRequestFromJson(json);
}

// 创建生活评论请求
@freezed
class CreateLifeCommentRequest with _$CreateLifeCommentRequest {
  const factory CreateLifeCommentRequest({
    required String content,
  }) = _CreateLifeCommentRequest;

  factory CreateLifeCommentRequest.fromJson(Map<String, dynamic> json) => _$CreateLifeCommentRequestFromJson(json);
}

// 响应模型
@freezed
class LifeModeResponse with _$LifeModeResponse {
  const factory LifeModeResponse({
    required LifeMode lifeMode,
    required String status,
  }) = _LifeModeResponse;

  factory LifeModeResponse.fromJson(Map<String, dynamic> json) => _$LifeModeResponseFromJson(json);
}

@freezed
class EntertainmentActivityResponse with _$EntertainmentActivityResponse {
  const factory EntertainmentActivityResponse({
    required EntertainmentActivity activity,
    required String status,
  }) = _EntertainmentActivityResponse;

  factory EntertainmentActivityResponse.fromJson(Map<String, dynamic> json) => _$EntertainmentActivityResponseFromJson(json);
}

@freezed
class LifeRecordResponse with _$LifeRecordResponse {
  const factory LifeRecordResponse({
    required LifeRecord record,
    required String status,
  }) = _LifeRecordResponse;

  factory LifeRecordResponse.fromJson(Map<String, dynamic> json) => _$LifeRecordResponseFromJson(json);
}

@freezed
class LifeGoalResponse with _$LifeGoalResponse {
  const factory LifeGoalResponse({
    required LifeGoal goal,
    required String status,
  }) = _LifeGoalResponse;

  factory LifeGoalResponse.fromJson(Map<String, dynamic> json) => _$LifeGoalResponseFromJson(json);
}

@freezed
class LifeReminderResponse with _$LifeReminderResponse {
  const factory LifeReminderResponse({
    required LifeReminder reminder,
    required String status,
  }) = _LifeReminderResponse;

  factory LifeReminderResponse.fromJson(Map<String, dynamic> json) => _$LifeReminderResponseFromJson(json);
}

@freezed
class LifeHabitResponse with _$LifeHabitResponse {
  const factory LifeHabitResponse({
    required LifeHabit habit,
    required String status,
  }) = _LifeHabitResponse;

  factory LifeHabitResponse.fromJson(Map<String, dynamic> json) => _$LifeHabitResponseFromJson(json);
}

@freezed
class LifeEventResponse with _$LifeEventResponse {
  const factory LifeEventResponse({
    required LifeEvent event,
    required String status,
  }) = _LifeEventResponse;

  factory LifeEventResponse.fromJson(Map<String, dynamic> json) => _$LifeEventResponseFromJson(json);
}

@freezed
class LifeNoteResponse with _$LifeNoteResponse {
  const factory LifeNoteResponse({
    required LifeNote note,
    required String status,
  }) = _LifeNoteResponse;

  factory LifeNoteResponse.fromJson(Map<String, dynamic> json) => _$LifeNoteResponseFromJson(json);
}

@freezed
class LifeShareResponse with _$LifeShareResponse {
  const factory LifeShareResponse({
    required LifeShare share,
    required String status,
  }) = _LifeShareResponse;

  factory LifeShareResponse.fromJson(Map<String, dynamic> json) => _$LifeShareResponseFromJson(json);
}

@freezed
class LifeCommentResponse with _$LifeCommentResponse {
  const factory LifeCommentResponse({
    required LifeComment comment,
    required String status,
  }) = _LifeCommentResponse;

  factory LifeCommentResponse.fromJson(Map<String, dynamic> json) => _$LifeCommentResponseFromJson(json);
}

// 列表响应模型
@freezed
class LifeModesListResponse with _$LifeModesListResponse {
  const factory LifeModesListResponse({
    required List<LifeMode> lifeModes,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeModesListResponse;

  factory LifeModesListResponse.fromJson(Map<String, dynamic> json) => _$LifeModesListResponseFromJson(json);
}

@freezed
class EntertainmentActivitiesListResponse with _$EntertainmentActivitiesListResponse {
  const factory EntertainmentActivitiesListResponse({
    required List<EntertainmentActivity> activities,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _EntertainmentActivitiesListResponse;

  factory EntertainmentActivitiesListResponse.fromJson(Map<String, dynamic> json) => _$EntertainmentActivitiesListResponseFromJson(json);
}

@freezed
class LifeRecordsListResponse with _$LifeRecordsListResponse {
  const factory LifeRecordsListResponse({
    required List<LifeRecord> records,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeRecordsListResponse;

  factory LifeRecordsListResponse.fromJson(Map<String, dynamic> json) => _$LifeRecordsListResponseFromJson(json);
}

@freezed
class LifeGoalsListResponse with _$LifeGoalsListResponse {
  const factory LifeGoalsListResponse({
    required List<LifeGoal> goals,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeGoalsListResponse;

  factory LifeGoalsListResponse.fromJson(Map<String, dynamic> json) => _$LifeGoalsListResponseFromJson(json);
}

@freezed
class LifeRemindersListResponse with _$LifeRemindersListResponse {
  const factory LifeRemindersListResponse({
    required List<LifeReminder> reminders,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeRemindersListResponse;

  factory LifeRemindersListResponse.fromJson(Map<String, dynamic> json) => _$LifeRemindersListResponseFromJson(json);
}

@freezed
class LifeHabitsListResponse with _$LifeHabitsListResponse {
  const factory LifeHabitsListResponse({
    required List<LifeHabit> habits,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeHabitsListResponse;

  factory LifeHabitsListResponse.fromJson(Map<String, dynamic> json) => _$LifeHabitsListResponseFromJson(json);
}

@freezed
class LifeEventsListResponse with _$LifeEventsListResponse {
  const factory LifeEventsListResponse({
    required List<LifeEvent> events,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeEventsListResponse;

  factory LifeEventsListResponse.fromJson(Map<String, dynamic> json) => _$LifeEventsListResponseFromJson(json);
}

@freezed
class LifeNotesListResponse with _$LifeNotesListResponse {
  const factory LifeNotesListResponse({
    required List<LifeNote> notes,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeNotesListResponse;

  factory LifeNotesListResponse.fromJson(Map<String, dynamic> json) => _$LifeNotesListResponseFromJson(json);
}

@freezed
class LifeSharesListResponse with _$LifeSharesListResponse {
  const factory LifeSharesListResponse({
    required List<LifeShare> shares,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeSharesListResponse;

  factory LifeSharesListResponse.fromJson(Map<String, dynamic> json) => _$LifeSharesListResponseFromJson(json);
}

@freezed
class LifeCommentsListResponse with _$LifeCommentsListResponse {
  const factory LifeCommentsListResponse({
    required List<LifeComment> comments,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeCommentsListResponse;

  factory LifeCommentsListResponse.fromJson(Map<String, dynamic> json) => _$LifeCommentsListResponseFromJson(json);
}

@freezed
class LifeNotificationsListResponse with _$LifeNotificationsListResponse {
  const factory LifeNotificationsListResponse({
    required List<LifeNotification> notifications,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _LifeNotificationsListResponse;

  factory LifeNotificationsListResponse.fromJson(Map<String, dynamic> json) => _$LifeNotificationsListResponseFromJson(json);
}

// 更新请求模型
@freezed
class UpdateLifeModeRequest with _$UpdateLifeModeRequest {
  const factory UpdateLifeModeRequest({
    String? name,
    String? description,
    String? category,
    String? icon,
    String? color,
    int? duration,
    Map<String, dynamic>? settings,
    List<String>? tags,
    bool? isActive,
  }) = _UpdateLifeModeRequest;

  factory UpdateLifeModeRequest.fromJson(Map<String, dynamic> json) => _$UpdateLifeModeRequestFromJson(json);
}

@freezed
class UpdateEntertainmentActivityRequest with _$UpdateEntertainmentActivityRequest {
  const factory UpdateEntertainmentActivityRequest({
    String? name,
    String? description,
    String? type,
    String? category,
    String? icon,
    String? color,
    int? duration,
    int? difficulty,
    Map<String, dynamic>? metadata,
    List<String>? tags,
    bool? isCompleted,
  }) = _UpdateEntertainmentActivityRequest;

  factory UpdateEntertainmentActivityRequest.fromJson(Map<String, dynamic> json) => _$UpdateEntertainmentActivityRequestFromJson(json);
}

@freezed
class UpdateLifeGoalRequest with _$UpdateLifeGoalRequest {
  const factory UpdateLifeGoalRequest({
    String? title,
    String? description,
    String? category,
    String? type,
    String? status,
    int? targetValue,
    int? currentValue,
    int? progress,
    Map<String, dynamic>? settings,
    List<String>? milestones,
    DateTime? targetDate,
  }) = _UpdateLifeGoalRequest;

  factory UpdateLifeGoalRequest.fromJson(Map<String, dynamic> json) => _$UpdateLifeGoalRequestFromJson(json);
}

@freezed
class UpdateLifeHabitRequest with _$UpdateLifeHabitRequest {
  const factory UpdateLifeHabitRequest({
    String? name,
    String? description,
    String? category,
    String? frequency,
    int? targetCount,
    int? currentCount,
    int? streak,
    Map<String, dynamic>? settings,
    List<String>? tags,
    bool? isActive,
  }) = _UpdateLifeHabitRequest;

  factory UpdateLifeHabitRequest.fromJson(Map<String, dynamic> json) => _$UpdateLifeHabitRequestFromJson(json);
}

// 完成请求模型
@freezed
class CompleteEntertainmentActivityRequest with _$CompleteEntertainmentActivityRequest {
  const factory CompleteEntertainmentActivityRequest({
    @Default({}) Map<String, dynamic> feedback,
    @Default(0) int rating,
    String? comment,
  }) = _CompleteEntertainmentActivityRequest;

  factory CompleteEntertainmentActivityRequest.fromJson(Map<String, dynamic> json) => _$CompleteEntertainmentActivityRequestFromJson(json);
}

@freezed
class CompleteLifeHabitRequest with _$CompleteLifeHabitRequest {
  const factory CompleteLifeHabitRequest({
    @Default({}) Map<String, dynamic> data,
    String? note,
  }) = _CompleteLifeHabitRequest;

  factory CompleteLifeHabitRequest.fromJson(Map<String, dynamic> json) => _$CompleteLifeHabitRequestFromJson(json);
}

@freezed
class CompleteLifeGoalRequest with _$CompleteLifeGoalRequest {
  const factory CompleteLifeGoalRequest({
    @Default({}) Map<String, dynamic> data,
    String? note,
  }) = _CompleteLifeGoalRequest;

  factory CompleteLifeGoalRequest.fromJson(Map<String, dynamic> json) => _$CompleteLifeGoalRequestFromJson(json);
}

// 统计请求模型
@freezed
class GenerateLifeStatisticsRequest with _$GenerateLifeStatisticsRequest {
  const factory GenerateLifeStatisticsRequest({
    required String period,
    @Default({}) Map<String, dynamic> filters,
  }) = _GenerateLifeStatisticsRequest;

  factory GenerateLifeStatisticsRequest.fromJson(Map<String, dynamic> json) => _$GenerateLifeStatisticsRequestFromJson(json);
}

@freezed
class LifeStatisticsResponse with _$LifeStatisticsResponse {
  const factory LifeStatisticsResponse({
    required LifeStatistics statistics,
    required String status,
  }) = _LifeStatisticsResponse;

  factory LifeStatisticsResponse.fromJson(Map<String, dynamic> json) => _$LifeStatisticsResponseFromJson(json);
}

// 添加缺失的模型类
@freezed
class UpdateLifeRecordRequest with _$UpdateLifeRecordRequest {
  const factory UpdateLifeRecordRequest({
    String? type,
    String? title,
    String? content,
    Map<String, dynamic>? data,
    List<String>? images,
    List<String>? tags,
    int? mood,
    int? energy,
    int? productivity,
  }) = _UpdateLifeRecordRequest;

  factory UpdateLifeRecordRequest.fromJson(Map<String, dynamic> json) => _$UpdateLifeRecordRequestFromJson(json);
}

@freezed
class RecordEmotionRequest with _$RecordEmotionRequest {
  const factory RecordEmotionRequest({
    required String emotion,
    required int intensity,
    required String trigger,
    required String context,
    required Map<String, dynamic> metadata,
  }) = _RecordEmotionRequest;

  factory RecordEmotionRequest.fromJson(Map<String, dynamic> json) => _$RecordEmotionRequestFromJson(json);
}

@freezed
class EmotionRecord with _$EmotionRecord {
  const factory EmotionRecord({
    required String id,
    required String emotion,
    required int intensity,
    required String trigger,
    required String context,
    required Map<String, dynamic> metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _EmotionRecord;

  factory EmotionRecord.fromJson(Map<String, dynamic> json) => _$EmotionRecordFromJson(json);
}

@freezed
class EmotionRecordListResponse with _$EmotionRecordListResponse {
  const factory EmotionRecordListResponse({
    required List<EmotionRecord> records,
    required int total,
    required int page,
    required int limit,
  }) = _EmotionRecordListResponse;

  factory EmotionRecordListResponse.fromJson(Map<String, dynamic> json) => _$EmotionRecordListResponseFromJson(json);
}

@freezed
class EmotionAnalysisResponse with _$EmotionAnalysisResponse {
  const factory EmotionAnalysisResponse({
    required Map<String, int> emotionDistribution,
    required List<EmotionTrend> trends,
    required Map<String, dynamic> insights,
    required List<String> recommendations,
  }) = _EmotionAnalysisResponse;

  factory EmotionAnalysisResponse.fromJson(Map<String, dynamic> json) => _$EmotionAnalysisResponseFromJson(json);
}

@freezed
class EmotionTrend with _$EmotionTrend {
  const factory EmotionTrend({
    required String emotion,
    required List<int> values,
    required List<String> dates,
  }) = _EmotionTrend;

  factory EmotionTrend.fromJson(Map<String, dynamic> json) => _$EmotionTrendFromJson(json);
}
