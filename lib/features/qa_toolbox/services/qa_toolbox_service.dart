import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/qa_toolbox_model.dart';

part 'qa_toolbox_service.g.dart';

/// QAToolBox 核心服务 - 调用Go后端API
@RestApi(baseUrl: "http://localhost:8080/api/v1")
abstract class QAToolBoxService {
  factory QAToolBoxService(Dio dio, {String baseUrl}) = _QAToolBoxService;

  // ==================== 测试用例生成器 ====================
  
  /// AI驱动的测试用例生成
  @POST('/test-cases/generate')
  Future<TestGenerationResponse> generateTestCases(@Body() TestGenerationRequest request);
  
  /// 批量生成测试用例
  @POST('/test-cases/generate-batch')
  Future<BatchTestGenerationResponse> generateBatchTestCases(@Body() BatchTestGenerationRequest request);
  
  /// 生成单元测试
  @POST('/test-cases/generate-unit')
  Future<UnitTestResponse> generateUnitTests(@Body() UnitTestRequest request);
  
  /// 生成集成测试
  @POST('/test-cases/generate-integration')
  Future<IntegrationTestResponse> generateIntegrationTests(@Body() IntegrationTestRequest request);
  
  /// 生成性能测试
  @POST('/test-cases/generate-performance')
  Future<PerformanceTestResponse> generatePerformanceTests(@Body() PerformanceTestRequest request);
  
  /// 生成安全测试
  @POST('/test-cases/generate-security')
  Future<SecurityTestResponse> generateSecurityTests(@Body() SecurityTestRequest request);
  
  /// 测试用例质量分析
  @POST('/test-cases/analyze-quality')
  Future<TestQualityAnalysisResponse> analyzeTestQuality(@Body() TestQualityAnalysisRequest request);
  
  /// 测试覆盖率分析
  @POST('/test-cases/coverage-analysis')
  Future<CoverageAnalysisResponse> analyzeCoverage(@Body() CoverageAnalysisRequest request);

  // ==================== PDF转换器 ====================
  
  /// Word转PDF
  @POST('/pdf/convert-word')
  Future<PDFConversionResponse> convertWordToPDF(@Body() WordToPDFRequest request);
  
  /// Excel转PDF
  @POST('/pdf/convert-excel')
  Future<PDFConversionResponse> convertExcelToPDF(@Body() ExcelToPDFRequest request);
  
  /// PowerPoint转PDF
  @POST('/pdf/convert-powerpoint')
  Future<PDFConversionResponse> convertPowerPointToPDF(@Body() PowerPointToPDFRequest request);
  
  /// 批量PDF转换
  @POST('/pdf/convert-batch')
  Future<BatchPDFConversionResponse> convertBatchToPDF(@Body() BatchPDFConversionRequest request);

  // ==================== 文档生成器 ====================
  
  /// 生成API文档
  @POST('/documentation/generate-api')
  Future<DocumentationResponse> generateAPIDocumentation(@Body() APIDocumentationRequest request);
  
  /// 生成用户手册
  @POST('/documentation/generate-user-manual')
  Future<DocumentationResponse> generateUserManual(@Body() UserManualRequest request);
  
  /// 生成技术文档
  @POST('/documentation/generate-technical')
  Future<DocumentationResponse> generateTechnicalDocumentation(@Body() TechnicalDocumentationRequest request);
  
  /// 生成README文档
  @POST('/documentation/generate-readme')
  Future<DocumentationResponse> generateReadmeDocumentation(@Body() ReadmeDocumentationRequest request);
  
  /// 生成变更日志
  @POST('/documentation/generate-changelog')
  Future<DocumentationResponse> generateChangelogDocumentation(@Body() ChangelogDocumentationRequest request);
  
  /// 生成部署文档
  @POST('/documentation/generate-deployment')
  Future<DocumentationResponse> generateDeploymentDocumentation(@Body() DeploymentDocumentationRequest request);
  
  /// 生成故障排除文档
  @POST('/documentation/generate-troubleshooting')
  Future<DocumentationResponse> generateTroubleshootingDocumentation(@Body() TroubleshootingDocumentationRequest request);
  
  /// 文档质量分析
  @POST('/documentation/analyze-quality')
  Future<DocumentationQualityAnalysisResponse> analyzeDocumentationQuality(@Body() DocumentationQualityAnalysisRequest request);

  // ==================== 代码审查 ====================
  
  /// 创建代码审查
  @POST('/code-review/create')
  Future<CodeReview> createCodeReview(@Body() CreateCodeReviewRequest request);
  
