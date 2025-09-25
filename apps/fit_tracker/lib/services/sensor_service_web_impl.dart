import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class SensorServiceWeb {
  static final SensorServiceWeb _instance = SensorServiceWeb._internal();
  factory SensorServiceWeb() => _instance;
  SensorServiceWeb._internal();

  Map<String, dynamic> _currentData = {};

  Map<String, dynamic> get currentData => _currentData;

  Future<void> initialize() async {
    if (kIsWeb) {
      // Web平台初始化
      _currentData = {
        'steps': 0,
        'distance': 0.0,
        'calories': 0,
        'heartRate': 0,
        'isWalking': false,
        'accelerometer': {'x': 0.0, 'y': 0.0, 'z': 0.0},
        'gyroscope': {'x': 0.0, 'y': 0.0, 'z': 0.0},
        'lastUpdate': DateTime.now(),
      };
    }
  }

  Future<void> startListening() async {
    if (kIsWeb) {
      // Web平台模拟数据
      _simulateData();
    }
  }

  void _simulateData() {
    // 模拟步数数据
    _currentData['steps'] = 8500;
    _currentData['distance'] = 6.5;
    _currentData['calories'] = 320;
    _currentData['heartRate'] = 75;
    _currentData['isWalking'] = true;
    _currentData['lastUpdate'] = DateTime.now();
  }

  void dispose() {
    // Web平台清理
  }
}
