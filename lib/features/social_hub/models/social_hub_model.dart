import 'package:freezed_annotation/freezed_annotation.dart';

part 'social_hub_model.freezed.dart';
part 'social_hub_model.g.dart';

// ==================== 心链系统模型 ====================

@freezed
class MatchingSession with _$MatchingSession {
  const factory MatchingSession({
    required String id,
    required String userId,
    required String status,
    required List<String> preferences,
    @Default({}) Map<String, dynamic> settings,
    DateTime? startTime,
    DateTime? endTime,
  }) = _MatchingSession;

  factory MatchingSession.fromJson(Map<String, dynamic> json) =>
      _$MatchingSessionFromJson(json);
}

@freezed
class Match with _$Match {
  const factory Match({
    required String id,
    required String userId1,
    required String userId2,
    required String userName1,
    required String userName2,
    required String userAvatar1,
    required String userAvatar2,
    required double compatibility,
    required List<String> commonInterests,
    required String status,
    DateTime? matchedAt,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) =>
      _$MatchFromJson(json);
}

@freezed
class Conversation with _$Conversation {
  const factory Conversation({
    required String id,
    required String userId1,
    required String userId2,
    required String userName1,
    required String userName2,
    required String userAvatar1,
    required String userAvatar2,
    required String status,
    required int messageCount,
    required Message? lastMessage,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    required String content,
    required String type,
    @Default([]) List<String> attachments,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

// ==================== 搭子活动模型 ====================

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String title,
    required String description,
    required String category,
    required String location,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
    required int currentParticipants,
    required String status,
    required String creatorId,
    required String creatorName,
    required String creatorAvatar,
    required List<String> tags,
    required List<String> images,
    @Default({}) Map<String, dynamic> settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}

// ==================== 社交订阅模型 ====================

@freezed
class SocialUser with _$SocialUser {
  const factory SocialUser({
    required String id,
    required String name,
    required String avatar,
    required String bio,
    @Default(0) int followers,
    @Default(0) int following,
    @Default(0) int posts,
    @Default(false) bool isFollowing,
    @Default([]) List<String> interests,
    @Default([]) List<String> badges,
    DateTime? lastActiveAt,
  }) = _SocialUser;

  factory SocialUser.fromJson(Map<String, dynamic> json) =>
      _$SocialUserFromJson(json);
}

@freezed
class FeedItem with _$FeedItem {
  const factory FeedItem({
    required String id,
    required String userId,
    required String userName,
    required String userAvatar,
    required String type,
    required String content,
    required List<String> images,
    required List<String> videos,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(false) bool isLiked,
    @Default([]) List<String> tags,
    DateTime? createdAt,
  }) = _FeedItem;

  factory FeedItem.fromJson(Map<String, dynamic> json) =>
      _$FeedItemFromJson(json);
}

@freezed
class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @Default(true) bool newFollowers,
    @Default(true) bool newMessages,
    @Default(true) bool activityUpdates,
    @Default(true) bool gameInvites,
    @Default(true) bool challengeUpdates,
    @Default(false) bool emailNotifications,
    @Default(false) bool pushNotifications,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);
}

// ==================== 聊天系统模型 ====================

@freezed
class ChatGroup with _$ChatGroup {
  const factory ChatGroup({
    required String id,
    required String name,
    required String description,
    required String avatar,
    required List<String> members,
    required int memberCount,
    required String creatorId,
    required String status,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ChatGroup;

  factory ChatGroup.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupFromJson(json);
}

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String groupId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String content,
    required String type,
    @Default([]) List<String> attachments,
    @Default([]) List<String> readBy,
    @Default(false) bool isRead,
    DateTime? createdAt,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

@freezed
class VoiceCall with _$VoiceCall {
  const factory VoiceCall({
    required String id,
    required String callerId,
    required String receiverId,
    required String status,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0) int duration,
  }) = _VoiceCall;

  factory VoiceCall.fromJson(Map<String, dynamic> json) =>
      _$VoiceCallFromJson(json);
}

@freezed
class VideoCall with _$VideoCall {
  const factory VideoCall({
    required String id,
    required String callerId,
    required String receiverId,
    required String status,
    required DateTime startTime,
    DateTime? endTime,
    @Default(0) int duration,
    @Default(false) bool isVideoEnabled,
  }) = _VideoCall;

