import 'package:flutter/foundation.dart';

// 条件导入Web相关库
import 'notification_service_web_stub.dart'
    if (dart.library.html) 'notification_service_web_impl.dart'
    if (dart.library.io) 'notification_service_web_stub.dart';

class NotificationServiceWeb {
  static final NotificationServiceWeb _instance = NotificationServiceWeb._internal();
  factory NotificationServiceWeb() => _instance;
  NotificationServiceWeb._internal();

  Future<void> initialize() async {
    if (kIsWeb) {
      // Web平台通知初始化
      await _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    if (kIsWeb) {
      // 在Web平台上请求通知权限
      // 具体实现将在notification_service_web_impl.dart中
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      // Web平台通知显示
      // 具体实现将在notification_service_web_impl.dart中
    }
  }

  void dispose() {
    // Web平台清理
  }
}