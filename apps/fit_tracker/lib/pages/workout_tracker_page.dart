// FitMatrix 训练追踪页面
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import '../models/fitness_models.dart';
import '../services/fitness_service.dart';

class WorkoutTrackerPage extends StatefulWidget {
  const WorkoutTrackerPage({super.key});

  @override
  State<WorkoutTrackerPage> createState() => _WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage> with TickerProviderStateMixin {
  final FitnessService _fitnessService = FitnessService();
  late TabController _tabController;
  
  // 训练状态
  bool _isWorkoutActive = false;
  Timer? _workoutTimer;
  Duration _workoutDuration = Duration.zero;
  
  // 当前训练数据
  WorkoutType _selectedWorkoutType = WorkoutType.strength;
  IntensityLevel _selectedIntensity = IntensityLevel.moderate;
  List<ExerciseRecord> _currentExercises = [];
  String _workoutNotes = '';
  
  // 统计数据
  List<EnhancedFitnessWorkoutSession> _recentSessions = [];
  WorkoutStatistics? _statistics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _workoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final sessions = await _fitnessService.getRecentWorkoutSessions(limit: 10);
      final statistics = await _fitnessService.getStatistics();
      
      setState(() {
        _recentSessions = sessions;
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('加载数据失败: $e');
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
        title: const Text('训练追踪'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '开始训练'),
            Tab(text: '训练记录'),
            Tab(text: '数据统计'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildWorkoutTab(),
                _buildHistoryTab(),
                _buildStatisticsTab(),
              ],
            ),
    );
  }