  factory VideoCall.fromJson(Map<String, dynamic> json) =>
      _$VideoCallFromJson(json);
}

// ==================== 人际关系管理模型 ====================

@freezed
class Contact with _$Contact {
  const factory Contact({
    required String id,
    required String userId,
    required String name,
    required String avatar,
    required String relationship,
    required String status,
    required int interactionCount,
    required DateTime lastInteraction,
    @Default({}) Map<String, dynamic> notes,
    DateTime? createdAt,
  }) = _Contact;

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
}

@freezed
class RelationshipMoment with _$RelationshipMoment {
  const factory RelationshipMoment({
    required String id,
    required String contactId,
    required String title,
    required String description,
    required String type,
    required List<String> images,
    required DateTime momentDate,
    @Default({}) Map<String, dynamic> data,
    DateTime? createdAt,
  }) = _RelationshipMoment;

  factory RelationshipMoment.fromJson(Map<String, dynamic> json) =>
      _$RelationshipMomentFromJson(json);
}

@freezed
class RelationshipAnalysis with _$RelationshipAnalysis {
  const factory RelationshipAnalysis({
    required String period,
    required int totalContacts,
    required int activeContacts,
    required List<RelationshipInsight> insights,
    required List<String> recommendations,
    required Map<String, dynamic> statistics,
  }) = _RelationshipAnalysis;

  factory RelationshipAnalysis.fromJson(Map<String, dynamic> json) =>
      _$RelationshipAnalysisFromJson(json);
}

@freezed
class RelationshipInsight with _$RelationshipInsight {
  const factory RelationshipInsight({
    required String type,
    required String description,
    required double score,
    required List<String> suggestions,
  }) = _RelationshipInsight;

  factory RelationshipInsight.fromJson(Map<String, dynamic> json) =>
      _$RelationshipInsightFromJson(json);
}

// ==================== 社交分析模型 ====================

@freezed
class SocialData with _$SocialData {
  const factory SocialData({
    required String period,
    required int totalConnections,
    required int activeConnections,
    required int totalInteractions,
    required double averageInteractionRate,
    required List<SocialMetric> metrics,
  }) = _SocialData;

  factory SocialData.fromJson(Map<String, dynamic> json) =>
      _$SocialDataFromJson(json);
}

@freezed
class SocialMetric with _$SocialMetric {
  const factory SocialMetric({
    required String name,
    required double value,
    required String unit,
    required String trend,
    required String description,
  }) = _SocialMetric;

  factory SocialMetric.fromJson(Map<String, dynamic> json) =>
      _$SocialMetricFromJson(json);
}

@freezed
class InteractionStats with _$InteractionStats {
  const factory InteractionStats({
    required String period,
    required int totalMessages,
    required int totalCalls,
    required int totalActivities,
    required int totalGames,
    required List<InteractionTrend> trends,
  }) = _InteractionStats;

  factory InteractionStats.fromJson(Map<String, dynamic> json) =>
      _$InteractionStatsFromJson(json);
}

@freezed
class InteractionTrend with _$InteractionTrend {
  const factory InteractionTrend({
    required String date,
    required int messages,
    required int calls,
    required int activities,
    required int games,
  }) = _InteractionTrend;

  factory InteractionTrend.fromJson(Map<String, dynamic> json) =>
      _$InteractionTrendFromJson(json);
}

@freezed
class RelationshipGraph with _$RelationshipGraph {
  const factory RelationshipGraph({
    required List<GraphNode> nodes,
    required List<GraphEdge> edges,
    required Map<String, dynamic> layout,
  }) = _RelationshipGraph;

  factory RelationshipGraph.fromJson(Map<String, dynamic> json) =>
      _$RelationshipGraphFromJson(json);
}

@freezed
class GraphNode with _$GraphNode {
  const factory GraphNode({
    required String id,
    required String name,
    required String type,
    required Map<String, dynamic> properties,
  }) = _GraphNode;

  factory GraphNode.fromJson(Map<String, dynamic> json) =>
      _$GraphNodeFromJson(json);
}

@freezed
class GraphEdge with _$GraphEdge {
  const factory GraphEdge({
    required String id,
    required String source,
    required String target,
    required String type,
    required Map<String, dynamic> properties,
  }) = _GraphEdge;

