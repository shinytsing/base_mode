import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/config/app_config.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('QAToolBox'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // 通知页面
            },
          ),
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: () {
              context.go('/theme-demo');
            },
          ),
          IconButton(
            icon: const Icon(Icons.apps_outlined),
            onPressed: () {
              context.go('/app-launcher');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 欢迎区域
            _buildWelcomeSection(context, user != null ? '${user!.firstName} ${user!.lastName}' : '用户'),
            
            const SizedBox(height: 24),
            
            // 会员状态
            _buildMembershipSection(context, user?.membershipLevel ?? 'free'),
            
            const SizedBox(height: 24),
            
            // 应用网格
            _buildAppsGrid(context),
            
            const SizedBox(height: 24),
            
            // 快速操作
            _buildQuickActions(context),
            
            const SizedBox(height: 24),
            
            // 统计信息
            _buildStatistics(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String userName) {
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
            '你好，$userName！',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '今天也要高效工作哦',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipSection(BuildContext context, String membershipLevel) {
    final membershipInfo = AppConfig.membershipLevels[membershipLevel];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.star_outline,
                color: AppTheme.primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    membershipInfo?['name'] ?? '免费版',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '可访问 ${membershipInfo?['maxApps'] ?? 1} 个应用',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            if (membershipLevel != 'vip')
              TextButton(
                onPressed: () => context.go('/membership'),
                child: const Text('升级'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppsGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '我的应用',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
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
    
    return Card(
      child: InkWell(
        onTap: () => context.go('/apps/${_getAppId(appName)}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: appColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  appIcon,
                  color: appColor,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                appName,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
                '创建任务',
                Icons.add_task_outlined,
                AppTheme.successColor,
                () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                context,
                '查看报告',
                Icons.analytics_outlined,
                AppTheme.accentColor,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
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

  Widget _buildStatistics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '今日统计',
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
                '完成任务',
                '12',
                Icons.check_circle_outline,
                AppTheme.successColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '使用时长',
                '2.5h',
                Icons.timer_outlined,
                AppTheme.accentColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                context,
                '效率评分',
                '85%',
                Icons.trending_up_outlined,
                AppTheme.primaryColor,
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
}
