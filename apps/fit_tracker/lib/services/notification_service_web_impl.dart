import 'dart:html' as html;
import 'package:flutter/foundation.dart';

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
    if (kIsWeb && html.Notification.supported) {
      final permission = await html.Notification.requestPermission();
      if (permission == 'granted') {
        // 权限已授予
      }
    }
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb && html.Notification.supported) {
      final notification = html.Notification(
        title,
        body: body,
        icon: '/icons/icon-192.png',
      );
      
      // Web通知点击处理
      // notification.onclick = (event) {
      //   event.preventDefault();
      //   notification.close();
      //   // 处理点击事件
      // };
    }
  }

  void dispose() {
    // Web平台清理
  }
}
