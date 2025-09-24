#!/usr/bin/env dart

import 'dart:io';
import '../lib/core/generator/config_manager.dart';
import 'enhanced_generator.dart';

/// QAToolBox 演示脚本
/// 展示增强版代码生成器和配置驱动开发的能力
void main(List<String> args) async {
  print('🎭 QAToolBox 增强版代码生成演示');
  print('=====================================');
  
  try {
    // 1. 显示当前配置
    await _showCurrentConfig();
    
    // 2. 演示代码生成
    await _demonstrateGeneration();
    
    // 3. 显示生成结果
    await _showGenerationResults();
    
    print('🎉 演示完成！');
    print('');
    print('接下来你可以：');
    print('  dart scripts/enhanced_generator.dart batch     # 批量生成所有应用');
    print('  dart scripts/dev_tools.dart dev                # 启动开发环境');
    print('  flutter run -d chrome                          # 运行Flutter应用');
    
  } catch (e) {
    print('❌ 演示过程中出现错误: $e');
    exit(1);
  }
}

/// 显示当前配置
Future<void> _showCurrentConfig() async {
  print('📋 当前项目配置:');
  print('=====================================');
  
  try {
    final configs = await AppConfigManager.getAllAppConfigs();
    
    if (configs.isEmpty) {
      print('⚠️  未找到应用配置，请检查 config/apps.yaml 文件');
      return;
    }
    
    print('📱 已配置的应用 (${configs.length}个):');
    for (final config in configs) {
      print('  📦 ${config.name} (${config.id})');
      print('     描述: ${config.description}');
      print('     分类: ${config.category}');
      print('     功能数: ${config.features.length}');
      print('     服务端口: ${config.servicePort ?? "未配置"}');
      print('');
    }
    
  } catch (e) {
    print('❌ 读取配置失败: $e');
    print('💡 提示: 请确保 config/apps.yaml 文件存在且格式正确');
  }
}

/// 演示代码生成
Future<void> _demonstrateGeneration() async {
  print('🚀 演示代码生成功能:');
  print('=====================================');
  
  try {
    // 获取第一个应用配置进行演示
    final configs = await AppConfigManager.getAllAppConfigs();
    if (configs.isEmpty) {
      print('⚠️  没有可用的应用配置进行演示');
      return;
    }
    
    final demoConfig = configs.first;
    print('🎯 选择演示应用: ${demoConfig.name}');
    print('');
    
    // 创建增强版代码生成器
    final generator = EnhancedCodeGenerator(
      useAI: false, // 演示模式不使用AI
      verbose: true,
    );
    
    print('⏳ 正在生成代码...');
    await generator.generateApp(demoConfig);
    
  } catch (e) {
    print('❌ 代码生成失败: $e');
  }
}

/// 显示生成结果
Future<void> _showGenerationResults() async {
  print('📊 代码生成结果统计:');
  print('=====================================');
  
  // 统计生成的文件
  final stats = await _collectFileStats();
  
  print('📁 生成的文件结构:');
  print('  前端代码:');
  print('    - 页面文件: ${stats['pages']} 个');
  print('    - 组件文件: ${stats['widgets']} 个');
  print('    - 服务文件: ${stats['services']} 个');
  print('    - 模型文件: ${stats['models']} 个');
  print('    - 提供者文件: ${stats['providers']} 个');
  print('');
  print('  后端代码:');
  print('    - 微服务: ${stats['microservices']} 个');
  print('    - API端点: ${stats['endpoints']} 个');
  print('    - 数据库表: ${stats['tables']} 个');
  print('');
  print('  配置文件:');
  print('    - Docker配置: ${stats['docker']} 个');
  print('    - K8s配置: ${stats['k8s']} 个');
  print('    - 测试文件: ${stats['tests']} 个');
  print('');
  print('  文档:');
  print('    - API文档: ${stats['api_docs']} 个');
  print('    - 应用文档: ${stats['app_docs']} 个');
  print('');
  
  final totalFiles = stats.values.fold<int>(0, (sum, count) => sum + count);
  print('📈 总计生成文件: $totalFiles 个');
  
  if (totalFiles > 0) {
    print('');
    print('🎯 代码生成效率统计:');
    print('  - 预计手动开发时间: ${(totalFiles * 2).toString().padLeft(3)} 小时');
    print('  - 自动生成时间: ${((totalFiles * 0.1)).toStringAsFixed(1).padLeft(5)} 小时');
    print('  - 效率提升: ${((totalFiles * 2) / (totalFiles * 0.1)).toStringAsFixed(1)}x');
  }
}

