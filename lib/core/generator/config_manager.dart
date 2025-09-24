import 'dart:io';
import 'dart:convert';

/// 应用配置管理器
class AppConfigManager {
  static const String _configDir = 'config';
  static const String _appsConfigFile = 'apps.yaml';
  static const String _templatesConfigFile = 'templates.yaml';
  static const String _servicesConfigFile = 'services.yaml';
  
  /// 获取默认应用配置
  static List<AppConfig> _getDefaultConfigs() {
    return [
      AppConfig(
        name: "QAToolBox Pro",
        id: "qa_toolbox",
        description: "工作效率工具套件",
        category: "productivity",
        icon: "Icons.work_outline",
        color: "AppTheme.primaryColor",
        features: ["测试用例生成器", "PDF转换器", "任务管理器", "网络爬虫"],
        servicePort: "8010",
        serviceDependencies: ["auth", "user", "analytics"],
      ),
      AppConfig(
        name: "LifeMode",
        id: "life_mode",
        description: "生活娱乐助手",
        category: "lifestyle",
        icon: "Icons.home_outlined",
        color: "AppTheme.secondaryColor",
        features: ["食物随机器", "生活日记", "冥想指南", "旅行指南"],
        servicePort: "8011",
        serviceDependencies: ["auth", "user", "analytics"],
      ),
    ];
  }
  
  /// 获取所有应用配置
  static Future<List<AppConfig>> getAllAppConfigs() async {
    final configFile = File('$_configDir/$_appsConfigFile');
    
    if (!await configFile.exists()) {
      return [];
    }
    
    final content = await configFile.readAsString();
    
    // 简单的YAML解析（仅用于演示）
    // 实际项目中应使用 yaml 包
    try {
      // 临时使用JSON格式作为替代
      if (content.trim().startsWith('{')) {
        final json = jsonDecode(content);
        final apps = json['apps'] as List? ?? [];
        return apps.map((app) => AppConfig.fromJson(Map<String, dynamic>.from(app))).toList();
      } else {
        // 返回默认配置用于演示
        return _getDefaultConfigs();
      }
    } catch (e) {
      return _getDefaultConfigs();
    }
  }
  
  /// 获取单个应用配置
  static Future<AppConfig?> getAppConfig(String appId) async {
    final configs = await getAllAppConfigs();
    try {
      return configs.firstWhere((config) => config.id == appId);
    } catch (e) {
      return null;
    }
  }
  
  /// 保存应用配置
  static Future<void> saveAppConfig(AppConfig config) async {
    final configFile = File('$_configDir/$_appsConfigFile');
    await configFile.parent.create(recursive: true);
    
    List<AppConfig> configs = await getAllAppConfigs();
    
    // 更新或添加配置
    final existingIndex = configs.indexWhere((c) => c.id == config.id);
    if (existingIndex >= 0) {
      configs[existingIndex] = config;
    } else {
      configs.add(config);
    }
    
    // 转换为JSON格式（临时替代YAML）
    final jsonContent = {
      'apps': configs.map((c) => c.toJson()).toList(),
    };
    
    await configFile.writeAsString(jsonEncode(jsonContent));
  }
  
  /// 删除应用配置
  static Future<void> deleteAppConfig(String appId) async {
    final configs = await getAllAppConfigs();
    configs.removeWhere((config) => config.id == appId);
    
    final configFile = File('$_configDir/$_appsConfigFile');
    final jsonContent = {
      'apps': configs.map((c) => c.toJson()).toList(),
    };
    
    await configFile.writeAsString(jsonEncode(jsonContent));
  }
  
  /// 获取模板配置
  static Future<Map<String, dynamic>> getTemplateConfig() async {
    final configFile = File('$_configDir/$_templatesConfigFile');
    
    if (!await configFile.exists()) {
      return _getDefaultTemplateConfig();
    }
    
    final content = await configFile.readAsString();
    
    try {
      // 简单JSON解析作为YAML的替代
      if (content.trim().startsWith('{')) {
        return Map<String, dynamic>.from(jsonDecode(content));
      } else {
        return _getDefaultTemplateConfig();
      }
    } catch (e) {
      return _getDefaultTemplateConfig();
    }
  }
  
  /// 获取服务配置
  static Future<Map<String, dynamic>> getServiceConfig() async {
    final configFile = File('$_configDir/$_servicesConfigFile');
    
    if (!await configFile.exists()) {
      return _getDefaultServiceConfig();
    }
    
    final content = await configFile.readAsString();
    
    try {
      // 简单JSON解析作为YAML的替代
      if (content.trim().startsWith('{')) {
        return Map<String, dynamic>.from(jsonDecode(content));
      } else {
        return _getDefaultServiceConfig();
      }
    } catch (e) {
      return _getDefaultServiceConfig();
    }
  }
  