  Widget _buildWorkoutTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWorkoutTimer(),
          SizedBox(height: 20.h),
          _buildWorkoutTypeSelector(),
          SizedBox(height: 20.h),
          _buildIntensitySelector(),
          SizedBox(height: 20.h),
          _buildExerciseList(),
          SizedBox(height: 20.h),
          _buildWorkoutNotes(),
          SizedBox(height: 20.h),
          _buildWorkoutActions(),
        ],
      ),
    );
  }

  Widget _buildWorkoutTimer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isWorkoutActive 
              ? [Colors.red, Colors.orange]
              : [Colors.green, Colors.lightGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: (_isWorkoutActive ? Colors.red : Colors.green).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _isWorkoutActive ? '训练进行中' : '准备开始训练',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _formatDuration(_workoutDuration),
            style: TextStyle(
              color: Colors.white,
              fontSize: 48.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _isWorkoutActive ? _pauseWorkout : _startWorkout,
                icon: Icon(_isWorkoutActive ? Icons.pause : Icons.play_arrow),
                label: Text(_isWorkoutActive ? '暂停' : '开始'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _isWorkoutActive ? Colors.red : Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                ),
              ),
              if (_isWorkoutActive)
                ElevatedButton.icon(
                  onPressed: _stopWorkout,
                  icon: const Icon(Icons.stop),
                  label: const Text('结束'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '训练类型',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: WorkoutType.values.map((type) {
            final isSelected = _selectedWorkoutType == type;
            return FilterChip(
              label: Text(_getWorkoutTypeText(type)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedWorkoutType = type);
                }
              },
              selectedColor: Colors.green.withOpacity(0.2),
              checkmarkColor: Colors.green,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildIntensitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '训练强度',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: IntensityLevel.values.map((level) {
            final isSelected = _selectedIntensity == level;
            return FilterChip(
              label: Text(_getIntensityText(level)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedIntensity = level);
                }
              },
              selectedColor: Colors.blue.withOpacity(0.2),
              checkmarkColor: Colors.blue,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '训练动作',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addExercise,
              icon: const Icon(Icons.add),
              label: const Text('添加动作'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (_currentExercises.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.fitness_center_outlined,
                  size: 48.w,
                  color: Colors.grey,
                ),
                SizedBox(height: 8.h),
                Text(
                  '还没有添加训练动作',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '点击"添加动作"开始记录',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        else
          ..._currentExercises.map((exercise) => _buildExerciseCard(exercise)),
      ],
    );
  }

  Widget _buildExerciseCard(ExerciseRecord exercise) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exercise.exerciseName,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => _removeExercise(exercise),
                icon: const Icon(Icons.delete_outline),
                color: Colors.red,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ...exercise.sets.map((set) => _buildSetRow(set)),
          SizedBox(height: 8.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _addSet(exercise),
                icon: const Icon(Icons.add),
                label: const Text('添加组数'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _editExercise(exercise),
                child: const Text('编辑'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(SetRecord set) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Text(
            '第${set.setNumber}组',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 16.w),
          if (set.weight != null)
            Text(
              '${set.weight}kg',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.green,
              ),
            ),
          SizedBox(width: 16.w),
          Text(
            '${set.reps}次',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.blue,
            ),
          ),
          if (set.restTime != null) ...[
            SizedBox(width: 16.w),
            Text(
              '休息${set.restTime!.inMinutes}分钟',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.orange,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkoutNotes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '训练笔记',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '记录训练感受、注意事项等...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          onChanged: (value) => _workoutNotes = value,
        ),
      ],
    );
  }

  Widget _buildWorkoutActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _saveWorkout,
            icon: const Icon(Icons.save),
            label: const Text('保存训练'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _clearWorkout,
            icon: const Icon(Icons.clear),
            label: const Text('清空'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16.h),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    if (_recentSessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64.w,
              color: Colors.grey,
            ),
            SizedBox(height: 16.h),
            Text(
              '还没有训练记录',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '开始您的第一次训练',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: _recentSessions.length,
      itemBuilder: (context, index) {
        final session = _recentSessions[index];
        return _buildSessionCard(session);
      },
    );
  }

  Widget _buildSessionCard(EnhancedFitnessWorkoutSession session) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getWorkoutTypeText(session.workoutType),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDate(session.createdAt),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _buildSessionInfo('时长', '${session.durationMinutes}分钟'),
              SizedBox(width: 16.w),
              _buildSessionInfo('强度', _getIntensityText(session.intensityLevel)),
              SizedBox(width: 16.w),
              _buildSessionInfo('卡路里', '${session.caloriesBurned.toInt()}kcal'),
            ],
          ),
          if (session.exercises.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Text(
              '${session.exercises.length}个动作',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSessionInfo(String label, String value) {
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

  Widget _buildStatisticsTab() {
    if (_statistics == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsOverview(),
          SizedBox(height: 20.h),
          _buildWorkoutTypeChart(),
          SizedBox(height: 20.h),
          _buildProgressChart(),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
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
          Text(
            '训练统计',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(child: _buildStatItem('总训练', '${_statistics!.totalWorkouts}次', Colors.white)),
              SizedBox(width: 16.w),
              Expanded(child: _buildStatItem('总时长', '${_statistics!.totalDurationMinutes}分钟', Colors.white70)),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(child: _buildStatItem('总卡路里', '${_statistics!.totalCaloriesBurned.toInt()}kcal', Colors.white)),
              SizedBox(width: 16.w),
              Expanded(child: _buildStatItem('连续天数', '${_statistics!.consecutiveDays}天', Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
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

  Widget _buildWorkoutTypeChart() {
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
            '训练类型分布',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          ..._statistics!.workoutTypeDistribution.entries.map((entry) {
            final percentage = _statistics!.totalWorkouts > 0 
                ? (entry.value / _statistics!.totalWorkouts * 100).toStringAsFixed(1)
                : '0.0';
            return _buildChartItem(
              _getWorkoutTypeText(entry.key),
              entry.value,
              percentage,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChartItem(String label, int value, String percentage) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: _statistics!.totalWorkouts > 0 ? value / _statistics!.totalWorkouts : 0,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart() {
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
            '训练进度',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          _buildProgressItem('平均训练时长', '${_statistics!.averageWorkoutDuration.toStringAsFixed(1)}分钟'),
          _buildProgressItem('平均卡路里消耗', '${_statistics!.averageCaloriesPerWorkout.toStringAsFixed(1)}kcal'),
          _buildProgressItem('最后训练', _formatDate(_statistics!.lastWorkoutDate)),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  // 工具方法
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getWorkoutTypeText(WorkoutType type) {
    switch (type) {
      case WorkoutType.strength:
        return '力量训练';
      case WorkoutType.cardio:
        return '有氧运动';
      case WorkoutType.flexibility:
        return '柔韧性训练';
      case WorkoutType.balance:
        return '平衡训练';
      case WorkoutType.mixed:
        return '混合训练';
    }
  }

  String _getIntensityText(IntensityLevel level) {
    switch (level) {
      case IntensityLevel.light:
        return '轻度';
      case IntensityLevel.moderate:
        return '中度';
      case IntensityLevel.high:
        return '高强度';
      case IntensityLevel.extreme:
        return '极限';
    }
  }

  // 训练控制方法
  void _startWorkout() {
    setState(() => _isWorkoutActive = true);
    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _workoutDuration = Duration(seconds: timer.tick));
    });
  }

  void _pauseWorkout() {
    setState(() => _isWorkoutActive = false);
    _workoutTimer?.cancel();
  }

  void _stopWorkout() {
    setState(() {
      _isWorkoutActive = false;
      _workoutDuration = Duration.zero;
    });
    _workoutTimer?.cancel();
  }

  void _addExercise() {
    // 这里应该显示动作选择对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加训练动作')),
    );
  }

  void _removeExercise(ExerciseRecord exercise) {
    setState(() => _currentExercises.remove(exercise));
  }

  void _addSet(ExerciseRecord exercise) {
    // 这里应该显示组数添加对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('添加组数')),
    );
  }

  void _editExercise(ExerciseRecord exercise) {
    // 这里应该显示动作编辑对话框
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('编辑动作')),
    );
  }

  void _saveWorkout() async {
    try {
      final session = EnhancedFitnessWorkoutSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        workoutType: _selectedWorkoutType,
        intensityLevel: _selectedIntensity,
        durationMinutes: _workoutDuration.inMinutes,
        caloriesBurned: _calculateCalories(),
        exercises: _currentExercises,
        workoutNotes: _workoutNotes,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );

      await _fitnessService.saveWorkoutSession(session);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('训练记录已保存')),
      );
      
      _clearWorkout();
      await _loadData();
    } catch (e) {
      _showErrorSnackBar('保存训练失败: $e');
    }
  }

  void _clearWorkout() {
    setState(() {
      _currentExercises.clear();
      _workoutNotes = '';
      _workoutDuration = Duration.zero;
      _isWorkoutActive = false;
    });
    _workoutTimer?.cancel();
  }

  double _calculateCalories() {
    // 简单的卡路里计算，实际应用中应该更复杂
    return _workoutDuration.inMinutes * 8.0;
  }
}
