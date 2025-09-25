import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';
// import 'package:health/health.dart'; // 暂时移除，有版本兼容性问题
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
  final StreamController<Map<String, dynamic>> _dataController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get dataStream => _dataController.stream;
  
  // 当前数据
  Map<String, dynamic> _currentData = {};
  
  /// 初始化服务
  Future<void> initialize() async {
    try {
      _logger.i('初始化真实健康服务...');
      
      // 初始化存储
      _prefs = await SharedPreferences.getInstance();
      
      // 初始化传感器
      await _initializeSensors();
      
      // 初始化健康数据
      await _initializeHealth();
      
      _logger.i('真实健康服务初始化完成');
    } catch (e) {
      _logger.e('初始化真实健康服务失败: $e');
    }
  }

  /// 初始化传感器
  Future<void> _initializeSensors() async {
    try {
      // 请求传感器权限
      final permission = await Permission.sensors.request();
      if (permission.isGranted) {
        _logger.i('传感器权限已授予');
        
        // 初始化计步器
        await _initializePedometer();
        
        // 初始化加速度计和陀螺仪
        await _initializeMotionSensors();
      } else {
        _logger.w('传感器权限被拒绝');
      }
    } catch (e) {
      _logger.e('初始化传感器失败: $e');
    }
  }

  /// 初始化计步器
  Future<void> _initializePedometer() async {
    try {
      // 监听步数变化
      _stepCountSubscription = Pedometer.stepCountStream.listen(
        (StepCount event) {
          _currentData['steps'] = event.steps;
          _currentData['distance'] = event.steps * 0.7; // 假设每步0.7米
          _dataController.add(Map.from(_currentData));
        },
        onError: (error) {
          _logger.e('计步器错误: $error');
        },
      );

      // 监听步行状态
      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus event) {
          _currentData['isWalking'] = event.status == 'walking';
          _dataController.add(Map.from(_currentData));
        },
        onError: (error) {
          _logger.e('步行状态错误: $error');
        },
      );

      _logger.i('计步器初始化完成');
    } catch (e) {
      _logger.e('初始化计步器失败: $e');
    }
  }

  /// 初始化运动传感器
  Future<void> _initializeMotionSensors() async {
    try {
      // 监听加速度计
      _accelerometerSubscription = accelerometerEvents.listen(
        (AccelerometerEvent event) {
          _currentData['acceleration'] = {
            'x': event.x,
            'y': event.y,
            'z': event.z,
          };
          _dataController.add(Map.from(_currentData));
        },
        onError: (error) {
          _logger.e('加速度计错误: $error');
        },
      );

      // 监听陀螺仪
      _gyroscopeSubscription = gyroscopeEvents.listen(
        (GyroscopeEvent event) {
          _currentData['gyroscope'] = {
            'x': event.x,
            'y': event.y,
            'z': event.z,
          };
          _dataController.add(Map.from(_currentData));
        },
        onError: (error) {
          _logger.e('陀螺仪错误: $error');
        },
      );

      _logger.i('运动传感器初始化完成');
    } catch (e) {
      _logger.e('初始化运动传感器失败: $e');
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

  /// 获取健康数据
  Future<Map<String, dynamic>> getHealthData({
    DateTime? start,
    DateTime? end,
  }) async {
    // 暂时返回空数据，避免health插件兼容性问题
    return {};
  }

  /// 获取当前数据
  Map<String, dynamic> getCurrentData() {
    return Map.from(_currentData);
  }

  /// 保存数据到本地
  Future<void> saveData(Map<String, dynamic> data) async {
    try {
      if (_prefs != null) {
        final jsonString = data.toString();
        await _prefs!.setString('health_data_${DateTime.now().millisecondsSinceEpoch}', jsonString);
        _logger.i('数据已保存到本地');
      }
    } catch (e) {
      _logger.e('保存数据失败: $e');
    }
  }

  /// 从本地加载数据
  Future<List<Map<String, dynamic>>> loadData() async {
    try {
      if (_prefs != null) {
        final keys = _prefs!.getKeys().where((key) => key.startsWith('health_data_'));
        final dataList = <Map<String, dynamic>>[];
        
        for (final key in keys) {
          final jsonString = _prefs!.getString(key);
          if (jsonString != null) {
            // 简化处理，实际应该解析JSON
            dataList.add({'timestamp': key, 'data': jsonString});
          }
        }
        
        return dataList;
      }
    } catch (e) {
      _logger.e('加载数据失败: $e');
    }
    
    return [];
  }

  /// 清理数据
  Future<void> clearData() async {
    try {
      if (_prefs != null) {
        final keys = _prefs!.getKeys().where((key) => key.startsWith('health_data_'));
        for (final key in keys) {
          await _prefs!.remove(key);
        }
        _logger.i('数据已清理');
      }
    } catch (e) {
      _logger.e('清理数据失败: $e');
    }
  }

  /// 停止服务
  Future<void> stop() async {
    try {
      await _stepCountSubscription?.cancel();
      await _pedestrianStatusSubscription?.cancel();
      await _accelerometerSubscription?.cancel();
      await _gyroscopeSubscription?.cancel();
      
      await _dataController.close();
      
      _logger.i('真实健康服务已停止');
    } catch (e) {
      _logger.e('停止真实健康服务失败: $e');
    }
  }

  /// 释放资源
  void dispose() {
    stop();
  }
}
