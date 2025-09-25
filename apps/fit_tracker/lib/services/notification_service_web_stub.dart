import 'package:flutter/foundation.dart';

class NotificationServiceWeb {
  static final NotificationServiceWeb _instance = NotificationServiceWeb._internal();
  factory NotificationServiceWeb() => _instance;
  NotificationServiceWeb._internal();

  Future<void> initialize() async {
    // 非Web平台的存根实现
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // 非Web平台的存根实现
  }

  void dispose() {
    // 非Web平台的存根实现
  }
}
