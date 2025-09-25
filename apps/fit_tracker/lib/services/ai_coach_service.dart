import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'real_health_service.dart';

class AICoachService {
  static final AICoachService _instance = AICoachService._internal();
  factory AICoachService() => _instance;
  AICoachService._internal();

  final Logger _logger = Logger();
  final Dio _dio = Dio();
  final RealHealthService _healthService = RealHealthService();
  
  // API配置
  String _apiKey = '';
  String _apiUrl = '';
  String _model = 'deepseek-chat';
  
  // 对话历史
  List<Map<String, String>> _conversationHistory = [];
  
  // 教练状态
  bool _isInitialized = false;
  
  // 数据流控制器
  final StreamController<Map<String, dynamic>> _coachResponseController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get coachResponseStream => _coachResponseController.stream;

  /// 初始化AI教练服务
  Future<bool> initialize() async {
    try {
      _logger.i('初始化AI健身教练服务...');
      
      // 加载API配置
      await _loadApiConfig();
      
      // 配置Dio
      _dio.options = BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
      );
      
      _isInitialized = true;
      _logger.i('AI健身教练服务初始化完成');
      return true;
    } catch (e) {
      _logger.e('AI健身教练服务初始化失败: $e');
      return false;
    }
  }

  /// 加载API配置
  Future<void> _loadApiConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _apiKey = prefs.getString('llm_api_key') ?? '';
      _apiUrl = prefs.getString('llm_api_url') ?? 'https://api.deepseek.com/v1/chat/completions';
      _model = prefs.getString('llm_model') ?? 'deepseek-chat';
      
      if (_apiKey.isEmpty) {
        // 使用默认配置
        _apiKey = 'sk-your-api-key-here';
        _apiUrl = 'https://api.deepseek.com/v1/chat/completions';
        _model = 'deepseek-chat';
      }
      
      _logger.i('API配置加载完成: $_model');
    } catch (e) {
      _logger.e('加载API配置失败: $e');
    }
  }

  /// 设置API配置
  Future<void> setApiConfig({
    required String apiKey,
    required String apiUrl,
    required String model,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('llm_api_key', apiKey);
      await prefs.setString('llm_api_url', apiUrl);
      await prefs.setString('llm_model', model);
      
      _apiKey = apiKey;
      _apiUrl = apiUrl;
      _model = model;
      
      _dio.options.headers!['Authorization'] = 'Bearer $_apiKey';
      
      _logger.i('API配置更新完成');
    } catch (e) {
      _logger.e('设置API配置失败: $e');
    }
  }

  /// 获取健身建议
  Future<String> getFitnessAdvice({
    required String userGoal,
    required String fitnessLevel,
    required String availableTime,
    required String equipment,
  }) async {
    try {
      final healthData = _healthService.getCurrentData();
      
      final prompt = _buildFitnessAdvicePrompt(
        userGoal: userGoal,
        fitnessLevel: fitnessLevel,
        availableTime: availableTime,
        equipment: equipment,
        healthData: healthData,
      );
      
      final response = await _callLLM(prompt);
      
      // 添加到对话历史
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      return response;
    } catch (e) {
      _logger.e('获取健身建议失败: $e');
      return '抱歉，暂时无法获取健身建议，请稍后重试。';
    }
  }

  /// 生成训练计划
  Future<String> generateWorkoutPlan({
    required String goal,
    required int daysPerWeek,
    required int sessionDuration,
    required String equipment,
    required String fitnessLevel,
  }) async {
    try {
      final healthData = _healthService.getCurrentData();
      
      final prompt = _buildWorkoutPlanPrompt(
        goal: goal,
        daysPerWeek: daysPerWeek,
        sessionDuration: sessionDuration,
        equipment: equipment,
        fitnessLevel: fitnessLevel,
        healthData: healthData,
      );
      
      final response = await _callLLM(prompt);
      
      // 添加到对话历史
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      return response;
    } catch (e) {
      _logger.e('生成训练计划失败: $e');
      return '抱歉，暂时无法生成训练计划，请稍后重试。';
    }
  }

  /// 获取营养建议
  Future<String> getNutritionAdvice({
    required String goal,
    required double weight,
    required double height,
    required int age,
    required String activityLevel,
  }) async {
    try {
      final healthData = _healthService.getCurrentData();
      
      final prompt = _buildNutritionAdvicePrompt(
        goal: goal,
        weight: weight,
        height: height,
        age: age,
        activityLevel: activityLevel,
        healthData: healthData,
      );
      
      final response = await _callLLM(prompt);
      
      // 添加到对话历史
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      return response;
    } catch (e) {
      _logger.e('获取营养建议失败: $e');
      return '抱歉，暂时无法获取营养建议，请稍后重试。';
    }
  }

  /// 分析训练数据
  Future<String> analyzeWorkoutData(Map<String, dynamic> workoutData) async {
    try {
      final prompt = _buildWorkoutAnalysisPrompt(workoutData);
      
      final response = await _callLLM(prompt);
      
      // 添加到对话历史
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      return response;
    } catch (e) {
      _logger.e('分析训练数据失败: $e');
      return '抱歉，暂时无法分析训练数据，请稍后重试。';
    }
  }

  /// 获取健康报告
  Future<String> getHealthReport() async {
    try {
      final healthData = _healthService.getCurrentData();
      
      final prompt = _buildHealthReportPrompt(healthData);
      
      final response = await _callLLM(prompt);
      
      // 添加到对话历史
      _conversationHistory.add({
        'role': 'user',
        'content': prompt,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      return response;
    } catch (e) {
      _logger.e('获取健康报告失败: $e');
      return '抱歉，暂时无法生成健康报告，请稍后重试。';
    }
  }

  /// 聊天对话
  Future<String> chat(String message) async {
    try {
      // 添加上下文信息
      final healthData = _healthService.getCurrentData();
      final contextMessage = _buildContextMessage(healthData);
      
      final fullMessage = '$contextMessage\n\n用户问题: $message';
      
      final response = await _callLLM(fullMessage);
      
      // 添加到对话历史
      _conversationHistory.add({
        'role': 'user',
        'content': fullMessage,
      });
      _conversationHistory.add({
        'role': 'assistant',
        'content': response,
      });
      
      return response;
    } catch (e) {
      _logger.e('聊天对话失败: $e');
      return '抱歉，暂时无法回复您的问题，请稍后重试。';
    }
  }

  /// 调用LLM API
  Future<String> _callLLM(String prompt) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': _getSystemPrompt(),
        },
        ..._conversationHistory.take(10), // 保留最近10轮对话
        {
          'role': 'user',
          'content': prompt,
        },
      ];

      final requestData = {
        'model': _model,
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 2000,
        'stream': false,
      };

      final response = await _dio.post(
        _apiUrl,
        data: requestData,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices'][0]['message']['content'];
        
        // 发送响应流
        _coachResponseController.add({
          'type': 'response',
          'content': content,
          'timestamp': DateTime.now(),
        });
        
        return content;
      } else {
        throw Exception('API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      _logger.e('调用LLM失败: $e');
      rethrow;
    }
  }

  /// 获取系统提示词
  String _getSystemPrompt() {
    return '''
你是一位专业的AI健身教练，具有丰富的健身和营养知识。你的职责是：

1. 提供科学、安全的健身建议
2. 制定个性化的训练计划
3. 给出合理的营养建议
4. 分析用户的健身数据
5. 回答健身相关问题

请始终：
- 基于用户的真实数据给出建议
- 考虑用户的身体状况和健身水平
- 提供安全、可执行的建议
- 鼓励用户坚持锻炼
- 用中文回复

用户数据格式：
- 步数、距离、卡路里等运动数据
- 心率、血压等健康指标
- 体重、体脂等身体数据
- 训练记录和营养摄入

请根据这些数据给出专业的建议。
''';
  }

  /// 构建健身建议提示词
  String _buildFitnessAdvicePrompt({
    required String userGoal,
    required String fitnessLevel,
    required String availableTime,
    required String equipment,
    required Map<String, dynamic> healthData,
  }) {
    return '''
请根据以下信息提供健身建议：

用户目标: $userGoal
健身水平: $fitnessLevel
可用时间: $availableTime
可用器械: $equipment

当前健康数据:
- 今日步数: ${healthData['steps'] ?? 0}
- 今日距离: ${healthData['distance'] ?? 0.0} 米
- 今日卡路里: ${healthData['calories'] ?? 0.0} kcal
- 当前心率: ${healthData['heartRate'] ?? 0} bpm
- 体重: ${healthData['weight'] ?? 0.0} kg
- 体脂率: ${healthData['bodyFat'] ?? 0.0}%

请提供：
1. 针对目标的训练建议
2. 适合的训练强度
3. 注意事项
4. 预期效果
''';
  }

  /// 构建训练计划提示词
  String _buildWorkoutPlanPrompt({
    required String goal,
    required int daysPerWeek,
    required int sessionDuration,
    required String equipment,
    required String fitnessLevel,
    required Map<String, dynamic> healthData,
  }) {
    return '''
请制定一个详细的训练计划：

目标: $goal
每周训练天数: $daysPerWeek
单次训练时长: $sessionDuration 分钟
可用器械: $equipment
健身水平: $fitnessLevel

用户数据:
- 体重: ${healthData['weight'] ?? 0.0} kg
- 身高: ${healthData['height'] ?? 175.0} cm
- 年龄: ${healthData['age'] ?? 30} 岁

请提供：
1. 详细的训练计划（包含具体动作、组数、次数）
2. 训练进度安排
3. 休息日安排
4. 注意事项和安全提醒
''';
  }

  /// 构建营养建议提示词
  String _buildNutritionAdvicePrompt({
    required String goal,
    required double weight,
    required double height,
    required int age,
    required String activityLevel,
    required Map<String, dynamic> healthData,
  }) {
    return '''
请提供营养建议：

目标: $goal
体重: $weight kg
身高: $height cm
年龄: $age 岁
活动水平: $activityLevel

当前数据:
- 今日卡路里消耗: ${healthData['calories'] ?? 0.0} kcal
- 今日步数: ${healthData['steps'] ?? 0}
- 今日饮水: ${healthData['waterIntake'] ?? 0.0} ml

请提供：
1. 每日热量需求
2. 宏量营养素分配
3. 具体食物建议
4. 饮水建议
5. 补充剂建议（如需要）
''';
  }

  /// 构建训练分析提示词
  String _buildWorkoutAnalysisPrompt(Map<String, dynamic> workoutData) {
    return '''
请分析以下训练数据：

训练类型: ${workoutData['type'] ?? '未知'}
训练时长: ${workoutData['duration'] ?? 0} 分钟
消耗卡路里: ${workoutData['calories'] ?? 0.0} kcal
训练强度: ${workoutData['intensity'] ?? '中等'}
完成情况: ${workoutData['completion'] ?? '100'}%

请分析：
1. 训练效果评估
2. 强度是否合适
3. 改进建议
4. 下次训练建议
''';
  }

  /// 构建健康报告提示词
  String _buildHealthReportPrompt(Map<String, dynamic> healthData) {
    return '''
请生成健康报告：

运动数据:
- 今日步数: ${healthData['steps'] ?? 0}
- 今日距离: ${healthData['distance'] ?? 0.0} 米
- 今日卡路里: ${healthData['calories'] ?? 0.0} kcal

健康指标:
- 心率: ${healthData['heartRate'] ?? 0} bpm
- 血压: ${healthData['bloodPressure']?['systolic'] ?? 0}/${healthData['bloodPressure']?['diastolic'] ?? 0} mmHg
- 体重: ${healthData['weight'] ?? 0.0} kg
- 体脂率: ${healthData['bodyFat'] ?? 0.0}%

生活方式:
- 饮水: ${healthData['waterIntake'] ?? 0.0} ml
- 睡眠: ${healthData['sleepHours'] ?? 0.0} 小时

请提供：
1. 整体健康状况评估
2. 运动表现分析
3. 健康风险提示
4. 改进建议
''';
  }

  /// 构建上下文消息
  String _buildContextMessage(Map<String, dynamic> healthData) {
    return '''
当前用户健康数据：
- 步数: ${healthData['steps'] ?? 0}
- 距离: ${healthData['distance'] ?? 0.0} 米
- 卡路里: ${healthData['calories'] ?? 0.0} kcal
- 心率: ${healthData['heartRate'] ?? 0} bpm
- 体重: ${healthData['weight'] ?? 0.0} kg
- 饮水: ${healthData['waterIntake'] ?? 0.0} ml
''';
  }

  /// 获取对话历史
  List<Map<String, String>> get conversationHistory => _conversationHistory;

  /// 清除对话历史
  void clearConversationHistory() {
    _conversationHistory.clear();
  }

  /// 是否已初始化
  bool get isInitialized => _isInitialized;

  /// 停止服务
  void dispose() {
    _coachResponseController.close();
  }
}
