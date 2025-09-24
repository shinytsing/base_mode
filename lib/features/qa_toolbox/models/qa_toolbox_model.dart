import 'package:freezed_annotation/freezed_annotation.dart';

part 'qa_toolbox_model.freezed.dart';
part 'qa_toolbox_model.g.dart';

// ==================== 测试用例生成器模型 ====================

@freezed
class TestGenerationRequest with _$TestGenerationRequest {
  const factory TestGenerationRequest({
    required String code,
    required String language,
    required String framework,
    @Default({}) Map<String, dynamic> options,
    @Default(false) bool includeEdgeCases,
    @Default(false) bool includePerformanceTests,
    @Default(false) bool includeSecurityTests,
    @Default('comprehensive') String testType,
  }) = _TestGenerationRequest;

  factory TestGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$TestGenerationRequestFromJson(json);
}

@freezed
class TestGenerationResponse with _$TestGenerationResponse {
  const factory TestGenerationResponse({
    required String id,
    required List<TestCase> testCases,
    required TestMetrics metrics,
    required String status,
    DateTime? createdAt,
    String? error,
  }) = _TestGenerationResponse;

  factory TestGenerationResponse.fromJson(Map<String, dynamic> json) =>
      _$TestGenerationResponseFromJson(json);
}

@freezed
class TestCase with _$TestCase {
  const factory TestCase({
    required String id,
    required String name,
    required String description,
    required String code,
    required String type,
    required List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
    @Default(0) int priority,
    @Default(false) bool isAutomated,
  }) = _TestCase;

  factory TestCase.fromJson(Map<String, dynamic> json) =>
      _$TestCaseFromJson(json);
}

@freezed
class TestMetrics with _$TestMetrics {
  const factory TestMetrics({
    @Default(0) int totalTests,
    @Default(0) int unitTests,
    @Default(0) int integrationTests,
    @Default(0) int performanceTests,
    @Default(0) int securityTests,
    @Default(0.0) double coverage,
    @Default(0) int complexity,
  }) = _TestMetrics;

  factory TestMetrics.fromJson(Map<String, dynamic> json) =>
      _$TestMetricsFromJson(json);
}

// ==================== PDF转换器模型 ====================

@freezed
class PDFConversionRequest with _$PDFConversionRequest {
  const factory PDFConversionRequest({
    required String fileUrl,
    required String sourceFormat,
    @Default('pdf') String targetFormat,
    @Default({}) Map<String, dynamic> options,
    @Default(false) bool compress,
    @Default(false) bool encrypt,
    String? password,
  }) = _PDFConversionRequest;

  factory PDFConversionRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFConversionRequestFromJson(json);
}

@freezed
class PDFConversionResponse with _$PDFConversionResponse {
  const factory PDFConversionResponse({
    required String id,
    required String downloadUrl,
    required String status,
    @Default(0) int fileSize,
    @Default(0) int pageCount,
    DateTime? createdAt,
    String? error,
  }) = _PDFConversionResponse;

  factory PDFConversionResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFConversionResponseFromJson(json);
}

@freezed
class BatchPDFConversionRequest with _$BatchPDFConversionRequest {
  const factory BatchPDFConversionRequest({
    required List<String> fileUrls,
    required String sourceFormat,
    @Default('pdf') String targetFormat,
    @Default({}) Map<String, dynamic> options,
    @Default(false) bool compress,
    @Default(false) bool encrypt,
    String? password,
  }) = _BatchPDFConversionRequest;

  factory BatchPDFConversionRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchPDFConversionRequestFromJson(json);
}

@freezed
class BatchPDFConversionResponse with _$BatchPDFConversionResponse {
  const factory BatchPDFConversionResponse({
    required String batchId,
    required List<PDFConversionResponse> conversions,
    required String status,
    @Default(0) int totalFiles,
    @Default(0) int completedFiles,
    @Default(0) int failedFiles,
    DateTime? createdAt,
  }) = _BatchPDFConversionResponse;

  factory BatchPDFConversionResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchPDFConversionResponseFromJson(json);
}

// ==================== 任务管理器模型 ====================

