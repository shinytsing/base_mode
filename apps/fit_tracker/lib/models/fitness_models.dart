// FitMatrix 数据模型
import 'package:json_annotation/json_annotation.dart';

part 'fitness_models.g.dart';

// 训练类型枚举
enum WorkoutType {
  @JsonValue('strength')
  strength, // 力量训练
  @JsonValue('cardio')
  cardio, // 有氧运动
  @JsonValue('flexibility')
  flexibility, // 柔韧性训练
  @JsonValue('balance')
  balance, // 平衡训练
  @JsonValue('mixed')
  mixed, // 混合训练
}

// 强度等级枚举
enum IntensityLevel {
  @JsonValue('light')
  light, // 轻度
  @JsonValue('moderate')
  moderate, // 中度
  @JsonValue('high')
  high, // 高强度
  @JsonValue('extreme')
  extreme, // 极限
}

// 健身目标枚举
enum FitnessGoal {
  @JsonValue('weight_loss')
  weightLoss, // 减脂
  @JsonValue('muscle_gain')
  muscleGain, // 增肌
  @JsonValue('maintenance')
  maintenance, // 维持体重
}

// 目标强度枚举
enum GoalIntensity {
  @JsonValue('conservative')
  conservative, // 保守型
  @JsonValue('balanced')
  balanced, // 均衡型
  @JsonValue('aggressive')
  aggressive, // 激进型
}

// 活动水平枚举
enum ActivityLevel {
  @JsonValue('sedentary')
  sedentary, // 久坐
  @JsonValue('light')
  light, // 轻度活动
  @JsonValue('moderate')
  moderate, // 中度活动
  @JsonValue('active')
  active, // 重度活动
}

// 训练模式枚举
enum TrainingMode {
  @JsonValue('five_split')
  fiveSplit, // 五分化训练
  @JsonValue('three_split')
  threeSplit, // 三分化训练
  @JsonValue('push_pull_legs')
  pushPullLegs, // 推拉腿训练
  @JsonValue('cardio')
  cardio, // 有氧训练
  @JsonValue('functional')
  functional, // 功能性训练
}

// 运动动作模型
@JsonSerializable()
class Exercise {
  final String id;
  final String name;
  final String description;
  final String category; // 动作分类
  final String muscleGroup; // 主要肌群
  final List<String> equipment; // 所需器械
  final String difficulty; // 难度等级
  final String instructions; // 动作说明
  final List<String> tips; // 训练要点
  final String? imageUrl; // 动作图片
  final String? videoUrl; // 动作视频

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.muscleGroup,
    required this.equipment,
    required this.difficulty,
    required this.instructions,
    required this.tips,
    this.imageUrl,
    this.videoUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}

// 器械设备模型
@JsonSerializable()
class Equipment {
  final String id;
  final String name;
  final String description;
  final String category; // 器械分类
  final String? imageUrl; // 器械图片
  final bool isAvailable; // 是否可用

  Equipment({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.imageUrl,
    this.isAvailable = true,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) => _$EquipmentFromJson(json);
  Map<String, dynamic> toJson() => _$EquipmentToJson(this);
}

// 训练动作记录模型
@JsonSerializable()
class ExerciseRecord {
  final String exerciseId;
  final String exerciseName;
  final List<SetRecord> sets; // 组数记录
  final String? notes; // 训练笔记
  final DateTime timestamp; // 记录时间

  ExerciseRecord({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    this.notes,
    required this.timestamp,
  });

  factory ExerciseRecord.fromJson(Map<String, dynamic> json) => _$ExerciseRecordFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseRecordToJson(this);
}

// 组数记录模型
@JsonSerializable()
class SetRecord {
  final int setNumber; // 组数
  final double? weight; // 重量
  final int reps; // 次数
  final Duration? restTime; // 休息时间
  final String? notes; // 组数备注

  SetRecord({
    required this.setNumber,
    this.weight,
    required this.reps,
    this.restTime,
    this.notes,
  });

  factory SetRecord.fromJson(Map<String, dynamic> json) => _$SetRecordFromJson(json);
  Map<String, dynamic> toJson() => _$SetRecordToJson(this);
}

// 增强版健身训练会话模型
@JsonSerializable()
class EnhancedFitnessWorkoutSession {
  final String id;
  final String userId;
  final WorkoutType workoutType;
  final IntensityLevel intensityLevel;
  final int durationMinutes; // 训练时长（分钟）
  final double caloriesBurned; // 卡路里消耗
  final int? averageHeartRate; // 平均心率
  final int? maxHeartRate; // 最大心率
  final List<ExerciseRecord> exercises; // 训练动作列表
  final String? workoutNotes; // 训练笔记
  final String? audioRecordingUrl; // 音频录音URL
  final DateTime createdAt; // 创建时间
  final DateTime? completedAt; // 完成时间
  final String? trainingPlanId; // 关联的训练计划ID

