import 'package:flutter/foundation.dart';

/// API配置类
class ApiConfig {
  // 基础API配置
  static const String baseApiUrl = kDebugMode 
      ? 'http://localhost:8080/api/v1'
      : 'https://api.qatoolbox.com/api/v1';
  
  // AI服务配置
  static const String aiServiceUrl = '$baseApiUrl/ai';
  
  // 第三方服务配置
  static const String thirdPartyServiceUrl = '$baseApiUrl/third-party';
  
  // 认证服务配置
  static const String authServiceUrl = '$baseApiUrl/auth';
  
  // 用户服务配置
  static const String userServiceUrl = '$baseApiUrl/user';
  
  // 应用服务配置
  static const String appServiceUrl = '$baseApiUrl/apps';
  
  // 会员服务配置
  static const String membershipServiceUrl = '$baseApiUrl/membership';
  
  // 支付服务配置
  static const String paymentServiceUrl = '$baseApiUrl/payment';
  
  // QAToolBox服务配置
  static const String qaToolboxServiceUrl = '$baseApiUrl/qa-toolbox';
  
  // LifeMode服务配置
  static const String lifeModeServiceUrl = '$baseApiUrl/life-mode';
  
  // FitTracker服务配置
  static const String fitTrackerServiceUrl = '$baseApiUrl/fit-tracker';
  
  // SocialHub服务配置
  static const String socialHubServiceUrl = '$baseApiUrl/social-hub';
  
  // CreativeStudio服务配置
  static const String creativeStudioServiceUrl = '$baseApiUrl/creative-studio';
  
  // 请求超时配置
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // 重试配置
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 1);
  
  // 分页配置
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // 文件上传配置
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'];
  static const List<String> allowedVideoTypes = ['mp4', 'avi', 'mov', 'wmv', 'flv'];
  static const List<String> allowedAudioTypes = ['mp3', 'wav', 'aac', 'ogg', 'm4a'];
  
  // AI模型配置
  static const Map<String, String> aiModels = {
    'gpt-3.5-turbo': 'GPT-3.5 Turbo',
    'gpt-4': 'GPT-4',
    'gpt-4-turbo': 'GPT-4 Turbo',
    'claude-3-sonnet': 'Claude 3 Sonnet',
    'claude-3-opus': 'Claude 3 Opus',
    'gemini-pro': 'Gemini Pro',
    'deepseek-chat': 'DeepSeek Chat',
    'qwen-turbo': 'Qwen Turbo',
    'llama-2-70b': 'Llama 2 70B',
    'mixtral-8x7b': 'Mixtral 8x7B',
  };
  
  // 第三方服务配置
  static const Map<String, Map<String, dynamic>> thirdPartyServices = {
    'amap': {
      'name': '高德地图',
      'description': '地图服务、位置查询、路径规划',
      'endpoints': {
        'geocode': '/amap/geocode',
        'regeocode': '/amap/regeocode',
      },
    },
    'pixabay': {
      'name': 'Pixabay',
      'description': '免费图片素材获取',
      'endpoints': {
        'search': '/pixabay/search',
      },
    },
    'openweather': {
      'name': 'OpenWeather',
      'description': '天气信息查询',
      'endpoints': {
        'weather': '/weather',
      },
    },
    'google': {
      'name': 'Google搜索',
      'description': 'Google搜索和自定义搜索',
      'endpoints': {
        'search': '/google/search',
      },
    },
    'email': {
      'name': '邮件服务',
      'description': '系统邮件发送',
      'endpoints': {
        'send': '/email/send',
      },
    },
  };
  
  // 错误码配置
  static const Map<int, String> errorMessages = {
    400: '请求参数错误',
    401: '未授权访问',
    403: '禁止访问',
    404: '资源不存在',
    409: '资源冲突',
    422: '数据验证失败',
    429: '请求过于频繁',
    500: '服务器内部错误',
    502: '网关错误',
    503: '服务不可用',
    504: '网关超时',
  };
  
  // 获取错误消息
  static String getErrorMessage(int statusCode) {
    return errorMessages[statusCode] ?? '未知错误';
  }
  
  // 获取完整的API URL
  static String getApiUrl(String endpoint) {
    return '$baseApiUrl$endpoint';
  }
  
  // 获取AI服务URL
  static String getAiServiceUrl(String endpoint) {
    return '$aiServiceUrl$endpoint';
  }
  
  // 获取第三方服务URL
  static String getThirdPartyServiceUrl(String endpoint) {
    return '$thirdPartyServiceUrl$endpoint';
  }
  
  // 检查文件类型是否允许
  static bool isFileTypeAllowed(String fileName, List<String> allowedTypes) {
    final extension = fileName.split('.').last.toLowerCase();
    return allowedTypes.contains(extension);
  }
  
  // 检查文件大小是否允许
  static bool isFileSizeAllowed(int fileSize) {
    return fileSize <= maxFileSize;
  }
  
  // 获取文件类型
  static String getFileType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    if (allowedImageTypes.contains(extension)) return 'image';
    if (allowedDocumentTypes.contains(extension)) return 'document';
    if (allowedVideoTypes.contains(extension)) return 'video';
    if (allowedAudioTypes.contains(extension)) return 'audio';
    return 'unknown';
  }
  
  // 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
  
  // 获取AI模型显示名称
  static String getAiModelDisplayName(String modelId) {
    return aiModels[modelId] ?? modelId;
  }
  
  // 获取第三方服务信息
  static Map<String, dynamic>? getThirdPartyServiceInfo(String serviceId) {
    return thirdPartyServices[serviceId];
  }
  
  // 获取所有可用的AI模型
  static List<String> getAvailableAiModels() {
    return aiModels.keys.toList();
  }
  
  // 获取所有可用的第三方服务
  static List<String> getAvailableThirdPartyServices() {
    return thirdPartyServices.keys.toList();
  }
}
