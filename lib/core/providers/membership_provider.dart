import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_model.dart';
import '../services/membership_service.dart';

// 会员状态
class MembershipState {
  final List<MembershipPlan> plans;
  final Subscription? currentSubscription;
  final bool isLoading;
  final String? error;

  const MembershipState({
    this.plans = const [],
    this.currentSubscription,
    this.isLoading = false,
    this.error,
  });

  MembershipState copyWith({
    List<MembershipPlan>? plans,
    Subscription? currentSubscription,
    bool? isLoading,
    String? error,
  }) {
    return MembershipState(
      plans: plans ?? this.plans,
      currentSubscription: currentSubscription ?? this.currentSubscription,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// 会员状态提供者
class MembershipNotifier extends StateNotifier<MembershipState> {
  final MembershipService _membershipService;
  
  MembershipNotifier(this._membershipService) : super(const MembershipState()) {
    loadPlans();
    loadStatus();
  }

  // 加载会员计划
  Future<void> loadPlans() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _membershipService.getPlans();
      
      if (response.success && response.data != null) {
        state = state.copyWith(
          plans: response.data!,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 加载会员状态
  Future<void> loadStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _membershipService.getStatus();
      
      if (response.success && response.data != null) {
        state = state.copyWith(
          currentSubscription: response.data,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // 订阅会员
  Future<bool> subscribe(String planId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _membershipService.subscribe({'plan_id': planId});
      
      if (response.success && response.data != null) {
        state = state.copyWith(
          currentSubscription: response.data,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 取消订阅
  Future<bool> cancelSubscription() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _membershipService.cancelSubscription();
      
      if (response.success) {
        state = state.copyWith(
          currentSubscription: null,
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response.message,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 检查是否为会员
  bool get isMember {
    return state.currentSubscription != null && 
           state.currentSubscription!.status == 'active';
  }

  // 获取当前会员等级
  String get currentMembershipLevel {
    return state.currentSubscription?.planId ?? 'free';
  }

  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// 提供者
final membershipServiceProvider = Provider<MembershipService>((ref) {
  return MembershipServiceClient.instance;
});

final membershipProvider = StateNotifierProvider<MembershipNotifier, MembershipState>((ref) {
  final membershipService = ref.watch(membershipServiceProvider);
  return MembershipNotifier(membershipService);
});
