import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../config/api_config.dart';

part 'ai_service.g.dart';
part 'ai_service.freezed.dart';

/// AI服务客户端
@RestApi(baseUrl: ApiConfig.aiServiceUrl)
abstract class AIService {
  factory AIService(Dio dio, {String baseUrl}) = _AIService;

  /// 生成文本
  @POST('/generate')
  Future<AIGenerateTextResponse> generateText(@Body() AIGenerateTextRequest request);

  /// 获取可用AI服务列表
  @GET('/services')
  Future<AIServicesResponse> getAvailableServices();

  /// 测试AI服务连接
  @GET('/services/{service}/test')
  Future<AIServiceTestResponse> testService(@Path('service') String service);

  /// 获取AI服务统计信息
  @GET('/stats')
  Future<AIServiceStatsResponse> getServiceStats();
}

/// AI文本生成请求
@freezed
class AIGenerateTextRequest with _$AIGenerateTextRequest {
  const factory AIGenerateTextRequest({
    required String model,
    required List<AIMessage> messages,
    @Default(0.7) double temperature,
    @Default(1000) int maxTokens,
    @Default(false) bool stream,
  }) = _AIGenerateTextRequest;

  factory AIGenerateTextRequest.fromJson(Map<String, dynamic> json) =>
      _$AIGenerateTextRequestFromJson(json);
}

/// AI消息
@freezed
class AIMessage with _$AIMessage {
  const factory AIMessage({
    required String role,
    required String content,
  }) = _AIMessage;

  factory AIMessage.fromJson(Map<String, dynamic> json) =>
      _$AIMessageFromJson(json);
}

/// AI文本生成响应
@freezed
class AIGenerateTextResponse with _$AIGenerateTextResponse {
  const factory AIGenerateTextResponse({
    required String id,
    required String object,
    required int created,
    required String model,
    required List<AIChoice> choices,
    required AIUsage usage,
    required String serviceType,
  }) = _AIGenerateTextResponse;

  factory AIGenerateTextResponse.fromJson(Map<String, dynamic> json) =>
      _$AIGenerateTextResponseFromJson(json);
}

/// AI选择结果
@freezed
class AIChoice with _$AIChoice {
  const factory AIChoice({
    required int index,
    required AIMessage message,
    required String finishReason,
  }) = _AIChoice;

  factory AIChoice.fromJson(Map<String, dynamic> json) =>
      _$AIChoiceFromJson(json);
}

/// AI使用统计
@freezed
class AIUsage with _$AIUsage {
  const factory AIUsage({
    required int promptTokens,
    required int completionTokens,
    required int totalTokens,
  }) = _AIUsage;

  factory AIUsage.fromJson(Map<String, dynamic> json) =>
      _$AIUsageFromJson(json);
}

/// AI服务列表响应
@freezed
class AIServicesResponse with _$AIServicesResponse {
  const factory AIServicesResponse({
    required List<AIServiceInfo> services,
    required int count,
  }) = _AIServicesResponse;

  factory AIServicesResponse.fromJson(Map<String, dynamic> json) =>
      _$AIServicesResponseFromJson(json);
}

/// AI服务信息
@freezed
class AIServiceInfo with _$AIServiceInfo {
  const factory AIServiceInfo({
    required String type,
    required bool available,
    required String name,
    required String description,
  }) = _AIServiceInfo;

  factory AIServiceInfo.fromJson(Map<String, dynamic> json) =>
      _$AIServiceInfoFromJson(json);
}

/// AI服务测试响应
@freezed
class AIServiceTestResponse with _$AIServiceTestResponse {
  const factory AIServiceTestResponse({
    required bool success,
    required String service,
    @JsonKey(fromJson: _responseFromJson, toJson: _responseToJson) AIGenerateTextResponse? response,
  }) = _AIServiceTestResponse;

  factory AIServiceTestResponse.fromJson(Map<String, dynamic> json) =>
      _$AIServiceTestResponseFromJson(json);
}

// JSON转换辅助函数
AIGenerateTextResponse? _responseFromJson(Map<String, dynamic>? json) {
  if (json == null) return null;
  return AIGenerateTextResponse.fromJson(json);
}

Map<String, dynamic>? _responseToJson(AIGenerateTextResponse? response) {
  return response?.toJson();
}

/// AI服务统计响应
@freezed
class AIServiceStatsResponse with _$AIServiceStatsResponse {
  const factory AIServiceStatsResponse({
    required int totalServices,
    required int availableServices,
    required List<AIServiceInfo> services,
  }) = _AIServiceStatsResponse;

  factory AIServiceStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$AIServiceStatsResponseFromJson(json);
}

/// AI服务客户端管理器
class AIServiceClient {
  static AIService? _instance;
  static Dio? _dio;

  static AIService get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = AIService(_dio!, baseUrl: ApiConfig.aiServiceUrl);
    }
    return _instance!;
  }

  static void _setupInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 添加通用头
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          // 处理错误
          if (error.response?.statusCode == 429) {
            // 请求过于频繁，可以在这里实现重试逻辑
          }
          handler.next(error);
        },
      ),
    );
  }

  /// 生成文本的便捷方法
  static Future<String> generateText({
    required String prompt,
    String model = 'gpt-3.5-turbo',
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    try {
      final request = AIGenerateTextRequest(
        model: model,
        messages: [
          AIMessage(role: 'user', content: prompt),
        ],
        temperature: temperature,
        maxTokens: maxTokens,
      );

      final response = await instance.generateText(request);
      
      if (response.choices.isNotEmpty) {
        return response.choices.first.message.content;
      }
      
      throw Exception('AI服务返回空结果');
    } catch (e) {
      throw Exception('AI文本生成失败: $e');
    }
  }

  /// 生成对话的便捷方法
  static Future<String> generateConversation({
    required List<AIMessage> messages,
    String model = 'gpt-3.5-turbo',
    double temperature = 0.7,
    int maxTokens = 1000,
  }) async {
    try {
      final request = AIGenerateTextRequest(
        model: model,
        messages: messages,
        temperature: temperature,
        maxTokens: maxTokens,
      );

      final response = await instance.generateText(request);
      
      if (response.choices.isNotEmpty) {
        return response.choices.first.message.content;
      }
      
      throw Exception('AI服务返回空结果');
    } catch (e) {
      throw Exception('AI对话生成失败: $e');
    }
  }

  /// 获取可用服务列表
  static Future<List<AIServiceInfo>> getAvailableServices() async {
    try {
      final response = await instance.getAvailableServices();
      return response.services;
    } catch (e) {
      throw Exception('获取AI服务列表失败: $e');
    }
  }

  /// 测试服务连接
  static Future<bool> testService(String serviceType) async {
    try {
      final response = await instance.testService(serviceType);
      return response.success;
    } catch (e) {
      return false;
    }
  }

  /// 获取服务统计信息
  static Future<AIServiceStatsResponse> getServiceStats() async {
    try {
      return await instance.getServiceStats();
    } catch (e) {
      throw Exception('获取AI服务统计失败: $e');
    }
  }
}

