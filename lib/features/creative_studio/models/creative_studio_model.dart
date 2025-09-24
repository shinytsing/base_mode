import 'package:freezed_annotation/freezed_annotation.dart';

part 'creative_studio_model.freezed.dart';
part 'creative_studio_model.g.dart';

// ==================== 创意写作模型 ====================

@freezed
class WritingResponse with _$WritingResponse {
  const factory WritingResponse({
    required String id,
    required String content,
    required String type,
    required List<String> suggestions,
    required Map<String, dynamic> metadata,
    DateTime? generatedAt,
  }) = _WritingResponse;

  factory WritingResponse.fromJson(Map<String, dynamic> json) =>
      _$WritingResponseFromJson(json);
}

@freezed
class InspirationResponse with _$InspirationResponse {
  const factory InspirationResponse({
    required String id,
    required List<String> prompts,
    required List<String> keywords,
    required List<String> themes,
    required Map<String, dynamic> context,
    DateTime? generatedAt,
  }) = _InspirationResponse;

  factory InspirationResponse.fromJson(Map<String, dynamic> json) =>
      _$InspirationResponseFromJson(json);
}

@freezed
class TextOptimizationResponse with _$TextOptimizationResponse {
  const factory TextOptimizationResponse({
    required String id,
    required String originalText,
    required String optimizedText,
    required List<OptimizationSuggestion> suggestions,
    required Map<String, dynamic> metrics,
    DateTime? optimizedAt,
  }) = _TextOptimizationResponse;

  factory TextOptimizationResponse.fromJson(Map<String, dynamic> json) =>
      _$TextOptimizationResponseFromJson(json);
}

@freezed
class OptimizationSuggestion with _$OptimizationSuggestion {
  const factory OptimizationSuggestion({
    required String type,
    required String description,
    required String suggestion,
    required int position,
    required String severity,
  }) = _OptimizationSuggestion;

  factory OptimizationSuggestion.fromJson(Map<String, dynamic> json) =>
      _$OptimizationSuggestionFromJson(json);
}

