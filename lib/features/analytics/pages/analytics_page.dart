import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui_kit/responsive/responsive_layout.dart';
import '../providers/analytics_provider.dart';
import '../models/analytics_model.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('数据分析'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(analyticsProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportReport(context),
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 概览统计
              _buildOverviewStats(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 使用趋势图表
              _buildUsageTrendChart(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 功能使用分布
              _buildFeatureUsageChart(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 用户行为分析
              _buildUserBehaviorAnalysis(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 性能指标
              _buildPerformanceMetrics(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewStats(BuildContext context, AnalyticsState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            '概览统计',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveSpacing(mobile: 16),
          ResponsiveGrid(
            mobileColumns: 2,
            tabletColumns: 4,
            desktopColumns: 4,
            children: [
              _buildStatCard(context, '总用户数', '${state.totalUsers}', Icons.people, Colors.blue),
              _buildStatCard(context, '活跃用户', '${state.activeUsers}', Icons.trending_up, Colors.green),
              _buildStatCard(context, '付费用户', '${state.paidUsers}', Icons.payment, Colors.orange),
              _buildStatCard(context, '月收入', '¥${state.monthlyRevenue}', Icons.attach_money, Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return ResponsiveCard(
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24.w,
            ),
          ),
          SizedBox(height: 8.h),
          ResponsiveText(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          ResponsiveText(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageTrendChart(BuildContext context, AnalyticsState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            '使用趋势',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveSpacing(mobile: 16),
          SizedBox(
            height: 300.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
                        if (value.toInt() < days.length) {
                          return Text(days[value.toInt()]);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: state.usageTrend.map((point) => FlSpot(point.x, point.y)).toList(),
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureUsageChart(BuildContext context, AnalyticsState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            '功能使用分布',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveSpacing(mobile: 16),
          SizedBox(
            height: 300.h,
            child: PieChart(
              PieChartData(
                sections: state.featureUsage.map((feature) {
                  return PieChartSectionData(
                    color: _getFeatureColor(feature.name),
                    value: feature.usage,
                    title: '${feature.usage}%',
                    radius: 80,
                    titleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: state.featureUsage.map((feature) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: _getFeatureColor(feature.name),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  ResponsiveText(
                    feature.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBehaviorAnalysis(BuildContext context, AnalyticsState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            '用户行为分析',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveSpacing(mobile: 16),
          ResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 3,
            children: [
              _buildBehaviorCard(context, '平均会话时长', '${state.avgSessionDuration}分钟', Icons.timer),
              _buildBehaviorCard(context, '页面浏览量', '${state.pageViews}', Icons.visibility),
              _buildBehaviorCard(context, '跳出率', '${state.bounceRate}%', Icons.exit_to_app),
              _buildBehaviorCard(context, '转化率', '${state.conversionRate}%', Icons.trending_up),
              _buildBehaviorCard(context, '留存率', '${state.retentionRate}%', Icons.repeat),
              _buildBehaviorCard(context, '推荐率', '${state.referralRate}%', Icons.share),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorCard(BuildContext context, String title, String value, IconData icon) {
    return ResponsiveCard(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20.w,
            ),
          ),
          SizedBox(height: 8.h),
          ResponsiveText(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveText(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, AnalyticsState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            '性能指标',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveSpacing(mobile: 16),
          ResponsiveGrid(
            mobileColumns: 1,
            tabletColumns: 2,
            desktopColumns: 4,
            children: [
              _buildPerformanceCard(context, '响应时间', '${state.avgResponseTime}ms', Icons.speed),
              _buildPerformanceCard(context, '错误率', '${state.errorRate}%', Icons.error),
              _buildPerformanceCard(context, '可用性', '${state.availability}%', Icons.check_circle),
              _buildPerformanceCard(context, '吞吐量', '${state.throughput}/s', Icons.analytics),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(BuildContext context, String title, String value, IconData icon) {
    return ResponsiveCard(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: AppTheme.successColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: AppTheme.successColor,
              size: 20.w,
            ),
          ),
          SizedBox(height: 8.h),
          ResponsiveText(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          ResponsiveText(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getFeatureColor(String featureName) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    
    final index = featureName.hashCode % colors.length;
    return colors[index];
  }

  void _exportReport(BuildContext context) {
    // 导出报告
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('报告导出功能开发中')),
    );
  }
}
