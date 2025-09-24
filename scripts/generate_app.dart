#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import '../lib/core/generator/template_manager.dart';
import '../lib/core/generator/config_manager.dart';

/// QAToolBox App 代码生成器
/// 用于快速生成新的应用模块
class AppGenerator {
  final String appName;
  final String appId;
  final String description;
  final String category;
  final String icon;
  final String color;
  final List<String> features;

  AppGenerator({
    required this.appName,
    required this.appId,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    required this.features,
  });

  /// 生成应用代码
  Future<void> generate() async {
    print('🚀 开始生成应用: $appName');
    
    // 创建应用目录结构
    await _createDirectoryStructure();
    
    // 生成应用页面
    await _generateAppPages();
    
    // 生成应用服务
    await _generateAppServices();
    
    // 生成应用模型
    await _generateAppModels();
    
    // 生成应用提供者
    await _generateAppProviders();
    
    // 更新路由配置
    await _updateRouterConfig();
    
    // 更新应用配置
    await _updateAppConfig();
    
    print('✅ 应用 $appName 生成完成！');
  }

  /// 创建目录结构
  Future<void> _createDirectoryStructure() async {
    final directories = [
      'lib/features/$appId/pages',
      'lib/features/$appId/widgets',
      'lib/features/$appId/services',
      'lib/features/$appId/models',
      'lib/features/$appId/providers',
    ];

    for (final dir in directories) {
      await Directory(dir).create(recursive: true);
      print('📁 创建目录: $dir');
    }
  }

  /// 生成应用页面
  Future<void> _generateAppPages() async {
    // 主页面
    await _writeFile(
      'lib/features/$appId/pages/${appId}_page.dart',
      _generateMainPage(),
    );

    // 设置页面
    await _writeFile(
      'lib/features/$appId/pages/${appId}_settings_page.dart',
      _generateSettingsPage(),
    );

    // 帮助页面
    await _writeFile(
      'lib/features/$appId/pages/${appId}_help_page.dart',
      _generateHelpPage(),
    );
  }

  /// 生成应用服务
  Future<void> _generateAppServices() async {
    await _writeFile(
      'lib/features/$appId/services/${appId}_service.dart',
      _generateAppService(),
    );
  }

  /// 生成应用模型
  Future<void> _generateAppModels() async {
    await _writeFile(
      'lib/features/$appId/models/${appId}_model.dart',
      _generateAppModel(),
    );
  }

  /// 生成应用提供者
  Future<void> _generateAppProviders() async {
    await _writeFile(
      'lib/features/$appId/providers/${appId}_provider.dart',
      _generateAppProvider(),
    );
  }

  /// 更新路由配置
  Future<void> _updateRouterConfig() async {
    // 这里应该更新 app_router.dart 文件
    print('🔄 更新路由配置');
  }

  /// 更新应用配置
  Future<void> _updateAppConfig() async {
    // 这里应该更新 app_config.dart 文件
    print('🔄 更新应用配置');
  }