  factory GraphEdge.fromJson(Map<String, dynamic> json) =>
      _$GraphEdgeFromJson(json);
}

@freezed
class SocialInsights with _$SocialInsights {
  const factory SocialInsights({
    required String period,
    required List<String> topInterests,
    required List<String> topActivities,
    required List<String> topConnections,
    required List<String> recommendations,
    required Map<String, dynamic> personalityInsights,
  }) = _SocialInsights;

  factory SocialInsights.fromJson(Map<String, dynamic> json) =>
      _$SocialInsightsFromJson(json);
}

@freezed
class SocialReport with _$SocialReport {
  const factory SocialReport({
    required String id,
    required String userId,
    required String period,
    required SocialSummary summary,
    required List<SocialMetric> metrics,
    required SocialInsights insights,
    required List<String> recommendations,
    DateTime? generatedAt,
  }) = _SocialReport;

  factory SocialReport.fromJson(Map<String, dynamic> json) =>
      _$SocialReportFromJson(json);
}

@freezed
class SocialSummary with _$SocialSummary {
  const factory SocialSummary({
    required double socialScore,
    required String status,
    required int totalConnections,
    required int activeConnections,
    required double averageInteractionRate,
    required String mostActiveTime,
    required String topInterest,
  }) = _SocialSummary;

  factory SocialSummary.fromJson(Map<String, dynamic> json) =>
      _$SocialSummaryFromJson(json);
}

// ==================== 活动推荐模型 ====================

@freezed
class ActivityRecommendation with _$ActivityRecommendation {
  const factory ActivityRecommendation({
    required String id,
    required String title,
    required String description,
    required String category,
    required String location,
    required DateTime startTime,
    required double relevanceScore,
    required List<String> reasons,
    required Activity activity,
  }) = _ActivityRecommendation;

  factory ActivityRecommendation.fromJson(Map<String, dynamic> json) =>
      _$ActivityRecommendationFromJson(json);
}

@freezed
class UserRecommendation with _$UserRecommendation {
  const factory UserRecommendation({
    required String id,
    required String name,
    required String avatar,
    required String bio,
    required double compatibilityScore,
    required List<String> commonInterests,
    required List<String> reasons,
    required SocialUser user,
  }) = _UserRecommendation;

  factory UserRecommendation.fromJson(Map<String, dynamic> json) =>
      _$UserRecommendationFromJson(json);
}

@freezed
class GroupRecommendation with _$GroupRecommendation {
  const factory GroupRecommendation({
    required String id,
    required String name,
    required String description,
    required String avatar,
    required int memberCount,
    required double relevanceScore,
    required List<String> reasons,
    required ChatGroup group,
  }) = _GroupRecommendation;

  factory GroupRecommendation.fromJson(Map<String, dynamic> json) =>
      _$GroupRecommendationFromJson(json);
}

// ==================== 社交游戏模型 ====================

@freezed
class Game with _$Game {
  const factory Game({
    required String id,
    required String name,
    required String description,
    required String category,
    required String difficulty,
    required int maxPlayers,
    required int duration,
    required String rules,
    required List<String> tags,
    @Default(0) int playCount,
    @Default(0) int rating,
    required String imageUrl,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) =>
      _$GameFromJson(json);
}

@freezed
class GameSession with _$GameSession {
  const factory GameSession({
    required String id,
    required String gameId,
    required String gameName,
    required List<String> players,
    required String status,
    required DateTime startTime,
    DateTime? endTime,
    @Default({}) Map<String, dynamic> gameData,
  }) = _GameSession;

  factory GameSession.fromJson(Map<String, dynamic> json) =>
      _$GameSessionFromJson(json);
}

@freezed
class GameResult with _$GameResult {
  const factory GameResult({
    required String id,
    required String sessionId,
    required String playerId,
    required String playerName,
    required int score,
    required int rank,
    required String status,
    required List<String> achievements,
    @Default({}) Map<String, dynamic> stats,
  }) = _GameResult;

  factory GameResult.fromJson(Map<String, dynamic> json) =>
      _$GameResultFromJson(json);
}

@freezed
class Challenge with _$Challenge {
  const factory Challenge({
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
    required List<String> rewards,
    @Default([]) List<String> tags,
  }) = _Challenge;

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);
}

@freezed
class PointsSystem with _$PointsSystem {
  const factory PointsSystem({
    required int totalPoints,
    required int level,
    required String levelName,
    required int pointsToNextLevel,
    required List<PointsActivity> recentActivities,
    required List<PointsReward> availableRewards,
  }) = _PointsSystem;

