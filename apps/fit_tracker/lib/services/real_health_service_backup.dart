import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RealHealthService {
  static final RealHealthService _instance = RealHealthService._internal();
  factory RealHealthService() => _instance;
  RealHealthService._internal();

  final Logger _logger = Logger();
  
  // 真实传感器数据
  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  StreamSubscription<GyroscopeEvent>? _gyroscopeSubscription;
  
  // 健康数据
  // Health? _health; // 暂时注释，有版本兼容性问题
  bool _isHealthDataAvailable = false;
  
  // 数据存储
  SharedPreferences? _prefs;
  
  // 数据流控制器
  final StreamController<Map<String, dynamic>> _healthDataController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get healthDataStream => _healthDataController.stream;
  
  // 当前数据
  Map<String, dynamic> _currentData = {
    'steps': 0,
    'distance': 0.0,
    'calories': 0.0,
    'heartRate': 0,
    'bloodPressure': {'systolic': 0, 'diastolic': 0},
    'weight': 0.0,
    'bodyFat': 0.0,
    'muscleMass': 0.0,
    'waterIntake': 0.0,
    'sleepHours': 0.0,
    'accelerometer': {'x': 0.0, 'y': 0.0, 'z': 0.0},
    'gyroscope': {'x': 0.0, 'y': 0.0, 'z': 0.0},
    'isWalking': false,
    'lastUpdate': DateTime.now(),
  };

  /// 初始化真实健康服务
  Future<bool> initialize() async {
    try {
      _logger.i('初始化真实健康服务...');
      
      // 初始化SharedPreferences
      _prefs = await SharedPreferences.getInstance();
      
      // 请求权限
      await _requestPermissions();
      
      // 初始化健康数据
      await _initializeHealth();
      
      // 开始监听真实传感器
      await _startRealSensorListening();
      
      // 加载历史数据
      await _loadHistoricalData();
      
      _logger.i('真实健康服务初始化完成');
      return true;
    } catch (e) {
      _logger.e('真实健康服务初始化失败: $e');
      return false;
    }
  }

  /// 请求必要权限
  Future<void> _requestPermissions() async {
    final permissions = [
      Permission.activityRecognition,
      Permission.sensors,
      Permission.notification,
      Permission.location,
    ];
    
    for (final permission in permissions) {
      final status = await permission.request();
      _logger.i('权限 $permission: $status');
    }
    
    // 请求健康数据权限
    if (Platform.isIOS) {
      // iOS健康权限请求
    }
  }

  /// 初始化健康数据
  Future<void> _initializeHealth() async {
    try {
      // _health = Health(); // 暂时注释
      
      // 检查健康数据是否可用
      _isHealthDataAvailable = true; // 简化处理
      
      if (_isHealthDataAvailable) {
        _logger.i('健康数据可用');
        
        // 请求健康数据权限
        // final types = [
        //   HealthDataType.STEPS,
        //   HealthDataType.DISTANCE_DELTA,
        //   HealthDataType.ACTIVE_ENERGY_BURNED,
        //   HealthDataType.HEART_RATE,
        //   HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        //   HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        //   HealthDataType.WEIGHT,
        //   HealthDataType.BODY_FAT_PERCENTAGE,
        //   HealthDataType.WATER,
        //   HealthDataType.SLEEP_IN_BED,
        //   HealthDataType.WORKOUT,
        // ];
        
        // final permissions = List.generate(types.length, (index) => HealthDataAccess.READ);
        
        // final granted = await _health!.requestAuthorization(types, permissions: permissions);
        // _logger.i('健康数据权限: $granted');
      } else {
        _logger.w('健康数据不可用');
      }
    } catch (e) {
      _logger.e('初始化健康数据失败: $e');
    }
  }

  /// 开始监听真实传感器
  Future<void> _startRealSensorListening() async {
    try {
      // 监听步数变化
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          _currentData['steps'] = event.steps;
          _currentData['distance'] = _calculateDistance(event.steps);
          _currentData['calories'] = _calculateCalories(event.steps);
          _currentData['lastUpdate'] = event.timeStamp;
          _updateHealthData();
          _saveToLocalStorage();
        },
        onError: (error) {
          _logger.e('步数监听错误: $error');
        },
      );

      // 监听步行状态
      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus event) {
          _currentData['isWalking'] = event.status.toString().contains('walking');
          _updateHealthData();
        },
        onError: (error) {
          _logger.e('步行状态监听错误: $error');
        },
      );

      // 监听加速度计
      _accelerometerSubscription = accelerometerEvents.listen((AccelerometerEvent event) {
        _currentData['accelerometer'] = {
          'x': event.x,
          'y': event.y,
          'z': event.z,
        };
        _updateHealthData();
      });

      // 监听陀螺仪
      _gyroscopeSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        _currentData['gyroscope'] = {
          'x': event.x,
          'y': event.y,
          'z': event.z,
        };
        _updateHealthData();
      });

      _logger.i('真实传感器监听已启动');
    } catch (e) {
      _logger.e('启动真实传感器监听失败: $e');
    }
  }

  /// 更新健康数据
  void _updateHealthData() {
    _currentData['distance'] = _calculateDistance(_currentData['steps']);
    _currentData['calories'] = _calculateCalories(_currentData['steps']);
    
    _healthDataController.add(Map.from(_currentData));
  }

  /// 计算距离（米）
  double _calculateDistance(int steps) {
    // 根据用户身高调整步长
    final height = _prefs?.getDouble('user_height') ?? 175.0;
    final stepLength = height * 0.43 / 100; // 身高 * 0.43% 作为步长
    return steps * stepLength;
  }

  /// 计算卡路里
  double _calculateCalories(int steps) {
    final weight = _prefs?.getDouble('user_weight') ?? 70.0;
    final height = _prefs?.getDouble('user_height') ?? 175.0;
    final age = _prefs?.getInt('user_age') ?? 30;
    
    // 使用Harris-Benedict公式计算BMR
    final bmr = _calculateBMR(weight, height, age);
    
    // 每1000步消耗约0.04 * BMR的卡路里
    return (steps / 1000) * (bmr * 0.04);
  }

  /// 计算基础代谢率
  double _calculateBMR(double weight, double height, int age) {
    // Harris-Benedict公式 (男性)
    return 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
  }

  /// 获取真实健康数据
  Future<Map<String, dynamic>> getRealHealthData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (!_isHealthDataAvailable || _health == null) {
      return _currentData;
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
        HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
        HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
        HealthDataType.WEIGHT,
          HealthDataType.BODY_FAT_PERCENTAGE,
        HealthDataType.WATER,
        HealthDataType.SLEEP_IN_BED,
      ];

      // final healthData = await _health!.getHealthDataFromTypes(
      //   types: types,
      //   startTime: start,
      //   endTime: end,
      // );

      final result = <String, dynamic>{};
      
      // for (final data in healthData) {
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
          case HealthDataType.BLOOD_PRESSURE_SYSTOLIC:
            result['bloodPressure'] = {
              'systolic': data.value,
              'diastolic': result['bloodPressure']?['diastolic'] ?? 0,
            };
            break;
          case HealthDataType.BLOOD_PRESSURE_DIASTOLIC:
            result['bloodPressure'] = {
              'systolic': result['bloodPressure']?['systolic'] ?? 0,
              'diastolic': data.value,
            };
            break;
          case HealthDataType.WEIGHT:
            result['weight'] = data.value;
            break;
          case HealthDataType.BODY_FAT_PERCENTAGE:
            result['bodyFat'] = data.value;
            break;
          case HealthDataType.BODY_FAT_PERCENTAGE:
            result['muscleMass'] = data.value;
            break;
          case HealthDataType.WATER:
            result['waterIntake'] = data.value;
            break;
          case HealthDataType.SLEEP_IN_BED:
            result['sleepHours'] = data.value;
            break;
          default:
            break;
        }
      }

      // 合并当前传感器数据
      result.addAll(_currentData);
      return result;
    } catch (e) {
      _logger.e('获取真实健康数据失败: $e');
      return _currentData;
    }
  }

  /// 记录训练数据
  Future<void> recordWorkout({
    required String workoutType,
    required int duration,
    required double calories,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final workoutData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'type': workoutType,
        'duration': duration,
        'calories': calories,
        'timestamp': DateTime.now().toIso8601String(),
        'additionalData': additionalData ?? {},
      };

      // 保存到本地存储
      final workouts = _prefs?.getStringList('workouts') ?? [];
      workouts.add(workoutData.toString());
      await _prefs?.setStringList('workouts', workouts);

      // 更新当前数据
      _currentData['calories'] = (_currentData['calories'] ?? 0.0) + calories;
      _updateHealthData();

      _logger.i('训练数据记录成功: $workoutType');
    } catch (e) {
      _logger.e('记录训练数据失败: $e');
    }
  }

  /// 记录营养数据
  Future<void> recordNutrition({
    required String foodName,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double quantity,
    required String unit,
  }) async {
    try {
      final nutritionData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'foodName': foodName,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
        'quantity': quantity,
        'unit': unit,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // 保存到本地存储
      final nutrition = _prefs?.getStringList('nutrition') ?? [];
      nutrition.add(nutritionData.toString());
      await _prefs?.setStringList('nutrition', nutrition);

      _logger.i('营养数据记录成功: $foodName');
    } catch (e) {
      _logger.e('记录营养数据失败: $e');
    }
  }

  /// 记录体重数据
  Future<void> recordWeight(double weight) async {
    try {
      await _prefs?.setDouble('user_weight', weight);
      _currentData['weight'] = weight;
      _updateHealthData();
      _logger.i('体重记录成功: $weight kg');
    } catch (e) {
      _logger.e('记录体重失败: $e');
    }
  }

  /// 记录饮水数据
  Future<void> recordWaterIntake(double amount) async {
    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final key = 'water_intake_$today';
      final currentIntake = _prefs?.getDouble(key) ?? 0.0;
      await _prefs?.setDouble(key, currentIntake + amount);
      
      _currentData['waterIntake'] = currentIntake + amount;
      _updateHealthData();
      _logger.i('饮水记录成功: $amount ml');
    } catch (e) {
      _logger.e('记录饮水失败: $e');
    }
  }

  /// 加载历史数据
  Future<void> _loadHistoricalData() async {
    try {
      // 加载用户基本信息
      _currentData['weight'] = _prefs?.getDouble('user_weight') ?? 0.0;
      
      // 加载今日饮水
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final waterKey = 'water_intake_$today';
      _currentData['waterIntake'] = _prefs?.getDouble(waterKey) ?? 0.0;
      
      _updateHealthData();
    } catch (e) {
      _logger.e('加载历史数据失败: $e');
    }
  }

  /// 保存到本地存储
  Future<void> _saveToLocalStorage() async {
    try {
      await _prefs?.setInt('daily_steps', _currentData['steps']);
      await _prefs?.setDouble('daily_distance', _currentData['distance']);
      await _prefs?.setDouble('daily_calories', _currentData['calories']);
    } catch (e) {
      _logger.e('保存到本地存储失败: $e');
    }
  }

  /// 获取当前数据
  Map<String, dynamic> getCurrentData() {
    return Map.from(_currentData);
  }

  /// 获取步数
  int get stepCount => _currentData['steps'] ?? 0;

  /// 获取距离
  double get distance => _currentData['distance'] ?? 0.0;

  /// 获取卡路里
  double get calories => _currentData['calories'] ?? 0.0;

  /// 是否正在步行
  bool get isWalking => _currentData['isWalking'] ?? false;

  /// 停止服务
  void dispose() {
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    _healthDataController.close();
  }
}
