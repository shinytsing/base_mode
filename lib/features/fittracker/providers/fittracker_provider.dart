import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../models/fittracker_model.dart';
import '../services/fittracker_service.dart';

// ==================== FitTracker 状态管理 ====================

class FitTrackerNotifier extends StateNotifier<FitTrackerState> {
  final FitTrackerService _service;

  FitTrackerNotifier(this._service) : super(
    const FitTrackerState(),
  ) {
    _loadInitialData();
  }

  /// 加载初始数据
  Future<void> _loadInitialData() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await Future.wait([
        _loadRecentWorkouts(),
        _loadWorkoutPlans(),
        _loadTodayStats(),
      ]);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // ==================== 锻炼管理 ====================

  /// 创建锻炼记录
  Future<void> createWorkout(CreateWorkoutRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createWorkout(request);
      
      state = state.copyWith(
        recentWorkouts: [response.workout, ...state.recentWorkouts],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '创建锻炼记录失败: ${e.toString()}',
      );
    }
  }

  /// 获取最近锻炼
  Future<void> _loadRecentWorkouts() async {
    try {
      final response = await _service.getRecentWorkouts();
      state = state.copyWith(recentWorkouts: response.workouts);
    } catch (e) {
      print('加载最近锻炼失败: $e');
    }
  }

  /// 获取锻炼计划
  Future<void> _loadWorkoutPlans() async {
    try {
      final response = await _service.getWorkoutPlans();
      state = state.copyWith(workoutPlans: response.plans);
    } catch (e) {
      print('加载锻炼计划失败: $e');
    }
  }

  /// 获取今日统计
  Future<void> _loadTodayStats() async {
    try {
      final response = await _service.getTodayStats();
      state = state.copyWith(todayStats: response.stats);
    } catch (e) {
      print('加载今日统计失败: $e');
    }
  }

  // ==================== 饮食管理 ====================

  /// 记录饮食
  Future<void> logMeal(CreateMealRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.createMeal(request);
      
      state = state.copyWith(
        meals: [response.meal, ...state.meals],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '记录饮食失败: ${e.toString()}',
      );
    }
  }

  // ==================== 体重管理 ====================

  /// 记录体重
  Future<void> logWeight(LogWeightRequest request) async {
    try {
      state = state.copyWith(isLoading: true);
      
      final response = await _service.logWeight(request);
      
      state = state.copyWith(
        weightEntries: [response.weightEntry, ...state.weightEntries],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '记录体重失败: ${e.toString()}',
      );
    }
  }

  // ==================== 分析数据 ====================

  /// 获取分析数据
  Future<GetAnalyticsResponse> getAnalytics() async {
    try {
      return await _service.getAnalytics();
    } catch (e) {
      throw Exception('获取分析数据失败: ${e.toString()}');
    }
  }

  // ==================== 通用方法 ====================

  /// 刷新所有数据
  Future<void> refresh() async {
    await _loadInitialData();
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ==================== Provider 定义 ====================

final fitTrackerServiceProvider = Provider<FitTrackerService>((ref) {
  final dio = Dio();
  return FitTrackerService(dio);
});

final fitTrackerProvider = StateNotifierProvider<FitTrackerNotifier, FitTrackerState>((ref) {
  final service = ref.watch(fitTrackerServiceProvider);
  return FitTrackerNotifier(service);
});

// ==================== 特定功能 Provider ====================

/// 最近锻炼提供者
final recentWorkoutsProvider = Provider<List<Workout>>((ref) {
  final state = ref.watch(fitTrackerProvider);
  return state.recentWorkouts;
});

/// 锻炼计划提供者
final workoutPlansProvider = Provider<List<WorkoutPlan>>((ref) {
  final state = ref.watch(fitTrackerProvider);
  return state.workoutPlans;
});

/// 今日统计提供者
final todayStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final state = ref.watch(fitTrackerProvider);
  return state.todayStats;
});

/// 本周锻炼次数
final weeklyWorkoutCountProvider = Provider<int>((ref) {
  final workouts = ref.watch(recentWorkoutsProvider);
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1));
  
  return workouts.where((workout) {
    final workoutDate = DateTime.parse(workout.date);
    return workoutDate.isAfter(weekStart);
  }).length;
});

/// 本月消耗卡路里
final monthlyCaloriesProvider = Provider<int>((ref) {
  final workouts = ref.watch(recentWorkoutsProvider);
  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);
  
  return workouts.where((workout) {
    final workoutDate = DateTime.parse(workout.date);
    return workoutDate.isAfter(monthStart);
  }).fold(0, (sum, workout) => sum + workout.caloriesBurned);
});

/// 平均锻炼时长
final averageWorkoutDurationProvider = Provider<double>((ref) {
  final workouts = ref.watch(recentWorkoutsProvider);
  if (workouts.isEmpty) return 0.0;
  
  final totalDuration = workouts.fold(0, (sum, workout) => sum + workout.duration);
  return totalDuration / workouts.length;
});