  EnhancedFitnessWorkoutSession({
    required this.id,
    required this.userId,
    required this.workoutType,
    required this.intensityLevel,
    required this.durationMinutes,
    required this.caloriesBurned,
    this.averageHeartRate,
    this.maxHeartRate,
    required this.exercises,
    this.workoutNotes,
    this.audioRecordingUrl,
    required this.createdAt,
    this.completedAt,
    this.trainingPlanId,
  });

  factory EnhancedFitnessWorkoutSession.fromJson(Map<String, dynamic> json) => 
      _$EnhancedFitnessWorkoutSessionFromJson(json);
  Map<String, dynamic> toJson() => _$EnhancedFitnessWorkoutSessionToJson(this);
}

// 增强版健身力量档案模型
@JsonSerializable()
class EnhancedFitnessStrengthProfile {
  final String id;
  final String userId;
  final double? squat1RM; // 深蹲1RM
  final double? benchPress1RM; // 卧推1RM
  final double? deadlift1RM; // 硬拉1RM
  final double totalWeight; // 总重量
  final double currentWeight; // 当前体重
  final double strengthCoefficient; // 力量系数（总重量/体重）
  final double? squatGoal; // 深蹲目标
  final double? benchPressGoal; // 卧推目标
  final double? deadliftGoal; // 硬拉目标
  final int totalWorkouts; // 总训练次数
  final int consecutiveDays; // 连续训练天数
  final int totalDurationMinutes; // 总训练时长（分钟）
  final DateTime lastUpdated; // 最后更新时间

  EnhancedFitnessStrengthProfile({
    required this.id,
    required this.userId,
    this.squat1RM,
    this.benchPress1RM,
    this.deadlift1RM,
    required this.totalWeight,
    required this.currentWeight,
    required this.strengthCoefficient,
    this.squatGoal,
    this.benchPressGoal,
    this.deadliftGoal,
    required this.totalWorkouts,
    required this.consecutiveDays,
    required this.totalDurationMinutes,
    required this.lastUpdated,
  });

  factory EnhancedFitnessStrengthProfile.fromJson(Map<String, dynamic> json) => 
      _$EnhancedFitnessStrengthProfileFromJson(json);
  Map<String, dynamic> toJson() => _$EnhancedFitnessStrengthProfileToJson(this);
}

// 增强版健身用户档案模型
@JsonSerializable()
class EnhancedFitnessUserProfile {
  final String id;
  final String userId;
  final int age; // 年龄
  final String gender; // 性别
  final double height; // 身高（cm）
  final double weight; // 体重（kg）
  final double? bodyFatPercentage; // 体脂率
  final double bmr; // 基础代谢率
  final FitnessGoal fitnessGoal; // 健身目标
  final GoalIntensity goalIntensity; // 目标强度
  final ActivityLevel activityLevel; // 活动水平
  final List<String> dietaryPreferences; // 饮食偏好
  final List<String> foodAllergies; // 过敏食物
  final int weeklyTrainingDays; // 每周训练天数
  final int preferredWorkoutDuration; // 偏好训练时长（分钟）
  final TrainingMode preferredTrainingMode; // 偏好训练模式
  final DateTime createdAt; // 创建时间
  final DateTime lastUpdated; // 最后更新时间

