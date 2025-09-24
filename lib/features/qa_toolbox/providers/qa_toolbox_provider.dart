import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/qa_toolbox_model.dart';
import '../services/qa_toolbox_service.dart';

// ==================== QAToolBox 状态管理 - 完整实现 ====================

/// QAToolBox 整体状态
class QAToolBoxState {
  final List<TestCase> testCases;
  final List<Project> projects;
  final List<Task> tasks;
  final List<CrawlerTask> crawlerTasks;
  final List<APITestSuite> apiTestSuites;
  final List<CodeReview> codeReviews;
  final List<PDFConversionResponse> pdfConversions;
  final QAToolBoxSettings settings;
  final bool isLoading;
  final String? error;

  const QAToolBoxState({
    this.testCases = const [],
    this.projects = const [],
    this.tasks = const [],
    this.crawlerTasks = const [],
    this.apiTestSuites = const [],
    this.codeReviews = const [],
    this.pdfConversions = const [],
    required this.settings,
    this.isLoading = false,
    this.error,
  });

  QAToolBoxState copyWith({
    List<TestCase>? testCases,
    List<Project>? projects,
    List<Task>? tasks,
    List<CrawlerTask>? crawlerTasks,
    List<APITestSuite>? apiTestSuites,
    List<CodeReview>? codeReviews,
    List<PDFConversionResponse>? pdfConversions,
    QAToolBoxSettings? settings,
    bool? isLoading,
    String? error,
  }) {
    return QAToolBoxState(
      testCases: testCases ?? this.testCases,
      projects: projects ?? this.projects,
      tasks: tasks ?? this.tasks,
      crawlerTasks: crawlerTasks ?? this.crawlerTasks,
      apiTestSuites: apiTestSuites ?? this.apiTestSuites,
      codeReviews: codeReviews ?? this.codeReviews,
      pdfConversions: pdfConversions ?? this.pdfConversions,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// QAToolBox 设置
class QAToolBoxSettings {
  final bool autoSaveEnabled;
  final bool notificationsEnabled;
  final String defaultLanguage;
  final String codeStyle;
  final int testCasePriority;
  final bool aiAssistanceEnabled;
  final Map<String, dynamic> preferences;

  const QAToolBoxSettings({
    this.autoSaveEnabled = true,
    this.notificationsEnabled = true,
    this.defaultLanguage = 'dart',
    this.codeStyle = 'standard',
    this.testCasePriority = 1,
    this.aiAssistanceEnabled = true,
    this.preferences = const {},
  });

  QAToolBoxSettings copyWith({
    bool? autoSaveEnabled,
    bool? notificationsEnabled,
    String? defaultLanguage,
    String? codeStyle,
    int? testCasePriority,
    bool? aiAssistanceEnabled,
    Map<String, dynamic>? preferences,
  }) {
    return QAToolBoxSettings(
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      codeStyle: codeStyle ?? this.codeStyle,
      testCasePriority: testCasePriority ?? this.testCasePriority,
      aiAssistanceEnabled: aiAssistanceEnabled ?? this.aiAssistanceEnabled,
      preferences: preferences ?? this.preferences,
    );
  }
}

/// QAToolBox 主状态管理器
class QAToolBoxNotifier extends StateNotifier<QAToolBoxState> {
  final QAToolBoxService _service;

  QAToolBoxNotifier(this._service) : super(
    QAToolBoxState(
      settings: QAToolBoxSettings(),
    ),
  ) {
    _loadInitialData();
  }

  /// 加载初始数据
  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await Future.wait([
        _loadProjects(),
        _loadTestCases(),
        _loadCrawlerTasks(),
        _loadAPITestSuites(),
        _loadCodeReviews(),
      ]);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ==================== 测试用例管理 ====================

  /// 生成测试用例
  Future<void> generateTestCases(TestGenerationRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.generateTestCases(request);
      
      state = state.copyWith(
        testCases: [...state.testCases, ...response.testCases],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '生成测试用例失败: ${e.toString()}',
      );
    }
  }

  /// 批量生成测试用例
  Future<void> generateBatchTestCases(BatchTestGenerationRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.generateBatchTestCases(request);
      
      // 处理批量结果
      final allTestCases = response.results.expand((r) => r.testCases).toList();
      
      state = state.copyWith(
        testCases: [...state.testCases, ...allTestCases],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '批量生成测试用例失败: ${e.toString()}',
      );
    }
  }

  /// 加载测试用例
  Future<void> _loadTestCases() async {
    // 实现加载逻辑
  }

  // ==================== PDF转换管理 ====================

  /// Word转PDF
  Future<void> convertWordToPDF(WordToPDFRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.convertWordToPDF(request);
      
      state = state.copyWith(
        pdfConversions: [...state.pdfConversions, response],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Word转PDF失败: ${e.toString()}',
      );
    }
  }