@freezed
class Project with _$Project {
  const factory Project({
    required String id,
    required String name,
    required String description,
    required String status,
    required String ownerId,
    required List<String> memberIds,
    @Default({}) Map<String, dynamic> settings,
    @Default(0) int taskCount,
    @Default(0) int completedTasks,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deadline,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String projectId,
    required String title,
    required String description,
    required String status,
    required String priority,
    required String assigneeId,
    required String creatorId,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
    @Default(0) int estimatedHours,
    @Default(0) int actualHours,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) =>
      _$TaskFromJson(json);
}

@freezed
class TaskComment with _$TaskComment {
  const factory TaskComment({
    required String id,
    required String taskId,
    required String userId,
    required String content,
    @Default([]) List<String> attachments,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TaskComment;

  factory TaskComment.fromJson(Map<String, dynamic> json) =>
      _$TaskCommentFromJson(json);
}

// ==================== 网络爬虫模型 ====================

@freezed
class CrawlerTask with _$CrawlerTask {
  const factory CrawlerTask({
    required String id,
    required String name,
    required String url,
    required String status,
    @Default({}) Map<String, dynamic> config,
    @Default([]) List<String> selectors,
    @Default(0) int maxPages,
    @Default(0) int delayMs,
    @Default(false) bool followLinks,
    @Default(false) bool respectRobots,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startedAt,
    DateTime? completedAt,
  }) = _CrawlerTask;

  factory CrawlerTask.fromJson(Map<String, dynamic> json) =>
      _$CrawlerTaskFromJson(json);
}

@freezed
class CrawlerResult with _$CrawlerResult {
  const factory CrawlerResult({
    required String id,
    required String taskId,
    required String url,
    required Map<String, dynamic> data,
    required int statusCode,
    @Default(0) int responseTime,
    @Default({}) Map<String, String> headers,
    DateTime? crawledAt,
  }) = _CrawlerResult;

  factory CrawlerResult.fromJson(Map<String, dynamic> json) =>
      _$CrawlerResultFromJson(json);
}

// ==================== 代码分析模型 ====================

@freezed
class CodeAnalysisResult with _$CodeAnalysisResult {
  const factory CodeAnalysisResult({
    required String id,
    required String fileName,
    required String language,
    required CodeQualityMetrics quality,
    required CodeComplexityMetrics complexity,
    required List<CodeIssue> issues,
    required List<CodeSecurityVulnerability> vulnerabilities,
    required List<CodeDuplicate> duplicates,
    DateTime? analyzedAt,
  }) = _CodeAnalysisResult;

  factory CodeAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$CodeAnalysisResultFromJson(json);
}

@freezed
class CodeQualityMetrics with _$CodeQualityMetrics {
  const factory CodeQualityMetrics({
    @Default(0.0) double maintainabilityIndex,
    @Default(0.0) double cyclomaticComplexity,
    @Default(0.0) double cognitiveComplexity,
    @Default(0) int linesOfCode,
    @Default(0) int commentLines,
    @Default(0.0) double commentRatio,
    @Default(0) int technicalDebt,
  }) = _CodeQualityMetrics;

  factory CodeQualityMetrics.fromJson(Map<String, dynamic> json) =>
      _$CodeQualityMetricsFromJson(json);
}

@freezed
class CodeComplexityMetrics with _$CodeComplexityMetrics {
  const factory CodeComplexityMetrics({
    @Default(0) int cyclomaticComplexity,
    @Default(0) int cognitiveComplexity,
    @Default(0) int nestingDepth,
    @Default(0) int parameterCount,
    @Default(0) int methodLength,
    @Default(0) int classLength,
  }) = _CodeComplexityMetrics;

  factory CodeComplexityMetrics.fromJson(Map<String, dynamic> json) =>
      _$CodeComplexityMetricsFromJson(json);
}

@freezed
class CodeIssue with _$CodeIssue {
  const factory CodeIssue({
    required String id,
    required String type,
    required String severity,
    required String message,
    required String file,
    required int line,
    required int column,
    @Default({}) Map<String, dynamic> metadata,
  }) = _CodeIssue;

  factory CodeIssue.fromJson(Map<String, dynamic> json) =>
      _$CodeIssueFromJson(json);
      
  Map<String, dynamic> toJson() => _$CodeIssueToJson(this);
}

@freezed
class CodeSecurityVulnerability with _$CodeSecurityVulnerability {
  const factory CodeSecurityVulnerability({
    required String id,
    required String cve,
    required String severity,
    required String description,
    required String file,
    required int line,
    @Default({}) Map<String, dynamic> remediation,
  }) = _CodeSecurityVulnerability;

  factory CodeSecurityVulnerability.fromJson(Map<String, dynamic> json) =>
      _$CodeSecurityVulnerabilityFromJson(json);
}

@freezed
class CodeDuplicate with _$CodeDuplicate {
  const factory CodeDuplicate({
    required String id,
    required List<String> files,
    required int lines,
    required double similarity,
    required String code,
  }) = _CodeDuplicate;

  factory CodeDuplicate.fromJson(Map<String, dynamic> json) =>
      _$CodeDuplicateFromJson(json);
}

// ==================== API测试模型 ====================

@freezed
class APITestSuite with _$APITestSuite {
  const factory APITestSuite({
    required String id,
    required String name,
    required String description,
    required String baseUrl,
    @Default([]) List<APITestCase> testCases,
    @Default({}) Map<String, String> headers,
    @Default({}) Map<String, dynamic> variables,
    @Default('active') String status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _APITestSuite;

  factory APITestSuite.fromJson(Map<String, dynamic> json) =>
      _$APITestSuiteFromJson(json);
}

@freezed
class APITestCase with _$APITestCase {
  const factory APITestCase({
    required String id,
    required String suiteId,
    required String name,
    required String method,
    required String endpoint,
    @Default({}) Map<String, dynamic> headers,
    @Default({}) Map<String, dynamic> params,
    @Default({}) Map<String, dynamic> body,
    @Default({}) Map<String, dynamic> assertions,
    @Default(200) int expectedStatus,
    @Default(5000) int timeout,
    @Default(false) bool enabled,
  }) = _APITestCase;

  factory APITestCase.fromJson(Map<String, dynamic> json) =>
      _$APITestCaseFromJson(json);
}

@freezed
class APITestResult with _$APITestResult {
  const factory APITestResult({
    required String id,
    required String testCaseId,
    required String status,
    required int responseStatus,
    required int responseTime,
    @Default({}) Map<String, dynamic> responseBody,
    @Default({}) Map<String, String> responseHeaders,
    @Default([]) List<String> errors,
    @Default([]) List<String> warnings,
    DateTime? executedAt,
  }) = _APITestResult;

  factory APITestResult.fromJson(Map<String, dynamic> json) =>
      _$APITestResultFromJson(json);
}

// ==================== 文档生成模型 ====================

@freezed
class DocumentationRequest with _$DocumentationRequest {
  const factory DocumentationRequest({
    required String type,
    required String source,
    @Default({}) Map<String, dynamic> options,
    @Default('markdown') String format,
    @Default(false) bool includeExamples,
    @Default(false) bool includeDiagrams,
  }) = _DocumentationRequest;

  factory DocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentationRequestFromJson(json);
}

@freezed
class DocumentationResponse with _$DocumentationResponse {
  const factory DocumentationResponse({
    required String id,
    required String content,
    required String format,
    required String status,
    @Default(0) int wordCount,
    @Default(0) int pageCount,
    DateTime? generatedAt,
    String? downloadUrl,
  }) = _DocumentationResponse;

  factory DocumentationResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentationResponseFromJson(json);
}

// ==================== 代码审查模型 ====================

@freezed
class CodeReview with _$CodeReview {
  const factory CodeReview({
    required String id,
    required String title,
    required String description,
    required String repository,
    required String branch,
    required String commitHash,
    required String authorId,
    required String reviewerId,
    required String status,
    @Default([]) List<CodeReviewComment> comments,
    @Default([]) List<String> files,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? reviewedAt,
  }) = _CodeReview;

  factory CodeReview.fromJson(Map<String, dynamic> json) =>
      _$CodeReviewFromJson(json);
}

@freezed
class CodeReviewComment with _$CodeReviewComment {
  const factory CodeReviewComment({
    required String id,
    required String reviewId,
    required String authorId,
    required String content,
    required String file,
    required int line,
    @Default('comment') String type,
    @Default(false) bool resolved,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _CodeReviewComment;

  factory CodeReviewComment.fromJson(Map<String, dynamic> json) =>
      _$CodeReviewCommentFromJson(json);
}

// ==================== 文档生成请求响应模型 ====================

@freezed
class APIDocumentationRequest with _$APIDocumentationRequest {
  const factory APIDocumentationRequest({
    required String projectName,
    required String description,
    required List<APIEndpoint> endpoints,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _APIDocumentationRequest;

  factory APIDocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$APIDocumentationRequestFromJson(json);
}

@freezed
class UserManualRequest with _$UserManualRequest {
  const factory UserManualRequest({
    required String productName,
    required String description,
    required List<String> features,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _UserManualRequest;

  factory UserManualRequest.fromJson(Map<String, dynamic> json) =>
      _$UserManualRequestFromJson(json);
}

@freezed
class TechnicalDocumentationRequest with _$TechnicalDocumentationRequest {
  const factory TechnicalDocumentationRequest({
    required String projectName,
    required String description,
    required String technology,
    required List<String> components,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _TechnicalDocumentationRequest;

  factory TechnicalDocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$TechnicalDocumentationRequestFromJson(json);
}

@freezed
class ReadmeDocumentationRequest with _$ReadmeDocumentationRequest {
  const factory ReadmeDocumentationRequest({
    required String projectName,
    required String description,
    required String repository,
    @Default([]) List<String> features,
    @Default([]) List<String> requirements,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _ReadmeDocumentationRequest;

  factory ReadmeDocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$ReadmeDocumentationRequestFromJson(json);
}

@freezed
class ChangelogDocumentationRequest with _$ChangelogDocumentationRequest {
  const factory ChangelogDocumentationRequest({
    required String projectName,
    required String version,
    required List<ChangelogEntry> entries,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _ChangelogDocumentationRequest;

  factory ChangelogDocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$ChangelogDocumentationRequestFromJson(json);
}

@freezed
class DeploymentDocumentationRequest with _$DeploymentDocumentationRequest {
  const factory DeploymentDocumentationRequest({
    required String projectName,
    required String environment,
    required List<String> steps,
    @Default([]) List<String> requirements,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _DeploymentDocumentationRequest;

  factory DeploymentDocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$DeploymentDocumentationRequestFromJson(json);
}

@freezed
class TroubleshootingDocumentationRequest with _$TroubleshootingDocumentationRequest {
  const factory TroubleshootingDocumentationRequest({
    required String projectName,
    required List<TroubleshootingIssue> issues,
    @Default('markdown') String format,
    @Default({}) Map<String, dynamic> options,
  }) = _TroubleshootingDocumentationRequest;

  factory TroubleshootingDocumentationRequest.fromJson(Map<String, dynamic> json) =>
      _$TroubleshootingDocumentationRequestFromJson(json);
}

@freezed
class DocumentationQualityAnalysisRequest with _$DocumentationQualityAnalysisRequest {
  const factory DocumentationQualityAnalysisRequest({
    required String content,
    required String type,
    @Default({}) Map<String, dynamic> options,
  }) = _DocumentationQualityAnalysisRequest;

  factory DocumentationQualityAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$DocumentationQualityAnalysisRequestFromJson(json);
}

@freezed
class DocumentationQualityAnalysisResponse with _$DocumentationQualityAnalysisResponse {
  const factory DocumentationQualityAnalysisResponse({
    required String id,
    required double qualityScore,
    required List<QualityIssue> issues,
    required List<String> suggestions,
    required Map<String, dynamic> metrics,
    DateTime? analyzedAt,
  }) = _DocumentationQualityAnalysisResponse;

  factory DocumentationQualityAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$DocumentationQualityAnalysisResponseFromJson(json);
}

// ==================== 代码审查请求响应模型 ====================

@freezed
class CreateCodeReviewRequest with _$CreateCodeReviewRequest {
  const factory CreateCodeReviewRequest({
    required String title,
    required String description,
    required String repository,
    required String branch,
    required String commitHash,
    required String authorId,
    required String reviewerId,
    @Default([]) List<String> files,
    @Default({}) Map<String, dynamic> options,
  }) = _CreateCodeReviewRequest;

  factory CreateCodeReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCodeReviewRequestFromJson(json);
}

@freezed
class UpdateCodeReviewRequest with _$UpdateCodeReviewRequest {
  const factory UpdateCodeReviewRequest({
    String? title,
    String? description,
    String? status,
    @Default({}) Map<String, dynamic> options,
  }) = _UpdateCodeReviewRequest;

  factory UpdateCodeReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCodeReviewRequestFromJson(json);
}

@freezed
class AddCodeReviewCommentRequest with _$AddCodeReviewCommentRequest {
  const factory AddCodeReviewCommentRequest({
    required String content,
    required String file,
    required int line,
    @Default('comment') String type,
    @Default({}) Map<String, dynamic> options,
  }) = _AddCodeReviewCommentRequest;

  factory AddCodeReviewCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddCodeReviewCommentRequestFromJson(json);
}

@freezed
class UpdateCodeReviewCommentRequest with _$UpdateCodeReviewCommentRequest {
  const factory UpdateCodeReviewCommentRequest({
    String? content,
    @Default({}) Map<String, dynamic> options,
  }) = _UpdateCodeReviewCommentRequest;

  factory UpdateCodeReviewCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCodeReviewCommentRequestFromJson(json);
}

@freezed
class AICodeReviewRequest with _$AICodeReviewRequest {
  const factory AICodeReviewRequest({
    required String code,
    required String language,
    @Default([]) List<String> focusAreas,
    @Default({}) Map<String, dynamic> options,
  }) = _AICodeReviewRequest;

  factory AICodeReviewRequest.fromJson(Map<String, dynamic> json) =>
      _$AICodeReviewRequestFromJson(json);
}

@freezed
class AICodeReviewResponse with _$AICodeReviewResponse {
  const factory AICodeReviewResponse({
    required String id,
    required double qualityScore,
    required List<CodeIssue> issues,
    required List<String> suggestions,
    required Map<String, dynamic> metrics,
    DateTime? reviewedAt,
  }) = _AICodeReviewResponse;

  factory AICodeReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$AICodeReviewResponseFromJson(json);
}

@freezed
class CodeQualityAnalysisRequest with _$CodeQualityAnalysisRequest {
  const factory CodeQualityAnalysisRequest({
    required String code,
    required String language,
    @Default({}) Map<String, dynamic> options,
  }) = _CodeQualityAnalysisRequest;

  factory CodeQualityAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$CodeQualityAnalysisRequestFromJson(json);
}

@freezed
class CodeQualityAnalysisResponse with _$CodeQualityAnalysisResponse {
  const factory CodeQualityAnalysisResponse({
    required String id,
    required double qualityScore,
    required List<QualityMetric> metrics,
    required List<String> recommendations,
    DateTime? analyzedAt,
  }) = _CodeQualityAnalysisResponse;

  factory CodeQualityAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$CodeQualityAnalysisResponseFromJson(json);
}

@freezed
class SecurityScanRequest with _$SecurityScanRequest {
  const factory SecurityScanRequest({
    required String code,
    required String language,
    @Default([]) List<String> scanTypes,
    @Default({}) Map<String, dynamic> options,
  }) = _SecurityScanRequest;

  factory SecurityScanRequest.fromJson(Map<String, dynamic> json) =>
      _$SecurityScanRequestFromJson(json);
}

@freezed
class SecurityScanResponse with _$SecurityScanResponse {
  const factory SecurityScanResponse({
    required String id,
    required double securityScore,
    required List<SecurityVulnerability> vulnerabilities,
    required List<String> recommendations,
    DateTime? scannedAt,
  }) = _SecurityScanResponse;

  factory SecurityScanResponse.fromJson(Map<String, dynamic> json) =>
      _$SecurityScanResponseFromJson(json);
}

@freezed
class PerformanceAnalysisRequest with _$PerformanceAnalysisRequest {
  const factory PerformanceAnalysisRequest({
    required String code,
    required String language,
    @Default([]) List<String> analysisTypes,
    @Default({}) Map<String, dynamic> options,
  }) = _PerformanceAnalysisRequest;

  factory PerformanceAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$PerformanceAnalysisRequestFromJson(json);
}

@freezed
class PerformanceAnalysisResponse with _$PerformanceAnalysisResponse {
  const factory PerformanceAnalysisResponse({
    required String id,
    required double performanceScore,
    required List<PerformanceIssue> issues,
    required List<String> optimizations,
    DateTime? analyzedAt,
  }) = _PerformanceAnalysisResponse;

  factory PerformanceAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$PerformanceAnalysisResponseFromJson(json);
}

@freezed
class CodeReviewListResponse with _$CodeReviewListResponse {
  const factory CodeReviewListResponse({
    required List<CodeReview> reviews,
    required int total,
    required int page,
    required int limit,
  }) = _CodeReviewListResponse;

  factory CodeReviewListResponse.fromJson(Map<String, dynamic> json) =>
      _$CodeReviewListResponseFromJson(json);
}

// ==================== 辅助模型 ====================

@freezed
class APIEndpoint with _$APIEndpoint {
  const factory APIEndpoint({
    required String method,
    required String path,
    required String description,
    @Default({}) Map<String, dynamic> parameters,
    @Default({}) Map<String, dynamic> responses,
  }) = _APIEndpoint;

  factory APIEndpoint.fromJson(Map<String, dynamic> json) =>
      _$APIEndpointFromJson(json);
}

@freezed
class ChangelogEntry with _$ChangelogEntry {
  const factory ChangelogEntry({
    required String type,
    required String description,
    @Default([]) List<String> details,
  }) = _ChangelogEntry;

  factory ChangelogEntry.fromJson(Map<String, dynamic> json) =>
      _$ChangelogEntryFromJson(json);
}

@freezed
class TroubleshootingIssue with _$TroubleshootingIssue {
  const factory TroubleshootingIssue({
    required String title,
    required String description,
    required List<String> solutions,
    @Default([]) List<String> preventionTips,
  }) = _TroubleshootingIssue;

  factory TroubleshootingIssue.fromJson(Map<String, dynamic> json) =>
      _$TroubleshootingIssueFromJson(json);
}

@freezed
class QualityIssue with _$QualityIssue {
  const factory QualityIssue({
    required String type,
    required String description,
    required String severity,
    required int line,
    @Default([]) List<String> suggestions,
  }) = _QualityIssue;

  factory QualityIssue.fromJson(Map<String, dynamic> json) =>
      _$QualityIssueFromJson(json);
}

@freezed
class CodeIssueDetail with _$CodeIssueDetail {
  const factory CodeIssueDetail({
    required String type,
    required String description,
    required String severity,
    required int line,
    @Default([]) List<String> suggestions,
  }) = _CodeIssueDetail;

  factory CodeIssueDetail.fromJson(Map<String, dynamic> json) =>
      _$CodeIssueDetailFromJson(json);
}

@freezed
class QualityMetric with _$QualityMetric {
  const factory QualityMetric({
    required String name,
    required double value,
    required String unit,
    required String description,
  }) = _QualityMetric;

  factory QualityMetric.fromJson(Map<String, dynamic> json) =>
      _$QualityMetricFromJson(json);
}

@freezed
class SecurityVulnerability with _$SecurityVulnerability {
  const factory SecurityVulnerability({
    required String type,
    required String description,
    required String severity,
    required int line,
    @Default([]) List<String> recommendations,
  }) = _SecurityVulnerability;

  factory SecurityVulnerability.fromJson(Map<String, dynamic> json) =>
      _$SecurityVulnerabilityFromJson(json);
}

@freezed
class PerformanceIssue with _$PerformanceIssue {
  const factory PerformanceIssue({
    required String type,
    required String description,
    required String severity,
    required int line,
    @Default([]) List<String> optimizations,
  }) = _PerformanceIssue;

  factory PerformanceIssue.fromJson(Map<String, dynamic> json) =>
      _$PerformanceIssueFromJson(json);
}

// ==================== 请求响应模型 ====================

// 批量测试生成请求
@freezed
class BatchTestGenerationRequest with _$BatchTestGenerationRequest {
  const factory BatchTestGenerationRequest({
    required List<String> codeFiles,
    required String language,
    required String framework,
    @Default({}) Map<String, dynamic> options,
  }) = _BatchTestGenerationRequest;

  factory BatchTestGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$BatchTestGenerationRequestFromJson(json);
}

@freezed
class BatchTestGenerationResponse with _$BatchTestGenerationResponse {
  const factory BatchTestGenerationResponse({
    required String batchId,
    required List<TestGenerationResponse> results,
    required String status,
    @Default(0) int totalFiles,
    @Default(0) int completedFiles,
    DateTime? createdAt,
  }) = _BatchTestGenerationResponse;

  factory BatchTestGenerationResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchTestGenerationResponseFromJson(json);
}

// 单元测试生成
@freezed
class UnitTestRequest with _$UnitTestRequest {
  const factory UnitTestRequest({
    required String functionCode,
    required String language,
    @Default({}) Map<String, dynamic> options,
  }) = _UnitTestRequest;

  factory UnitTestRequest.fromJson(Map<String, dynamic> json) =>
      _$UnitTestRequestFromJson(json);
}

@freezed
class UnitTestResponse with _$UnitTestResponse {
  const factory UnitTestResponse({
    required String id,
    required List<TestCase> unitTests,
    required String status,
    DateTime? generatedAt,
  }) = _UnitTestResponse;

  factory UnitTestResponse.fromJson(Map<String, dynamic> json) =>
      _$UnitTestResponseFromJson(json);
}

// 集成测试生成
@freezed
class IntegrationTestRequest with _$IntegrationTestRequest {
  const factory IntegrationTestRequest({
    required String serviceCode,
    required String language,
    @Default([]) List<String> dependencies,
    @Default({}) Map<String, dynamic> options,
  }) = _IntegrationTestRequest;

  factory IntegrationTestRequest.fromJson(Map<String, dynamic> json) =>
      _$IntegrationTestRequestFromJson(json);
}

@freezed
class IntegrationTestResponse with _$IntegrationTestResponse {
  const factory IntegrationTestResponse({
    required String id,
    required List<TestCase> integrationTests,
    required String status,
    DateTime? generatedAt,
  }) = _IntegrationTestResponse;

  factory IntegrationTestResponse.fromJson(Map<String, dynamic> json) =>
      _$IntegrationTestResponseFromJson(json);
}

// 性能测试生成
@freezed
class PerformanceTestRequest with _$PerformanceTestRequest {
  const factory PerformanceTestRequest({
    required String code,
    required String language,
    @Default({}) Map<String, dynamic> benchmarkOptions,
  }) = _PerformanceTestRequest;

  factory PerformanceTestRequest.fromJson(Map<String, dynamic> json) =>
      _$PerformanceTestRequestFromJson(json);
}

@freezed
class PerformanceTestResponse with _$PerformanceTestResponse {
  const factory PerformanceTestResponse({
    required String id,
    required List<TestCase> performanceTests,
    required String status,
    DateTime? generatedAt,
  }) = _PerformanceTestResponse;

  factory PerformanceTestResponse.fromJson(Map<String, dynamic> json) =>
      _$PerformanceTestResponseFromJson(json);
}

// 安全测试生成
@freezed
class SecurityTestRequest with _$SecurityTestRequest {
  const factory SecurityTestRequest({
    required String code,
    required String language,
    @Default([]) List<String> vulnerabilityTypes,
    @Default({}) Map<String, dynamic> options,
  }) = _SecurityTestRequest;

  factory SecurityTestRequest.fromJson(Map<String, dynamic> json) =>
      _$SecurityTestRequestFromJson(json);
}

@freezed
class SecurityTestResponse with _$SecurityTestResponse {
  const factory SecurityTestResponse({
    required String id,
    required List<TestCase> securityTests,
    required String status,
    DateTime? generatedAt,
  }) = _SecurityTestResponse;

  factory SecurityTestResponse.fromJson(Map<String, dynamic> json) =>
      _$SecurityTestResponseFromJson(json);
}

// 测试质量分析
@freezed
class TestQualityAnalysisRequest with _$TestQualityAnalysisRequest {
  const factory TestQualityAnalysisRequest({
    required List<TestCase> testCases,
    required String codeBase,
    @Default({}) Map<String, dynamic> options,
  }) = _TestQualityAnalysisRequest;

  factory TestQualityAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$TestQualityAnalysisRequestFromJson(json);
}

@freezed
class TestQualityAnalysisResponse with _$TestQualityAnalysisResponse {
  const factory TestQualityAnalysisResponse({
    required String id,
    required TestQualityReport report,
    required String status,
    DateTime? analyzedAt,
  }) = _TestQualityAnalysisResponse;

  factory TestQualityAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$TestQualityAnalysisResponseFromJson(json);
}

@freezed
class TestQualityReport with _$TestQualityReport {
  const factory TestQualityReport({
    @Default(0.0) double coverageScore,
    @Default(0.0) double qualityScore,
    @Default(0) int duplicateTests,
    @Default(0) int missingTests,
    @Default([]) List<String> recommendations,
  }) = _TestQualityReport;

  factory TestQualityReport.fromJson(Map<String, dynamic> json) =>
      _$TestQualityReportFromJson(json);
}

// 覆盖率分析
@freezed
class CoverageAnalysisRequest with _$CoverageAnalysisRequest {
  const factory CoverageAnalysisRequest({
    required String codeBase,
    required List<TestCase> testCases,
    @Default({}) Map<String, dynamic> options,
  }) = _CoverageAnalysisRequest;

  factory CoverageAnalysisRequest.fromJson(Map<String, dynamic> json) =>
      _$CoverageAnalysisRequestFromJson(json);
}

@freezed
class CoverageAnalysisResponse with _$CoverageAnalysisResponse {
  const factory CoverageAnalysisResponse({
    required String id,
    required CoverageReport report,
    required String status,
    DateTime? analyzedAt,
  }) = _CoverageAnalysisResponse;

  factory CoverageAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$CoverageAnalysisResponseFromJson(json);
}

@freezed
class CoverageReport with _$CoverageReport {
  const factory CoverageReport({
    @Default(0.0) double lineCoverage,
    @Default(0.0) double functionCoverage,
    @Default(0.0) double branchCoverage,
    @Default([]) List<String> uncoveredLines,
    @Default([]) List<String> uncoveredFunctions,
  }) = _CoverageReport;

  factory CoverageReport.fromJson(Map<String, dynamic> json) =>
      _$CoverageReportFromJson(json);
}

// PDF转换相关请求
@freezed
class WordToPDFRequest with _$WordToPDFRequest {
  const factory WordToPDFRequest({
    required String fileUrl,
    @Default({}) Map<String, dynamic> options,
    @Default(false) bool compress,
    String? password,
  }) = _WordToPDFRequest;

  factory WordToPDFRequest.fromJson(Map<String, dynamic> json) =>
      _$WordToPDFRequestFromJson(json);
}

@freezed
class ExcelToPDFRequest with _$ExcelToPDFRequest {
  const factory ExcelToPDFRequest({
    required String fileUrl,
    @Default({}) Map<String, dynamic> options,
    @Default(false) bool compress,
    String? password,
  }) = _ExcelToPDFRequest;

  factory ExcelToPDFRequest.fromJson(Map<String, dynamic> json) =>
      _$ExcelToPDFRequestFromJson(json);
}

@freezed
class PowerPointToPDFRequest with _$PowerPointToPDFRequest {
  const factory PowerPointToPDFRequest({
    required String fileUrl,
    @Default({}) Map<String, dynamic> options,
    @Default(false) bool compress,
    String? password,
  }) = _PowerPointToPDFRequest;

  factory PowerPointToPDFRequest.fromJson(Map<String, dynamic> json) =>
      _$PowerPointToPDFRequestFromJson(json);
}

@freezed
class PDFMergeRequest with _$PDFMergeRequest {
  const factory PDFMergeRequest({
    required List<String> fileUrls,
    @Default({}) Map<String, dynamic> options,
    String? outputName,
  }) = _PDFMergeRequest;

  factory PDFMergeRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFMergeRequestFromJson(json);
}

@freezed
class PDFMergeResponse with _$PDFMergeResponse {
  const factory PDFMergeResponse({
    required String id,
    required String downloadUrl,
    required String status,
    @Default(0) int totalPages,
    DateTime? createdAt,
  }) = _PDFMergeResponse;

  factory PDFMergeResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFMergeResponseFromJson(json);
}

@freezed
class PDFSplitRequest with _$PDFSplitRequest {
  const factory PDFSplitRequest({
    required String fileUrl,
    @Default([]) List<int> pageRanges,
    @Default({}) Map<String, dynamic> options,
  }) = _PDFSplitRequest;

  factory PDFSplitRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFSplitRequestFromJson(json);
}

@freezed
class PDFSplitResponse with _$PDFSplitResponse {
  const factory PDFSplitResponse({
    required String id,
    required List<String> downloadUrls,
    required String status,
    @Default(0) int totalParts,
    DateTime? createdAt,
  }) = _PDFSplitResponse;

  factory PDFSplitResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFSplitResponseFromJson(json);
}

@freezed
class PDFCompressionRequest with _$PDFCompressionRequest {
  const factory PDFCompressionRequest({
    required String fileUrl,
    @Default('medium') String compressionLevel,
    @Default({}) Map<String, dynamic> options,
  }) = _PDFCompressionRequest;

  factory PDFCompressionRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFCompressionRequestFromJson(json);
}

@freezed
class PDFCompressionResponse with _$PDFCompressionResponse {
  const factory PDFCompressionResponse({
    required String id,
    required String downloadUrl,
    required String status,
    @Default(0) int originalSize,
    @Default(0) int compressedSize,
    @Default(0.0) double compressionRatio,
    DateTime? createdAt,
  }) = _PDFCompressionResponse;

  factory PDFCompressionResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFCompressionResponseFromJson(json);
}

@freezed
class PDFEncryptionRequest with _$PDFEncryptionRequest {
  const factory PDFEncryptionRequest({
    required String fileUrl,
    required String password,
    @Default({}) Map<String, dynamic> permissions,
  }) = _PDFEncryptionRequest;

  factory PDFEncryptionRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFEncryptionRequestFromJson(json);
}

@freezed
class PDFEncryptionResponse with _$PDFEncryptionResponse {
  const factory PDFEncryptionResponse({
    required String id,
    required String downloadUrl,
    required String status,
    DateTime? createdAt,
  }) = _PDFEncryptionResponse;

  factory PDFEncryptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFEncryptionResponseFromJson(json);
}

@freezed
class PDFDecryptionRequest with _$PDFDecryptionRequest {
  const factory PDFDecryptionRequest({
    required String fileUrl,
    required String password,
  }) = _PDFDecryptionRequest;

  factory PDFDecryptionRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFDecryptionRequestFromJson(json);
}

@freezed
class PDFDecryptionResponse with _$PDFDecryptionResponse {
  const factory PDFDecryptionResponse({
    required String id,
    required String downloadUrl,
    required String status,
    DateTime? createdAt,
  }) = _PDFDecryptionResponse;

  factory PDFDecryptionResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFDecryptionResponseFromJson(json);
}

@freezed
class PDFToImagesRequest with _$PDFToImagesRequest {
  const factory PDFToImagesRequest({
    required String fileUrl,
    @Default('png') String format,
    @Default(150) int dpi,
    @Default({}) Map<String, dynamic> options,
  }) = _PDFToImagesRequest;

  factory PDFToImagesRequest.fromJson(Map<String, dynamic> json) =>
      _$PDFToImagesRequestFromJson(json);
}

@freezed
class PDFToImagesResponse with _$PDFToImagesResponse {
  const factory PDFToImagesResponse({
    required String id,
    required List<String> imageUrls,
    required String status,
    @Default(0) int totalImages,
    DateTime? createdAt,
  }) = _PDFToImagesResponse;

  factory PDFToImagesResponse.fromJson(Map<String, dynamic> json) =>
      _$PDFToImagesResponseFromJson(json);
}

@freezed
class ImagesToPDFRequest with _$ImagesToPDFRequest {
  const factory ImagesToPDFRequest({
    required List<String> imageUrls,
    @Default({}) Map<String, dynamic> options,
    String? outputName,
  }) = _ImagesToPDFRequest;

  factory ImagesToPDFRequest.fromJson(Map<String, dynamic> json) =>
      _$ImagesToPDFRequestFromJson(json);
}

@freezed
class ImagesToPDFResponse with _$ImagesToPDFResponse {
  const factory ImagesToPDFResponse({
    required String id,
    required String downloadUrl,
    required String status,
    @Default(0) int totalPages,
    DateTime? createdAt,
  }) = _ImagesToPDFResponse;

  factory ImagesToPDFResponse.fromJson(Map<String, dynamic> json) =>
      _$ImagesToPDFResponseFromJson(json);
}

// 项目任务管理相关请求
@freezed
class CreateProjectRequest with _$CreateProjectRequest {
  const factory CreateProjectRequest({
    required String name,
    required String description,
    @Default([]) List<String> memberIds,
    @Default({}) Map<String, dynamic> settings,
    DateTime? deadline,
  }) = _CreateProjectRequest;

  factory CreateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProjectRequestFromJson(json);
}

@freezed
class ProjectResponse with _$ProjectResponse {
  const factory ProjectResponse({
    required Project project,
    required String status,
  }) = _ProjectResponse;

  factory ProjectResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectResponseFromJson(json);
}

@freezed
class ProjectsListResponse with _$ProjectsListResponse {
  const factory ProjectsListResponse({
    required List<Project> projects,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _ProjectsListResponse;

  factory ProjectsListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectsListResponseFromJson(json);
}

@freezed
class ProjectDetailResponse with _$ProjectDetailResponse {
  const factory ProjectDetailResponse({
    required Project project,
    required List<Task> tasks,
    required List<ProjectMember> members,
  }) = _ProjectDetailResponse;

  factory ProjectDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectDetailResponseFromJson(json);
}

@freezed
class ProjectMember with _$ProjectMember {
  const factory ProjectMember({
    required String id,
    required String userId,
    required String role,
    required String status,
    DateTime? joinedAt,
  }) = _ProjectMember;

  factory ProjectMember.fromJson(Map<String, dynamic> json) =>
      _$ProjectMemberFromJson(json);
}

@freezed
class UpdateProjectRequest with _$UpdateProjectRequest {
  const factory UpdateProjectRequest({
    String? name,
    String? description,
    String? status,
    List<String>? memberIds,
    Map<String, dynamic>? settings,
    DateTime? deadline,
  }) = _UpdateProjectRequest;

  factory UpdateProjectRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProjectRequestFromJson(json);
}

@freezed
class CreateTaskRequest with _$CreateTaskRequest {
  const factory CreateTaskRequest({
    required String title,
    required String description,
    required String priority,
    required String assigneeId,
    @Default([]) List<String> tags,
    @Default({}) Map<String, dynamic> metadata,
    @Default(0) int estimatedHours,
    DateTime? dueDate,
  }) = _CreateTaskRequest;

  factory CreateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTaskRequestFromJson(json);
}

@freezed
class TaskResponse with _$TaskResponse {
  const factory TaskResponse({
    required Task task,
    required String status,
  }) = _TaskResponse;

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);
}

@freezed
class TasksListResponse with _$TasksListResponse {
  const factory TasksListResponse({
    required List<Task> tasks,
    @Default(0) int total,
    @Default(1) int page,
    @Default(10) int limit,
  }) = _TasksListResponse;

  factory TasksListResponse.fromJson(Map<String, dynamic> json) =>
      _$TasksListResponseFromJson(json);
}

@freezed
class UpdateTaskStatusRequest with _$UpdateTaskStatusRequest {
  const factory UpdateTaskStatusRequest({
    required String status,
    String? comment,
  }) = _UpdateTaskStatusRequest;

  factory UpdateTaskStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskStatusRequestFromJson(json);
}

@freezed
class AssignTaskRequest with _$AssignTaskRequest {
  const factory AssignTaskRequest({
    required String assigneeId,
    String? comment,
  }) = _AssignTaskRequest;

  factory AssignTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignTaskRequestFromJson(json);
}

@freezed
class AddTaskCommentRequest with _$AddTaskCommentRequest {
  const factory AddTaskCommentRequest({
    required String content,
    @Default([]) List<String> attachments,
  }) = _AddTaskCommentRequest;

  factory AddTaskCommentRequest.fromJson(Map<String, dynamic> json) =>
      _$AddTaskCommentRequestFromJson(json);
}

@freezed
class TaskCommentResponse with _$TaskCommentResponse {
  const factory TaskCommentResponse({
    required TaskComment comment,
    required String status,
  }) = _TaskCommentResponse;

  factory TaskCommentResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskCommentResponseFromJson(json);
}

@freezed
class TaskTimelineResponse with _$TaskTimelineResponse {
  const factory TaskTimelineResponse({
    required List<TaskTimelineEvent> events,
  }) = _TaskTimelineResponse;

  factory TaskTimelineResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskTimelineResponseFromJson(json);
}

@freezed
class TaskTimelineEvent with _$TaskTimelineEvent {
  const factory TaskTimelineEvent({
    required String id,
    required String type,
    required String description,
    required String userId,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? occurredAt,
  }) = _TaskTimelineEvent;

  factory TaskTimelineEvent.fromJson(Map<String, dynamic> json) =>
      _$TaskTimelineEventFromJson(json);
}

@freezed
class GenerateReportRequest with _$GenerateReportRequest {
  const factory GenerateReportRequest({
    required String type,
    @Default({}) Map<String, dynamic> options,
    DateTime? startDate,
    DateTime? endDate,
  }) = _GenerateReportRequest;

  factory GenerateReportRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateReportRequestFromJson(json);
}

@freezed
class ProjectReportResponse with _$ProjectReportResponse {
  const factory ProjectReportResponse({
    required String id,
    required String downloadUrl,
    required String status,
    DateTime? generatedAt,
  }) = _ProjectReportResponse;

  factory ProjectReportResponse.fromJson(Map<String, dynamic> json) =>
      _$ProjectReportResponseFromJson(json);
}