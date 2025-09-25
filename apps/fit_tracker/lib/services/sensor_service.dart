import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';

class SensorService {
  static final SensorService _instance = SensorService._internal();
  factory SensorService() => _instance;
  SensorService._internal();

  final Logger _logger = Logger();
  
  // 步数相关
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  int _stepCount = 0;
  DateTime _lastStepCountTime = DateTime.now();
  
  // 传感器数据
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  StreamSubscription<UserAccelerometerEvent>? _userAccelerometerSubscription;
  
  // 健康数据
  Health? _health;
  bool _isHealthDataAvailable = false;
  
  // 数据流控制器
  final StreamController<Map<String, dynamic>> _sensorDataController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get sensorDataStream => _sensorDataController.stream;
  
  // 当前数据
  Map<String, dynamic> _currentData = {
    'steps': 0,
    'distance': 0.0,
    'calories': 0.0,
    'heartRate': 0,
    'accelerometer': {'x': 0.0, 'y': 0.0, 'z': 0.0},
    'gyroscope': {'x': 0.0, 'y': 0.0, 'z': 0.0},
    'isWalking': false,
    'lastUpdate': DateTime.now(),
  };

  /// 初始化传感器服务
  Future<bool> initialize() async {
    try {
      _logger.i('初始化传感器服务...');
      
      // 请求权限
      await _requestPermissions();
      
      // 初始化健康数据
      await _initializeHealth();
      
      // 开始监听步数
      await _startStepCounting();
      
      // 开始监听传感器
      _startSensorListening();
      
      _logger.i('传感器服务初始化完成');
      return true;
    } catch (e) {
      _logger.e('传感器服务初始化失败: $e');
      return false;
    }
  }

  /// 请求必要权限
  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.activityRecognition,
      Permission.sensors,
      Permission.notification,
    ];
    
    for (final permission in permissions) {
      final status = await permission.request();
      _logger.i('权限 $permission: $status');
    }
    
    // 请求健康数据权限
    if (Platform.isIOS) {
      await Permission.activityRecognition.request();
    }
  }

  /// 初始化健康数据
  Future<void> _initializeHealth() async {
    try {
      _health = Health();
      
      // 检查健康数据是否可用
      _isHealthDataAvailable = true; // 暂时设为true
      
      if (_isHealthDataAvailable) {
        _logger.i('健康数据可用');
        
        // 请求健康数据权限
        final types = [
          HealthDataType.STEPS,
          HealthDataType.DISTANCE_DELTA,
          HealthDataType.ACTIVE_ENERGY_BURNED,
          HealthDataType.HEART_RATE,
          HealthDataType.WORKOUT,
        ];
        
        final permissions = [
          HealthDataAccess.READ,
          HealthDataAccess.READ,
          HealthDataAccess.READ,
          HealthDataAccess.READ,
          HealthDataAccess.READ,
        ];
        
        final granted = await _health!.requestAuthorization(types, permissions: permissions);
        _logger.i('健康数据权限: $granted');
      } else {
        _logger.w('健康数据不可用');
      }
    } catch (e) {
      _logger.e('初始化健康数据失败: $e');
    }
  }

  /// 开始步数统计
  Future<void> _startStepCounting() async {
    try {
      // 监听步数变化
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          _stepCount = event.steps;
          _lastStepCountTime = event.timeStamp;
          _updateSensorData();
        },
        onError: (error) {
          _logger.e('步数监听错误: $error');
        },
      );

      // 监听步行状态
      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus event) {
          _currentData['isWalking'] = event.status == 'walking';
          _updateSensorData();
        },
        onError: (error) {
          _logger.e('步行状态监听错误: $error');
        },
      );

      _logger.i('步数统计已启动');
    } catch (e) {
      _logger.e('启动步数统计失败: $e');
    }
  }

  /// 开始传感器监听
  void _startSensorListening() {
    // 加速度计
    _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
      _currentData['accelerometer'] = {
        'x': event.x,
        'y': event.y,
        'z': event.z,
      };
      _updateSensorData();
    });

    // 陀螺仪
    _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      _currentData['gyroscope'] = {
        'x': event.x,
        'y': event.y,
        'z': event.z,
      };
      _updateSensorData();
    });

    // 用户加速度计
    _userAccelerometerSubscription = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      // 可以用于检测用户活动
      _updateSensorData();
    });

    _logger.i('传感器监听已启动');
  }

  /// 更新传感器数据
  void _updateSensorData() {
    _currentData['steps'] = _stepCount;
    _currentData['distance'] = _calculateDistance(_stepCount);
    _currentData['calories'] = _calculateCalories(_stepCount);
    _currentData['lastUpdate'] = DateTime.now();
    
    _sensorDataController.add(Map.from(_currentData));
  }

  /// 计算距离（米）
  double _calculateDistance(int steps) {
    // 假设平均步长为0.7米
    return steps * 0.7;
  }

  /// 计算卡路里
  double _calculateCalories(int steps) {
    // 假设每1000步消耗50卡路里
    return (steps / 1000) * 50;
  }

  /// 获取健康数据
  Future<Map<String, dynamic>> getHealthData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (!_isHealthDataAvailable || _health == null) {
      return {};
    }

    try {
      final now = DateTime.now();
      final start = startDate ?? DateTime(now.year, now.month, now.day);
      final end = endDate ?? now;

      final types = [
        HealthDataType.STEPS,
        HealthDataType.DISTANCE_DELTA,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.HEART_RATE,
      ];

      final healthData = await _health!.getHealthDataFromTypes(
        types: types,
        startTime: start,
        endTime: end,
      );

      final result = <String, dynamic>{};
      
      for (final data in healthData) {
        switch (data.type) {
          case HealthDataType.STEPS:
            result['steps'] = data.value;
            break;
          case HealthDataType.DISTANCE_DELTA:
            result['distance'] = data.value;
            break;
          case HealthDataType.ACTIVE_ENERGY_BURNED:
            result['calories'] = data.value;
            break;
          case HealthDataType.HEART_RATE:
            result['heartRate'] = data.value;
            break;
          default:
            break;
        }
      }

      return result;
    } catch (e) {
      _logger.e('获取健康数据失败: $e');
      return {};
    }
  }

  /// 获取当前传感器数据
  Map<String, dynamic> getCurrentData() {
    return Map.from(_currentData);
  }

  /// 获取步数
  int get stepCount => _stepCount;

  /// 获取距离
  double get distance => _calculateDistance(_stepCount);

  /// 获取卡路里
  double get calories => _calculateCalories(_stepCount);

  /// 是否正在步行
  bool get isWalking => _currentData['isWalking'] ?? false;

  /// 停止服务
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _userAccelerometerSubscription?.cancel();
    _sensorDataController.close();
  }
}