  factory PointsSystem.fromJson(Map<String, dynamic> json) =>
      _$PointsSystemFromJson(json);
}

@freezed
class PointsActivity with _$PointsActivity {
  const factory PointsActivity({
    required String id,
    required String type,
    required String description,
    required int points,
    required DateTime earnedAt,
  }) = _PointsActivity;

  factory PointsActivity.fromJson(Map<String, dynamic> json) =>
      _$PointsActivityFromJson(json);
}

@freezed
class PointsReward with _$PointsReward {
  const factory PointsReward({
    required String id,
    required String name,
    required String description,
    required int cost,
    required String type,
    required String status,
  }) = _PointsReward;

  factory PointsReward.fromJson(Map<String, dynamic> json) =>
      _$PointsRewardFromJson(json);
}

// ==================== 请求模型 ====================

@freezed
class StartMatchingRequest with _$StartMatchingRequest {
  const factory StartMatchingRequest({
    required List<String> preferences,
    @Default({}) Map<String, dynamic> settings,
  }) = _StartMatchingRequest;

  factory StartMatchingRequest.fromJson(Map<String, dynamic> json) =>
      _$StartMatchingRequestFromJson(json);
}

@freezed
class StartConversationRequest with _$StartConversationRequest {
  const factory StartConversationRequest({
    required String matchId,
    @Default({}) Map<String, dynamic> settings,
  }) = _StartConversationRequest;

  factory StartConversationRequest.fromJson(Map<String, dynamic> json) =>
      _$StartConversationRequestFromJson(json);
}

@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    required String content,
    required String type,
    @Default([]) List<String> attachments,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}

@freezed
class CreateActivityRequest with _$CreateActivityRequest {
  const factory CreateActivityRequest({
    required String title,
    required String description,
    required String category,
    required String location,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
    @Default([]) List<String> tags,
    @Default([]) List<String> images,
    @Default({}) Map<String, dynamic> settings,
  }) = _CreateActivityRequest;

  factory CreateActivityRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateActivityRequestFromJson(json);
}

@freezed
class FollowUserRequest with _$FollowUserRequest {
  const factory FollowUserRequest({
    required String userId,
  }) = _FollowUserRequest;

  factory FollowUserRequest.fromJson(Map<String, dynamic> json) =>
      _$FollowUserRequestFromJson(json);
}

@freezed
class SubscribeToUpdatesRequest with _$SubscribeToUpdatesRequest {
  const factory SubscribeToUpdatesRequest({
    required String type,
    required String targetId,
    @Default({}) Map<String, dynamic> settings,
  }) = _SubscribeToUpdatesRequest;

  factory SubscribeToUpdatesRequest.fromJson(Map<String, dynamic> json) =>
      _$SubscribeToUpdatesRequestFromJson(json);
}

@freezed
class UpdateNotificationPreferencesRequest with _$UpdateNotificationPreferencesRequest {
  const factory UpdateNotificationPreferencesRequest({
    required NotificationPreferences preferences,
  }) = _UpdateNotificationPreferencesRequest;

  factory UpdateNotificationPreferencesRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateNotificationPreferencesRequestFromJson(json);
}

@freezed
class CreateGroupRequest with _$CreateGroupRequest {
  const factory CreateGroupRequest({
    required String name,
    required String description,
    required String avatar,
    @Default([]) List<String> tags,
  }) = _CreateGroupRequest;

  factory CreateGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateGroupRequestFromJson(json);
}

@freezed
class SendChatMessageRequest with _$SendChatMessageRequest {
  const factory SendChatMessageRequest({
    required String content,
    required String type,
    @Default([]) List<String> attachments,
  }) = _SendChatMessageRequest;

  factory SendChatMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendChatMessageRequestFromJson(json);
}

@freezed
class StartVoiceCallRequest with _$StartVoiceCallRequest {
  const factory StartVoiceCallRequest({
    required String receiverId,
  }) = _StartVoiceCallRequest;

