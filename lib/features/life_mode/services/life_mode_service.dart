import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/life_mode_model.dart';

part 'life_mode_service.g.dart';

/// LifeMode 核心服务 - 调用Go后端API
@RestApi(baseUrl: "http://localhost:8080/api/v1")
abstract class LifeModeService {
  factory LifeModeService(Dio dio, {String baseUrl}) = _LifeModeService;

  // ==================== 生活记录 ====================
  
  /// 创建生活记录
  @POST('/life-records/create')
  Future<LifeRecord> createLifeRecord(@Body() CreateLifeRecordRequest request);
  
  /// 获取生活记录列表
  @GET('/life-records/list')
  Future<LifeRecordListResponse> getLifeRecordList(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取生活记录详情
  @GET('/life-records/{id}')
  Future<LifeRecord> getLifeRecord(@Path('id') String id);
  
  /// 更新生活记录
  @PUT('/life-records/{id}')
  Future<LifeRecord> updateLifeRecord(@Path('id') String id, @Body() UpdateLifeRecordRequest request);
  
  /// 删除生活记录
  @DELETE('/life-records/{id}')
  Future<void> deleteLifeRecord(@Path('id') String id);

  // ==================== 情绪管理 ====================
  
  /// 记录情绪
  @POST('/emotion/record')
  Future<EmotionRecord> recordEmotion(@Body() RecordEmotionRequest request);
  
  /// 获取情绪记录列表
  @GET('/emotion/records')
  Future<EmotionRecordListResponse> getEmotionRecords(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取情绪分析
  @GET('/emotion/analysis')
  Future<EmotionAnalysisResponse> getEmotionAnalysis(@Query('period') String period);
  
  /// 获取情绪建议
  @POST('/emotion/suggestions')
  Future<EmotionSuggestionsResponse> getEmotionSuggestions(@Body() EmotionSuggestionsRequest request);

  // ==================== 冥想指南 ====================
  
  /// 开始冥想
  @POST('/meditation/start')
  Future<MeditationSession> startMeditation(@Body() StartMeditationRequest request);
  
  /// 结束冥想
  @POST('/meditation/end')
  Future<MeditationSession> endMeditation(@Path('id') String id, @Body() EndMeditationRequest request);
  
  /// 获取冥想历史
  @GET('/meditation/history')
  Future<MeditationHistoryResponse> getMeditationHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取冥想统计
  @GET('/meditation/stats')
  Future<MeditationStatsResponse> getMeditationStats(@Query('period') String period);

  // ==================== 生活目标 ====================
  
  /// 创建生活目标
  @POST('/life-goals/create')
  Future<LifeGoal> createLifeGoal(@Body() CreateLifeGoalRequest request);
  
  /// 获取生活目标列表
  @GET('/life-goals/list')
  Future<LifeGoalListResponse> getLifeGoalList(@Query('page') int page, @Query('limit') int limit);
  
  /// 更新生活目标进度
  @PUT('/life-goals/{id}/progress')
  Future<LifeGoal> updateLifeGoalProgress(@Path('id') String id, @Body() UpdateLifeGoalProgressRequest request);
  
  /// 完成生活目标
  @PUT('/life-goals/{id}/complete')
  Future<LifeGoal> completeLifeGoal(@Path('id') String id);

  // ==================== 时间胶囊 ====================
  
  /// 创建时间胶囊
  @POST('/time-capsule/create')
  Future<TimeCapsule> createTimeCapsule(@Body() CreateTimeCapsuleRequest request);
  
  /// 获取时间胶囊列表
  @GET('/time-capsule/list')
  Future<TimeCapsuleListResponse> getTimeCapsuleList(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取时间胶囊详情
  @GET('/time-capsule/{id}')
  Future<TimeCapsule> getTimeCapsule(@Path('id') String id);
  
  /// 打开时间胶囊
  @PUT('/time-capsule/{id}/open')
  Future<TimeCapsule> openTimeCapsule(@Path('id') String id);
  
  /// 删除时间胶囊
  @DELETE('/time-capsule/{id}')
  Future<void> deleteTimeCapsule(@Path('id') String id);

  // ==================== 食物随机器 ====================
  
  /// 获取随机食物推荐
  @POST('/food-randomizer/random')
  Future<FoodRecommendation> getRandomFood(@Body() RandomFoodRequest request);
  
  /// 根据偏好获取食物推荐
  @POST('/food-randomizer/preference')
  Future<FoodRecommendation> getFoodByPreference(@Body() FoodPreferenceRequest request);
  
  /// 获取附近餐厅推荐
  @POST('/food-randomizer/nearby')
  Future<RestaurantRecommendation> getNearbyRestaurants(@Body() NearbyRestaurantRequest request);
  
  /// 获取食物营养信息
  @POST('/food-randomizer/nutrition')
  Future<NutritionInfo> getFoodNutrition(@Body() FoodNutritionRequest request);
  
  /// 获取食物制作方法
  @POST('/food-randomizer/recipe')
  Future<Recipe> getFoodRecipe(@Body() FoodRecipeRequest request);
  
  /// 获取食物评价
  @POST('/food-randomizer/reviews')
  Future<FoodReviewsResponse> getFoodReviews(@Body() FoodReviewsRequest request);
  
  /// 保存喜欢的食物
  @POST('/food-randomizer/favorite')
  Future<void> saveFavoriteFood(@Body() SaveFavoriteFoodRequest request);
  
  /// 获取喜欢的食物列表
  @GET('/food-randomizer/favorites')
  Future<FavoriteFoodListResponse> getFavoriteFoods(@Query('page') int page, @Query('limit') int limit);

  // ==================== 旅行指南 ====================
  
  /// 获取旅行目的地推荐
  @POST('/travel-guide/destinations')
  Future<TravelDestinationResponse> getTravelDestinations(@Body() TravelDestinationRequest request);
  
  /// 生成旅行计划
  @POST('/travel-guide/itinerary')
  Future<TravelItinerary> generateTravelItinerary(@Body() TravelItineraryRequest request);
  
  /// 获取景点信息
  @POST('/travel-guide/attractions')
  Future<TravelAttractionsResponse> getTravelAttractions(@Body() TravelAttractionsRequest request);
  
  /// 获取住宿推荐
  @POST('/travel-guide/accommodations')
  Future<TravelAccommodationsResponse> getTravelAccommodations(@Body() TravelAccommodationsRequest request);
  
  /// 获取交通信息
  @POST('/travel-guide/transportation')
  Future<TravelTransportationResponse> getTravelTransportation(@Body() TravelTransportationRequest request);
  
  /// 获取天气信息
  @POST('/travel-guide/weather')
  Future<TravelWeatherResponse> getTravelWeather(@Body() TravelWeatherRequest request);
  
  /// 获取当地文化信息
  @POST('/travel-guide/culture')
  Future<TravelCultureResponse> getTravelCulture(@Body() TravelCultureRequest request);
  
  /// 获取旅行预算
  @POST('/travel-guide/budget')
  Future<TravelBudgetResponse> getTravelBudget(@Body() TravelBudgetRequest request);
  
  /// 保存旅行计划
  @POST('/travel-guide/save-plan')
  Future<TravelPlan> saveTravelPlan(@Body() SaveTravelPlanRequest request);
  
  /// 获取旅行计划列表
  @GET('/travel-guide/plans')
  Future<TravelPlanListResponse> getTravelPlans(@Query('page') int page, @Query('limit') int limit);

  // ==================== 音乐治疗 ====================
  
  /// 获取音乐推荐
  @POST('/music-therapy/recommendations')
  Future<MusicRecommendationResponse> getMusicRecommendations(@Body() MusicRecommendationRequest request);
  
  /// 获取冥想音乐
  @POST('/music-therapy/meditation')
  Future<MeditationMusicResponse> getMeditationMusic(@Body() MeditationMusicRequest request);
  
  /// 获取放松音乐
  @POST('/music-therapy/relaxation')
  Future<RelaxationMusicResponse> getRelaxationMusic(@Body() RelaxationMusicRequest request);
  
  /// 获取专注音乐
  @POST('/music-therapy/focus')
  Future<FocusMusicResponse> getFocusMusic(@Body() FocusMusicRequest request);
  
  /// 获取睡眠音乐
  @POST('/music-therapy/sleep')
  Future<SleepMusicResponse> getSleepMusic(@Body() SleepMusicRequest request);
  
  /// 获取运动音乐
  @POST('/music-therapy/workout')
  Future<WorkoutMusicResponse> getWorkoutMusic(@Body() WorkoutMusicRequest request);
  
  /// 获取情绪音乐
  @POST('/music-therapy/mood')
  Future<MoodMusicResponse> getMoodMusic(@Body() MoodMusicRequest request);
  
  /// 播放音乐
  @POST('/music-therapy/play')
  Future<MusicPlayResponse> playMusic(@Body() MusicPlayRequest request);
  
  /// 停止音乐
  @POST('/music-therapy/stop')
  Future<void> stopMusic(@Body() MusicStopRequest request);
  
  /// 获取音乐播放历史
  @GET('/music-therapy/history')
  Future<MusicHistoryResponse> getMusicHistory(@Query('page') int page, @Query('limit') int limit);
}
