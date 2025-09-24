import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import 'config_manager.dart';

/// 模板管理器 - 管理代码生成模板
class TemplateManager {
  static const String _templatesDir = 'lib/core/generator/templates';
  
  /// 获取模板内容
  static Future<String> getTemplate(String templateName) async {
    final templatePath = path.join(_templatesDir, '$templateName.dart.template');
    final file = File(templatePath);
    
    if (!await file.exists()) {
      throw Exception('模板文件不存在: $templatePath');
    }
    
    return await file.readAsString();
  }
  
  /// 渲染模板
  static String renderTemplate(String template, Map<String, dynamic> variables) {
    String result = template;
    
    variables.forEach((key, value) {
      final placeholder = '{{$key}}';
      result = result.replaceAll(placeholder, value.toString());
    });
    
    return result;
  }
  
  /// 获取所有可用模板
  static Future<List<String>> getAvailableTemplates() async {
    final templatesDir = Directory(_templatesDir);
    
    if (!await templatesDir.exists()) {
      return [];
    }
    
    final files = await templatesDir.list().toList();
    return files
        .whereType<File>()
        .map((file) => path.basenameWithoutExtension(path.basenameWithoutExtension(file.path)))
        .toList();
  }
}

// AppConfig 已在 config_manager.dart 中定义

/// AI代码生成器
class AICodeGenerator {
  static const String _openaiApiKey = 'YOUR_OPENAI_API_KEY';
  static const String _openaiBaseUrl = 'https://api.openai.com/v1';
  
  /// 使用AI生成代码
  static Future<String> generateCodeWithAI(String prompt, String context) async {
    try {
      // 这里集成OpenAI API
      // 实际实现需要HTTP客户端调用OpenAI API
      return _mockAIGeneration(prompt, context);
    } catch (e) {
      print('AI代码生成失败: $e');
      return _fallbackGeneration(prompt);
    }
  }
  
  /// 模拟AI生成（实际项目中替换为真实API调用）
  static String _mockAIGeneration(String prompt, String context) {
    return '''
// AI生成的代码 - 基于提示: $prompt
// 上下文: $context

class AIGeneratedCode {
  // 这里是根据AI分析生成的代码
  // 实际实现会调用OpenAI API
}
''';
  }
  
  /// 备用生成方案
  static String _fallbackGeneration(String prompt) {
    return '''
// 备用代码生成
class FallbackCode {
  // 当AI服务不可用时的备用方案
}
''';
  }
}

/// 增强版应用生成器
class EnhancedAppGenerator {
  final AppConfig config;
  final bool useAI;
  
  EnhancedAppGenerator({
    required this.config,
    this.useAI = false,
  });
  
  /// 生成完整应用
  Future<void> generateApp() async {
    print('🚀 开始生成应用: ${config.name}');
    
    // 1. 创建目录结构
    await _createDirectoryStructure();
    
    // 2. 生成核心文件
    await _generateCoreFiles();
    
    // 3. 生成功能模块
    await _generateFeatureModules();
    
    // 4. 生成测试文件
    await _generateTestFiles();
    
    // 5. 更新配置文件
    await _updateConfigFiles();
    
    // 6. 生成文档
    await _generateDocumentation();
    
    print('✅ 应用 ${config.name} 生成完成！');
  }
  
  /// 创建目录结构
  Future<void> _createDirectoryStructure() async {
    final directories = [
      'lib/features/${config.id}/pages',
      'lib/features/${config.id}/widgets',
      'lib/features/${config.id}/services',
      'lib/features/${config.id}/models',
      'lib/features/${config.id}/providers',
      'lib/features/${config.id}/utils',
      'test/features/${config.id}',
      'docs/${config.id}',
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
      print('📁 创建目录: $dir');
    }
  }
  
  /// 生成核心文件
  Future<void> _generateCoreFiles() async {
    // 生成主页面
    await _generateFile(
      'lib/features/${config.id}/pages/${config.id}_page.dart',
      await _generateMainPage(),
    );
    
    // 生成服务
    await _generateFile(
      'lib/features/${config.id}/services/${config.id}_service.dart',
      await _generateService(),
    );
    
    // 生成模型
    await _generateFile(
      'lib/features/${config.id}/models/${config.id}_model.dart',
      await _generateModel(),
    );
    
    // 生成提供者
    await _generateFile(
      'lib/features/${config.id}/providers/${config.id}_provider.dart',
      await _generateProvider(),
    );
  }
  
  /// 生成功能模块
  Future<void> _generateFeatureModules() async {
    for (final feature in config.features) {
      final featureId = _toSnakeCase(feature);
      
      // 生成功能页面
      await _generateFile(
        'lib/features/${config.id}/pages/${featureId}_page.dart',
        await _generateFeaturePage(feature),
      );
      
      // 生成功能组件
      await _generateFile(
        'lib/features/${config.id}/widgets/${featureId}_widget.dart',
        await _generateFeatureWidget(feature),
      );
    }
  }
  
  /// 生成测试文件
  Future<void> _generateTestFiles() async {
    // 生成单元测试
    await _generateFile(
      'test/features/${config.id}/${config.id}_test.dart',
      await _generateUnitTests(),
    );
    
    // 生成Widget测试
    await _generateFile(
      'test/features/${config.id}/${config.id}_page_test.dart',
      await _generateWidgetTests(),
    );
  }
  
  /// 更新配置文件
  Future<void> _updateConfigFiles() async {
    // 更新路由配置
    await _updateRouterConfig();
    
    // 更新依赖配置
    await _updateDependencies();
    
    // 更新主题配置
    await _updateThemeConfig();
  }
  