@freezed
class WritingProject with _$WritingProject {
  const factory WritingProject({
    required String id,
    required String title,
    required String description,
    required String type,
    required String status,
    required String content,
    required int wordCount,
    required List<String> tags,
    required Map<String, dynamic> metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _WritingProject;

  factory WritingProject.fromJson(Map<String, dynamic> json) =>
      _$WritingProjectFromJson(json);
}

// ==================== 故事板模型 ====================

@freezed
class Story with _$Story {
  const factory Story({
    required String id,
    required String title,
    required String description,
    required String genre,
    required String status,
    required List<Chapter> chapters,
    required List<Character> characters,
    required List<Plot> plots,
    required StoryOutline outline,
    required Map<String, dynamic> settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Story;

  factory Story.fromJson(Map<String, dynamic> json) =>
      _$StoryFromJson(json);
}

@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required String id,
    required String title,
    required String content,
    required int order,
    required String status,
    required Map<String, dynamic> notes,
    DateTime? createdAt,
  }) = _Chapter;

  factory Chapter.fromJson(Map<String, dynamic> json) =>
      _$ChapterFromJson(json);
}

@freezed
class Character with _$Character {
  const factory Character({
    required String id,
    required String name,
    required String description,
    required String role,
    required Map<String, dynamic> traits,
    required Map<String, dynamic> background,
    required List<String> relationships,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}

@freezed
class Plot with _$Plot {
  const factory Plot({
    required String id,
    required String title,
    required String description,
    required String type,
    required int order,
    required Map<String, dynamic> details,
  }) = _Plot;

  factory Plot.fromJson(Map<String, dynamic> json) =>
      _$PlotFromJson(json);
}

@freezed
class StoryOutline with _$StoryOutline {
  const factory StoryOutline({
    required String id,
    required String storyId,
    required List<OutlineSection> sections,
    required Map<String, dynamic> structure,
    DateTime? generatedAt,
  }) = _StoryOutline;

  factory StoryOutline.fromJson(Map<String, dynamic> json) =>
      _$StoryOutlineFromJson(json);
}

@freezed
class OutlineSection with _$OutlineSection {
  const factory OutlineSection({
    required String title,
    required String description,
    required int order,
    required List<String> keyPoints,
  }) = _OutlineSection;

  factory OutlineSection.fromJson(Map<String, dynamic> json) =>
      _$OutlineSectionFromJson(json);
}

// ==================== 头像生成器模型 ====================

@freezed
class AvatarGenerationResponse with _$AvatarGenerationResponse {
  const factory AvatarGenerationResponse({
    required String id,
    required String imageUrl,
    required String style,
    required Map<String, dynamic> parameters,
    required List<String> variations,
    DateTime? generatedAt,
  }) = _AvatarGenerationResponse;

  factory AvatarGenerationResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarGenerationResponseFromJson(json);
}

@freezed
class StyleTransferResponse with _$StyleTransferResponse {
  const factory StyleTransferResponse({
    required String id,
    required String originalImageUrl,
    required String styledImageUrl,
    required String style,
    required Map<String, dynamic> parameters,
    DateTime? processedAt,
  }) = _StyleTransferResponse;

  factory StyleTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$StyleTransferResponseFromJson(json);
}

@freezed
class AvatarCustomizationResponse with _$AvatarCustomizationResponse {
  const factory AvatarCustomizationResponse({
    required String id,
    required String imageUrl,
    required Map<String, dynamic> customizations,
    required List<String> options,
    DateTime? customizedAt,
  }) = _AvatarCustomizationResponse;

  factory AvatarCustomizationResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarCustomizationResponseFromJson(json);
}

@freezed
class AvatarHistory with _$AvatarHistory {
  const factory AvatarHistory({
    required String id,
    required String imageUrl,
    required String style,
    required Map<String, dynamic> parameters,
    DateTime? createdAt,
  }) = _AvatarHistory;

  factory AvatarHistory.fromJson(Map<String, dynamic> json) =>
      _$AvatarHistoryFromJson(json);
}

// ==================== 吉他训练模型 ====================

@freezed
class Chord with _$Chord {
  const factory Chord({
    required String id,
    required String name,
    required String symbol,
    required String difficulty,
    required List<Fingering> fingerings,
    required String imageUrl,
    required List<String> notes,
  }) = _Chord;

  factory Chord.fromJson(Map<String, dynamic> json) =>
      _$ChordFromJson(json);
}

@freezed
class Fingering with _$Fingering {
  const factory Fingering({
    required String id,
    required String chordId,
    required List<FingerPosition> positions,
    required String difficulty,
    required String description,
  }) = _Fingering;

  factory Fingering.fromJson(Map<String, dynamic> json) =>
      _$FingeringFromJson(json);
}

@freezed
class FingerPosition with _$FingerPosition {
  const factory FingerPosition({
    required int string,
    required int fret,
    required int finger,
  }) = _FingerPosition;

  factory FingerPosition.fromJson(Map<String, dynamic> json) =>
      _$FingerPositionFromJson(json);
}

@freezed
class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    required String artist,
    required String difficulty,
    required List<String> chords,
    required String tablature,
    required String audioUrl,
    required String imageUrl,
    required Map<String, dynamic> metadata,
  }) = _Song;

  factory Song.fromJson(Map<String, dynamic> json) =>
      _$SongFromJson(json);
}

@freezed
class PracticeSession with _$PracticeSession {
  const factory PracticeSession({
    required String id,
    required String userId,
    required String type,
    required DateTime startTime,
    DateTime? endTime,
    required int duration,
    required Map<String, dynamic> metrics,
    required List<String> exercises,
    required PracticeResult result,
  }) = _PracticeSession;

  factory PracticeSession.fromJson(Map<String, dynamic> json) =>
      _$PracticeSessionFromJson(json);
}

@freezed
class PracticeResult with _$PracticeResult {
  const factory PracticeResult({
    required double accuracy,
    required int totalExercises,
    required int completedExercises,
    required List<String> achievements,
    required Map<String, dynamic> statistics,
  }) = _PracticeResult;

  factory PracticeResult.fromJson(Map<String, dynamic> json) =>
      _$PracticeResultFromJson(json);
}

@freezed
class PracticeStatistics with _$PracticeStatistics {
  const factory PracticeStatistics({
    required String period,
    required int totalSessions,
    required int totalDuration,
    required double averageAccuracy,
    required List<PracticeTrend> trends,
    required List<String> achievements,
  }) = _PracticeStatistics;

  factory PracticeStatistics.fromJson(Map<String, dynamic> json) =>
      _$PracticeStatisticsFromJson(json);
}

