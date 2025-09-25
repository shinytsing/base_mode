import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'sensor_service.dart';
import 'notification_service.dart';

class BackgroundService {
  static final BackgroundService _instance = BackgroundService._internal();
  factory BackgroundService() => _instance;
  BackgroundService._internal();

  final Logger _logger = Logger();
  final SensorService _sensorService = SensorService();
  final NotificationService _notificationService = NotificationService();

  static const String _taskName = 'fitmatrix_background_task';
  static const String _stepTrackingTask = 'step_tracking_task';
  static const String _healthMonitoringTask = 'health_monitoring_task';

  /// 初始化后台服务
  Future<bool> initialize() async {
    try {
      _logger.i('初始化后台服务...');
      
      // 初始化WorkManager
      await Workmanager().initialize(
        callbackDispatcher,
        isInDebugMode: kDebugMode,
      );
      
      // 注册后台任务
      await _registerBackgroundTasks();
      
      _logger.i('后台服务初始化完成');
      return true;
    } catch (e) {
      _logger.e('后台服务初始化失败: $e');
      return false;
    }
  }

  /// 注册后台任务
  Future<void> _registerBackgroundTasks() async {
    // 步数追踪任务（每15分钟执行一次）
    await Workmanager().registerPeriodicTask(
      _stepTrackingTask,
      _stepTrackingTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    // 健康监控任务（每小时执行一次）
    await Workmanager().registerPeriodicTask(
      _healthMonitoringTask,
      _healthMonitoringTask,
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresDeviceIdle: false,
        requiresStorageNotLow: false,
      ),
    );

    _logger.i('后台任务注册完成');
  }

  /// 启动步数追踪
  Future<void> startStepTracking() async {
    try {
      await Workmanager().registerOneOffTask(
        'start_step_tracking',
        _stepTrackingTask,
        initialDelay: const Duration(seconds: 10),
      );
      _logger.i('步数追踪已启动');
    } catch (e) {
      _logger.e('启动步数追踪失败: $e');
    }
  }

  /// 停止步数追踪
  Future<void> stopStepTracking() async {
    try {
      await Workmanager().cancelByUniqueName(_stepTrackingTask);
      _logger.i('步数追踪已停止');
    } catch (e) {
      _logger.e('停止步数追踪失败: $e');
    }
  }

  /// 启动健康监控
  Future<void> startHealthMonitoring() async {
    try {
      await Workmanager().registerOneOffTask(
        'start_health_monitoring',
        _healthMonitoringTask,
        initialDelay: const Duration(seconds: 30),
      );
      _logger.i('健康监控已启动');
    } catch (e) {
      _logger.e('启动健康监控失败: $e');
    }
  }

  /// 停止健康监控
  Future<void> stopHealthMonitoring() async {
    try {
      await Workmanager().cancelByUniqueName(_healthMonitoringTask);
      _logger.i('健康监控已停止');
    } catch (e) {
      _logger.e('停止健康监控失败: $e');
    }
  }

  /// 停止所有后台任务
  Future<void> stopAllTasks() async {
    try {
      await Workmanager().cancelAll();
      _logger.i('所有后台任务已停止');
    } catch (e) {
      _logger.e('停止后台任务失败: $e');
    }
  }
}

/// 后台任务回调函数（必须在顶级作用域）
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final logger = Logger();
    
    try {
      logger.i('执行后台任务: $task');
      
      switch (task) {
        case 'step_tracking_task':
          await _handleStepTrackingTask();
          break;
        case 'health_monitoring_task':
          await _handleHealthMonitoringTask();
          break;
        default:
          logger.w('未知的后台任务: $task');
      }
      
      return Future.value(true);
    } catch (e) {
      logger.e('后台任务执行失败: $e');
      return Future.value(false);
    }
  });
}

/// 处理步数追踪任务
Future<void> _handleStepTrackingTask() async {
  final logger = Logger();
  final prefs = await SharedPreferences.getInstance();
  
  try {
    logger.i('执行步数追踪任务');
    
    // 获取当前步数（这里需要根据实际传感器API调整）
    final currentSteps = 0; // 实际应该从传感器获取
    final lastSteps = prefs.getInt('last_steps') ?? 0;
    final stepIncrease = currentSteps - lastSteps;
    
    // 保存当前步数
    await prefs.setInt('last_steps', currentSteps);
    await prefs.setInt('daily_steps', (prefs.getInt('daily_steps') ?? 0) + stepIncrease);
    
    // 检查步数目标
    final dailySteps = prefs.getInt('daily_steps') ?? 0;
    final stepGoal = prefs.getInt('step_goal') ?? 10000;
    
    if (dailySteps >= stepGoal) {
      // 发送目标达成通知
      await _sendGoalAchievedNotification('步数', '$dailySteps步');
    } else if (dailySteps % 2000 == 0 && dailySteps > 0) {
      // 每2000步发送一次提醒
      await _sendStepReminder(dailySteps, stepGoal);
    }
    
    logger.i('步数追踪任务完成: $dailySteps步');
  } catch (e) {
    logger.e('步数追踪任务失败: $e');
  }
}

/// 处理健康监控任务
Future<void> _handleHealthMonitoringTask() async {
  final logger = Logger();
  final prefs = await SharedPreferences.getInstance();
  
  try {
    logger.i('执行健康监控任务');
    
    final now = DateTime.now();
    final lastActivityTime = prefs.getString('last_activity_time');
    
    // 检查久坐状态
    if (lastActivityTime != null) {
      final lastTime = DateTime.parse(lastActivityTime);
      final sedentaryDuration = now.difference(lastTime);
      
      if (sedentaryDuration.inHours >= 1) {
        // 发送久坐提醒
        await _sendSedentaryReminder();
      }
    }
    
    // 检查饮水提醒
    final lastHydrationTime = prefs.getString('last_hydration_time');
    if (lastHydrationTime != null) {
      final lastTime = DateTime.parse(lastHydrationTime);
      final hydrationDuration = now.difference(lastTime);
      
      if (hydrationDuration.inHours >= 2) {
        // 发送饮水提醒
        await _sendHydrationReminder();
      }
    }
    
    // 检查睡眠提醒
    final hour = now.hour;
    if (hour >= 22 || hour <= 6) {
      // 发送睡眠提醒
      await _sendSleepReminder();
    }
    
    logger.i('健康监控任务完成');
  } catch (e) {
    logger.e('健康监控任务失败: $e');
  }
}

/// 发送目标达成通知
Future<void> _sendGoalAchievedNotification(String goalType, String goalValue) async {
  // 这里需要实现通知发送逻辑
  // 由于在后台任务中，可能需要使用不同的通知方式
  print('目标达成通知: $goalType - $goalValue');
}

/// 发送步数提醒
Future<void> _sendStepReminder(int currentSteps, int targetSteps) async {
  final remaining = targetSteps - currentSteps;
  print('步数提醒: 还需要 $remaining 步');
}

/// 发送久坐提醒
Future<void> _sendSedentaryReminder() async {
  print('久坐提醒: 您已经久坐1小时了');
}

/// 发送饮水提醒
Future<void> _sendHydrationReminder() async {
  print('饮水提醒: 记得多喝水');
}

/// 发送睡眠提醒
Future<void> _sendSleepReminder() async {
  print('睡眠提醒: 该睡觉了');
}
