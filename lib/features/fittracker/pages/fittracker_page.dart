import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui_kit/responsive/responsive_layout.dart';
import '../providers/fittracker_provider.dart';
import '../models/fittracker_model.dart';

class FitTrackerPage extends ConsumerWidget {
  const FitTrackerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(fitTrackerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddWorkoutDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => _showAnalytics(context),
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 今日概览
              _buildTodayOverview(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 快速操作
              _buildQuickActions(context, ref),
              
              ResponsiveSpacing(mobile: 24),
              
              // 最近锻炼
              _buildRecentWorkouts(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 健身计划
              _buildWorkoutPlans(context, state),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWorkoutDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodayOverview(BuildContext context, FitTrackerState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ResponsiveText(
            '今日概览',
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
              _buildStatCard(context, '步数', '8,432', Icons.directions_walk, Colors.blue),
              _buildStatCard(context, '卡路里', '456', Icons.local_fire_department, Colors.orange),
              _buildStatCard(context, '锻炼时间', '45分钟', Icons.timer, Colors.green),
              _buildStatCard(context, '心率', '72 BPM', Icons.favorite, Colors.red),
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
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          '快速操作',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ResponsiveSpacing(mobile: 16),
        ResponsiveGrid(
          mobileColumns: 2,
          tabletColumns: 3,
          desktopColumns: 4,
          children: [
            _buildActionCard(context, '开始锻炼', Icons.play_arrow, Colors.green, () {
              _startWorkout(context, ref);
            }),
            _buildActionCard(context, '记录饮食', Icons.restaurant, Colors.orange, () {
              _logMeal(context, ref);
            }),
            _buildActionCard(context, '测量体重', Icons.monitor_weight, Colors.blue, () {
              _logWeight(context, ref);
            }),
            _buildActionCard(context, '查看计划', Icons.calendar_today, Colors.purple, () {
              _viewPlans(context);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return ResponsiveCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
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
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentWorkouts(BuildContext context, FitTrackerState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          '最近锻炼',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ResponsiveSpacing(mobile: 16),
        ...state.recentWorkouts.map((workout) => _buildWorkoutCard(context, workout)),
      ],
    );
  }

  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    return ResponsiveCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              _getWorkoutIcon(workout.type),
              color: AppTheme.primaryColor,
              size: 24.w,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  workout.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                ResponsiveText(
                  '${workout.duration}分钟 • ${workout.caloriesBurned}卡路里',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          ResponsiveText(
            workout.date,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textTertiaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPlans(BuildContext context, FitTrackerState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          '健身计划',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        ResponsiveSpacing(mobile: 16),
        ResponsiveGrid(
          mobileColumns: 1,
          tabletColumns: 2,
          desktopColumns: 3,
          children: state.workoutPlans.map((plan) => _buildPlanCard(context, plan)).toList(),
        ),
      ],
    );
  }

  Widget _buildPlanCard(BuildContext context, WorkoutPlan plan) {
    return ResponsiveCard(
      child: InkWell(
        onTap: () => _viewPlanDetails(context, plan),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 120.h,
              decoration: BoxDecoration(
                color: plan.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Icon(
                  _getPlanIcon(plan.type),
                  size: 48.w,
                  color: plan.color,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            ResponsiveText(
              plan.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            ResponsiveText(
              plan.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryColor,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16.w,
                  color: AppTheme.textTertiaryColor,
                ),
                SizedBox(width: 4.w),
                ResponsiveText(
                  '${plan.duration}周',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
                const Spacer(),
                ResponsiveText(
                  '${plan.difficulty}/5',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.textTertiaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getWorkoutIcon(String type) {
    switch (type.toLowerCase()) {
      case 'running':
        return Icons.directions_run;
      case 'cycling':
        return Icons.directions_bike;
      case 'swimming':
        return Icons.pool;
      case 'weightlifting':
        return Icons.fitness_center;
      case 'yoga':
        return Icons.self_improvement;
      default:
        return Icons.fitness_center;
    }
  }

  IconData _getPlanIcon(String type) {
    switch (type.toLowerCase()) {
      case 'strength':
        return Icons.fitness_center;
      case 'cardio':
        return Icons.directions_run;
      case 'flexibility':
        return Icons.self_improvement;
      case 'weight_loss':
        return Icons.trending_down;
      case 'muscle_gain':
        return Icons.trending_up;
      default:
        return Icons.fitness_center;
    }
  }

  void _showAddWorkoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _AddWorkoutDialog(),
    );
  }

  void _showAnalytics(BuildContext context) {
    // 显示分析页面
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('查看健身分析')),
    );
  }

  void _startWorkout(BuildContext context, WidgetRef ref) {
    // 开始锻炼
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('开始锻炼')),
    );
  }

  void _logMeal(BuildContext context, WidgetRef ref) {
    // 记录饮食
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('记录饮食')),
    );
  }

  void _logWeight(BuildContext context, WidgetRef ref) {
    // 记录体重
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('记录体重')),
    );
  }

  void _viewPlans(BuildContext context) {
    // 查看计划
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('查看健身计划')),
    );
  }

  void _viewPlanDetails(BuildContext context, WorkoutPlan plan) {
    // 查看计划详情
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('查看计划: ${plan.name}')),
    );
  }
}

// 添加锻炼对话框
class _AddWorkoutDialog extends StatefulWidget {
  @override
  _AddWorkoutDialogState createState() => _AddWorkoutDialogState();
}

class _AddWorkoutDialogState extends State<_AddWorkoutDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  
  String _selectedType = 'running';
  String _selectedIntensity = 'medium';

  final List<String> _workoutTypes = [
    'running', 'cycling', 'swimming', 'weightlifting', 'yoga', 'pilates'
  ];

  final List<String> _intensities = [
    'low', 'medium', 'high'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ResponsiveText(
                    '添加锻炼',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '锻炼名称',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入锻炼名称';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: '锻炼类型',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    items: _workoutTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getWorkoutTypeDisplayName(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    controller: _durationController,
                    decoration: InputDecoration(
                      labelText: '持续时间（分钟）',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '请输入持续时间';
                      }
                      if (int.tryParse(value) == null) {
                        return '请输入有效的数字';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),
                  DropdownButtonFormField<String>(
                    value: _selectedIntensity,
                    decoration: InputDecoration(
                      labelText: '强度',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    items: _intensities.map((intensity) {
                      return DropdownMenuItem(
                        value: intensity,
                        child: Text(_getIntensityDisplayName(intensity)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedIntensity = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveWorkout,
                    child: const Text('保存'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getWorkoutTypeDisplayName(String type) {
    switch (type) {
      case 'running':
        return '跑步';
      case 'cycling':
        return '骑行';
      case 'swimming':
        return '游泳';
      case 'weightlifting':
        return '举重';
      case 'yoga':
        return '瑜伽';
      case 'pilates':
        return '普拉提';
      default:
        return type;
    }
  }

  String _getIntensityDisplayName(String intensity) {
    switch (intensity) {
      case 'low':
        return '低强度';
      case 'medium':
        return '中等强度';
      case 'high':
        return '高强度';
      default:
        return intensity;
    }
  }

  void _saveWorkout() {
    if (_formKey.currentState!.validate()) {
      // 保存锻炼记录
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('锻炼记录已保存')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}