@freezed
class PracticeTrend with _$PracticeTrend {
  const factory PracticeTrend({
    required String date,
    required int sessions,
    required int duration,
    required double accuracy,
  }) = _PracticeTrend;

  factory PracticeTrend.fromJson(Map<String, dynamic> json) =>
      _$PracticeTrendFromJson(json);
}

// ==================== 内容创作模型 ====================

@freezed
class VideoEditResponse with _$VideoEditResponse {
  const factory VideoEditResponse({
    required String id,
    required String videoUrl,
    required Map<String, dynamic> edits,
    required List<String> effects,
    required Map<String, dynamic> metadata,
    DateTime? processedAt,
  }) = _VideoEditResponse;

  factory VideoEditResponse.fromJson(Map<String, dynamic> json) =>
      _$VideoEditResponseFromJson(json);
}

@freezed
class ImageProcessResponse with _$ImageProcessResponse {
  const factory ImageProcessResponse({
    required String id,
    required String imageUrl,
    required Map<String, dynamic> processes,
    required List<String> effects,
    required Map<String, dynamic> metadata,
    DateTime? processedAt,
  }) = _ImageProcessResponse;

  factory ImageProcessResponse.fromJson(Map<String, dynamic> json) =>
      _$ImageProcessResponseFromJson(json);
}

@freezed
class AudioCreationResponse with _$AudioCreationResponse {
  const factory AudioCreationResponse({
    required String id,
    required String audioUrl,
    required Map<String, dynamic> creation,
    required List<String> effects,
    required Map<String, dynamic> metadata,
    DateTime? createdAt,
  }) = _AudioCreationResponse;

  factory AudioCreationResponse.fromJson(Map<String, dynamic> json) =>
      _$AudioCreationResponseFromJson(json);
}

