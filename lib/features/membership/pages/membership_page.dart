import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/ui_kit/responsive/responsive_layout.dart';
import '../providers/membership_provider.dart';
import '../models/membership_model.dart' as models;

class MembershipPage extends ConsumerWidget {
  const MembershipPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(membershipProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('会员中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showPaymentHistory(context),
          ),
        ],
      ),
      body: ResponsiveContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 当前会员状态
              _buildCurrentMembership(context, state),
              
              ResponsiveSpacing(mobile: 24),
              
              // 会员计划
              _buildMembershipPlans(context, ref),
              
              ResponsiveSpacing(mobile: 24),
              
              // 会员特权
              _buildMembershipBenefits(context),
              
              ResponsiveSpacing(mobile: 24),
              
              // 使用统计
              _buildUsageStats(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentMembership(BuildContext context, models.MembershipState state) {
    return ResponsiveCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: _getMembershipColor(state.currentPlan?.type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  _getMembershipIcon(state.currentPlan?.type),
                  color: _getMembershipColor(state.currentPlan?.type),
                  size: 24.w,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ResponsiveText(
                      state.currentPlan?.name ?? '免费版',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    ResponsiveText(
                      state.currentPlan?.description ?? '基础功能，适合个人使用',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (state.currentPlan?.type != 'free') ...[
            SizedBox(height: 16.h),
            Row(
              children: [
                ResponsiveText(
                  '到期时间: ',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                ResponsiveText(
                  state.currentPlan?.expiresAt ?? '',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (state.currentPlan?.isExpiringSoon == true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ResponsiveText(
                      '即将到期',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMembershipPlans(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          '选择会员计划',
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
            _buildPlanCard(context, ref, models.MembershipPlan(
              id: 'basic',
              name: '基础会员',
              description: '适合个人用户',
              price: 29.9,
              period: 'month',
              type: 'basic',
              features: [
                '2个应用访问权限',
                '基础功能使用',
                '标准客服支持',
                '数据同步',
              ],
            )),
            _buildPlanCard(context, ref, models.MembershipPlan(
              id: 'premium',
              name: '高级会员',
              description: '适合专业用户',
              price: 59.9,
              period: 'month',
              type: 'premium',
              features: [
                '4个应用访问权限',
                '高级功能使用',
                '优先客服支持',
                '高级数据分析',
                '自定义主题',
              ],
            )),
            _buildPlanCard(context, ref, models.MembershipPlan(
              id: 'vip',
              name: 'VIP会员',
              description: '适合企业用户',
              price: 99.9,
              period: 'month',
              type: 'vip',
              features: [
                '全部应用访问权限',
                '所有功能使用',
                '专属客服支持',
                '企业级数据分析',
                'API访问权限',
                '团队协作功能',
              ],
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanCard(BuildContext context, WidgetRef ref, models.MembershipPlan plan) {
    final isCurrentPlan = ref.watch(membershipProvider).currentPlan?.type == plan.type;
    
    return ResponsiveCard(
      child: InkWell(
        onTap: isCurrentPlan ? null : () => _subscribeToPlan(context, ref, plan),
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveText(
                        plan.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      ResponsiveText(
                        plan.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCurrentPlan)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ResponsiveText(
                      '当前计划',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                ResponsiveText(
                  '¥${plan.price}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getMembershipColor(plan.type),
                  ),
                ),
                SizedBox(width: 4.w),
                ResponsiveText(
                  '/${plan.period == 'month' ? '月' : '年'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ...plan.features.map((feature) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16.w,
                    color: AppTheme.successColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: ResponsiveText(
                      feature,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCurrentPlan ? null : () => _subscribeToPlan(context, ref, plan),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getMembershipColor(plan.type),
                  foregroundColor: Colors.white,
                ),
                child: ResponsiveText(
                  isCurrentPlan ? '当前计划' : '立即订阅',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipBenefits(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          '会员特权',
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
            _buildBenefitCard(context, '无限制使用', Icons.all_inclusive, '所有功能无限制使用'),
            _buildBenefitCard(context, '优先支持', Icons.support_agent, '7x24小时优先客服支持'),
            _buildBenefitCard(context, '数据同步', Icons.sync, '跨设备数据实时同步'),
            _buildBenefitCard(context, '高级分析', Icons.analytics, '深度数据分析和报告'),
            _buildBenefitCard(context, '自定义主题', Icons.palette, '个性化界面和主题'),
            _buildBenefitCard(context, 'API访问', Icons.api, '开放API接口访问'),
          ],
        ),
      ],
    );
  }

  Widget _buildBenefitCard(BuildContext context, String title, IconData icon, String description) {
    return ResponsiveCard(
      child: Column(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 24.w,
            ),
          ),
          SizedBox(height: 12.h),
          ResponsiveText(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          ResponsiveText(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStats(BuildContext context, models.MembershipState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveText(
          '使用统计',
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
            _buildStatCard(context, '本月使用', '${state.monthlyUsage}', Icons.trending_up),
            _buildStatCard(context, '剩余额度', '${state.remainingQuota}', Icons.account_balance_wallet),
            _buildStatCard(context, '存储空间', '${state.storageUsed}GB', Icons.storage),
            _buildStatCard(context, 'API调用', '${state.apiCalls}', Icons.api),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
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

  Color _getMembershipColor(String? type) {
    switch (type) {
      case 'basic':
        return Colors.blue;
      case 'premium':
        return Colors.purple;
      case 'vip':
        return Colors.orange;
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getMembershipIcon(String? type) {
    switch (type) {
      case 'basic':
        return Icons.star;
      case 'premium':
        return Icons.star_half;
      case 'vip':
        return Icons.diamond;
      default:
        return Icons.person;
    }
  }

  void _subscribeToPlan(BuildContext context, WidgetRef ref, models.MembershipPlan plan) {
    showDialog(
      context: context,
      builder: (context) => _PaymentDialog(plan: plan),
    );
  }

  void _showPaymentHistory(BuildContext context) {
    // 显示支付历史
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('查看支付历史')),
    );
  }
}

// 支付对话框
class _PaymentDialog extends StatefulWidget {
  final models.MembershipPlan plan;

  const _PaymentDialog({required this.plan});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  String _selectedPaymentMethod = 'wechat';
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'wechat', 'name': '微信支付', 'icon': Icons.wechat},
    {'id': 'alipay', 'name': '支付宝', 'icon': Icons.payment},
    {'id': 'card', 'name': '银行卡', 'icon': Icons.credit_card},
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
                    '订阅 ${widget.plan.name}',
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
            SizedBox(height: 16.h),
            ResponsiveText(
              '¥${widget.plan.price}/${widget.plan.period == 'month' ? '月' : '年'}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            SizedBox(height: 24.h),
            ResponsiveText(
              '选择支付方式',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16.h),
            ..._paymentMethods.map((method) => _buildPaymentMethod(method)),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                    child: const Text('取消'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processPayment,
                    child: _isProcessing 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('立即支付'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPaymentMethod = method['id'];
          });
        },
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Icon(
                method['icon'],
                color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                size: 24.w,
              ),
              SizedBox(width: 12.w),
              ResponsiveText(
                method['name'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimaryColor,
                ),
              ),
              const Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryColor,
                  size: 20.w,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() {
    setState(() {
      _isProcessing = true;
    });

    // 模拟支付处理
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });
      
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.plan.name} 订阅成功！')),
      );
    });
  }
}