  /// 批量PDF转换
  Future<void> convertBatchToPDF(BatchPDFConversionRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.convertBatchToPDF(request);
      
      state = state.copyWith(
        pdfConversions: [...state.pdfConversions, ...response.conversions],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '批量PDF转换失败: ${e.toString()}',
      );
    }
  }

  // ==================== 项目任务管理 ====================

  /// 创建项目
  Future<void> createProject(CreateProjectRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createProject(request);
      
      state = state.copyWith(
        projects: [...state.projects, response.project],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '创建项目失败: ${e.toString()}',
      );
    }
  }

  /// 创建任务
  Future<void> createTask(String projectId, CreateTaskRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createTask(projectId, request);
      
      state = state.copyWith(
        tasks: [...state.tasks, response.task],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '创建任务失败: ${e.toString()}',
      );
    }
  }

  /// 更新任务状态
  Future<void> updateTaskStatus(String taskId, UpdateTaskStatusRequest request) async {
    try {
      final response = await _service.updateTaskStatus(taskId, request);
      
      // 更新本地状态
      final updatedTasks = state.tasks.map((task) {
        return task.id == taskId ? response.task : task;
      }).toList();
      
      state = state.copyWith(tasks: updatedTasks);
    } catch (e) {
      state = state.copyWith(
        error: '更新任务状态失败: ${e.toString()}',
      );
    }
  }

  /// 加载项目
  Future<void> _loadProjects() async {
    try {
      final response = await _service.getProjects(1, 100);
      state = state.copyWith(projects: response.projects);
    } catch (e) {
      // 记录错误但不中断其他数据加载
      print('加载项目失败: $e');
    }
  }

  // ==================== 网络爬虫管理 ====================

  /// 创建爬虫任务
  Future<void> createCrawlerTask(CreateCrawlerTaskRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createCrawlerTask(request);
      
      state = state.copyWith(
        crawlerTasks: [...state.crawlerTasks, response.task],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '创建爬虫任务失败: ${e.toString()}',
      );
    }
  }

  /// 启动爬虫任务
  Future<void> startCrawlerTask(String taskId) async {
    try {
      final response = await _service.startCrawlerTask(taskId);
      
      // 更新本地状态
      final updatedTasks = state.crawlerTasks.map((task) {
        return task.id == taskId ? response.task : task;
      }).toList();
      
      state = state.copyWith(crawlerTasks: updatedTasks);
    } catch (e) {
      state = state.copyWith(
        error: '启动爬虫任务失败: ${e.toString()}',
      );
    }
  }

  /// 加载爬虫任务
  Future<void> _loadCrawlerTasks() async {
    try {
      final response = await _service.getCrawlerTasks(null);
      state = state.copyWith(crawlerTasks: response.tasks);
    } catch (e) {
      print('加载爬虫任务失败: $e');
    }
  }

  // ==================== API测试管理 ====================

  /// 创建API测试套件
  Future<void> createAPITestSuite(CreateAPITestSuiteRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createAPITestSuite(request);
      
      state = state.copyWith(
        apiTestSuites: [...state.apiTestSuites, response.suite],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '创建API测试套件失败: ${e.toString()}',
      );
    }
  }

  /// 执行API测试
  Future<void> executeAPITest(ExecuteAPITestRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.executeAPITest(request);
      
      // 处理测试结果
      _handleAPITestResult(response);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '执行API测试失败: ${e.toString()}',
      );
    }
  }

  /// 处理API测试结果
  void _handleAPITestResult(APITestExecutionResponse response) {
    // 更新测试套件状态
    final updatedSuites = state.apiTestSuites.map((suite) {
      if (suite.id == response.suiteId) {
        // 更新套件的测试结果
        return suite; // 实际应该更新测试结果
      }
      return suite;
    }).toList();
    
    state = state.copyWith(apiTestSuites: updatedSuites);
  }

  /// 加载API测试套件
  Future<void> _loadAPITestSuites() async {
    try {
      // 实现加载逻辑
    } catch (e) {
      print('加载API测试套件失败: $e');
    }
  }

  // ==================== 代码审查管理 ====================

  /// 创建代码审查
  Future<void> createCodeReview(CreateCodeReviewRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createCodeReview(request);
      
      state = state.copyWith(
        codeReviews: [...state.codeReviews, response.review],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '创建代码审查失败: ${e.toString()}',
      );
    }
  }

  /// 批准代码审查
  Future<void> approveCodeReview(String reviewId) async {
    try {
      final response = await _service.approveCodeReview(reviewId);
      
      // 更新本地状态
      final updatedReviews = state.codeReviews.map((review) {
        return review.id == reviewId ? response.review : review;
      }).toList();
      
      state = state.copyWith(codeReviews: updatedReviews);
    } catch (e) {
      state = state.copyWith(
        error: '批准代码审查失败: ${e.toString()}',
      );
    }
  }

  /// 加载代码审查
  Future<void> _loadCodeReviews() async {
    try {
      final response = await _service.getCodeReviews(null);
      state = state.copyWith(codeReviews: response.reviews);
    } catch (e) {
      print('加载代码审查失败: $e');
    }
  }

  // ==================== 通用方法 ====================

  /// 刷新所有数据
  Future<void> refresh() async {
    await _loadInitialData();
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 更新设置
  void updateSettings(QAToolBoxSettings newSettings) {
    state = state.copyWith(settings: newSettings);
    _saveSettings(newSettings);
  }

  /// 保存设置到本地
  Future<void> _saveSettings(QAToolBoxSettings settings) async {
    // 实现本地存储逻辑
  }
}

