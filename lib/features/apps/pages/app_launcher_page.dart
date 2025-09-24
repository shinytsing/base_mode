import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';

class AppLauncherPage extends ConsumerWidget {
  const AppLauncherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('应用启动器'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryColor.withOpacity(0.1),
              AppTheme.backgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 欢迎标题
              _buildWelcomeSection(context),
              
              const SizedBox(height: 24),
              
              // 应用网格
              _buildAppsGrid(context),
              
              const SizedBox(height: 24),
              
              // 快速操作
              _buildQuickActions(context),
              
              const SizedBox(height: 24),
              
              // 使用统计
              _buildUsageStats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '欢迎使用QAToolBox',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '选择您需要的应用，开启高效工作之旅',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '可用应用',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
          children: AppConfig.supportedApps.map((appName) {
            return _buildAppCard(context, appName);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAppCard(BuildContext context, String appName) {
    final appIcon = _getAppIcon(appName);
    final appColor = _getAppColor(appName);
    final appDescription = _getAppDescription(appName);
    final isInstalled = _isAppInstalled(appName);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _launchApp(context, appName),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColor.withOpacity(0.1),
                appColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: appColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  appIcon,
                  color: appColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: appColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                appDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isInstalled 
                      ? AppTheme.successColor.withOpacity(0.1)
                      : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isInstalled ? '已安装' : '点击安装',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isInstalled 
                        ? AppTheme.successColor
                        : AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
                '安装所有应用',
                Icons.download_outlined,
                AppTheme.primaryColor,
                () => _installAllApps(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                '查看已安装',
                Icons.check_circle_outline,
                AppTheme.successColor,
                () => _showInstalledApps(context),
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
    Color color,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '使用统计',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                '已安装应用',
                '5',
                Icons.apps,
                AppTheme.primaryColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '可用应用',
                '5',
                Icons.store,
                AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '总使用时长',
                '2.5h',
                Icons.timer,
                AppTheme.warningColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
    // 模拟所有应用都已安装
    return true;
  }

  void _launchApp(BuildContext context, String appName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('正在启动 $appName...'),
        backgroundColor: _getAppColor(appName),
        duration: const Duration(seconds: 2),
      ),
    );
    
    // 模拟应用启动
    Future.delayed(const Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$appName 已启动！'),
          backgroundColor: AppTheme.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }

  void _installAllApps(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('正在安装所有应用...'),
        backgroundColor: AppTheme.primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
    
    // 模拟安装过程
    Future.delayed(const Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('所有应用安装完成！'),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  void _showInstalledApps(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('已安装的应用'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConfig.supportedApps.map((app) {
            return ListTile(
              leading: Icon(
                _getAppIcon(app),
                color: _getAppColor(app),
              ),
              title: Text(app),
              subtitle: Text(_getAppDescription(app)),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