@freezed
class ContentProject with _$ContentProject {
  const factory ContentProject({
    required String id,
    required String title,
    required String description,
    required String type,
    required String status,
    required List<String> assets,
    required Map<String, dynamic> settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ContentProject;

  factory ContentProject.fromJson(Map<String, dynamic> json) =>
      _$ContentProjectFromJson(json);
}

@freezed
class ExportResponse with _$ExportResponse {
  const factory ExportResponse({
    required String id,
    required String downloadUrl,
    required String format,
    required Map<String, dynamic> metadata,
    DateTime? exportedAt,
  }) = _ExportResponse;

  factory ExportResponse.fromJson(Map<String, dynamic> json) =>
      _$ExportResponseFromJson(json);
}

// ==================== 设计工具模型 ====================

@freezed
class PosterDesignResponse with _$PosterDesignResponse {
  const factory PosterDesignResponse({
    required String id,
    required String imageUrl,
    required Map<String, dynamic> design,
    required List<String> elements,
    required Map<String, dynamic> metadata,
    DateTime? designedAt,
  }) = _PosterDesignResponse;

  factory PosterDesignResponse.fromJson(Map<String, dynamic> json) =>
      _$PosterDesignResponseFromJson(json);
}

@freezed
class LogoDesignResponse with _$LogoDesignResponse {
  const factory LogoDesignResponse({
    required String id,
    required String imageUrl,
    required Map<String, dynamic> design,
    required List<String> variations,
    required Map<String, dynamic> metadata,
    DateTime? designedAt,
  }) = _LogoDesignResponse;

  factory LogoDesignResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoDesignResponseFromJson(json);
}

@freezed
class UIDesignResponse with _$UIDesignResponse {
  const factory UIDesignResponse({
    required String id,
    required String imageUrl,
    required Map<String, dynamic> design,
    required List<String> components,
    required Map<String, dynamic> metadata,
    DateTime? designedAt,
  }) = _UIDesignResponse;

  factory UIDesignResponse.fromJson(Map<String, dynamic> json) =>
      _$UIDesignResponseFromJson(json);
}

@freezed
class DesignTemplate with _$DesignTemplate {
  const factory DesignTemplate({
    required String id,
    required String name,
    required String category,
    required String imageUrl,
    required Map<String, dynamic> template,
    required List<String> tags,
  }) = _DesignTemplate;

  factory DesignTemplate.fromJson(Map<String, dynamic> json) =>
      _$DesignTemplateFromJson(json);
}

@freezed
class DesignHistory with _$DesignHistory {
  const factory DesignHistory({
    required String id,
    required String imageUrl,
    required String type,
    required Map<String, dynamic> design,
    DateTime? createdAt,
  }) = _DesignHistory;

  factory DesignHistory.fromJson(Map<String, dynamic> json) =>
      _$DesignHistoryFromJson(json);
}

// ==================== 音乐制作模型 ====================

@freezed
class MetronomeResponse with _$MetronomeResponse {
  const factory MetronomeResponse({
    required String id,
    required int bpm,
    required String timeSignature,
    required String status,
    required String audioUrl,
  }) = _MetronomeResponse;

  factory MetronomeResponse.fromJson(Map<String, dynamic> json) =>
      _$MetronomeResponseFromJson(json);
}

@freezed
class RecordingResponse with _$RecordingResponse {
  const factory RecordingResponse({
    required String id,
    required String audioUrl,
    required int duration,
    required Map<String, dynamic> settings,
    required String status,
    DateTime? recordedAt,
  }) = _RecordingResponse;

  factory RecordingResponse.fromJson(Map<String, dynamic> json) =>
      _$RecordingResponseFromJson(json);
}

@freezed
class AudioEffectResponse with _$AudioEffectResponse {
  const factory AudioEffectResponse({
    required String id,
    required String audioUrl,
    required List<String> effects,
    required Map<String, dynamic> parameters,
    DateTime? processedAt,
  }) = _AudioEffectResponse;

  factory AudioEffectResponse.fromJson(Map<String, dynamic> json) =>
      _$AudioEffectResponseFromJson(json);
}

@freezed
class MusicSynthesisResponse with _$MusicSynthesisResponse {
  const factory MusicSynthesisResponse({
    required String id,
    required String audioUrl,
    required Map<String, dynamic> synthesis,
    required List<String> instruments,
    required Map<String, dynamic> metadata,
    DateTime? synthesizedAt,
  }) = _MusicSynthesisResponse;

  factory MusicSynthesisResponse.fromJson(Map<String, dynamic> json) =>
      _$MusicSynthesisResponseFromJson(json);
}

@freezed
class MusicProject with _$MusicProject {
  const factory MusicProject({
    required String id,
    required String title,
    required String description,
    required String genre,
    required String status,
    required List<String> tracks,
    required Map<String, dynamic> settings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _MusicProject;

  factory MusicProject.fromJson(Map<String, dynamic> json) =>
      _$MusicProjectFromJson(json);
}

// ==================== 创作社区模型 ====================

@freezed
class CreativeWork with _$CreativeWork {
  const factory CreativeWork({
    required String id,
    required String title,
    required String description,
    required String type,
    required String category,
    required String creatorId,
    required String creatorName,
    required String creatorAvatar,
    required List<String> assets,
    @Default(0) int likes,
    @Default(0) int comments,
    @Default(0) int shares,
    @Default(0) int views,
    @Default(false) bool isLiked,
    @Default([]) List<String> tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CreativeWork;

  factory CreativeWork.fromJson(Map<String, dynamic> json) =>
      _$CreativeWorkFromJson(json);
}

@freezed
class WorkComment with _$WorkComment {
  const factory WorkComment({
    required String id,
    required String workId,
    required String userId,
    required String userName,
    required String userAvatar,
    required String content,
    @Default(0) int likes,
    @Default(false) bool isLiked,
    DateTime? createdAt,
  }) = _WorkComment;

  factory WorkComment.fromJson(Map<String, dynamic> json) =>
      _$WorkCommentFromJson(json);
}

@freezed
class Creator with _$Creator {
  const factory Creator({
    required String id,
    required String name,
    required String avatar,
    required String bio,
    @Default(0) int followers,
    @Default(0) int following,
    @Default(0) int works,
    @Default(false) bool isFollowing,
    @Default([]) List<String> specialties,
    @Default([]) List<String> badges,
  }) = _Creator;

  factory Creator.fromJson(Map<String, dynamic> json) =>
      _$CreatorFromJson(json);
}

@freezed
class Inspiration with _$Inspiration {
  const factory Inspiration({
    required String id,
    required String title,
    required String description,
    required String type,
    required String category,
    required List<String> images,
    required List<String> tags,
    required String source,
    DateTime? createdAt,
  }) = _Inspiration;

  factory Inspiration.fromJson(Map<String, dynamic> json) =>
      _$InspirationFromJson(json);
}

// ==================== 请求模型 ====================

@freezed
class AIWritingRequest with _$AIWritingRequest {
  const factory AIWritingRequest({
    required String prompt,
    required String type,
    @Default({}) Map<String, dynamic> options,
  }) = _AIWritingRequest;

  factory AIWritingRequest.fromJson(Map<String, dynamic> json) =>
      _$AIWritingRequestFromJson(json);
}

@freezed
class InspirationRequest with _$InspirationRequest {
  const factory InspirationRequest({
    required String type,
    @Default([]) List<String> keywords,
    @Default({}) Map<String, dynamic> context,
  }) = _InspirationRequest;

  factory InspirationRequest.fromJson(Map<String, dynamic> json) =>
      _$InspirationRequestFromJson(json);
}

@freezed
class TextOptimizationRequest with _$TextOptimizationRequest {
  const factory TextOptimizationRequest({
    required String text,
    required String type,
    @Default({}) Map<String, dynamic> options,
  }) = _TextOptimizationRequest;

  factory TextOptimizationRequest.fromJson(Map<String, dynamic> json) =>
      _$TextOptimizationRequestFromJson(json);
}

@freezed
class SaveWritingProjectRequest with _$SaveWritingProjectRequest {
  const factory SaveWritingProjectRequest({
    required String title,
    required String description,
    required String type,
    required String content,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
  }) = _SaveWritingProjectRequest;

  factory SaveWritingProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveWritingProjectRequestFromJson(json);
}

@freezed
class UpdateWritingProjectRequest with _$UpdateWritingProjectRequest {
  const factory UpdateWritingProjectRequest({
    String? title,
    String? description,
    String? content,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
  }) = _UpdateWritingProjectRequest;

  factory UpdateWritingProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateWritingProjectRequestFromJson(json);
}

@freezed
class CreateStoryRequest with _$CreateStoryRequest {
  const factory CreateStoryRequest({
    required String title,
    required String description,
    required String genre,
    @Default({}) Map<String, dynamic> settings,
  }) = _CreateStoryRequest;

  factory CreateStoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateStoryRequestFromJson(json);
}

@freezed
class AddChapterRequest with _$AddChapterRequest {
  const factory AddChapterRequest({
    required String title,
    required String content,
    required int order,
    @Default({}) Map<String, dynamic> notes,
  }) = _AddChapterRequest;

  factory AddChapterRequest.fromJson(Map<String, dynamic> json) =>
      _$AddChapterRequestFromJson(json);
}

@freezed
class AddCharacterRequest with _$AddCharacterRequest {
  const factory AddCharacterRequest({
    required String name,
    required String description,
    required String role,
    @Default({}) Map<String, dynamic> traits,
    @Default({}) Map<String, dynamic> background,
  }) = _AddCharacterRequest;

  factory AddCharacterRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCharacterRequestFromJson(json);
}

@freezed
class AddPlotRequest with _$AddPlotRequest {
  const factory AddPlotRequest({
    required String title,
    required String description,
    required String type,
    required int order,
    @Default({}) Map<String, dynamic> details,
  }) = _AddPlotRequest;

  factory AddPlotRequest.fromJson(Map<String, dynamic> json) =>
      _$AddPlotRequestFromJson(json);
}

@freezed
class GenerateStoryOutlineRequest with _$GenerateStoryOutlineRequest {
  const factory GenerateStoryOutlineRequest({
    @Default({}) Map<String, dynamic> options,
  }) = _GenerateStoryOutlineRequest;

  factory GenerateStoryOutlineRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateStoryOutlineRequestFromJson(json);
}

@freezed
class GenerateAvatarRequest with _$GenerateAvatarRequest {
  const factory GenerateAvatarRequest({
    required String style,
    @Default({}) Map<String, dynamic> parameters,
  }) = _GenerateAvatarRequest;

  factory GenerateAvatarRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateAvatarRequestFromJson(json);
}

@freezed
class StyleTransferRequest with _$StyleTransferRequest {
  const factory StyleTransferRequest({
    required String originalImageUrl,
    required String style,
    @Default({}) Map<String, dynamic> parameters,
  }) = _StyleTransferRequest;

  factory StyleTransferRequest.fromJson(Map<String, dynamic> json) =>
      _$StyleTransferRequestFromJson(json);
}

@freezed
class AvatarCustomizationRequest with _$AvatarCustomizationRequest {
  const factory AvatarCustomizationRequest({
    required String baseImageUrl,
    required Map<String, dynamic> customizations,
  }) = _AvatarCustomizationRequest;

  factory AvatarCustomizationRequest.fromJson(Map<String, dynamic> json) =>
      _$AvatarCustomizationRequestFromJson(json);
}

@freezed
class SaveAvatarRequest with _$SaveAvatarRequest {
  const factory SaveAvatarRequest({
    required String imageUrl,
    required String style,
    @Default({}) Map<String, dynamic> parameters,
  }) = _SaveAvatarRequest;

  factory SaveAvatarRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveAvatarRequestFromJson(json);
}

@freezed
class StartPracticeRequest with _$StartPracticeRequest {
  const factory StartPracticeRequest({
    required String type,
    @Default({}) Map<String, dynamic> settings,
  }) = _StartPracticeRequest;

  factory StartPracticeRequest.fromJson(Map<String, dynamic> json) =>
      _$StartPracticeRequestFromJson(json);
}

@freezed
class EndPracticeRequest with _$EndPracticeRequest {
  const factory EndPracticeRequest({
    required Map<String, dynamic> metrics,
    required List<String> exercises,
  }) = _EndPracticeRequest;

  factory EndPracticeRequest.fromJson(Map<String, dynamic> json) =>
      _$EndPracticeRequestFromJson(json);
}

@freezed
class VideoEditRequest with _$VideoEditRequest {
  const factory VideoEditRequest({
    required String videoUrl,
    required Map<String, dynamic> edits,
    @Default([]) List<String> effects,
  }) = _VideoEditRequest;

  factory VideoEditRequest.fromJson(Map<String, dynamic> json) =>
      _$VideoEditRequestFromJson(json);
}

@freezed
class ImageProcessRequest with _$ImageProcessRequest {
  const factory ImageProcessRequest({
    required String imageUrl,
    required Map<String, dynamic> processes,
    @Default([]) List<String> effects,
  }) = _ImageProcessRequest;

  factory ImageProcessRequest.fromJson(Map<String, dynamic> json) =>
      _$ImageProcessRequestFromJson(json);
}

@freezed
class AudioCreationRequest with _$AudioCreationRequest {
  const factory AudioCreationRequest({
    required Map<String, dynamic> creation,
    @Default([]) List<String> effects,
  }) = _AudioCreationRequest;

  factory AudioCreationRequest.fromJson(Map<String, dynamic> json) =>
      _$AudioCreationRequestFromJson(json);
}

@freezed
class SaveContentProjectRequest with _$SaveContentProjectRequest {
  const factory SaveContentProjectRequest({
    required String title,
    required String description,
    required String type,
    required List<String> assets,
    @Default({}) Map<String, dynamic> settings,
  }) = _SaveContentProjectRequest;

  factory SaveContentProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveContentProjectRequestFromJson(json);
}

@freezed
class ExportRequest with _$ExportRequest {
  const factory ExportRequest({
    required String projectId,
    required String format,
    @Default({}) Map<String, dynamic> options,
  }) = _ExportRequest;

  factory ExportRequest.fromJson(Map<String, dynamic> json) =>
      _$ExportRequestFromJson(json);
}

@freezed
class PosterDesignRequest with _$PosterDesignRequest {
  const factory PosterDesignRequest({
    required String title,
    required String description,
    required Map<String, dynamic> design,
    @Default([]) List<String> elements,
  }) = _PosterDesignRequest;

  factory PosterDesignRequest.fromJson(Map<String, dynamic> json) =>
      _$PosterDesignRequestFromJson(json);
}

@freezed
class LogoDesignRequest with _$LogoDesignRequest {
  const factory LogoDesignRequest({
    required String companyName,
    required String description,
    required Map<String, dynamic> design,
    @Default([]) List<String> styles,
  }) = _LogoDesignRequest;

  factory LogoDesignRequest.fromJson(Map<String, dynamic> json) =>
      _$LogoDesignRequestFromJson(json);
}

@freezed
class UIDesignRequest with _$UIDesignRequest {
  const factory UIDesignRequest({
    required String appName,
    required String description,
    required Map<String, dynamic> design,
    @Default([]) List<String> components,
  }) = _UIDesignRequest;

  factory UIDesignRequest.fromJson(Map<String, dynamic> json) =>
      _$UIDesignRequestFromJson(json);
}

@freezed
class SaveDesignRequest with _$SaveDesignRequest {
  const factory SaveDesignRequest({
    required String imageUrl,
    required String type,
    required Map<String, dynamic> design,
  }) = _SaveDesignRequest;

  factory SaveDesignRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveDesignRequestFromJson(json);
}

@freezed
class MetronomeRequest with _$MetronomeRequest {
  const factory MetronomeRequest({
    required int bpm,
    required String timeSignature,
  }) = _MetronomeRequest;

  factory MetronomeRequest.fromJson(Map<String, dynamic> json) =>
      _$MetronomeRequestFromJson(json);
}

@freezed
class RecordingRequest with _$RecordingRequest {
  const factory RecordingRequest({
    @Default({}) Map<String, dynamic> settings,
  }) = _RecordingRequest;

  factory RecordingRequest.fromJson(Map<String, dynamic> json) =>
      _$RecordingRequestFromJson(json);
}

@freezed
class AudioEffectRequest with _$AudioEffectRequest {
  const factory AudioEffectRequest({
    required String audioUrl,
    required List<String> effects,
    required Map<String, dynamic> parameters,
  }) = _AudioEffectRequest;

  factory AudioEffectRequest.fromJson(Map<String, dynamic> json) =>
      _$AudioEffectRequestFromJson(json);
}

@freezed
class MusicSynthesisRequest with _$MusicSynthesisRequest {
  const factory MusicSynthesisRequest({
    required Map<String, dynamic> synthesis,
    required List<String> instruments,
  }) = _MusicSynthesisRequest;

  factory MusicSynthesisRequest.fromJson(Map<String, dynamic> json) =>
      _$MusicSynthesisRequestFromJson(json);
}

@freezed
class SaveMusicProjectRequest with _$SaveMusicProjectRequest {
  const factory SaveMusicProjectRequest({
    required String title,
    required String description,
    required String genre,
    required List<String> tracks,
    @Default({}) Map<String, dynamic> settings,
  }) = _SaveMusicProjectRequest;

  factory SaveMusicProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$SaveMusicProjectRequestFromJson(json);
}

@freezed
class PublishWorkRequest with _$PublishWorkRequest {
  const factory PublishWorkRequest({
    required String title,
    required String description,
    required String type,
    required String category,
    required List<String> assets,
    @Default([]) List<String> tags,
  }) = _PublishWorkRequest;

  factory PublishWorkRequest.fromJson(Map<String, dynamic> json) =>
      _$PublishWorkRequestFromJson(json);
}

@freezed
class CommentWorkRequest with _$CommentWorkRequest {
  const factory CommentWorkRequest({
    required String content,
  }) = _CommentWorkRequest;

  factory CommentWorkRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentWorkRequestFromJson(json);
}

@freezed
class ShareWorkRequest with _$ShareWorkRequest {
  const factory ShareWorkRequest({
    required String platform,
    @Default({}) Map<String, dynamic> options,
  }) = _ShareWorkRequest;

  factory ShareWorkRequest.fromJson(Map<String, dynamic> json) =>
      _$ShareWorkRequestFromJson(json);
}

@freezed
class FollowCreatorRequest with _$FollowCreatorRequest {
  const factory FollowCreatorRequest({
    required String creatorId,
  }) = _FollowCreatorRequest;

  factory FollowCreatorRequest.fromJson(Map<String, dynamic> json) =>
      _$FollowCreatorRequestFromJson(json);
}

// ==================== 列表响应模型 ====================

@freezed
class WritingProjectListResponse with _$WritingProjectListResponse {
  const factory WritingProjectListResponse({
    required List<WritingProject> projects,
    required int total,
    required int page,
    required int limit,
  }) = _WritingProjectListResponse;

  factory WritingProjectListResponse.fromJson(Map<String, dynamic> json) =>
      _$WritingProjectListResponseFromJson(json);
}

@freezed
class StoryListResponse with _$StoryListResponse {
  const factory StoryListResponse({
    required List<Story> stories,
    required int total,
    required int page,
    required int limit,
  }) = _StoryListResponse;

  factory StoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$StoryListResponseFromJson(json);
}

@freezed
class AvatarHistoryResponse with _$AvatarHistoryResponse {
  const factory AvatarHistoryResponse({
    required List<AvatarHistory> history,
    required int total,
    required int page,
    required int limit,
  }) = _AvatarHistoryResponse;

  factory AvatarHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$AvatarHistoryResponseFromJson(json);
}

@freezed
class ChordListResponse with _$ChordListResponse {
  const factory ChordListResponse({
    required List<Chord> chords,
    required int total,
  }) = _ChordListResponse;

  factory ChordListResponse.fromJson(Map<String, dynamic> json) =>
      _$ChordListResponseFromJson(json);
}

@freezed
class FingeringListResponse with _$FingeringListResponse {
  const factory FingeringListResponse({
    required List<Fingering> fingerings,
    required int total,
  }) = _FingeringListResponse;

  factory FingeringListResponse.fromJson(Map<String, dynamic> json) =>
      _$FingeringListResponseFromJson(json);
}

@freezed
class SongListResponse with _$SongListResponse {
  const factory SongListResponse({
    required List<Song> songs,
    required int total,
    required int page,
    required int limit,
  }) = _SongListResponse;

  factory SongListResponse.fromJson(Map<String, dynamic> json) =>
      _$SongListResponseFromJson(json);
}

@freezed
class PracticeHistoryResponse with _$PracticeHistoryResponse {
  const factory PracticeHistoryResponse({
    required List<PracticeSession> sessions,
    required int total,
    required int page,
    required int limit,
  }) = _PracticeHistoryResponse;

  factory PracticeHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$PracticeHistoryResponseFromJson(json);
}

@freezed
class ContentProjectListResponse with _$ContentProjectListResponse {
  const factory ContentProjectListResponse({
    required List<ContentProject> projects,
    required int total,
    required int page,
    required int limit,
  }) = _ContentProjectListResponse;

  factory ContentProjectListResponse.fromJson(Map<String, dynamic> json) =>
      _$ContentProjectListResponseFromJson(json);
}

@freezed
class DesignTemplateListResponse with _$DesignTemplateListResponse {
  const factory DesignTemplateListResponse({
    required List<DesignTemplate> templates,
    required int total,
  }) = _DesignTemplateListResponse;

  factory DesignTemplateListResponse.fromJson(Map<String, dynamic> json) =>
      _$DesignTemplateListResponseFromJson(json);
}

@freezed
class DesignHistoryResponse with _$DesignHistoryResponse {
  const factory DesignHistoryResponse({
    required List<DesignHistory> history,
    required int total,
    required int page,
    required int limit,
  }) = _DesignHistoryResponse;

  factory DesignHistoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DesignHistoryResponseFromJson(json);
}

@freezed
class MusicProjectListResponse with _$MusicProjectListResponse {
  const factory MusicProjectListResponse({
    required List<MusicProject> projects,
    required int total,
    required int page,
    required int limit,
  }) = _MusicProjectListResponse;

  factory MusicProjectListResponse.fromJson(Map<String, dynamic> json) =>
      _$MusicProjectListResponseFromJson(json);
}

@freezed
class CreativeWorkListResponse with _$CreativeWorkListResponse {
  const factory CreativeWorkListResponse({
    required List<CreativeWork> works,
    required int total,
    required int page,
    required int limit,
  }) = _CreativeWorkListResponse;

  factory CreativeWorkListResponse.fromJson(Map<String, dynamic> json) =>
      _$CreativeWorkListResponseFromJson(json);
}

@freezed
class WorkCommentListResponse with _$WorkCommentListResponse {
  const factory WorkCommentListResponse({
    required List<WorkComment> comments,
    required int total,
    required int page,
    required int limit,
  }) = _WorkCommentListResponse;

  factory WorkCommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkCommentListResponseFromJson(json);
}

@freezed
class CreatorListResponse with _$CreatorListResponse {
  const factory CreatorListResponse({
    required List<Creator> creators,
    required int total,
    required int page,
    required int limit,
  }) = _CreatorListResponse;

  factory CreatorListResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatorListResponseFromJson(json);
}

@freezed
class InspirationListResponse with _$InspirationListResponse {
  const factory InspirationListResponse({
    required List<Inspiration> inspirations,
    required int total,
    required int page,
    required int limit,
  }) = _InspirationListResponse;

  factory InspirationListResponse.fromJson(Map<String, dynamic> json) =>
      _$InspirationListResponseFromJson(json);
}