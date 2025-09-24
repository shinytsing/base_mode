import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/fittracker_model.dart';

part 'fittracker_service.g.dart';

/// FitTracker 核心服务 - 调用Go后端API
@RestApi(baseUrl: "http://localhost:8080/api/v1")
abstract class FitTrackerService {
  factory FitTrackerService(Dio dio, {String baseUrl}) = _FitTrackerService;

  // ==================== 健身中心 ====================
  
  /// 创建训练计划
  @POST('/fitness/training-plans')
  Future<TrainingPlan> createTrainingPlan(@Body() CreateTrainingPlanRequest request);
  
  /// 获取训练计划列表
  @GET('/fitness/training-plans')
  Future<TrainingPlanListResponse> getTrainingPlans(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取训练计划详情
  @GET('/fitness/training-plans/{id}')
  Future<TrainingPlan> getTrainingPlan(@Path('id') String id);
  
  /// 开始训练
  @POST('/fitness/training-sessions')
  Future<TrainingSession> startTraining(@Body() StartTrainingRequest request);
  
  /// 结束训练
  @PUT('/fitness/training-sessions/{id}/end')
  Future<TrainingSession> endTraining(@Path('id') String id, @Body() EndTrainingRequest request);
  
  /// 获取训练历史
  @GET('/fitness/training-sessions')
  Future<TrainingSessionListResponse> getTrainingSessions(@Query('page') int page, @Query('limit') int limit);

  // ==================== BMI计算器 ====================
  
  /// 计算BMI
  @POST('/health/bmi/calculate')
  Future<BMICalculation> calculateBMI(@Body() BMICalculationRequest request);
  
  /// 获取BMI历史
  @GET('/health/bmi/history')
  Future<BMIHistoryResponse> getBMIHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取健康评估
  @POST('/health/assessment')
  Future<HealthAssessment> getHealthAssessment(@Body() HealthAssessmentRequest request);

  // ==================== 营养计算器 ====================
  
  /// 计算卡路里
  @POST('/nutrition/calories/calculate')
  Future<CalorieCalculation> calculateCalories(@Body() CalorieCalculationRequest request);
  
  /// 获取营养分析
  @POST('/nutrition/analysis')
  Future<NutritionAnalysis> getNutritionAnalysis(@Body() NutritionAnalysisRequest request);
  
  /// 获取饮食建议
  @POST('/nutrition/recommendations')
  Future<DietRecommendations> getDietRecommendations(@Body() DietRecommendationsRequest request);
  
  /// 记录饮食
  @POST('/nutrition/food-log')
  Future<FoodLog> logFood(@Body() LogFoodRequest request);
  
  /// 获取饮食记录
  @GET('/nutrition/food-log')
  Future<FoodLogListResponse> getFoodLogs(@Query('page') int page, @Query('limit') int limit);

  // ==================== 签到日历 ====================
  
  /// 签到
  @POST('/habits/check-in')
  Future<CheckIn> checkIn(@Body() CheckInRequest request);
  
  /// 获取签到日历
  @GET('/habits/calendar')
  Future<CheckInCalendar> getCheckInCalendar(@Query('year') int year, @Query('month') int month);
  
  /// 获取习惯统计
  @GET('/habits/statistics')
  Future<HabitStatistics> getHabitStatistics(@Query('period') String period);

  // ==================== 运动追踪 ====================
  
  /// 记录运动
  @POST('/exercise/log')
  Future<ExerciseLog> logExercise(@Body() LogExerciseRequest request);
  
  /// 获取运动记录
  @GET('/exercise/logs')
  Future<ExerciseLogListResponse> getExerciseLogs(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取运动统计
  @GET('/exercise/statistics')
  Future<ExerciseStatistics> getExerciseStatistics(@Query('period') String period);
  
  /// 设置运动目标
  @POST('/exercise/goals')
  Future<ExerciseGoal> setExerciseGoal(@Body() SetExerciseGoalRequest request);
  
  /// 获取运动目标
  @GET('/exercise/goals')
  Future<ExerciseGoalListResponse> getExerciseGoals();

  // ==================== 健康监测 ====================
  
  /// 记录心率
  @POST('/health/heart-rate')
  Future<HeartRateRecord> recordHeartRate(@Body() RecordHeartRateRequest request);
  
  /// 获取心率历史
  @GET('/health/heart-rate/history')
  Future<HeartRateHistoryResponse> getHeartRateHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 记录睡眠
  @POST('/health/sleep')
  Future<SleepRecord> recordSleep(@Body() RecordSleepRequest request);
  
  /// 获取睡眠历史
  @GET('/health/sleep/history')
  Future<SleepHistoryResponse> getSleepHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 记录压力
  @POST('/health/stress')
  Future<StressRecord> recordStress(@Body() RecordStressRequest request);
  
  /// 获取压力历史
  @GET('/health/stress/history')
  Future<StressHistoryResponse> getStressHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取健康趋势分析
  @GET('/health/trends')
  Future<HealthTrends> getHealthTrends(@Query('period') String period);
  
  /// 获取健康报告
  @POST('/health/reports')
  Future<HealthReport> generateHealthReport(@Body() GenerateHealthReportRequest request);

  // ==================== 社区互动 ====================
  
  /// 发布健身动态
  @POST('/community/posts')
  Future<FitnessPost> createFitnessPost(@Body() CreateFitnessPostRequest request);
  
  /// 获取健身动态列表
  @GET('/community/posts')
  Future<FitnessPostListResponse> getFitnessPosts(@Query('page') int page, @Query('limit') int limit);
  
  /// 点赞动态
  @POST('/community/posts/{id}/like')
  Future<void> likePost(@Path('id') String id);
  
  /// 评论动态
  @POST('/community/posts/{id}/comments')
  Future<PostComment> commentPost(@Path('id') String id, @Body() CommentPostRequest request);
  
  /// 获取评论列表
  @GET('/community/posts/{id}/comments')
  Future<PostCommentListResponse> getPostComments(@Path('id') String id, @Query('page') int page, @Query('limit') int limit);
  
  /// 创建挑战
  @POST('/community/challenges')
  Future<FitnessChallenge> createChallenge(@Body() CreateChallengeRequest request);
  
  /// 参与挑战
  @POST('/community/challenges/{id}/join')
  Future<void> joinChallenge(@Path('id') String id);
  
  /// 获取挑战列表
  @GET('/community/challenges')
  Future<FitnessChallengeListResponse> getChallenges(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取挑战详情
  @GET('/community/challenges/{id}')
  Future<FitnessChallenge> getChallenge(@Path('id') String id);
  
  /// 获取用户排行榜
  @GET('/community/leaderboard')
  Future<LeaderboardResponse> getLeaderboard(@Query('period') String period, @Query('type') String type);
  
  /// 关注用户
  @POST('/community/follow')
  Future<void> followUser(@Body() FollowUserRequest request);
  
  /// 取消关注
  @DELETE('/community/follow/{userId}')
  Future<void> unfollowUser(@Path('userId') String userId);
  
  /// 获取关注列表
  @GET('/community/following')
  Future<UserListResponse> getFollowing(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取粉丝列表
  @GET('/community/followers')
  Future<UserListResponse> getFollowers(@Query('page') int page, @Query('limit') int limit);
}