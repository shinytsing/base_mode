import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/ai_coach_service.dart';
import '../services/real_health_service.dart';

class AICoachPage extends StatefulWidget {
  const AICoachPage({super.key});

  @override
  State<AICoachPage> createState() => _AICoachPageState();
}

class _AICoachPageState extends State<AICoachPage> with TickerProviderStateMixin {
  final AICoachService _aiCoachService = AICoachService();
  final RealHealthService _healthService = RealHealthService();
  
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    try {
      await _healthService.initialize();
      final coachInitialized = await _aiCoachService.initialize();
      
      if (coachInitialized) {
        setState(() {
          _isInitialized = true;
        });
        
        // 添加欢迎消息
        _addMessage('assistant', '您好！我是您的AI健身教练，随时为您提供专业的健身指导。');
      }
    } catch (e) {
      _addMessage('assistant', '服务初始化失败，请检查网络连接和API配置。');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI健身教练'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: '聊天', icon: Icon(Icons.chat)),
            Tab(text: '训练计划', icon: Icon(Icons.fitness_center)),
            Tab(text: '营养建议', icon: Icon(Icons.restaurant)),
            Tab(text: '数据分析', icon: Icon(Icons.analytics)),
            Tab(text: '健康报告', icon: Icon(Icons.health_and_safety)),
          ],
        ),
      ),
      body: _isInitialized
          ? TabBarView(
              controller: _tabController,
              children: [
                _buildChatTab(),
                _buildWorkoutPlanTab(),
                _buildNutritionTab(),
                _buildAnalysisTab(),
                _buildHealthReportTab(),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  SizedBox(height: 16.h),
                  Text('正在初始化AI教练服务...', style: TextStyle(fontSize: 16.sp)),
                ],
              ),
            ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(16.w),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildMessageBubble(message);
            },
          ),
        ),
        _buildMessageInput(),
      ],
    );
  }

  Widget _buildWorkoutPlanTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '生成训练计划',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildWorkoutPlanForm(),
        ],
      ),
    );
  }

  Widget _buildNutritionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '营养建议',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildNutritionForm(),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '训练数据分析',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildAnalysisForm(),
        ],
      ),
    );
  }

  Widget _buildHealthReportTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '健康报告',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildHealthDataCard(),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _generateHealthReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 50.h),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('生成健康报告'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['role'] == 'user';
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16.r,
              backgroundColor: Colors.green,
              child: Icon(Icons.smart_toy, size: 16.w, color: Colors.white),
            ),
            SizedBox(width: 8.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isUser ? Colors.green : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                message['content'],
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 8.w),
            CircleAvatar(
              radius: 16.r,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 16.w, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '输入您的问题...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              ),
              maxLines: null,
            ),
          ),
          SizedBox(width: 8.w),
          FloatingActionButton(
            onPressed: _isLoading ? null : _sendMessage,
            backgroundColor: Colors.green,
            mini: true,
            child: _isLoading
                ? SizedBox(
                    height: 16.h,
                    width: 16.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutPlanForm() {
    return Column(
      children: [
        _buildDropdownField('目标', ['减脂', '增肌', '塑形', '提高体能', '康复训练']),
        SizedBox(height: 12.h),
        _buildDropdownField('每周训练天数', ['3天', '4天', '5天', '6天']),
        SizedBox(height: 12.h),
        _buildDropdownField('单次训练时长', ['30分钟', '45分钟', '60分钟', '90分钟']),
        SizedBox(height: 12.h),
        _buildDropdownField('可用器械', ['徒手', '哑铃', '杠铃', '健身房', '家庭器械']),
        SizedBox(height: 12.h),
        _buildDropdownField('健身水平', ['初学者', '中级', '高级']),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: _generateWorkoutPlan,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('生成训练计划'),
        ),
      ],
    );
  }

  Widget _buildNutritionForm() {
    return Column(
      children: [
        _buildDropdownField('目标', ['减脂', '增肌', '维持体重', '提高运动表现']),
        SizedBox(height: 12.h),
        _buildDropdownField('活动水平', ['久坐', '轻度活动', '中度活动', '高强度活动']),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: _generateNutritionAdvice,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('获取营养建议'),
        ),
      ],
    );
  }

  Widget _buildAnalysisForm() {
    return Column(
      children: [
        _buildDropdownField('训练类型', ['力量训练', '有氧运动', 'HIIT', '瑜伽', '普拉提']),
        SizedBox(height: 12.h),
        _buildDropdownField('训练强度', ['低强度', '中等强度', '高强度', '极限强度']),
        SizedBox(height: 12.h),
        _buildDropdownField('完成情况', ['50%', '75%', '90%', '100%']),
        SizedBox(height: 20.h),
        ElevatedButton(
          onPressed: _analyzeWorkoutData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            minimumSize: Size(double.infinity, 50.h),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('分析训练数据'),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      items: options.map((option) => DropdownMenuItem(
        value: option,
        child: Text(option),
      )).toList(),
      onChanged: (value) {
        // 处理选择
      },
    );
  }

  Widget _buildHealthDataCard() {
    final healthData = _healthService.getCurrentData();
    
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '当前健康数据',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildDataItem('步数', '${healthData['steps'] ?? 0}', Icons.directions_walk),
                ),
                Expanded(
                  child: _buildDataItem('距离', '${(healthData['distance'] ?? 0.0).toStringAsFixed(1)}m', Icons.straighten),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildDataItem('卡路里', '${(healthData['calories'] ?? 0.0).toStringAsFixed(1)}kcal', Icons.local_fire_department),
                ),
                Expanded(
                  child: _buildDataItem('心率', '${healthData['heartRate'] ?? 0}bpm', Icons.favorite),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildDataItem('体重', '${healthData['weight'] ?? 0.0}kg', Icons.monitor_weight),
                ),
                Expanded(
                  child: _buildDataItem('饮水', '${healthData['waterIntake'] ?? 0.0}ml', Icons.water_drop),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.green, size: 24.w),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _addMessage(String role, String content) {
    setState(() {
      _messages.add({
        'role': role,
        'content': content,
        'timestamp': DateTime.now(),
      });
    });
    
    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _addMessage('user', message);
    
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aiCoachService.chat(message);
      _addMessage('assistant', response);
    } catch (e) {
      _addMessage('assistant', '抱歉，暂时无法回复您的问题，请稍后重试。');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateWorkoutPlan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aiCoachService.generateWorkoutPlan(
        goal: '减脂',
        daysPerWeek: 4,
        sessionDuration: 60,
        equipment: '健身房',
        fitnessLevel: '中级',
      );
      
      _addMessage('assistant', '训练计划：\n\n$response');
      _tabController.animateTo(0);
    } catch (e) {
      _addMessage('assistant', '抱歉，暂时无法生成训练计划，请稍后重试。');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateNutritionAdvice() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final healthData = _healthService.getCurrentData();
      final response = await _aiCoachService.getNutritionAdvice(
        goal: '减脂',
        weight: healthData['weight'] ?? 70.0,
        height: healthData['height'] ?? 175.0,
        age: healthData['age'] ?? 30,
        activityLevel: '中度活动',
      );
      
      _addMessage('assistant', '营养建议：\n\n$response');
      _tabController.animateTo(0);
    } catch (e) {
      _addMessage('assistant', '抱歉，暂时无法获取营养建议，请稍后重试。');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _analyzeWorkoutData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final workoutData = {
        'type': '力量训练',
        'duration': 60,
        'calories': 300.0,
        'intensity': '高强度',
        'completion': '90',
      };
      
      final response = await _aiCoachService.analyzeWorkoutData(workoutData);
      _addMessage('assistant', '训练分析：\n\n$response');
      _tabController.animateTo(0);
    } catch (e) {
      _addMessage('assistant', '抱歉，暂时无法分析训练数据，请稍后重试。');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _generateHealthReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aiCoachService.getHealthReport();
      _addMessage('assistant', '健康报告：\n\n$response');
      _tabController.animateTo(0);
    } catch (e) {
      _addMessage('assistant', '抱歉，暂时无法生成健康报告，请稍后重试。');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
