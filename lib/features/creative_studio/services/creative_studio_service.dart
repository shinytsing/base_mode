import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/creative_studio_model.dart';

part 'creative_studio_service.g.dart';

/// CreativeStudio 核心服务 - 调用Go后端API
@RestApi(baseUrl: "http://localhost:8080/api/v1")
abstract class CreativeStudioService {
  factory CreativeStudioService(Dio dio, {String baseUrl}) = _CreativeStudioService;

  // ==================== 创意写作 ====================
  
  /// AI写作助手
  @POST('/writing/ai-assistant')
  Future<WritingResponse> getAIWritingAssistant(@Body() AIWritingRequest request);
  
  /// 灵感激发
  @POST('/writing/inspiration')
  Future<InspirationResponse> getInspiration(@Body() InspirationRequest request);
  
  /// 文本优化
  @POST('/writing/optimize')
  Future<TextOptimizationResponse> optimizeText(@Body() TextOptimizationRequest request);
  
  /// 保存写作项目
  @POST('/writing/projects')
  Future<WritingProject> saveWritingProject(@Body() SaveWritingProjectRequest request);
  
  /// 获取写作项目列表
  @GET('/writing/projects')
  Future<WritingProjectListResponse> getWritingProjects(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取写作项目详情
  @GET('/writing/projects/{id}')
  Future<WritingProject> getWritingProject(@Path('id') String id);
  
  /// 更新写作项目
  @PUT('/writing/projects/{id}')
  Future<WritingProject> updateWritingProject(@Path('id') String id, @Body() UpdateWritingProjectRequest request);
  
  /// 删除写作项目
  @DELETE('/writing/projects/{id}')
  Future<void> deleteWritingProject(@Path('id') String id);

  // ==================== 故事板 ====================
  
  /// 创建故事
  @POST('/storyboard/stories')
  Future<Story> createStory(@Body() CreateStoryRequest request);
  
  /// 获取故事列表
  @GET('/storyboard/stories')
  Future<StoryListResponse> getStories(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取故事详情
  @GET('/storyboard/stories/{id}')
  Future<Story> getStory(@Path('id') String id);
  
  /// 添加章节
  @POST('/storyboard/stories/{id}/chapters')
  Future<Chapter> addChapter(@Path('id') String id, @Body() AddChapterRequest request);
  
  /// 添加角色
  @POST('/storyboard/stories/{id}/characters')
  Future<Character> addCharacter(@Path('id') String id, @Body() AddCharacterRequest request);
  
  /// 添加情节
  @POST('/storyboard/stories/{id}/plots')
  Future<Plot> addPlot(@Path('id') String id, @Body() AddPlotRequest request);
  
  /// 生成故事大纲
  @POST('/storyboard/stories/{id}/outline')
  Future<StoryOutline> generateStoryOutline(@Path('id') String id, @Body() GenerateStoryOutlineRequest request);

  // ==================== 头像生成器 ====================
  
  /// 生成AI头像
  @POST('/avatar/generate')
  Future<AvatarGenerationResponse> generateAvatar(@Body() GenerateAvatarRequest request);
  
  /// 风格转换
  @POST('/avatar/style-transfer')
  Future<StyleTransferResponse> transferStyle(@Body() StyleTransferRequest request);
  
  /// 个性化定制
  @POST('/avatar/customize')
  Future<AvatarCustomizationResponse> customizeAvatar(@Body() AvatarCustomizationRequest request);
  
  /// 获取头像历史
  @GET('/avatar/history')
  Future<AvatarHistoryResponse> getAvatarHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 保存头像
  @POST('/avatar/save')
  Future<void> saveAvatar(@Body() SaveAvatarRequest request);

  // ==================== 吉他训练 ====================
  
  /// 获取和弦学习
  @GET('/guitar/chords')
  Future<ChordListResponse> getChords(@Query('difficulty') String difficulty);
  
  /// 获取指法练习
  @GET('/guitar/fingerings')
  Future<FingeringListResponse> getFingerings(@Query('level') String level);
  
  /// 获取歌曲教学
  @GET('/guitar/songs')
  Future<SongListResponse> getSongs(@Query('page') int page, @Query('limit') int limit);
  
  /// 开始练习
  @POST('/guitar/practice')
  Future<PracticeSession> startPractice(@Body() StartPracticeRequest request);
  
  /// 结束练习
  @PUT('/guitar/practice/{id}/end')
  Future<PracticeSession> endPractice(@Path('id') String id, @Body() EndPracticeRequest request);
  
  /// 获取练习历史
  @GET('/guitar/practice/history')
  Future<PracticeHistoryResponse> getPracticeHistory(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取练习统计
  @GET('/guitar/practice/statistics')
  Future<PracticeStatistics> getPracticeStatistics(@Query('period') String period);

  // ==================== 内容创作 ====================
  
  /// 视频剪辑
  @POST('/content/video/edit')
  Future<VideoEditResponse> editVideo(@Body() VideoEditRequest request);
  
  /// 图片处理
  @POST('/content/image/process')
  Future<ImageProcessResponse> processImage(@Body() ImageProcessRequest request);
  
  /// 音频制作
  @POST('/content/audio/create')
  Future<AudioCreationResponse> createAudio(@Body() AudioCreationRequest request);
  
  /// 获取创作项目
  @GET('/content/projects')
  Future<ContentProjectListResponse> getContentProjects(@Query('page') int page, @Query('limit') int limit);
  
  /// 保存创作项目
  @POST('/content/projects')
  Future<ContentProject> saveContentProject(@Body() SaveContentProjectRequest request);
  
  /// 导出作品
  @POST('/content/export')
  Future<ExportResponse> exportContent(@Body() ExportRequest request);

  // ==================== 设计工具 ====================
  
  /// 海报设计
  @POST('/design/poster')
  Future<PosterDesignResponse> designPoster(@Body() PosterDesignRequest request);
  
  /// Logo制作
  @POST('/design/logo')
  Future<LogoDesignResponse> designLogo(@Body() LogoDesignRequest request);
  
  /// UI设计
  @POST('/design/ui')
  Future<UIDesignResponse> designUI(@Body() UIDesignRequest request);
  
  /// 获取设计模板
  @GET('/design/templates')
  Future<DesignTemplateListResponse> getDesignTemplates(@Query('category') String category);
  
  /// 保存设计
  @POST('/design/save')
  Future<void> saveDesign(@Body() SaveDesignRequest request);
  
  /// 获取设计历史
  @GET('/design/history')
  Future<DesignHistoryResponse> getDesignHistory(@Query('page') int page, @Query('limit') int limit);

  // ==================== 音乐制作 ====================
  
  /// 节拍器
  @POST('/music/metronome')
  Future<MetronomeResponse> startMetronome(@Body() MetronomeRequest request);
  
  /// 录音功能
  @POST('/music/recording')
  Future<RecordingResponse> startRecording(@Body() RecordingRequest request);
  
  /// 音效处理
  @POST('/music/effects')
  Future<AudioEffectResponse> applyAudioEffects(@Body() AudioEffectRequest request);
  
  /// 音乐合成
  @POST('/music/synthesize')
  Future<MusicSynthesisResponse> synthesizeMusic(@Body() MusicSynthesisRequest request);
  
  /// 获取音乐项目
  @GET('/music/projects')
  Future<MusicProjectListResponse> getMusicProjects(@Query('page') int page, @Query('limit') int limit);
  
  /// 保存音乐项目
  @POST('/music/projects')
  Future<MusicProject> saveMusicProject(@Body() SaveMusicProjectRequest request);

  // ==================== 创作社区 ====================
  
  /// 发布作品
  @POST('/community/works')
  Future<CreativeWork> publishWork(@Body() PublishWorkRequest request);
  
  /// 获取作品列表
  @GET('/community/works')
  Future<CreativeWorkListResponse> getWorks(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取作品详情
  @GET('/community/works/{id}')
  Future<CreativeWork> getWork(@Path('id') String id);
  
  /// 点赞作品
  @POST('/community/works/{id}/like')
  Future<void> likeWork(@Path('id') String id);
  
  /// 评论作品
  @POST('/community/works/{id}/comments')
  Future<WorkComment> commentWork(@Path('id') String id, @Body() CommentWorkRequest request);
  
  /// 获取作品评论
  @GET('/community/works/{id}/comments')
  Future<WorkCommentListResponse> getWorkComments(@Path('id') String id, @Query('page') int page, @Query('limit') int limit);
  
  /// 分享作品
  @POST('/community/works/{id}/share')
  Future<void> shareWork(@Path('id') String id, @Body() ShareWorkRequest request);
  
  /// 获取灵感推荐
  @GET('/community/inspiration')
  Future<InspirationListResponse> getInspiration(@Query('page') int page, @Query('limit') int limit);
  
  /// 收藏作品
  @POST('/community/works/{id}/favorite')
  Future<void> favoriteWork(@Path('id') String id);
  
  /// 获取收藏列表
  @GET('/community/favorites')
  Future<CreativeWorkListResponse> getFavorites(@Query('page') int page, @Query('limit') int limit);
  
  /// 关注创作者
  @POST('/community/follow-creator')
  Future<void> followCreator(@Body() FollowCreatorRequest request);
  
  /// 获取关注列表
  @GET('/community/following')
  Future<CreatorListResponse> getFollowing(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取创作者详情
  @GET('/community/creators/{id}')
  Future<Creator> getCreator(@Path('id') String id);
}
