// FitMatrix 健身服务
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fitness_models.dart';

class FitnessService {
  static final FitnessService _instance = FitnessService._internal();
  factory FitnessService() => _instance;
  FitnessService._internal();

  // 本地存储键
  static const String _workoutSessionsKey = 'workout_sessions';
  static const String _strengthProfileKey = 'strength_profile';
  static const String _userProfileKey = 'user_profile';
  static const String _weightRecordsKey = 'weight_records';
  static const String _trainingPlansKey = 'training_plans';
  static const String _achievementsKey = 'achievements';
  static const String _statisticsKey = 'statistics';

  // 获取SharedPreferences实例
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  // ========== 训练会话管理 ==========

  // 保存训练会话
  Future<void> saveWorkoutSession(EnhancedFitnessWorkoutSession session) async {
    try {
      final prefs = await _prefs;
      final sessions = await getWorkoutSessions();
      sessions.add(session);
      
      final sessionsJson = sessions.map((s) => s.toJson()).toList();
      await prefs.setString(_workoutSessionsKey, jsonEncode(sessionsJson));
      
      // 更新统计数据
      await _updateStatistics();
    } catch (e) {
      debugPrint('保存训练会话失败: $e');
      rethrow;
    }
  }

  // 获取所有训练会话
  Future<List<EnhancedFitnessWorkoutSession>> getWorkoutSessions() async {
    try {
      final prefs = await _prefs;
      final sessionsJson = prefs.getString(_workoutSessionsKey);
      
      if (sessionsJson == null) return [];
      
      final List<dynamic> sessionsList = jsonDecode(sessionsJson);
      return sessionsList
          .map((json) => EnhancedFitnessWorkoutSession.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('获取训练会话失败: $e');
      return [];
    }
  }

  // 获取最近的训练会话
  Future<List<EnhancedFitnessWorkoutSession>> getRecentWorkoutSessions({int limit = 10}) async {
    final sessions = await getWorkoutSessions();
    sessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sessions.take(limit).toList();
  }

  // ========== 力量档案管理 ==========

  // 保存力量档案
  Future<void> saveStrengthProfile(EnhancedFitnessStrengthProfile profile) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_strengthProfileKey, jsonEncode(profile.toJson()));
    } catch (e) {
      debugPrint('保存力量档案失败: $e');
      rethrow;
    }
  }

  // 获取力量档案
  Future<EnhancedFitnessStrengthProfile?> getStrengthProfile() async {
    try {
      final prefs = await _prefs;
      final profileJson = prefs.getString(_strengthProfileKey);
      
      if (profileJson == null) return null;
      
      return EnhancedFitnessStrengthProfile.fromJson(jsonDecode(profileJson));
    } catch (e) {
      debugPrint('获取力量档案失败: $e');
      return null;
    }
  }

  // 更新三大项记录
  Future<void> updateBigThree({
    double? squat1RM,
    double? benchPress1RM,
    double? deadlift1RM,
    double? currentWeight,
  }) async {
    try {
      final profile = await getStrengthProfile();
      if (profile == null) return;

      final updatedProfile = EnhancedFitnessStrengthProfile(
        id: profile.id,
        userId: profile.userId,
        squat1RM: squat1RM ?? profile.squat1RM,
        benchPress1RM: benchPress1RM ?? profile.benchPress1RM,
        deadlift1RM: deadlift1RM ?? profile.deadlift1RM,
        totalWeight: (squat1RM ?? profile.squat1RM ?? 0) +
                    (benchPress1RM ?? profile.benchPress1RM ?? 0) +
                    (deadlift1RM ?? profile.deadlift1RM ?? 0),
        currentWeight: currentWeight ?? profile.currentWeight,
        strengthCoefficient: 0, // 将在下面计算
        squatGoal: profile.squatGoal,
        benchPressGoal: profile.benchPressGoal,
        deadliftGoal: profile.deadliftGoal,
        totalWorkouts: profile.totalWorkouts,
        consecutiveDays: profile.consecutiveDays,
        totalDurationMinutes: profile.totalDurationMinutes,
        lastUpdated: DateTime.now(),
      );

      // 计算力量系数
      final finalProfile = updatedProfile.copyWith(
        strengthCoefficient: updatedProfile.totalWeight / updatedProfile.currentWeight,
      );

      await saveStrengthProfile(finalProfile);
    } catch (e) {
      debugPrint('更新三大项记录失败: $e');
      rethrow;
    }
  }

  // ========== 用户档案管理 ==========

  // 保存用户档案
  Future<void> saveUserProfile(EnhancedFitnessUserProfile profile) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(_userProfileKey, jsonEncode(profile.toJson()));
    } catch (e) {
      debugPrint('保存用户档案失败: $e');
      rethrow;
    }
  }

  // 获取用户档案
  Future<EnhancedFitnessUserProfile?> getUserProfile() async {
    try {
      final prefs = await _prefs;
      final profileJson = prefs.getString(_userProfileKey);
      
      if (profileJson == null) return null;
      
      return EnhancedFitnessUserProfile.fromJson(jsonDecode(profileJson));
    } catch (e) {
      debugPrint('获取用户档案失败: $e');
      return null;
    }
  }

  // 计算BMI
  double calculateBMI(double weight, double height) {
    return weight / ((height / 100) * (height / 100));
  }

  // 计算基础代谢率（BMR）
  double calculateBMR({
    required double weight,
    required double height,
    required int age,
    required String gender,
  }) {
    if (gender.toLowerCase() == 'male') {
      return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
    } else {
      return 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
    }
  }

  // ========== 重量记录管理 ==========

  // 保存重量记录
  Future<void> saveWeightRecord(EnhancedExerciseWeightRecord record) async {
    try {
      final prefs = await _prefs;
      final records = await getWeightRecords();
      records.add(record);
      
      final recordsJson = records.map((r) => r.toJson()).toList();
      await prefs.setString(_weightRecordsKey, jsonEncode(recordsJson));
    } catch (e) {
      debugPrint('保存重量记录失败: $e');
      rethrow;
    }
  }

  // 获取重量记录
  Future<List<EnhancedExerciseWeightRecord>> getWeightRecords() async {
    try {
      final prefs = await _prefs;
      final recordsJson = prefs.getString(_weightRecordsKey);
      
      if (recordsJson == null) return [];
      
      final List<dynamic> recordsList = jsonDecode(recordsJson);
      return recordsList
          .map((json) => EnhancedExerciseWeightRecord.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('获取重量记录失败: $e');
      return [];
    }
  }

  // 获取特定动作的重量记录
  Future<List<EnhancedExerciseWeightRecord>> getWeightRecordsByExercise(String exerciseId) async {
    final records = await getWeightRecords();
    return records.where((r) => r.exerciseId == exerciseId).toList();
  }

  // ========== 训练计划管理 ==========

  // 保存训练计划
  Future<void> saveTrainingPlan(TrainingPlan plan) async {
    try {
      final prefs = await _prefs;
      final plans = await getTrainingPlans();
      plans.add(plan);
      
      final plansJson = plans.map((p) => p.toJson()).toList();
      await prefs.setString(_trainingPlansKey, jsonEncode(plansJson));
    } catch (e) {
      debugPrint('保存训练计划失败: $e');
      rethrow;
    }
  }

  // 获取训练计划
  Future<List<TrainingPlan>> getTrainingPlans() async {
    try {
      final prefs = await _prefs;
      final plansJson = prefs.getString(_trainingPlansKey);
      
      if (plansJson == null) return [];
      
      final List<dynamic> plansList = jsonDecode(plansJson);
      return plansList
          .map((json) => TrainingPlan.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('获取训练计划失败: $e');
      return [];
    }
  }

  // 获取激活的训练计划
  Future<TrainingPlan?> getActiveTrainingPlan() async {
    final plans = await getTrainingPlans();
    try {
      return plans.firstWhere((plan) => plan.isActive);
    } catch (e) {
      return null;
    }
  }

  // ========== 成就管理 ==========

  // 保存成就
  Future<void> saveAchievement(Achievement achievement) async {
    try {
      final prefs = await _prefs;
      final achievements = await getAchievements();
      
      // 更新或添加成就
      final index = achievements.indexWhere((a) => a.id == achievement.id);
      if (index != -1) {
        achievements[index] = achievement;
      } else {
        achievements.add(achievement);
      }
      
      final achievementsJson = achievements.map((a) => a.toJson()).toList();
      await prefs.setString(_achievementsKey, jsonEncode(achievementsJson));
    } catch (e) {
      debugPrint('保存成就失败: $e');
      rethrow;
    }
  }

  // 获取成就
  Future<List<Achievement>> getAchievements() async {
    try {
      final prefs = await _prefs;
      final achievementsJson = prefs.getString(_achievementsKey);
      
      if (achievementsJson == null) return [];
      
      final List<dynamic> achievementsList = jsonDecode(achievementsJson);
      return achievementsList
          .map((json) => Achievement.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('获取成就失败: $e');
      return [];
    }
  }

  // 检查并解锁成就
  Future<void> checkAndUnlockAchievements() async {
    try {
      final statistics = await getStatistics();
      final achievements = await getAchievements();
      
      // 连续训练成就
      if (statistics.consecutiveDays >= 7 && 
          !achievements.any((a) => a.id == 'consecutive_7_days')) {
        final achievement = Achievement(
          id: 'consecutive_7_days',
          name: '连续训练达人',
          description: '连续训练7天',
          category: 'training',
          icon: '🏃‍♂️',
          requirements: {'consecutive_days': 7},
          unlockedAt: DateTime.now(),
          isUnlocked: true,
        );
        await saveAchievement(achievement);
      }
      
      // 总训练次数成就
      if (statistics.totalWorkouts >= 50 && 
          !achievements.any((a) => a.id == 'total_50_workouts')) {
        final achievement = Achievement(
          id: 'total_50_workouts',
          name: '训练狂人',
          description: '完成50次训练',
          category: 'training',
          icon: '💪',
          requirements: {'total_workouts': 50},
          unlockedAt: DateTime.now(),
          isUnlocked: true,
        );
        await saveAchievement(achievement);
      }
      
    } catch (e) {
      debugPrint('检查成就失败: $e');
    }
  }

  // ========== 统计管理 ==========

  // 获取统计数据
  Future<WorkoutStatistics> getStatistics() async {
    try {
      final prefs = await _prefs;
      final statisticsJson = prefs.getString(_statisticsKey);
      
      if (statisticsJson == null) {
        return _createDefaultStatistics();
      }
      
      return WorkoutStatistics.fromJson(jsonDecode(statisticsJson));
    } catch (e) {
      debugPrint('获取统计数据失败: $e');
      return _createDefaultStatistics();
    }
  }

  // 创建默认统计数据
  WorkoutStatistics _createDefaultStatistics() {
    return WorkoutStatistics(
      userId: 'default_user',
      totalWorkouts: 0,
      totalDurationMinutes: 0,
      totalCaloriesBurned: 0.0,
      workoutTypeDistribution: {},
      consecutiveDays: 0,
      lastWorkoutDate: DateTime.now(),
      averageWorkoutDuration: 0.0,
      averageCaloriesPerWorkout: 0.0,
    );
  }

  // 更新统计数据
  Future<void> _updateStatistics() async {
    try {
      final sessions = await getWorkoutSessions();
      final currentStats = await getStatistics();
      
      // 计算统计数据
      final totalWorkouts = sessions.length;
      final totalDurationMinutes = sessions.fold(0, (sum, session) => sum + session.durationMinutes);
      final totalCaloriesBurned = sessions.fold(0.0, (sum, session) => sum + session.caloriesBurned);
      
      // 计算训练类型分布
      final workoutTypeDistribution = <WorkoutType, int>{};
      for (final session in sessions) {
        workoutTypeDistribution[session.workoutType] = 
            (workoutTypeDistribution[session.workoutType] ?? 0) + 1;
      }
      
      // 计算连续训练天数
      final consecutiveDays = _calculateConsecutiveDays(sessions);
      
      // 计算平均数据
      final averageWorkoutDuration = totalWorkouts > 0 ? totalDurationMinutes / totalWorkouts : 0.0;
      final averageCaloriesPerWorkout = totalWorkouts > 0 ? totalCaloriesBurned / totalWorkouts : 0.0;
      
      // 获取最后训练日期
      final lastWorkoutDate = sessions.isNotEmpty 
          ? sessions.map((s) => s.createdAt).reduce((a, b) => a.isAfter(b) ? a : b)
          : DateTime.now();
      
      final updatedStats = WorkoutStatistics(
        userId: currentStats.userId,
        totalWorkouts: totalWorkouts,
        totalDurationMinutes: totalDurationMinutes,
        totalCaloriesBurned: totalCaloriesBurned,
        workoutTypeDistribution: workoutTypeDistribution,
        consecutiveDays: consecutiveDays,
        lastWorkoutDate: lastWorkoutDate,
        averageWorkoutDuration: averageWorkoutDuration,
        averageCaloriesPerWorkout: averageCaloriesPerWorkout,
      );
      
      // 保存统计数据
      final prefs = await _prefs;
      await prefs.setString(_statisticsKey, jsonEncode(updatedStats.toJson()));
      
      // 检查成就
      await checkAndUnlockAchievements();
      
    } catch (e) {
      debugPrint('更新统计数据失败: $e');
    }
  }

  // 计算连续训练天数
  int _calculateConsecutiveDays(List<EnhancedFitnessWorkoutSession> sessions) {
    if (sessions.isEmpty) return 0;
    
    // 按日期排序
    final sortedSessions = List<EnhancedFitnessWorkoutSession>.from(sessions);
    sortedSessions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    int consecutiveDays = 0;
    DateTime currentDate = DateTime.now();
    
    for (final session in sortedSessions) {
      final sessionDate = DateTime(session.createdAt.year, session.createdAt.month, session.createdAt.day);
      final checkDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
      
      if (sessionDate.isAtSameMomentAs(checkDate) || 
          sessionDate.isAtSameMomentAs(checkDate.subtract(const Duration(days: 1)))) {
        consecutiveDays++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return consecutiveDays;
  }

  // ========== 工具方法 ==========

  // 清除所有数据
  Future<void> clearAllData() async {
    try {
      final prefs = await _prefs;
      await prefs.remove(_workoutSessionsKey);
      await prefs.remove(_strengthProfileKey);
      await prefs.remove(_userProfileKey);
      await prefs.remove(_weightRecordsKey);
      await prefs.remove(_trainingPlansKey);
      await prefs.remove(_achievementsKey);
      await prefs.remove(_statisticsKey);
    } catch (e) {
      debugPrint('清除数据失败: $e');
      rethrow;
    }
  }

  // 导出数据
  Future<Map<String, dynamic>> exportData() async {
    try {
      return {
        'workoutSessions': (await getWorkoutSessions()).map((s) => s.toJson()).toList(),
        'strengthProfile': (await getStrengthProfile())?.toJson(),
        'userProfile': (await getUserProfile())?.toJson(),
        'weightRecords': (await getWeightRecords()).map((r) => r.toJson()).toList(),
        'trainingPlans': (await getTrainingPlans()).map((p) => p.toJson()).toList(),
        'achievements': (await getAchievements()).map((a) => a.toJson()).toList(),
        'statistics': (await getStatistics()).toJson(),
        'exportDate': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('导出数据失败: $e');
      rethrow;
    }
  }

  // 导入数据
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      final prefs = await _prefs;
      
      if (data['workoutSessions'] != null) {
        await prefs.setString(_workoutSessionsKey, jsonEncode(data['workoutSessions']));
      }
      
      if (data['strengthProfile'] != null) {
        await prefs.setString(_strengthProfileKey, jsonEncode(data['strengthProfile']));
      }
      
      if (data['userProfile'] != null) {
        await prefs.setString(_userProfileKey, jsonEncode(data['userProfile']));
      }
      
      if (data['weightRecords'] != null) {
        await prefs.setString(_weightRecordsKey, jsonEncode(data['weightRecords']));
      }
      
      if (data['trainingPlans'] != null) {
        await prefs.setString(_trainingPlansKey, jsonEncode(data['trainingPlans']));
      }
      
      if (data['achievements'] != null) {
        await prefs.setString(_achievementsKey, jsonEncode(data['achievements']));
      }
      
      if (data['statistics'] != null) {
        await prefs.setString(_statisticsKey, jsonEncode(data['statistics']));
      }
      
    } catch (e) {
      debugPrint('导入数据失败: $e');
      rethrow;
    }
  }
}

// 扩展方法，用于复制对象
extension EnhancedFitnessStrengthProfileExtension on EnhancedFitnessStrengthProfile {
  EnhancedFitnessStrengthProfile copyWith({
    String? id,
    String? userId,
    double? squat1RM,
    double? benchPress1RM,
    double? deadlift1RM,
    double? totalWeight,
    double? currentWeight,
    double? strengthCoefficient,
    double? squatGoal,
    double? benchPressGoal,
    double? deadliftGoal,
    int? totalWorkouts,
    int? consecutiveDays,
    int? totalDurationMinutes,
    DateTime? lastUpdated,
  }) {
    return EnhancedFitnessStrengthProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      squat1RM: squat1RM ?? this.squat1RM,
      benchPress1RM: benchPress1RM ?? this.benchPress1RM,
      deadlift1RM: deadlift1RM ?? this.deadlift1RM,
      totalWeight: totalWeight ?? this.totalWeight,
      currentWeight: currentWeight ?? this.currentWeight,
      strengthCoefficient: strengthCoefficient ?? this.strengthCoefficient,
      squatGoal: squatGoal ?? this.squatGoal,
      benchPressGoal: benchPressGoal ?? this.benchPressGoal,
      deadliftGoal: deadliftGoal ?? this.deadliftGoal,
      totalWorkouts: totalWorkouts ?? this.totalWorkouts,
      consecutiveDays: consecutiveDays ?? this.consecutiveDays,
      totalDurationMinutes: totalDurationMinutes ?? this.totalDurationMinutes,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