  /// 获取默认模板配置
  static Map<String, dynamic> _getDefaultTemplateConfig() {
    return {
      'templates': {
        'main_page': {
          'path': 'lib/core/generator/templates/main_page.dart.template',
          'description': '主页面模板',
        },
        'service': {
          'path': 'lib/core/generator/templates/service.dart.template',
          'description': '服务层模板',
        },
        'model': {
          'path': 'lib/core/generator/templates/model.dart.template',
          'description': '数据模型模板',
        },
        'provider': {
          'path': 'lib/core/generator/templates/provider.dart.template',
          'description': '状态管理模板',
        },
        'feature_page': {
          'path': 'lib/core/generator/templates/feature_page.dart.template',
          'description': '功能页面模板',
        },
        'feature_widget': {
          'path': 'lib/core/generator/templates/feature_widget.dart.template',
          'description': '功能组件模板',
        },
        'unit_test': {
          'path': 'lib/core/generator/templates/unit_test.dart.template',
          'description': '单元测试模板',
        },
        'widget_test': {
          'path': 'lib/core/generator/templates/widget_test.dart.template',
          'description': 'Widget测试模板',
        },
        'app_documentation': {
          'path': 'lib/core/generator/templates/app_documentation.dart.template',
          'description': '应用文档模板',
        },
      },
      'variables': {
        'appName': '应用名称',
        'appId': '应用ID',
        'description': '应用描述',
        'category': '应用分类',
        'icon': '应用图标',
        'color': '主题颜色',
        'features': '功能列表',
      },
    };
  }
  
  /// 获取默认服务配置
  static Map<String, dynamic> _getDefaultServiceConfig() {
    return {
      'services': {
        'auth': {
          'port': 8001,
          'description': '认证服务',
          'dependencies': ['user'],
        },
        'user': {
          'port': 8002,
          'description': '用户管理服务',
          'dependencies': [],
        },
        'payment': {
          'port': 8003,
          'description': '支付服务',
          'dependencies': ['user'],
        },
        'notification': {
          'port': 8004,
          'description': '通知服务',
          'dependencies': ['user'],
        },
        'analytics': {
          'port': 8005,
          'description': '数据分析服务',
          'dependencies': ['user'],
        },
        'qa_toolbox': {
          'port': 8010,
          'description': 'QAToolBox应用服务',
          'dependencies': ['auth', 'user', 'analytics'],
        },
        'life_mode': {
          'port': 8011,
          'description': 'LifeMode应用服务',
          'dependencies': ['auth', 'user', 'analytics'],
        },
        'fit_tracker': {
          'port': 8012,
          'description': 'FitTracker应用服务',
          'dependencies': ['auth', 'user', 'analytics'],
        },
        'social_hub': {
          'port': 8013,
          'description': 'SocialHub应用服务',
          'dependencies': ['auth', 'user', 'analytics'],
        },
        'creative_studio': {
          'port': 8014,
          'description': 'CreativeStudio应用服务',
          'dependencies': ['auth', 'user', 'analytics'],
        },
      },
      'database': {
        'postgres': {
          'host': 'localhost',
          'port': 5432,
          'database': 'qatoolbox',
          'username': 'postgres',
          'password': 'password',
        },
        'redis': {
          'host': 'localhost',
          'port': 6379,
          'password': '',
        },
      },
      'ai': {
        'openai': {
          'api_key': 'YOUR_OPENAI_API_KEY',
          'base_url': 'https://api.openai.com/v1',
          'model': 'gpt-3.5-turbo',
        },
      },
    };
  }
}

/// 应用配置模型
class AppConfig {
  final String name;
  final String id;
  final String description;
  final String category;
  final String icon;
  final String color;
  final List<String> features;
  final Map<String, dynamic> theme;
  final List<String> dependencies;
  final Map<String, dynamic> metadata;
  final String? servicePort;
  final List<String> serviceDependencies;

  const AppConfig({
    required this.name,
    required this.id,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.features,
    this.theme = const {},
    this.dependencies = const [],
    this.metadata = const {},
    this.servicePort,
    this.serviceDependencies = const [],
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      name: json['name'] as String,
      id: json['id'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      features: List<String>.from(json['features'] ?? []),
      theme: Map<String, dynamic>.from(json['theme'] ?? {}),
      dependencies: List<String>.from(json['dependencies'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      servicePort: json['service_port'] as String?,
      serviceDependencies: List<String>.from(json['service_dependencies'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'description': description,
      'category': category,
      'icon': icon,
      'color': color,
      'features': features,
      'theme': theme,
      'dependencies': dependencies,
      'metadata': metadata,
      'service_port': servicePort,
      'service_dependencies': serviceDependencies,
    };
  }
}
