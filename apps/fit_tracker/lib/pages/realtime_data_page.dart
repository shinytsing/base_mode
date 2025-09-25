import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/sensor_service.dart';
import '../services/notification_service.dart';
import '../services/background_service.dart';
import '../services/sensor_service_web.dart';
import '../services/notification_service_web.dart';
import '../services/background_service_web.dart';
import '../services/real_health_service.dart';

class RealtimeDataPage extends StatefulWidget {
  const RealtimeDataPage({super.key});

  @override
  State<RealtimeDataPage> createState() => _RealtimeDataPageState();
}

class _RealtimeDataPageState extends State<RealtimeDataPage> {
  // 根据平台选择服务
  dynamic get _sensorService => kIsWeb ? SensorServiceWeb() : RealHealthService();
  dynamic get _notificationService => kIsWeb ? NotificationServiceWeb() : NotificationService();
  dynamic get _backgroundService => kIsWeb ? BackgroundServiceWeb() : BackgroundService();
  
  StreamSubscription<Map<String, dynamic>>? _sensorSubscription;
  StreamSubscription<Map<String, dynamic>>? _notificationSubscription;
  
  Map<String, dynamic> _sensorData = {};
  List<Map<String, dynamic>> _notificationHistory = [];
  
  bool _isInitialized = false;
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      // 初始化传感器服务
      final sensorInitialized = await _sensorService.initialize();
      
      // 初始化通知服务
      final notificationInitialized = await _notificationService.initialize();
      
      // 初始化后台服务
      final backgroundInitialized = await _backgroundService.initialize();
      
      if (sensorInitialized && notificationInitialized && backgroundInitialized) {
        setState(() {
          _isInitialized = true;
        });
        
        // 开始监听数据
        _startListening();
        
        // 启动后台任务
        await _backgroundService.startStepTracking();
        await _backgroundService.startHealthMonitoring();
      }
    } catch (e) {
      print('服务初始化失败: $e');
    }
  }

  void _startListening() {
    // 监听传感器数据
    _sensorSubscription = _sensorService.sensorDataStream.listen((data) {
      setState(() {
        _sensorData = data;
      });
    });

    // 监听通知
    _notificationSubscription = _notificationService.notificationStream.listen((notification) {
      setState(() {
        _notificationHistory.insert(0, notification);
        if (_notificationHistory.length > 10) {
          _notificationHistory.removeLast();
        }
      });
    });
  }

  @override
  void dispose() {
    _sensorSubscription?.cancel();
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('实时数据'),
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleTracking,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: _showNotificationSettings,
          ),
        ],
      ),
      body: _isInitialized
          ? SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusCard(),
                  SizedBox(height: 16.h),
                  _buildSensorDataCard(),
                  SizedBox(height: 16.h),
                  _buildChartCard(),
                  SizedBox(height: 16.h),
                  _buildNotificationCard(),
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text('正在初始化服务...', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '服务状态',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  _isInitialized ? Icons.check_circle : Icons.error,
                  color: _isInitialized ? Colors.green : Colors.red,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  '传感器服务: ${_isInitialized ? "正常" : "异常"}',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  _notificationService.hasPermission ? Icons.check_circle : Icons.error,
                  color: _notificationService.hasPermission ? Colors.green : Colors.red,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  '通知权限: ${_notificationService.hasPermission ? "已授权" : "未授权"}',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  _isTracking ? Icons.play_circle : Icons.pause_circle,
                  color: _isTracking ? Colors.green : Colors.orange,
                  size: 20.w,
                ),
                SizedBox(width: 8.w),
                Text(
                  '数据追踪: ${_isTracking ? "进行中" : "已暂停"}',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorDataCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '传感器数据',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDataItem(
                    '步数',
                    '${_sensorData['steps'] ?? 0}',
                    Icons.directions_walk,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildDataItem(
                    '距离',
                    '${(_sensorData['distance'] ?? 0.0).toStringAsFixed(1)}m',
                    Icons.straighten,
                    Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildDataItem(
                    '卡路里',
                    '${(_sensorData['calories'] ?? 0.0).toStringAsFixed(1)}kcal',
                    Icons.local_fire_department,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildDataItem(
                    '状态',
                    _sensorData['isWalking'] == true ? '步行中' : '静止',
                    Icons.accessibility_new,
                    _sensorData['isWalking'] == true ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              '加速度计',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _buildAxisData('X', _sensorData['accelerometer']?['x'] ?? 0.0),
                ),
                Expanded(
                  child: _buildAxisData('Y', _sensorData['accelerometer']?['y'] ?? 0.0),
                ),
                Expanded(
                  child: _buildAxisData('Z', _sensorData['accelerometer']?['z'] ?? 0.0),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.w),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAxisData(String axis, double value) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        children: [
          Text(
            axis,
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '步数趋势',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              height: 200.h,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateStepSpots(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateStepSpots() {
    // 生成模拟的步数数据点
    final spots = <FlSpot>[];
    for (int i = 0; i < 24; i++) {
      spots.add(FlSpot(i.toDouble(), (i * 100 + (_sensorData['steps'] ?? 0) / 24).toDouble()));
    }
    return spots;
  }

  Widget _buildNotificationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '通知历史',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _sendTestNotification,
                  child: const Text('发送测试通知'),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            if (_notificationHistory.isEmpty)
              Center(
                child: Text(
                  '暂无通知',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
              )
            else
              ..._notificationHistory.map((notification) => _buildNotificationItem(notification)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            notification['title'] ?? '通知',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            notification['body'] ?? '',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 4.h),
          Text(
            '类型: ${notification['type'] ?? 'unknown'}',
            style: TextStyle(fontSize: 10.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
    });
    
    if (_isTracking) {
      _backgroundService.startStepTracking();
      _backgroundService.startHealthMonitoring();
    } else {
      _backgroundService.stopStepTracking();
      _backgroundService.stopHealthMonitoring();
    }
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('通知设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('发送步数提醒'),
              onTap: () {
                _notificationService.sendStepReminder(
                  _sensorData['steps'] ?? 0,
                  10000,
                );
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('发送久坐提醒'),
              onTap: () {
                _notificationService.sendSedentaryReminder();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('发送饮水提醒'),
              onTap: () {
                _notificationService.sendHydrationReminder();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('发送睡眠提醒'),
              onTap: () {
                _notificationService.sendSleepReminder();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _sendTestNotification() {
    _notificationService.showLocalNotification(
      title: 'FitMatrix测试',
      body: '这是一条测试通知',
      payload: 'test_notification',
    );
  }
}
