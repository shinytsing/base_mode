import 'package:flutter/foundation.dart';
import 'sensor_service_web.dart';
import 'notification_service_web.dart';

class BackgroundServiceWeb {
  static final BackgroundServiceWeb _instance = BackgroundServiceWeb._internal();
  factory BackgroundServiceWeb() => _instance;
  BackgroundServiceWeb._internal();

  final SensorServiceWeb _sensorService = SensorServiceWeb();
  final NotificationServiceWeb _notificationService = NotificationServiceWeb();

  Future<void> initialize() async {
    if (kIsWeb) {
      await _sensorService.initialize();
      await _notificationService.initialize();
    }
  }

  Future<void> startBackgroundTask() async {
    if (kIsWeb) {
      // Web平台后台任务
      await _sensorService.startListening();
    }
  }

  void dispose() {
    if (kIsWeb) {
      _sensorService.dispose();
      _notificationService.dispose();
    }
  }
}