  /// 生成文档
  Future<void> _generateDocumentation() async {
    await _generateFile(
      'docs/${config.id}/README.md',
      await _generateAppDocumentation(),
    );
  }
  
  /// 生成主页面
  Future<String> _generateMainPage() async {
    final template = await TemplateManager.getTemplate('main_page');
    return TemplateManager.renderTemplate(template, {
      'appName': config.name,
      'appId': config.id,
      'description': config.description,
      'icon': config.icon,
      'color': config.color,
      'features': config.features.map((f) => _toPascalCase(f)).join(', '),
    });
  }
  
  /// 生成服务
  Future<String> _generateService() async {
    final template = await TemplateManager.getTemplate('service');
    return TemplateManager.renderTemplate(template, {
      'appName': _toPascalCase(config.name),
      'appId': config.id,
    });
  }
  
  /// 生成模型
  Future<String> _generateModel() async {
    final template = await TemplateManager.getTemplate('model');
    return TemplateManager.renderTemplate(template, {
      'appName': _toPascalCase(config.name),
      'appId': config.id,
    });
  }
  
  /// 生成提供者
  Future<String> _generateProvider() async {
    final template = await TemplateManager.getTemplate('provider');
    return TemplateManager.renderTemplate(template, {
      'appName': _toPascalCase(config.name),
      'appId': config.id,
    });
  }
  
  /// 生成功能页面
  Future<String> _generateFeaturePage(String feature) async {
    if (useAI) {
      return await AICodeGenerator.generateCodeWithAI(
        '生成Flutter页面: $feature',
        '应用: ${config.name}, 功能: $feature',
      );
    }
    
    final template = await TemplateManager.getTemplate('feature_page');
    return TemplateManager.renderTemplate(template, {
      'featureName': _toPascalCase(feature),
      'featureId': _toSnakeCase(feature),
      'appId': config.id,
    });
  }
  
  /// 生成功能组件
  Future<String> _generateFeatureWidget(String feature) async {
    if (useAI) {
      return await AICodeGenerator.generateCodeWithAI(
        '生成Flutter组件: $feature',
        '应用: ${config.name}, 功能: $feature',
      );
    }
    
    final template = await TemplateManager.getTemplate('feature_widget');
    return TemplateManager.renderTemplate(template, {
      'featureName': _toPascalCase(feature),
      'featureId': _toSnakeCase(feature),
      'appId': config.id,
    });
  }
  
  /// 生成单元测试
  Future<String> _generateUnitTests() async {
    final template = await TemplateManager.getTemplate('unit_test');
    return TemplateManager.renderTemplate(template, {
      'appName': _toPascalCase(config.name),
      'appId': config.id,
    });
  }
  
  /// 生成Widget测试
  Future<String> _generateWidgetTests() async {
    final template = await TemplateManager.getTemplate('widget_test');
    return TemplateManager.renderTemplate(template, {
      'appName': _toPascalCase(config.name),
      'appId': config.id,
    });
  }
  
  /// 生成应用文档
  Future<String> _generateAppDocumentation() async {
    final template = await TemplateManager.getTemplate('app_documentation');
    return TemplateManager.renderTemplate(template, {
      'appName': config.name,
      'description': config.description,
      'category': config.category,
      'features': config.features.join('\n- '),
    });
  }
  
  /// 更新路由配置
  Future<void> _updateRouterConfig() async {
    // 读取现有路由配置
    final routerFile = File('lib/core/router/app_router.dart');
    if (await routerFile.exists()) {
      String content = await routerFile.readAsString();
      
      // 添加新路由
      final newRoute = '''
        // ${config.name} 路由
        GoRoute(
          path: '/${config.id}',
          name: '${config.id}',
          builder: (context, state) => ${_toPascalCase(config.name)}Page(),
        ),
''';
      
      // 在适当位置插入新路由
      content = content.replaceFirst(
        '// 添加新路由的位置',
        '$newRoute\n        // 添加新路由的位置',
      );
      
      await routerFile.writeAsString(content);
      print('🔄 更新路由配置');
    }
  }
  
  /// 更新依赖配置
  Future<void> _updateDependencies() async {
    final pubspecFile = File('pubspec.yaml');
    if (await pubspecFile.exists()) {
      String content = await pubspecFile.readAsString();
      
      // 添加新依赖
      for (final dependency in config.dependencies) {
        if (!content.contains(dependency)) {
          content = content.replaceFirst(
            'dependencies:',
            'dependencies:\n  $dependency',
          );
        }
      }
      
      await pubspecFile.writeAsString(content);
      print('🔄 更新依赖配置');
    }
  }
  
  /// 更新主题配置
  Future<void> _updateThemeConfig() async {
    final themeFile = File('lib/core/theme/app_theme.dart');
    if (await themeFile.exists()) {
      String content = await themeFile.readAsString();
      
      // 添加新主题
      final newTheme = '''
  // ${config.name} 主题
  static Color get ${config.id}PrimaryColor => ${config.color};
  static Color get ${config.id}SecondaryColor => ${config.color}.withOpacity(0.7);
''';
      
      content = content.replaceFirst(
        '// 添加新主题的位置',
        '$newTheme\n  // 添加新主题的位置',
      );
      
      await themeFile.writeAsString(content);
      print('🔄 更新主题配置');
    }
  }
  
  /// 生成文件
  Future<void> _generateFile(String filePath, String content) async {
    final file = File(filePath);
    await file.writeAsString(content);
    print('📝 生成文件: $filePath');
  }
  
  /// 转换为PascalCase
  String _toPascalCase(String input) {
    return input
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
  
  /// 转换为snake_case
  String _toSnakeCase(String input) {
    return input
        .replaceAll(' ', '_')
        .toLowerCase();
  }
}
