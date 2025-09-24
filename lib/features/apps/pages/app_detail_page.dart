import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme.dart';

class AppDetailPage extends ConsumerWidget {
  final String appId;
  
  const AppDetailPage({
    super.key,
    required this.appId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfo = _getAppInfo(appId);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(appInfo['name']),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // 分享功能
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用头部信息
            _buildAppHeader(context, appInfo),
            
            // 应用描述
            _buildAppDescription(context, appInfo),
            
            // 功能特色
            _buildFeatures(context, appInfo),
            
            // 截图展示
            _buildScreenshots(context, appInfo),
            
            // 安装按钮
            _buildInstallButton(context, appInfo),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context, Map<String, dynamic> appInfo) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            appInfo['color'].withOpacity(0.1),
            appInfo['color'].withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: appInfo['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              appInfo['icon'],
              color: appInfo['color'],
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            appInfo['name'],
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            appInfo['category'],
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRatingStars(context, appInfo['rating']),
              const SizedBox(width: 8),
              Text(
                '${appInfo['rating']} (${appInfo['reviewCount']} 评价)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingStars(BuildContext context, double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
                  ? Icons.star_half
                  : Icons.star_border,
          color: AppTheme.warningColor,
          size: 16,
        );
      }),
    );
  }

  Widget _buildAppDescription(BuildContext context, Map<String, dynamic> appInfo) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '应用介绍',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            appInfo['description'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatures(BuildContext context, Map<String, dynamic> appInfo) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '核心功能',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...appInfo['features'].map<Widget>((feature) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: appInfo['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildScreenshots(BuildContext context, Map<String, dynamic> appInfo) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '应用截图',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: appInfo['screenshots'].length,
              itemBuilder: (context, index) {
                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      appInfo['screenshots'][index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.borderColor,
                          child: Icon(
                            Icons.image_outlined,
                            color: AppTheme.textTertiaryColor,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallButton(BuildContext context, Map<String, dynamic> appInfo) {
    final isInstalled = _isAppInstalled(appInfo['id']);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _handleInstall(context, appInfo),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: Text(
            isInstalled ? '打开应用' : '立即安装',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getAppInfo(String appId) {
    switch (appId) {
      case 'qa_toolbox_pro':
        return {
          'id': appId,
          'name': 'QAToolBox Pro',
          'category': '工作效率',
          'icon': Icons.work_outline,
          'color': AppTheme.primaryColor,
          'rating': 4.8,
          'reviewCount': 1250,
          'description': 'QAToolBox Pro是专为开发者和测试工程师设计的专业工具套件。集成了测试用例生成器、代码分析工具、API测试平台等多项功能，帮助您提升工作效率，确保代码质量。',
          'features': [
            'AI智能测试用例生成',
            '多语言代码质量分析',
            'RESTful API自动化测试',
            '性能瓶颈检测',
            '安全漏洞扫描',
            '技术文档自动生成',
            '代码审查建议',
            '团队协作管理',
          ],
          'screenshots': [
            'assets/images/qa_toolbox_1.png',
            'assets/images/qa_toolbox_2.png',
            'assets/images/qa_toolbox_3.png',
          ],
        };
      case 'life_mode':
        return {
          'id': appId,
          'name': 'LifeMode',
          'category': '生活娱乐',
          'icon': Icons.home_outlined,
          'color': AppTheme.successColor,
          'rating': 4.6,
          'reviewCount': 890,
          'description': 'LifeMode是您的生活智能助手，通过AI技术为您提供个性化的生活建议。从美食推荐到旅行规划，从情绪管理到习惯养成，让生活更加精彩。',
          'features': [
            'AI美食推荐系统',
            '个性化旅行规划',
            '情绪智能分析',
            '冥想引导练习',
            '生活目标管理',
            '时间胶囊功能',
            '生活数据可视化',
            '社区分享互动',
          ],
          'screenshots': [
            'assets/images/life_mode_1.png',
            'assets/images/life_mode_2.png',
            'assets/images/life_mode_3.png',
          ],
        };
      case 'fit_tracker':
        return {
          'id': appId,
          'name': 'FitTracker',
          'category': '健康管理',
          'icon': Icons.fitness_center_outlined,
          'color': AppTheme.warningColor,
          'rating': 4.7,
          'reviewCount': 2100,
          'description': 'FitTracker是全面的健康管理平台，为您提供科学的健身计划、营养指导和运动追踪。通过数据分析和AI建议，帮助您建立健康的生活方式。',
          'features': [
            'AI训练计划生成',
            '实时运动指导',
            '营养计算分析',
            '健康数据监测',
            '习惯养成打卡',
            '社交健身挑战',
            'BMI健康评估',
            '睡眠质量分析',
          ],
          'screenshots': [
            'assets/images/fit_tracker_1.png',
            'assets/images/fit_tracker_2.png',
            'assets/images/fit_tracker_3.png',
          ],
        };
      case 'social_hub':
        return {
          'id': appId,
          'name': 'SocialHub',
          'category': '社交互动',
          'icon': Icons.people_outline,
          'color': AppTheme.secondaryColor,
          'rating': 4.5,
          'reviewCount': 1680,
          'description': 'SocialHub是新一代社交平台，通过智能匹配算法帮助您找到志同道合的朋友。支持活动组织、深度交流、关系管理等多种社交功能。',
          'features': [
            '智能匹配算法',
            '活动发布参与',
            '深度交流系统',
            '人际关系管理',
            '社交行为分析',
            '兴趣标签匹配',
            '群组讨论功能',
            '隐私安全保护',
          ],
          'screenshots': [
            'assets/images/social_hub_1.png',
            'assets/images/social_hub_2.png',
            'assets/images/social_hub_3.png',
          ],
        };
      case 'creative_studio':
        return {
          'id': appId,
          'name': 'CreativeStudio',
          'category': '创作工具',
          'icon': Icons.palette_outlined,
          'color': AppTheme.accentColor,
          'rating': 4.9,
          'reviewCount': 950,
          'description': 'CreativeStudio是创作者的梦想工坊，集成了AI写作助手、设计工具、音乐制作等多种创作功能。让您的创意想法轻松变为现实。',
          'features': [
            'AI写作助手',
            '智能设计工具',
            '音乐制作平台',
            '视频剪辑功能',
            '创意灵感激发',
            '作品分享社区',
            '协作创作支持',
            '版权保护机制',
          ],
          'screenshots': [
            'assets/images/creative_studio_1.png',
            'assets/images/creative_studio_2.png',
            'assets/images/creative_studio_3.png',
          ],
        };
      default:
        return {
          'id': appId,
          'name': '未知应用',
          'category': '其他',
          'icon': Icons.apps_outlined,
          'color': AppTheme.textSecondaryColor,
          'rating': 0.0,
          'reviewCount': 0,
          'description': '应用信息暂不可用',
          'features': [],
          'screenshots': [],
        };
    }
  }

  bool _isAppInstalled(String appId) {
    // 这里应该检查用户是否已安装该应用
    return false;
  }

  void _handleInstall(BuildContext context, Map<String, dynamic> appInfo) {
    final isInstalled = _isAppInstalled(appInfo['id']);
    
    if (isInstalled) {
      // 打开应用
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('正在打开 ${appInfo['name']}...'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } else {
      // 安装应用
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('正在安装 ${appInfo['name']}...'),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }
}
