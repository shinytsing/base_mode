import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/social_hub_model.dart';

part 'social_hub_service.g.dart';

/// SocialHub 核心服务 - 调用Go后端API
@RestApi(baseUrl: "http://localhost:8080/api/v1")
abstract class SocialHubService {
  factory SocialHubService(Dio dio, {String baseUrl}) = _SocialHubService;

  // ==================== 心链系统 ====================
  
  /// 开始随机匹配
  @POST('/heart-chain/start-matching')
  Future<MatchingSession> startMatching(@Body() StartMatchingRequest request);
  
  /// 停止匹配
  @POST('/heart-chain/stop-matching')
  Future<void> stopMatching(@Path('sessionId') String sessionId);
  
  /// 获取匹配结果
  @GET('/heart-chain/matches')
  Future<MatchListResponse> getMatches(@Query('page') int page, @Query('limit') int limit);
  
  /// 开始深度交流
  @POST('/heart-chain/conversations')
  Future<Conversation> startConversation(@Body() StartConversationRequest request);
  
  /// 获取对话列表
  @GET('/heart-chain/conversations')
  Future<ConversationListResponse> getConversations(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取对话详情
  @GET('/heart-chain/conversations/{id}')
  Future<Conversation> getConversation(@Path('id') String id);
  
  /// 发送消息
  @POST('/heart-chain/conversations/{id}/messages')
  Future<Message> sendMessage(@Path('id') String id, @Body() SendMessageRequest request);
  
  /// 获取消息历史
  @GET('/heart-chain/conversations/{id}/messages')
  Future<MessageListResponse> getMessages(@Path('id') String id, @Query('page') int page, @Query('limit') int limit);

  // ==================== 搭子活动 ====================
  
  /// 创建活动
  @POST('/activities/create')
  Future<Activity> createActivity(@Body() CreateActivityRequest request);
  
  /// 获取活动列表
  @GET('/activities/list')
  Future<ActivityListResponse> getActivities(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取活动详情
  @GET('/activities/{id}')
  Future<Activity> getActivity(@Path('id') String id);
  
  /// 参与活动
  @POST('/activities/{id}/join')
  Future<void> joinActivity(@Path('id') String id);
  
  /// 取消参与
  @DELETE('/activities/{id}/leave')
  Future<void> leaveActivity(@Path('id') String id);
  
  /// 获取我的活动
  @GET('/activities/my-activities')
  Future<ActivityListResponse> getMyActivities(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取参与的活动
  @GET('/activities/joined-activities')
  Future<ActivityListResponse> getJoinedActivities(@Query('page') int page, @Query('limit') int limit);

  // ==================== 社交订阅 ====================
  
  /// 关注用户
  @POST('/subscriptions/follow')
  Future<void> followUser(@Body() FollowUserRequest request);
  
  /// 取消关注
  @DELETE('/subscriptions/unfollow/{userId}')
  Future<void> unfollowUser(@Path('userId') String userId);
  
  /// 获取关注列表
  @GET('/subscriptions/following')
  Future<UserListResponse> getFollowing(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取粉丝列表
  @GET('/subscriptions/followers')
  Future<UserListResponse> getFollowers(@Query('page') int page, @Query('limit') int limit);
  
  /// 订阅动态
  @POST('/subscriptions/subscribe')
  Future<void> subscribeToUpdates(@Body() SubscribeToUpdatesRequest request);
  
  /// 获取订阅动态
  @GET('/subscriptions/feed')
  Future<FeedListResponse> getFeed(@Query('page') int page, @Query('limit') int limit);
  
  /// 设置通知偏好
  @PUT('/subscriptions/notification-preferences')
  Future<void> updateNotificationPreferences(@Body() UpdateNotificationPreferencesRequest request);

  // ==================== 聊天系统 ====================
  
  /// 创建群组
  @POST('/chat/groups')
  Future<ChatGroup> createGroup(@Body() CreateGroupRequest request);
  
  /// 获取群组列表
  @GET('/chat/groups')
  Future<ChatGroupListResponse> getGroups(@Query('page') int page, @Query('limit') int limit);
  
  /// 加入群组
  @POST('/chat/groups/{id}/join')
  Future<void> joinGroup(@Path('id') String id);
  
  /// 离开群组
  @DELETE('/chat/groups/{id}/leave')
  Future<void> leaveGroup(@Path('id') String id);
  
  /// 发送群组消息
  @POST('/chat/groups/{id}/messages')
  Future<ChatMessage> sendGroupMessage(@Path('id') String id, @Body() SendChatMessageRequest request);
  
  /// 获取群组消息
  @GET('/chat/groups/{id}/messages')
  Future<ChatMessageListResponse> getGroupMessages(@Path('id') String id, @Query('page') int page, @Query('limit') int limit);
  
  /// 开始语音通话
  @POST('/chat/voice-call')
  Future<VoiceCall> startVoiceCall(@Body() StartVoiceCallRequest request);
  
  /// 开始视频通话
  @POST('/chat/video-call')
  Future<VideoCall> startVideoCall(@Body() StartVideoCallRequest request);
  
  /// 结束通话
  @POST('/chat/calls/{id}/end')
  Future<void> endCall(@Path('id') String id);

  // ==================== 人际关系管理 ====================
  
  /// 添加联系人
  @POST('/relationships/contacts')
  Future<Contact> addContact(@Body() AddContactRequest request);
  
  /// 获取联系人列表
  @GET('/relationships/contacts')
  Future<ContactListResponse> getContacts(@Query('page') int page, @Query('limit') int limit);
  
  /// 更新关系状态
  @PUT('/relationships/{id}/status')
  Future<void> updateRelationshipStatus(@Path('id') String id, @Body() UpdateRelationshipStatusRequest request);
  
  /// 记录重要时刻
  @POST('/relationships/moments')
  Future<RelationshipMoment> recordMoment(@Body() RecordMomentRequest request);
  
  /// 获取关系时刻
  @GET('/relationships/moments')
  Future<RelationshipMomentListResponse> getMoments(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取关系分析
  @GET('/relationships/analysis')
  Future<RelationshipAnalysis> getRelationshipAnalysis(@Query('period') String period);

  // ==================== 社交分析 ====================
  
  /// 获取社交数据
  @GET('/analytics/social-data')
  Future<SocialData> getSocialData(@Query('period') String period);
  
  /// 获取互动统计
  @GET('/analytics/interaction-stats')
  Future<InteractionStats> getInteractionStats(@Query('period') String period);
  
  /// 获取关系图谱
  @GET('/analytics/relationship-graph')
  Future<RelationshipGraph> getRelationshipGraph();
  
  /// 获取社交洞察
  @GET('/analytics/insights')
  Future<SocialInsights> getSocialInsights(@Query('period') String period);
  
  /// 生成社交报告
  @POST('/analytics/reports')
  Future<SocialReport> generateSocialReport(@Body() GenerateSocialReportRequest request);

  // ==================== 活动推荐 ====================
  
  /// 获取推荐活动
  @GET('/recommendations/activities')
  Future<ActivityRecommendationResponse> getRecommendedActivities(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取推荐用户
  @GET('/recommendations/users')
  Future<UserRecommendationResponse> getRecommendedUsers(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取推荐群组
  @GET('/recommendations/groups')
  Future<GroupRecommendationResponse> getRecommendedGroups(@Query('page') int page, @Query('limit') int limit);
  
  /// 反馈推荐结果
  @POST('/recommendations/feedback')
  Future<void> feedbackRecommendation(@Body() FeedbackRecommendationRequest request);

  // ==================== 社交游戏 ====================
  
  /// 获取游戏列表
  @GET('/games/list')
  Future<GameListResponse> getGames(@Query('page') int page, @Query('limit') int limit);
  
  /// 开始游戏
  @POST('/games/{id}/start')
  Future<GameSession> startGame(@Path('id') String id, @Body() StartGameRequest request);
  
  /// 提交游戏结果
  @POST('/games/{id}/submit')
  Future<GameResult> submitGameResult(@Path('id') String id, @Body() SubmitGameResultRequest request);
  
  /// 获取游戏排行榜
  @GET('/games/{id}/leaderboard')
  Future<GameLeaderboardResponse> getGameLeaderboard(@Path('id') String id, @Query('period') String period);
  
  /// 获取挑战任务
  @GET('/games/challenges')
  Future<ChallengeListResponse> getChallenges(@Query('page') int page, @Query('limit') int limit);
  
  /// 完成挑战
  @POST('/games/challenges/{id}/complete')
  Future<void> completeChallenge(@Path('id') String id);
  
  /// 获取积分系统
  @GET('/games/points')
  Future<PointsSystem> getPointsSystem();
  
  /// 获取积分历史
  @GET('/games/points/history')
  Future<PointsHistoryResponse> getPointsHistory(@Query('page') int page, @Query('limit') int limit);
}