  factory StartVoiceCallRequest.fromJson(Map<String, dynamic> json) =>
      _$StartVoiceCallRequestFromJson(json);
}

@freezed
class StartVideoCallRequest with _$StartVideoCallRequest {
  const factory StartVideoCallRequest({
    required String receiverId,
    @Default(true) bool enableVideo,
  }) = _StartVideoCallRequest;

  factory StartVideoCallRequest.fromJson(Map<String, dynamic> json) =>
      _$StartVideoCallRequestFromJson(json);
}

@freezed
class AddContactRequest with _$AddContactRequest {
  const factory AddContactRequest({
    required String userId,
    required String relationship,
    @Default({}) Map<String, dynamic> notes,
  }) = _AddContactRequest;

  factory AddContactRequest.fromJson(Map<String, dynamic> json) =>
      _$AddContactRequestFromJson(json);
}

@freezed
class UpdateRelationshipStatusRequest with _$UpdateRelationshipStatusRequest {
  const factory UpdateRelationshipStatusRequest({
    required String status,
    @Default({}) Map<String, dynamic> data,
  }) = _UpdateRelationshipStatusRequest;

  factory UpdateRelationshipStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateRelationshipStatusRequestFromJson(json);
}

@freezed
class RecordMomentRequest with _$RecordMomentRequest {
  const factory RecordMomentRequest({
    required String contactId,
    required String title,
    required String description,
    required String type,
    required List<String> images,
    required DateTime momentDate,
    @Default({}) Map<String, dynamic> data,
  }) = _RecordMomentRequest;

  factory RecordMomentRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordMomentRequestFromJson(json);
}

@freezed
class GenerateSocialReportRequest with _$GenerateSocialReportRequest {
  const factory GenerateSocialReportRequest({
    required String period,
    @Default({}) Map<String, dynamic> options,
  }) = _GenerateSocialReportRequest;

  factory GenerateSocialReportRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateSocialReportRequestFromJson(json);
}

@freezed
class FeedbackRecommendationRequest with _$FeedbackRecommendationRequest {
  const factory FeedbackRecommendationRequest({
    required String recommendationId,
    required String type,
    required String feedback,
    @Default({}) Map<String, dynamic> data,
  }) = _FeedbackRecommendationRequest;

  factory FeedbackRecommendationRequest.fromJson(Map<String, dynamic> json) =>
      _$FeedbackRecommendationRequestFromJson(json);
}

@freezed
class StartGameRequest with _$StartGameRequest {
  const factory StartGameRequest({
    @Default([]) List<String> players,
    @Default({}) Map<String, dynamic> settings,
  }) = _StartGameRequest;

  factory StartGameRequest.fromJson(Map<String, dynamic> json) =>
      _$StartGameRequestFromJson(json);
}

@freezed
class SubmitGameResultRequest with _$SubmitGameResultRequest {
  const factory SubmitGameResultRequest({
    required int score,
    required Map<String, dynamic> gameData,
    @Default([]) List<String> achievements,
  }) = _SubmitGameResultRequest;

  factory SubmitGameResultRequest.fromJson(Map<String, dynamic> json) =>
      _$SubmitGameResultRequestFromJson(json);
}

// ==================== 列表响应模型 ====================

@freezed
class MatchListResponse with _$MatchListResponse {
  const factory MatchListResponse({
    required List<Match> matches,
    required int total,
    required int page,
    required int limit,
  }) = _MatchListResponse;

  factory MatchListResponse.fromJson(Map<String, dynamic> json) =>
      _$MatchListResponseFromJson(json);
}

@freezed
class ConversationListResponse with _$ConversationListResponse {
  const factory ConversationListResponse({
    required List<Conversation> conversations,
    required int total,
    required int page,
    required int limit,
  }) = _ConversationListResponse;

  factory ConversationListResponse.fromJson(Map<String, dynamic> json) =>
      _$ConversationListResponseFromJson(json);
}

@freezed
class MessageListResponse with _$MessageListResponse {
  const factory MessageListResponse({
    required List<Message> messages,
    required int total,
    required int page,
    required int limit,
  }) = _MessageListResponse;

  factory MessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageListResponseFromJson(json);
}

@freezed
class ActivityListResponse with _$ActivityListResponse {
  const factory ActivityListResponse({
    required List<Activity> activities,
    required int total,
    required int page,
    required int limit,
  }) = _ActivityListResponse;