  /// 获取代码审查列表
  @GET('/code-review/list')
  Future<CodeReviewListResponse> getCodeReviewList(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取代码审查详情
  @GET('/code-review/{id}')
  Future<CodeReview> getCodeReview(@Path('id') String id);
  
  /// 更新代码审查
  @PUT('/code-review/{id}')
  Future<CodeReview> updateCodeReview(@Path('id') String id, @Body() UpdateCodeReviewRequest request);
  
  /// 添加审查评论
  @POST('/code-review/{id}/comments')
  Future<CodeReviewComment> addCodeReviewComment(@Path('id') String id, @Body() AddCodeReviewCommentRequest request);
  
  /// 更新审查评论
  @PUT('/code-review/{id}/comments/{commentId}')
  Future<CodeReviewComment> updateCodeReviewComment(@Path('id') String id, @Path('commentId') String commentId, @Body() UpdateCodeReviewCommentRequest request);
  
  /// 解决审查评论
  @PUT('/code-review/{id}/comments/{commentId}/resolve')
  Future<CodeReviewComment> resolveCodeReviewComment(@Path('id') String id, @Path('commentId') String commentId);
  
  /// 完成代码审查
  @PUT('/code-review/{id}/complete')
  Future<CodeReview> completeCodeReview(@Path('id') String id);
  
  /// AI代码审查
  @POST('/code-review/ai-review')
  Future<AICodeReviewResponse> performAICodeReview(@Body() AICodeReviewRequest request);
  
  /// 代码质量分析
  @POST('/code-review/analyze-quality')
  Future<CodeQualityAnalysisResponse> analyzeCodeQuality(@Body() CodeQualityAnalysisRequest request);
  
  /// 安全漏洞扫描
  @POST('/code-review/security-scan')
  Future<SecurityScanResponse> performSecurityScan(@Body() SecurityScanRequest request);
  
  /// 性能分析
  @POST('/code-review/performance-analysis')
  Future<PerformanceAnalysisResponse> performPerformanceAnalysis(@Body() PerformanceAnalysisRequest request);
  
  /// PDF合并
  @POST('/pdf/merge')
  Future<PDFMergeResponse> mergePDFs(@Body() PDFMergeRequest request);
  
  /// PDF分割
  @POST('/pdf/split')
  Future<PDFSplitResponse> splitPDF(@Body() PDFSplitRequest request);
  
  /// PDF压缩
  @POST('/pdf/compress')
  Future<PDFCompressionResponse> compressPDF(@Body() PDFCompressionRequest request);
  
  /// PDF加密
  @POST('/pdf/encrypt')
  Future<PDFEncryptionResponse> encryptPDF(@Body() PDFEncryptionRequest request);
  
  /// PDF解密
  @POST('/pdf/decrypt')
  Future<PDFDecryptionResponse> decryptPDF(@Body() PDFDecryptionRequest request);
  
  /// PDF转图片
  @POST('/pdf/to-images')
  Future<PDFToImagesResponse> convertPDFToImages(@Body() PDFToImagesRequest request);
  
  /// 图片转PDF
  @POST('/pdf/from-images')
  Future<ImagesToPDFResponse> convertImagesToPDF(@Body() ImagesToPDFRequest request);

  // ==================== 任务管理器 ====================
  
  /// 创建项目
  @POST('/projects')
  Future<ProjectResponse> createProject(@Body() CreateProjectRequest request);
  
  /// 获取项目列表
  @GET('/projects')
  Future<ProjectsListResponse> getProjects(@Query('page') int page, @Query('limit') int limit);
  
  /// 获取项目详情
  @GET('/projects/{id}')
  Future<ProjectDetailResponse> getProject(@Path('id') String id);
  
  /// 更新项目
  @PUT('/projects/{id}')
  Future<ProjectResponse> updateProject(@Path('id') String id, @Body() UpdateProjectRequest request);
  
  /// 删除项目
  @DELETE('/projects/{id}')
  Future<void> deleteProject(@Path('id') String id);
  
  /// 创建任务
  @POST('/projects/{projectId}/tasks')
  Future<TaskResponse> createTask(@Path('projectId') String projectId, @Body() CreateTaskRequest request);
  
  /// 获取任务列表
  @GET('/projects/{projectId}/tasks')
  Future<TasksListResponse> getTasks(@Path('projectId') String projectId, @Query('status') String? status);
  
  /// 更新任务状态
  @PUT('/tasks/{id}/status')
  Future<TaskResponse> updateTaskStatus(@Path('id') String id, @Body() UpdateTaskStatusRequest request);
  
  /// 分配任务
  @PUT('/tasks/{id}/assign')
  Future<TaskResponse> assignTask(@Path('id') String id, @Body() AssignTaskRequest request);
  
  /// 添加任务评论
  @POST('/tasks/{id}/comments')
  Future<TaskCommentResponse> addTaskComment(@Path('id') String id, @Body() AddTaskCommentRequest request);
  
  /// 获取任务时间线
  @GET('/tasks/{id}/timeline')
  Future<TaskTimelineResponse> getTaskTimeline(@Path('id') String id);
  
  /// 生成项目报告
  @POST('/projects/{id}/reports')
  Future<ProjectReportResponse> generateProjectReport(@Path('id') String id, @Body() GenerateReportRequest request);
}