  /// 生成主页面代码
  String _generateMainPage() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/${appId}_provider.dart';
import '../widgets/${appId}_feature_card.dart';

class ${_toPascalCase(appName)}Page extends ConsumerWidget {
  const ${_toPascalCase(appName)}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(${appId}Provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('$appName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // 打开设置页面
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用介绍
            _buildAppIntro(context),
            
            const SizedBox(height: 24),
            
            // 功能列表
            _buildFeaturesList(context),
            
            const SizedBox(height: 24),
            
            // 快速操作
            _buildQuickActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIntro(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            $color,
            $color.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  $icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$appName',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$description',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '核心功能',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...features.map((feature) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ${_toPascalCase(appName)}FeatureCard(
              title: feature,
              onTap: () {
                // 处理功能点击
              },
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快速操作',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                context,
                '开始使用',
                Icons.play_arrow_outlined,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                '查看帮助',
                Icons.help_outline,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: $color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: $color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }

  /// 生成设置页面代码
  String _generateSettingsPage() {
    return '''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';

class ${_toPascalCase(appName)}SettingsPage extends ConsumerWidget {
  const ${_toPascalCase(appName)}SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$appName 设置'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection(
            context,
            '通用设置',
            [
              _buildSettingsItem(
                context,
                '通知设置',
                '管理推送通知',
                Icons.notifications_outlined,
                () {},
              ),
              _buildSettingsItem(
                context,
                '主题设置',
                '选择应用主题',
                Icons.palette_outlined,
                () {},
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsSection(
            context,
            '数据管理',
            [
              _buildSettingsItem(
                context,
                '数据同步',
                '同步到云端',
                Icons.cloud_sync_outlined,
                () {},
              ),
              _buildSettingsItem(
                context,
                '数据导出',
                '导出应用数据',
                Icons.download_outlined,
                () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    String title,
    List<Widget> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: $color,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
''';
  }

  /// 生成帮助页面代码
  String _generateHelpPage() {
    return '''
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class ${_toPascalCase(appName)}HelpPage extends StatelessWidget {
  const ${_toPascalCase(appName)}HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('$appName 帮助'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSection(
              context,
              '常见问题',
              [
                '如何使用$appName？',
                '如何设置通知？',
                '如何同步数据？',
                '如何联系客服？',
              ],
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              context,
              '使用指南',
              [
                '快速入门',
                '功能详解',
                '高级技巧',
                '最佳实践',
              ],
            ),
            const SizedBox(height: 24),
            _buildHelpSection(
              context,
              '技术支持',
              [
                '问题反馈',
                '功能建议',
                '联系客服',
                '用户社区',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSection(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: items.map((item) {
              return ListTile(
                title: Text(item),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // 处理帮助项点击
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
''';
  }

  /// 生成应用服务代码
  String _generateAppService() {
    return '''
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/config/app_config.dart';

part '${appId}_service.g.dart';

@RestApi(baseUrl: AppConfig.baseApiUrl)
abstract class ${_toPascalCase(appName)}Service {
  factory ${_toPascalCase(appName)}Service(Dio dio, {String baseUrl}) = _${_toPascalCase(appName)}Service;

  @GET('/$appId/data')
  Future<Map<String, dynamic>> getData();

  @POST('/$appId/data')
  Future<Map<String, dynamic>> saveData(@Body() Map<String, dynamic> data);

  @GET('/$appId/settings')
  Future<Map<String, dynamic>> getSettings();

  @PUT('/$appId/settings')
  Future<Map<String, dynamic>> updateSettings(@Body() Map<String, dynamic> settings);
}

class ${_toPascalCase(appName)}ServiceClient {
  static ${_toPascalCase(appName)}Service? _instance;
  static Dio? _dio;

  static ${_toPascalCase(appName)}Service get instance {
    if (_instance == null) {
      _dio = Dio();
      _setupInterceptors();
      _instance = ${_toPascalCase(appName)}Service(_dio!);
    }
    return _instance!;
  }

  static void _setupInterceptors() {
    _dio!.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 添加认证头
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }
}
''';
  }

  /// 生成应用模型代码
  String _generateAppModel() {
    return '''
import 'package:freezed_annotation/freezed_annotation.dart';

part '${appId}_model.freezed.dart';
part '${appId}_model.g.dart';

@freezed
class ${_toPascalCase(appName)}Data with _\$${_toPascalCase(appName)}Data {
  const factory ${_toPascalCase(appName)}Data({
    required String id,
    required String title,
    String? description,
    @Default({}) Map<String, dynamic> metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _${_toPascalCase(appName)}Data;

  factory ${_toPascalCase(appName)}Data.fromJson(Map<String, dynamic> json) => 
      _\$${_toPascalCase(appName)}DataFromJson(json);
}

@freezed
class ${_toPascalCase(appName)}Settings with _\$${_toPascalCase(appName)}Settings {
  const factory ${_toPascalCase(appName)}Settings({
    @Default(true) bool notifications,
    @Default('light') String theme,
    @Default({}) Map<String, dynamic> preferences,
  }) = _${_toPascalCase(appName)}Settings;

  factory ${_toPascalCase(appName)}Settings.fromJson(Map<String, dynamic> json) => 
      _\$${_toPascalCase(appName)}SettingsFromJson(json);
}
''';
  }

  /// 生成应用提供者代码
  String _generateAppProvider() {
    return '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/${appId}_model.dart';
import '../services/${appId}_service.dart';

// 应用数据状态
class ${_toPascalCase(appName)}State {
  final List<${_toPascalCase(appName)}Data> data;
  final ${_toPascalCase(appName)}Settings settings;
  final bool isLoading;
  final String? error;

  const ${_toPascalCase(appName)}State({
    this.data = const [],
    required this.settings,
    this.isLoading = false,
    this.error,
  });

  ${_toPascalCase(appName)}State copyWith({
    List<${_toPascalCase(appName)}Data>? data,
    ${_toPascalCase(appName)}Settings? settings,
    bool? isLoading,
    String? error,
  }) {
    return ${_toPascalCase(appName)}State(
      data: data ?? this.data,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// 应用状态提供者
class ${_toPascalCase(appName)}Notifier extends StateNotifier<${_toPascalCase(appName)}State> {
  final ${_toPascalCase(appName)}Service _service;

  ${_toPascalCase(appName)}Notifier(this._service) : super(
    ${_toPascalCase(appName)}State(
      settings: const ${_toPascalCase(appName)}Settings(),
    ),
  ) {
    _loadData();
  }

  // 加载数据
  Future<void> _loadData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final data = await _service.getData();
      final settings = await _service.getSettings();
      
      state = state.copyWith(
        data: [], // 根据实际数据结构解析
        settings: ${_toPascalCase(appName)}Settings.fromJson(settings),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 保存数据
  Future<void> saveData(${_toPascalCase(appName)}Data item) async {
    try {
      await _service.saveData(item.toJson());
      await _loadData();
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 更新设置
  Future<void> updateSettings(${_toPascalCase(appName)}Settings newSettings) async {
    try {
      await _service.updateSettings(newSettings.toJson());
      state = state.copyWith(settings: newSettings);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 提供者
final ${appId}ServiceProvider = Provider<${_toPascalCase(appName)}Service>((ref) {
  return ${_toPascalCase(appName)}ServiceClient.instance;
});

final ${appId}Provider = StateNotifierProvider<${_toPascalCase(appName)}Notifier, ${_toPascalCase(appName)}State>((ref) {
  final service = ref.watch(${appId}ServiceProvider);
  return ${_toPascalCase(appName)}Notifier(service);
});
''';
  }

  /// 生成功能卡片组件代码
  String _generateFeatureCard() {
    return '''
import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class ${_toPascalCase(appName)}FeatureCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback? onTap;

  const ${_toPascalCase(appName)}FeatureCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: $color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: $color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppTheme.textTertiaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
  }

  /// 写入文件
  Future<void> _writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
    print('📝 生成文件: $path');
  }

  /// 转换为PascalCase
  String _toPascalCase(String input) {
    return input
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}

/// 主函数
void main(List<String> args) async {
  if (args.length < 7) {
    print('用法: dart generate_app.dart <appName> <appId> <description> <category> <icon> <color> <features...>');
    print('示例: dart generate_app.dart "MyApp" "my_app" "我的应用" "工具" "Icons.tool" "AppTheme.primaryColor" "功能1" "功能2"');
    exit(1);
  }

  final appName = args[0];
  final appId = args[1];
  final description = args[2];
  final category = args[3];
  final icon = args[4];
  final color = args[5];
  final features = args.skip(6).toList();

  final generator = AppGenerator(
    appName: appName,
    appId: appId,
    description: description,
    category: category,
    icon: icon,
    color: color,
    features: features,
  );

  await generator.generate();
}
''';
  }

  /// 写入文件
  Future<void> _writeFile(String path, String content) async {
    final file = File(path);
    await file.writeAsString(content);
    print('📝 生成文件: $path');
  }

  /// 转换为PascalCase
  String _toPascalCase(String input) {
    return input
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join('');
  }
}

/// 主函数
void main(List<String> args) async {
  if (args.length < 7) {
    print('用法: dart generate_app.dart <appName> <appId> <description> <category> <icon> <color> <features...>');
    print('示例: dart generate_app.dart "MyApp" "my_app" "我的应用" "工具" "Icons.tool" "AppTheme.primaryColor" "功能1" "功能2"');
    exit(1);
  }

  final appName = args[0];
  final appId = args[1];
  final description = args[2];
  final category = args[3];
  final icon = args[4];
  final color = args[5];
  final features = args.skip(6).toList();

  final generator = AppGenerator(
    appName: appName,
    appId: appId,
    description: description,
    category: category,
    icon: icon,
    color: color,
    features: features,
  );

  await generator.generate();
}