  EnhancedFitnessUserProfile({
    required this.id,
    required this.userId,
    required this.age,
    required this.gender,
    required this.height,
    required this.weight,
    this.bodyFatPercentage,
    required this.bmr,
    required this.fitnessGoal,
    required this.goalIntensity,
    required this.activityLevel,
    required this.dietaryPreferences,
    required this.foodAllergies,
    required this.weeklyTrainingDays,
    required this.preferredWorkoutDuration,
    required this.preferredTrainingMode,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory EnhancedFitnessUserProfile.fromJson(Map<String, dynamic> json) => 
      _$EnhancedFitnessUserProfileFromJson(json);
  Map<String, dynamic> toJson() => _$EnhancedFitnessUserProfileToJson(this);
}

// 增强版运动重量记录模型
@JsonSerializable()
class EnhancedExerciseWeightRecord {
  final String id;
  final String userId;
  final String exerciseId;
  final String exerciseName;
  final double weight; // 重量
  final int reps; // 次数
  final String weightLevel; // 重量等级（新手/中级/高级/专家级）
  final DateTime recordedAt; // 记录时间
  final String? notes; // 备注

  EnhancedExerciseWeightRecord({
    required this.id,
    required this.userId,
    required this.exerciseId,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.weightLevel,
    required this.recordedAt,
    this.notes,
  });

  factory EnhancedExerciseWeightRecord.fromJson(Map<String, dynamic> json) => 
      _$EnhancedExerciseWeightRecordFromJson(json);
  Map<String, dynamic> toJson() => _$EnhancedExerciseWeightRecordToJson(this);
}

// 训练计划模型
@JsonSerializable()
class TrainingPlan {
  final String id;
  final String userId;
  final String name; // 计划名称
  final String description; // 计划描述
  final TrainingMode mode; // 训练模式
  final int durationWeeks; // 计划周期（周）
  final List<WorkoutDay> workoutDays; // 训练日安排
  final DateTime createdAt; // 创建时间
  final DateTime? startDate; // 开始日期
  final DateTime? endDate; // 结束日期
  final bool isActive; // 是否激活
  final bool isTemplate; // 是否为模板

  TrainingPlan({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.mode,
    required this.durationWeeks,
    required this.workoutDays,
    required this.createdAt,
    this.startDate,
    this.endDate,
    this.isActive = false,
    this.isTemplate = false,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) => _$TrainingPlanFromJson(json);
  Map<String, dynamic> toJson() => _$TrainingPlanToJson(this);
}

// 训练日模型
@JsonSerializable()
class WorkoutDay {
  final String id;
  final String name; // 训练日名称
  final String description; // 训练日描述
  final List<WorkoutPhase> phases; // 训练阶段
  final int estimatedDuration; // 预计时长（分钟）
  final String? notes; // 训练日备注

  WorkoutDay({
    required this.id,
    required this.name,
    required this.description,
    required this.phases,
    required this.estimatedDuration,
    this.notes,
  });

  factory WorkoutDay.fromJson(Map<String, dynamic> json) => _$WorkoutDayFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutDayToJson(this);
}

// 训练阶段模型
@JsonSerializable()
class WorkoutPhase {
  final String id;
  final String name; // 阶段名称
  final String type; // 阶段类型（热身/主训练/辅助/冷却）
  final List<WorkoutExercise> exercises; // 阶段动作
  final int estimatedDuration; // 预计时长（分钟）
  final String? notes; // 阶段备注

  WorkoutPhase({
    required this.id,
    required this.name,
    required this.type,
    required this.exercises,
    required this.estimatedDuration,
    this.notes,
  });

  factory WorkoutPhase.fromJson(Map<String, dynamic> json) => _$WorkoutPhaseFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutPhaseToJson(this);
}

// 训练动作模型
@JsonSerializable()
class WorkoutExercise {
  final String exerciseId;
  final String exerciseName;
  final int sets; // 组数
  final int reps; // 次数
  final double? weight; // 重量
  final Duration? restTime; // 休息时间
  final String? notes; // 动作备注

  WorkoutExercise({
    required this.exerciseId,
    required this.exerciseName,
    required this.sets,
    required this.reps,
    this.weight,
    this.restTime,
    this.notes,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) => _$WorkoutExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutExerciseToJson(this);
}

// 成就模型
@JsonSerializable()
class Achievement {
  final String id;
  final String name; // 成就名称
  final String description; // 成就描述
  final String category; // 成就分类
  final String icon; // 成就图标
  final Map<String, dynamic> requirements; // 达成条件
  final DateTime? unlockedAt; // 解锁时间
  final bool isUnlocked; // 是否已解锁

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.icon,
    required this.requirements,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) => _$AchievementFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementToJson(this);
}

// 训练统计模型
@JsonSerializable()
class WorkoutStatistics {
  final String userId;
  final int totalWorkouts; // 总训练次数
  final int totalDurationMinutes; // 总训练时长（分钟）
  final double totalCaloriesBurned; // 总卡路里消耗
  final Map<WorkoutType, int> workoutTypeDistribution; // 训练类型分布
  final int consecutiveDays; // 连续训练天数
  final DateTime lastWorkoutDate; // 最后训练日期
  final double averageWorkoutDuration; // 平均训练时长
  final double averageCaloriesPerWorkout; // 平均每次训练卡路里消耗

  WorkoutStatistics({
    required this.userId,
    required this.totalWorkouts,
    required this.totalDurationMinutes,
    required this.totalCaloriesBurned,
    required this.workoutTypeDistribution,
    required this.consecutiveDays,
    required this.lastWorkoutDate,
    required this.averageWorkoutDuration,
    required this.averageCaloriesPerWorkout,
  });

  factory WorkoutStatistics.fromJson(Map<String, dynamic> json) => 
      _$WorkoutStatisticsFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutStatisticsToJson(this);
}
