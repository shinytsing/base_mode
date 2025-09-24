import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';

class AppsPage extends ConsumerWidget {
  const AppsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('应用中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              // 搜索功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类标签
            _buildCategoryTabs(context),
            
            const SizedBox(height: 24),
            
            // 应用列表
            _buildAppsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(context, '全部', true),
          const SizedBox(width: 8),
          _buildCategoryChip(context, '工作效率', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, '生活娱乐', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, '健康管理', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, '社交互动', false),
          const SizedBox(width: 8),
          _buildCategoryChip(context, '创作工具', false),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(BuildContext context, String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        // 处理分类选择
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
    );
  }

  Widget _buildAppsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '推荐应用',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...AppConfig.supportedApps.map((appName) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAppListItem(context, appName),
          );
        }),
      ],
    );
  }

  Widget _buildAppListItem(BuildContext context, String appName) {
    final appIcon = _getAppIcon(appName);
    final appColor = _getAppColor(appName);
    final appDescription = _getAppDescription(appName);
    final isInstalled = _isAppInstalled(appName);

    return Card(
      child: InkWell(
        onTap: () => context.go('/apps/${_getAppId(appName)}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  appIcon,
                  color: appColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appDescription,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isInstalled)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '已安装',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () => _installApp(context, appName),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('安装'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAppIcon(String appName) {
    switch (appName) {
      case 'QAToolBox Pro':
        return Icons.work_outline;
      case 'LifeMode':
        return Icons.home_outlined;
      case 'FitTracker':
        return Icons.fitness_center_outlined;
      case 'SocialHub':
        return Icons.people_outline;
      case 'CreativeStudio':
        return Icons.palette_outlined;
      default:
        return Icons.apps_outlined;
    }
  }

  Color _getAppColor(String appName) {
    switch (appName) {
      case 'QAToolBox Pro':
        return AppTheme.primaryColor;
      case 'LifeMode':
        return AppTheme.successColor;
      case 'FitTracker':
        return AppTheme.warningColor;
      case 'SocialHub':
        return AppTheme.secondaryColor;
      case 'CreativeStudio':
        return AppTheme.accentColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }

  String _getAppDescription(String appName) {
    switch (appName) {
      case 'QAToolBox Pro':
        return '专业的工作效率工具，包含测试用例生成、代码分析、API测试等功能';
      case 'LifeMode':
        return '智能生活助手，美食推荐、旅行规划、情绪管理一应俱全';
      case 'FitTracker':
        return '全面的健康管理平台，健身计划、营养计算、运动追踪';
      case 'SocialHub':
        return '社交互动中心，智能匹配、活动推荐、人际关系管理';
      case 'CreativeStudio':
        return '创意工作室，AI写作、设计工具、音乐制作、内容创作';
      default:
        return '未知应用';
    }
  }

  String _getAppId(String appName) {
    switch (appName) {
      case 'QAToolBox Pro':
        return 'qa_toolbox_pro';
      case 'LifeMode':
        return 'life_mode';
      case 'FitTracker':
        return 'fit_tracker';
      case 'SocialHub':
        return 'social_hub';
      case 'CreativeStudio':
        return 'creative_studio';
      default:
        return 'unknown';
    }
  }

  bool _isAppInstalled(String appName) {
    // 这里应该检查用户是否已安装该应用
    // 暂时返回false
    return false;
  }

  void _installApp(BuildContext context, String appName) {
    // 这里应该处理应用安装逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('正在安装 $appName...'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}