/// 收集文件统计信息
Future<Map<String, int>> _collectFileStats() async {
  final stats = <String, int>{
    'pages': 0,
    'widgets': 0,
    'services': 0,
    'models': 0,
    'providers': 0,
    'microservices': 0,
    'endpoints': 0,
    'tables': 0,
    'docker': 0,
    'k8s': 0,
    'tests': 0,
    'api_docs': 0,
    'app_docs': 0,
  };
  
  try {
    // 统计前端文件
    await _countFilesInDirectory('lib/features', 'pages', stats);
    await _countFilesInDirectory('lib/features', 'widgets', stats);
    await _countFilesInDirectory('lib/features', 'services', stats);
    await _countFilesInDirectory('lib/features', 'models', stats);
    await _countFilesInDirectory('lib/features', 'providers', stats);
    
    // 统计后端文件
    await _countFilesInDirectory('backend/services', '', stats, key: 'microservices');
    
    // 统计配置文件
    await _countFilesInDirectory('k8s', '', stats, key: 'k8s');
    
    // 统计测试文件
    await _countFilesInDirectory('test', '', stats, key: 'tests');
    
    // 统计文档文件
    await _countFilesInDirectory('docs', '', stats, key: 'api_docs');
    
  } catch (e) {
    print('⚠️  统计文件时出现错误: $e');
  }
  
  return stats;
}

/// 统计目录中的文件数量
Future<void> _countFilesInDirectory(
  String basePath, 
  String subPath, 
  Map<String, int> stats, 
  {String? key}
) async {
  final targetPath = subPath.isEmpty ? basePath : '$basePath/$subPath';
  final directory = Directory(targetPath);
  
  if (!await directory.exists()) {
    return;
  }
  
  int count = 0;
  await for (final entity in directory.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      count++;
    }
  }
  
  final statKey = key ?? subPath;
  if (stats.containsKey(statKey)) {
    stats[statKey] = count;
  }
}

/// 显示项目结构
Future<void> _showProjectStructure() async {
  print('📁 项目结构预览:');
  print('=====================================');
  
  final structure = '''
base_mode/
├── lib/
│   ├── core/
│   │   ├── generator/          # 🚀 增强版代码生成器
│   │   │   ├── template_manager.dart
│   │   │   ├── config_manager.dart
│   │   │   └── templates/      # 📄 代码模板
│   │   ├── config/             # ⚙️ 应用配置
│   │   ├── theme/              # 🎨 主题系统
│   │   └── router/             # 🔀 路由管理
│   └── features/               # 📱 功能模块
│       ├── qa_toolbox/         # 🔧 QA工具箱
│       ├── life_mode/          # 🏠 生活模式
│       ├── fit_tracker/        # 💪 健身追踪
│       ├── social_hub/         # 👥 社交中心
│       └── creative_studio/    # 🎨 创作工具
├── backend/
│   └── services/               # 🔌 微服务
│       ├── auth/               # 🔐 认证服务
│       ├── user/               # 👤 用户服务
│       ├── payment/            # 💳 支付服务
│       └── apps/               # 📱 应用服务
├── config/                     # 📋 配置文件
│   ├── apps.yaml              # 🎯 应用配置
│   ├── services.yaml          # 🔧 服务配置
│   └── templates.yaml         # 📄 模板配置
├── k8s/                       # ☸️ Kubernetes配置
├── scripts/                   # 🛠️ 开发脚本
│   ├── enhanced_generator.dart # 🚀 增强版生成器
│   ├── dev_tools.dart         # 🔧 开发工具
│   └── demo.dart              # 🎭 演示脚本
└── docs/                      # 📚 文档
''';
  
  print(structure);
}
