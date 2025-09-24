import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme_config.dart';

enum AppFlavor {
  qaToolbox,
  businessApp,
  socialApp,
  productivityApp,
}

class AppConfig {
  static AppFlavor _currentFlavor = AppFlavor.qaToolbox;
  
  static AppFlavor get currentFlavor => _currentFlavor;
  
  static void setFlavor(AppFlavor flavor) {
    _currentFlavor = flavor;
  }

  static AppThemeType get themeType {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return AppThemeType.qaToolbox;
      case AppFlavor.businessApp:
        return AppThemeType.businessApp;
      case AppFlavor.socialApp:
        return AppThemeType.socialApp;
      case AppFlavor.productivityApp:
        return AppThemeType.productivityApp;
    }
  }

  static AppThemeConfig get themeConfig => AppThemeConfig.getTheme(themeType);

  // API配置
  static String get baseApiUrl {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return kDebugMode ? 'http://localhost:8080/api/v1' : 'https://api.qatoolbox.com/v1';
      case AppFlavor.businessApp:
        return kDebugMode ? 'http://localhost:8080/api/v1' : 'https://api.businessapp.com/v1';
      case AppFlavor.socialApp:
        return kDebugMode ? 'http://localhost:8080/api/v1' : 'https://api.socialapp.com/v1';
      case AppFlavor.productivityApp:
        return kDebugMode ? 'http://localhost:8080/api/v1' : 'https://api.productivityapp.com/v1';
    }
  }

  static String get devBaseUrl {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return 'https://dev-api.qatoolbox.com';
      case AppFlavor.businessApp:
        return 'https://dev-api.businessapp.com';
      case AppFlavor.socialApp:
        return 'https://dev-api.socialapp.com';
      case AppFlavor.productivityApp:
        return 'https://dev-api.productivityapp.com';
    }
  }

  // 应用信息
  static String get appName => themeConfig.appName;
  static String get logoPath => themeConfig.logoPath;
  
  // 支持的应用列表
  static List<String> get supportedApps {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return ['QAToolBox Pro', 'LifeMode', 'FitTracker', 'SocialHub', 'CreativeStudio'];
      case AppFlavor.businessApp:
        return ['Business App', 'QAToolBox Pro', 'LifeMode', 'FitTracker'];
      case AppFlavor.socialApp:
        return ['SocialHub', 'QAToolBox Pro', 'LifeMode', 'CreativeStudio'];
      case AppFlavor.productivityApp:
        return ['Productivity App', 'QAToolBox Pro', 'LifeMode', 'FitTracker'];
    }
  }
  
  // 会员等级配置
  static Map<String, Map<String, dynamic>> get membershipLevels {
    return {
      'free': {
        'name': '免费版',
        'price': 0,
        'features': ['基础功能', '有限使用'],
        'color': 0xFF9E9E9E,
      },
      'premium': {
        'name': '高级版',
        'price': 29,
        'features': ['所有功能', '优先支持', '无限制使用'],
        'color': 0xFF2196F3,
      },
      'enterprise': {
        'name': '企业版',
        'price': 99,
        'features': ['所有功能', '专属支持', '团队协作', '定制服务'],
        'color': 0xFF4CAF50,
      },
    };
  }
  
  // 功能开关
  static Map<String, bool> get featureFlags {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return {
          'auth': true,
          'apps': true,
          'membership': true,
          'profile': true,
          'charts': true,
          'notifications': true,
        };
      case AppFlavor.businessApp:
        return {
          'auth': true,
          'dashboard': true,
          'reports': true,
          'team': true,
          'analytics': true,
          'notifications': true,
        };
      case AppFlavor.socialApp:
        return {
          'auth': true,
          'feed': true,
          'chat': true,
          'friends': true,
          'stories': true,
          'notifications': true,
        };
      case AppFlavor.productivityApp:
        return {
          'auth': true,
          'tasks': true,
          'calendar': true,
          'notes': true,
          'projects': true,
          'notifications': true,
        };
    }
  }

  // 路由配置
  static List<String> get initialRoutes {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return ['/home', '/apps', '/membership', '/profile'];
      case AppFlavor.businessApp:
        return ['/dashboard', '/reports', '/team', '/analytics'];
      case AppFlavor.socialApp:
        return ['/feed', '/chat', '/friends', '/stories'];
      case AppFlavor.productivityApp:
        return ['/tasks', '/calendar', '/notes', '/projects'];
    }
  }

  // 自定义配置
  static Map<String, dynamic> get customConfig {
    switch (_currentFlavor) {
      case AppFlavor.qaToolbox:
        return {
          'maxAppsPerUser': 10,
          'premiumFeatures': ['advancedAnalytics', 'customThemes'],
          'supportedFormats': ['json', 'csv', 'xml'],
        };
      case AppFlavor.businessApp:
        return {
          'maxTeamMembers': 50,
          'premiumFeatures': ['advancedReports', 'teamManagement'],
          'supportedFormats': ['pdf', 'excel', 'csv'],
        };
      case AppFlavor.socialApp:
        return {
          'maxFriends': 1000,
          'premiumFeatures': ['unlimitedStories', 'advancedFilters'],
          'supportedFormats': ['image', 'video', 'audio'],
        };
      case AppFlavor.productivityApp:
        return {
          'maxProjects': 20,
          'premiumFeatures': ['teamCollaboration', 'advancedScheduling'],
          'supportedFormats': ['text', 'markdown', 'pdf'],
        };
    }
  }

  // 检查功能是否启用
  static bool isFeatureEnabled(String feature) {
    return featureFlags[feature] ?? false;
  }

  // 获取自定义配置值
  static T? getCustomValue<T>(String key) {
    return customConfig[key] as T?;
  }
}