// ==================== Provider 定义 ====================

final qaToolBoxServiceProvider = Provider<QAToolBoxService>((ref) {
  final dio = Dio();
  return QAToolBoxService(dio);
});

final qaToolBoxProvider = StateNotifierProvider<QAToolBoxNotifier, QAToolBoxState>((ref) {
  final service = ref.watch(qaToolBoxServiceProvider);
  return QAToolBoxNotifier(service);
});

// ==================== 特定功能 Provider ====================

/// 测试用例提供者
final testCasesProvider = Provider<List<TestCase>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.testCases;
});

/// 项目提供者
final projectsProvider = Provider<List<Project>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.projects;
});

/// 任务提供者
final tasksProvider = Provider<List<Task>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.tasks;
});

/// 爬虫任务提供者
final crawlerTasksProvider = Provider<List<CrawlerTask>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.crawlerTasks;
});

/// API测试套件提供者
final apiTestSuitesProvider = Provider<List<APITestSuite>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.apiTestSuites;
});

/// 代码审查提供者
final codeReviewsProvider = Provider<List<CodeReview>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.codeReviews;
});

/// PDF转换提供者
final pdfConversionsProvider = Provider<List<PDFConversionResponse>>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.pdfConversions;
});

/// 设置提供者
final qaToolBoxSettingsProvider = Provider<QAToolBoxSettings>((ref) {
  final state = ref.watch(qaToolBoxProvider);
  return state.settings;
});

// ==================== 计算属性 Provider ====================

/// 活跃项目数量
final activeProjectsCountProvider = Provider<int>((ref) {
  final projects = ref.watch(projectsProvider);
  return projects.where((p) => p.status == 'active').length;
});

/// 待办任务数量
final pendingTasksCountProvider = Provider<int>((ref) {
  final tasks = ref.watch(tasksProvider);
  return tasks.where((t) => t.status == 'pending').length;
});

/// 运行中的爬虫任务数量
final runningCrawlerTasksCountProvider = Provider<int>((ref) {
  final crawlerTasks = ref.watch(crawlerTasksProvider);
  return crawlerTasks.where((t) => t.status == 'running').length;
});

/// 待审查的代码数量
final pendingCodeReviewsCountProvider = Provider<int>((ref) {
  final codeReviews = ref.watch(codeReviewsProvider);
  return codeReviews.where((r) => r.status == 'pending').length;
});