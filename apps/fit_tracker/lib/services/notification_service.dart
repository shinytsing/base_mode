import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final Logger _logger = Logger();
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  
  FirebaseMessaging? _firebaseMessaging;
  String? _fcmToken;
  
  // 通知权限状态
  bool _hasPermission = false;
  
  // 通知流控制器
  final StreamController<Map<String, dynamic>> _notificationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

  /// 初始化通知服务
  Future<bool> initialize() async {
    try {
      _logger.i('初始化通知服务...');
      
      // 初始化Firebase
      await _initializeFirebase();
      
      // 初始化本地通知
      await _initializeLocalNotifications();
      
      // 请求通知权限
      await _requestNotificationPermission();
      
      // 设置消息处理
      _setupMessageHandlers();
      
      _logger.i('通知服务初始化完成');
      return true;
    } catch (e) {
      _logger.e('通知服务初始化失败: $e');
      return false;
    }
  }

  /// 初始化Firebase
  Future<void> _initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      _firebaseMessaging = FirebaseMessaging.instance;
      
      // 获取FCM Token
      _fcmToken = await _firebaseMessaging!.getToken();
      _logger.i('FCM Token: $_fcmToken');
      
      // 监听Token刷新
      _firebaseMessaging!.onTokenRefresh.listen((token) {
        _fcmToken = token;
        _logger.i('FCM Token刷新: $token');
      });
      
    } catch (e) {
      _logger.e('Firebase初始化失败: $e');
    }
  }

  /// 初始化本地通知
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _logger.i('本地通知初始化完成');
  }

  /// 请求通知权限
  Future<void> _requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      _hasPermission = status.isGranted;
    } else if (Platform.isIOS) {
      final settings = await _firebaseMessaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      _hasPermission = settings.authorizationStatus == AuthorizationStatus.authorized;
    }
    
    _logger.i('通知权限状态: $_hasPermission');
  }

  /// 设置消息处理
  void _setupMessageHandlers() {
    // 前台消息处理
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i('收到前台消息: ${message.notification?.title}');
      _handleForegroundMessage(message);
    });

    // 后台消息处理
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i('通过通知打开应用: ${message.notification?.title}');
      _handleBackgroundMessage(message);
    });

    // 应用启动时的消息处理
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _logger.i('应用启动时的消息: ${message.notification?.title}');
        _handleBackgroundMessage(message);
      }
    });
  }

  /// 处理前台消息
  void _handleForegroundMessage(RemoteMessage message) {
    // 在前台显示本地通知
    showLocalNotification(
      title: message.notification?.title ?? 'FitMatrix',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  /// 处理后台消息
  void _handleBackgroundMessage(RemoteMessage message) {
    _notificationController.add({
      'type': 'background_message',
      'title': message.notification?.title,
      'body': message.notification?.body,
      'data': message.data,
      'timestamp': DateTime.now(),
    });
  }

  /// 通知点击处理
  void _onNotificationTapped(NotificationResponse response) {
    _notificationController.add({
      'type': 'notification_tapped',
      'payload': response.payload,
      'timestamp': DateTime.now(),
    });
  }

  /// 显示本地通知
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    if (!_hasPermission) {
      _logger.w('没有通知权限');
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'fitmatrix_channel',
      'FitMatrix通知',
      channelDescription: 'FitMatrix健身应用通知',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );

    _logger.i('本地通知已发送: $title');
  }

  /// 发送健身提醒通知
  Future<void> sendWorkoutReminder({
    required String workoutName,
    required DateTime scheduledTime,
  }) async {
    final timeFormat = DateFormat('HH:mm');
    final title = '🏋️‍♂️ 训练提醒';
    final body = '您的 $workoutName 训练将在 ${timeFormat.format(scheduledTime)} 开始';

    await showLocalNotification(
      title: title,
      body: body,
      payload: 'workout_reminder:$workoutName',
    );
  }

  /// 发送目标达成通知
  Future<void> sendGoalAchievedNotification({
    required String goalType,
    required String goalValue,
  }) async {
    final title = '🎉 目标达成！';
    final body = '恭喜！您已达成 $goalType 目标：$goalValue';

    await showLocalNotification(
      title: title,
      body: body,
      payload: 'goal_achieved:$goalType',
    );
  }

  /// 发送步数提醒
  Future<void> sendStepReminder(int currentSteps, int targetSteps) async {
    final remaining = targetSteps - currentSteps;
    if (remaining > 0) {
      final title = '🚶‍♂️ 步数提醒';
      final body = '您还需要 $remaining 步才能达成今日目标';

      await showLocalNotification(
        title: title,
        body: body,
        payload: 'step_reminder:$remaining',
      );
    }
  }

  /// 发送久坐提醒
  Future<void> sendSedentaryReminder() async {
    final title = '💺 久坐提醒';
    final body = '您已经久坐1小时了，起来活动一下吧！';

    await showLocalNotification(
      title: title,
      body: body,
      payload: 'sedentary_reminder',
    );
  }

  /// 发送饮水提醒
  Future<void> sendHydrationReminder() async {
    final title = '💧 饮水提醒';
    final body = '记得多喝水，保持身体水分平衡！';

    await showLocalNotification(
      title: title,
      body: body,
      payload: 'hydration_reminder',
    );
  }

  /// 发送睡眠提醒
  Future<void> sendSleepReminder() async {
    final title = '😴 睡眠提醒';
    final body = '该睡觉了，充足的睡眠有助于恢复！';

    await showLocalNotification(
      title: title,
      body: body,
      payload: 'sleep_reminder',
    );
  }

  /// 安排定期通知
  Future<void> schedulePeriodicNotifications() async {
    // 每小时久坐提醒
    await _scheduleRepeatingNotification(
      id: 1,
      title: '💺 久坐提醒',
      body: '您已经久坐1小时了，起来活动一下吧！',
      interval: const Duration(hours: 1),
      payload: 'sedentary_reminder',
    );

    // 每2小时饮水提醒
    await _scheduleRepeatingNotification(
      id: 2,
      title: '💧 饮水提醒',
      body: '记得多喝水，保持身体水分平衡！',
      interval: const Duration(hours: 2),
      payload: 'hydration_reminder',
    );
  }

  /// 安排重复通知
  Future<void> _scheduleRepeatingNotification({
    required int id,
    required String title,
    required String body,
    required Duration interval,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'fitmatrix_periodic',
      'FitMatrix定期提醒',
      channelDescription: 'FitMatrix定期健康提醒',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.periodicallyShow(
      id,
      title,
      body,
      RepeatInterval.everyMinute, // 这里需要根据实际需求调整
      details,
      payload: payload,
    );
  }

  /// 取消通知
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  /// 取消所有通知
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// 获取FCM Token
  String? get fcmToken => _fcmToken;

  /// 是否有通知权限
  bool get hasPermission => _hasPermission;

  /// 停止服务
  void dispose() {
    _notificationController.close();
  }
}

/// 后台消息处理函数（必须在顶级作用域）
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('处理后台消息: ${message.messageId}');
}
