import 'package:flutter/foundation.dart';

class SensorServiceWeb {
  static final SensorServiceWeb _instance = SensorServiceWeb._internal();
  factory SensorServiceWeb() => _instance;
  SensorServiceWeb._internal();

  Map<String, dynamic> _currentData = {};

  Map<String, dynamic> get currentData => _currentData;

  Future<void> initialize() async {
    // 非Web平台的存根实现
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

  Future<void> startListening() async {
    // 非Web平台的存根实现
  }

  void dispose() {
    // 非Web平台的存根实现
  }
}
