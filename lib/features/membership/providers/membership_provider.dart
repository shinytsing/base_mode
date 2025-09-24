import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/membership_model.dart';

// Membership状态管理
class MembershipState {
  final List<MembershipPlan> plans;
  final MembershipPlan? currentPlan;
  final bool isLoading;
  final String? error;

  const MembershipState({
    this.plans = const [],
    this.currentPlan,
    this.isLoading = false,
    this.error,
  });

  MembershipState copyWith({
    List<MembershipPlan>? plans,
    MembershipPlan? currentPlan,
    bool? isLoading,
    String? error,
  }) {
    return MembershipState(
      plans: plans ?? this.plans,
      currentPlan: currentPlan ?? this.currentPlan,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Membership Provider
class MembershipNotifier extends StateNotifier<MembershipState> {
  MembershipNotifier() : super(const MembershipState()) {
    _loadPlans();
  }

  void _loadPlans() {
    state = state.copyWith(isLoading: true);
    
    // 模拟加载会员计划
    final plans = [
      MembershipPlan(
        id: 'free',
        name: '免费版',
        description: '基础功能，适合个人用户',
        price: 0,
        period: 'month',
        type: 'free',
        features: ['基础功能', '有限使用'],
      ),
      MembershipPlan(
        id: 'premium',
        name: '高级版',
        description: '所有功能，优先支持',
        price: 29,
        period: 'month',
        type: 'premium',
        features: ['所有功能', '优先支持', '无限制使用'],
      ),
      MembershipPlan(
        id: 'enterprise',
        name: '企业版',
        description: '团队协作，定制服务',
        price: 99,
        period: 'month',
        type: 'enterprise',
        features: ['所有功能', '专属支持', '团队协作', '定制服务'],
      ),
    ];

    state = state.copyWith(
      plans: plans,
      isLoading: false,
    );
  }

  void setCurrentPlan(MembershipPlan plan) {
    state = state.copyWith(currentPlan: plan);
  }

  void subscribeToPlan(String planId) {
    // 模拟订阅逻辑
    final plan = state.plans.firstWhere((p) => p.id == planId);
    state = state.copyWith(currentPlan: plan);
  }

  void cancelSubscription() {
    state = state.copyWith(currentPlan: null);
  }
}

// Provider实例
final membershipProvider = StateNotifierProvider<MembershipNotifier, MembershipState>(
  (ref) => MembershipNotifier(),
);
