// FitMatrix 训练计划管理页面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/fitness_models.dart';
import '../services/fitness_service.dart';

class TrainingPlanPage extends StatefulWidget {
  const TrainingPlanPage({super.key});

  @override
  State<TrainingPlanPage> createState() => _TrainingPlanPageState();
}

class _TrainingPlanPageState extends State<TrainingPlanPage> with TickerProviderStateMixin {
  final FitnessService _fitnessService = FitnessService();
  late TabController _tabController;
  
  List<TrainingPlan> _trainingPlans = [];
  TrainingPlan? _activePlan;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadTrainingPlans();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTrainingPlans() async {
    setState(() => _isLoading = true);
    try {
      final plans = await _fitnessService.getTrainingPlans();
      final activePlan = await _fitnessService.getActiveTrainingPlan();
      
      setState(() {
        _trainingPlans = plans;
        _activePlan = activePlan;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('加载训练计划失败: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('训练计划'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '我的计划'),
            Tab(text: 'AI教练'),
            Tab(text: '训练模式'),
            Tab(text: '计划模板'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreatePlanDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildMyPlansTab(),
                _buildAICoachTab(),
                _buildTrainingModesTab(),
                _buildTemplatesTab(),
              ],
            ),
    );
  }

  Widget _buildMyPlansTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_activePlan != null) ...[
            _buildActivePlanCard(_activePlan!),
            SizedBox(height: 20.h),
          ],
          _buildPlansList(),
        ],
      ),
    );
  }

  Widget _buildActivePlanCard(TrainingPlan plan) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      plan.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '进行中',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildPlanStat('周期', '${plan.durationWeeks}周', Colors.white),
              SizedBox(width: 16.w),
              _buildPlanStat('训练日', '${plan.workoutDays.length}天', Colors.white70),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPlansList() {
    if (_trainingPlans.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100.h),
            Icon(
              Icons.fitness_center_outlined,
              size: 64.w,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              '还没有训练计划',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '创建您的第一个训练计划',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _showCreatePlanDialog,
              icon: const Icon(Icons.add),
              label: const Text('创建计划'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '所有计划',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        ..._trainingPlans.map((plan) => _buildPlanCard(plan)),
      ],
    );
  }

  Widget _buildPlanCard(TrainingPlan plan) {
    final isActive = plan.isActive;
    
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: isActive ? Border.all(color: Colors.green, width: 2) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.green : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      plan.description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '进行中',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              _buildPlanInfo('模式', _getTrainingModeText(plan.mode)),
              SizedBox(width: 16.w),
              _buildPlanInfo('周期', '${plan.durationWeeks}周'),
              SizedBox(width: 16.w),
              _buildPlanInfo('训练日', '${plan.workoutDays.length}天'),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => _showPlanDetails(plan),
                child: const Text('查看详情'),
              ),
              if (!isActive)
                TextButton(
                  onPressed: () => _activatePlan(plan),
                  child: const Text('激活'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.green,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String _getTrainingModeText(TrainingMode mode) {
    switch (mode) {
      case TrainingMode.fiveSplit:
        return '五分化';
      case TrainingMode.threeSplit:
        return '三分化';
      case TrainingMode.pushPullLegs:
        return '推拉腿';
      case TrainingMode.cardio:
        return '有氧';
      case TrainingMode.functional:
        return '功能性';
    }
  }

  Widget _buildAICoachTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAICoachHeader(),
          SizedBox(height: 20.h),
          _buildAICoachFeatures(),
          SizedBox(height: 20.h),
          _buildAICoachChat(),
        ],
      ),
    );
  }

  Widget _buildAICoachHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.purple, Colors.deepPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 32.w,
              ),
              SizedBox(width: 12.w),
              Text(
                'AI健身教练',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '基于LLM的智能健身指导，为您量身定制训练计划',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildAICoachStat('智能分析', '实时', Colors.white),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildAICoachStat('个性化', '100%', Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAICoachStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color.withOpacity(0.8),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildAICoachFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI教练功能',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16.h),
        _buildAICoachFeatureCard(
          '智能训练计划',
          '根据您的目标、体能和偏好生成个性化训练计划',
          Icons.fitness_center,
          Colors.blue,
          () => _generateWorkoutPlan(),
        ),
        _buildAICoachFeatureCard(
          '实时指导',
          '训练过程中提供实时动作指导和纠正建议',
          Icons.record_voice_over,
          Colors.green,
          () => _startRealTimeCoaching(),
        ),
        _buildAICoachFeatureCard(
          '营养建议',
          '基于训练强度提供个性化营养和饮食建议',
          Icons.restaurant,
          Colors.orange,
          () => _getNutritionAdvice(),
        ),
        _buildAICoachFeatureCard(
          '进度分析',
          '分析您的训练数据，提供改进建议和激励',
          Icons.analytics,
          Colors.purple,
          () => _analyzeProgress(),
        ),
      ],
    );
  }

  Widget _buildAICoachFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAICoachChat() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '与AI教练对话',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '向AI教练提问，例如："我想减脂，应该怎么训练？"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _chatWithAI,
              icon: const Icon(Icons.send),
              label: const Text('发送消息'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingModesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '选择训练模式',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTrainingModeCard(
            TrainingMode.fiveSplit,
            '五分化训练',
            '经典五分化力量训练，适合中高级训练者',
            Icons.fitness_center,
            Colors.blue,
          ),
          _buildTrainingModeCard(
            TrainingMode.threeSplit,
            '三分化训练',
            '推拉腿三分化训练，平衡发展',
            Icons.directions_run,
            Colors.orange,
          ),
          _buildTrainingModeCard(
            TrainingMode.pushPullLegs,
            '推拉腿训练',
            'Push/Pull/Legs训练模式',
            Icons.sports,
            Colors.green,
          ),
          _buildTrainingModeCard(
            TrainingMode.cardio,
            '有氧训练',
            '心肺功能训练，提升耐力',
            Icons.favorite,
            Colors.red,
          ),
          _buildTrainingModeCard(
            TrainingMode.functional,
            '功能性训练',
            '注重实用性和运动表现',
            Icons.accessibility_new,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingModeCard(
    TrainingMode mode,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _createPlanWithMode(mode),
            icon: const Icon(Icons.arrow_forward_ios),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplatesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '计划模板',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          _buildTemplateCard(
            '新手入门计划',
            '适合健身新手的4周入门计划',
            '4周 • 3天/周',
            Icons.school,
            Colors.green,
          ),
          _buildTemplateCard(
            '增肌力量计划',
            '专注于肌肉增长的力量训练计划',
            '8周 • 4天/周',
            Icons.fitness_center,
            Colors.blue,
          ),
          _buildTemplateCard(
            '减脂有氧计划',
            '高效燃脂的有氧训练计划',
            '6周 • 5天/周',
            Icons.favorite,
            Colors.red,
          ),
          _buildTemplateCard(
            '功能性训练计划',
            '提升日常运动表现的功能性训练',
            '4周 • 3天/周',
            Icons.accessibility_new,
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    String title,
    String description,
    String duration,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _applyTemplate(title),
            child: const Text('应用'),
          ),
        ],
      ),
    );
  }

  void _showCreatePlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('创建训练计划'),
        content: const Text('选择训练模式来创建新的训练计划'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showTrainingModeSelection();
            },
            child: const Text('创建'),
          ),
        ],
      ),
    );
  }

  void _showTrainingModeSelection() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择训练模式',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                children: [
                  _buildModeOption(TrainingMode.fiveSplit, '五分化训练'),
                  _buildModeOption(TrainingMode.threeSplit, '三分化训练'),
                  _buildModeOption(TrainingMode.pushPullLegs, '推拉腿训练'),
                  _buildModeOption(TrainingMode.cardio, '有氧训练'),
                  _buildModeOption(TrainingMode.functional, '功能性训练'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(TrainingMode mode, String title) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pop(context);
        _createPlanWithMode(mode);
      },
    );
  }

  void _createPlanWithMode(TrainingMode mode) {
    // 这里应该跳转到计划创建页面
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('创建${_getTrainingModeText(mode)}计划')),
    );
  }

  void _showPlanDetails(TrainingPlan plan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plan.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('描述: ${plan.description}'),
            const SizedBox(height: 8),
            Text('模式: ${_getTrainingModeText(plan.mode)}'),
            const SizedBox(height: 8),
            Text('周期: ${plan.durationWeeks}周'),
            const SizedBox(height: 8),
            Text('训练日: ${plan.workoutDays.length}天'),
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

  void _activatePlan(TrainingPlan plan) async {
    try {
      // 这里应该更新计划的激活状态
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已激活${plan.name}')),
      );
      await _loadTrainingPlans();
    } catch (e) {
      _showErrorSnackBar('激活计划失败: $e');
    }
  }

  void _applyTemplate(String templateName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已应用$templateName')),
    );
  }

  // AI教练功能方法
  void _generateWorkoutPlan() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI智能训练计划'),
        content: const Text('正在为您生成个性化训练计划...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _startRealTimeCoaching() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('实时指导'),
        content: const Text('AI教练将为您提供实时动作指导和纠正建议'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('开始指导'),
          ),
        ],
      ),
    );
  }

  void _getNutritionAdvice() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('营养建议'),
        content: const Text('基于您的训练强度，AI教练为您提供个性化营养建议'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('查看建议'),
          ),
        ],
      ),
    );
  }

  void _analyzeProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('进度分析'),
        content: const Text('AI教练正在分析您的训练数据，提供改进建议'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('查看分析'),
          ),
        ],
      ),
    );
  }

  void _chatWithAI() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI教练回复'),
        content: const Text('基于LLM的智能回复：\n\n"根据您的目标，我建议您采用有氧运动结合力量训练的方式。建议每周进行3-4次训练，每次45-60分钟。有氧运动可以选择跑步、游泳或骑行，力量训练建议进行全身性的复合动作训练。"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('继续对话'),
          ),
        ],
      ),
    );
  }
}