  factory ActivityListResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivityListResponseFromJson(json);
}

@freezed
class UserListResponse with _$UserListResponse {
  const factory UserListResponse({
    required List<SocialUser> users,
    required int total,
    required int page,
    required int limit,
  }) = _UserListResponse;

  factory UserListResponse.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseFromJson(json);
}

@freezed
class FeedListResponse with _$FeedListResponse {
  const factory FeedListResponse({
    required List<FeedItem> items,
    required int total,
    required int page,
    required int limit,
  }) = _FeedListResponse;

  factory FeedListResponse.fromJson(Map<String, dynamic> json) =>
      _$FeedListResponseFromJson(json);
}

@freezed
class ChatGroupListResponse with _$ChatGroupListResponse {
  const factory ChatGroupListResponse({
    required List<ChatGroup> groups,
    required int total,
    required int page,
    required int limit,
  }) = _ChatGroupListResponse;

  factory ChatGroupListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupListResponseFromJson(json);
}

@freezed
class ChatMessageListResponse with _$ChatMessageListResponse {
  const factory ChatMessageListResponse({
    required List<ChatMessage> messages,
    required int total,
    required int page,
    required int limit,
  }) = _ChatMessageListResponse;

  factory ChatMessageListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageListResponseFromJson(json);
}

@freezed
class ContactListResponse with _$ContactListResponse {
  const factory ContactListResponse({
    required List<Contact> contacts,
    required int total,
    required int page,
    required int limit,
  }) = _ContactListResponse;

  factory ContactListResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactListResponseFromJson(json);
}

@freezed
class RelationshipMomentListResponse with _$RelationshipMomentListResponse {
  const factory RelationshipMomentListResponse({
    required List<RelationshipMoment> moments,
    required int total,
    required int page,
    required int limit,
  }) = _RelationshipMomentListResponse;

  factory RelationshipMomentListResponse.fromJson(Map<String, dynamic> json) =>
      _$RelationshipMomentListResponseFromJson(json);
}

@freezed
class ActivityRecommendationResponse with _$ActivityRecommendationResponse {
  const factory ActivityRecommendationResponse({
    required List<ActivityRecommendation> recommendations,
    required int total,
    required int page,
    required int limit,
  }) = _ActivityRecommendationResponse;

  factory ActivityRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivityRecommendationResponseFromJson(json);
}

@freezed
class UserRecommendationResponse with _$UserRecommendationResponse {
  const factory UserRecommendationResponse({
    required List<UserRecommendation> recommendations,
    required int total,
    required int page,
    required int limit,
  }) = _UserRecommendationResponse;

  factory UserRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$UserRecommendationResponseFromJson(json);
}

@freezed
class GroupRecommendationResponse with _$GroupRecommendationResponse {
  const factory GroupRecommendationResponse({
    required List<GroupRecommendation> recommendations,
    required int total,
    required int page,
    required int limit,
  }) = _GroupRecommendationResponse;

  factory GroupRecommendationResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupRecommendationResponseFromJson(json);
}

@freezed
class GameListResponse with _$GameListResponse {
  const factory GameListResponse({
    required List<Game> games,
    required int total,
    required int page,
    required int limit,
  }) = _GameListResponse;

  factory GameListResponse.fromJson(Map<String, dynamic> json) =>
      _$GameListResponseFromJson(json);
}

@freezed
class GameLeaderboardResponse with _$GameLeaderboardResponse {
  const factory GameLeaderboardResponse({
    required List<GameResult> leaderboard,
    required int total,
    required String period,
  }) = _GameLeaderboardResponse;

  factory GameLeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      _$GameLeaderboardResponseFromJson(json);
}

@freezed
class ChallengeListResponse with _$ChallengeListResponse {
  const factory ChallengeListResponse({
    required List<Challenge> challenges,
    required int total,
    required int page,
    required int limit,
  }) = _ChallengeListResponse;

  factory ChallengeListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChallengeListResponseFromJson(json);
}

@freezed
class PointsHistoryResponse with _$PointsHistoryResponse {
  const factory PointsHistoryResponse({
    required List<PointsActivity> activities,
    required int total,
    required int page,
    required int limit,
  }) = _PointsHistoryResponse;

  factory PointsHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PointsHistoryResponseFromJson(json);
}