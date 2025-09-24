import 'package:flutter/material.dart';

void main() {
  runApp(const FitTrackerApp());
}

class FitTrackerApp extends StatelessWidget {
  const FitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTracker',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const FitTrackerHomePage(),
    );
  }
}

class FitTrackerHomePage extends StatefulWidget {
  const FitTrackerHomePage({super.key});

  @override
  State<FitTrackerHomePage> createState() => _FitTrackerHomePageState();
}

class _FitTrackerHomePageState extends State<FitTrackerHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTracker'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [_HomeTab(), _ExerciseTab(), _HealthTab(), _ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center_outlined), activeIcon: Icon(Icons.fitness_center), label: '运动'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), activeIcon: Icon(Icons.favorite), label: '健康'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('今日健康数据', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildDataCard('步数', '8,456', '步', Colors.green)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDataCard('卡路里', '324', 'kcal', Colors.orange)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildDataCard('运动时长', '45', '分钟', Colors.blue)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildDataCard('心率', '72', 'bpm', Colors.red)),
                  ],
                ),
              ],
            ),
          ),
          _buildGroup('运动记录', [
            _buildListItem(Icons.directions_run, '跑步记录', '记录跑步距离和时长', () {}),
            _buildListItem(Icons.pool, '游泳记录', '记录游泳圈数和时间', () {}),
            _buildListItem(Icons.directions_bike, '骑行记录', '记录骑行距离和路线', () {}),
          ]),
          _buildGroup('健康管理', [
            _buildListItem(Icons.monitor_heart, '心率监测', '实时监测心率变化', () {}),
            _buildListItem(Icons.bedtime, '睡眠分析', '分析睡眠质量和时长', () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildDataCard(String title, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(unit, style: TextStyle(fontSize: 12, color: color)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ExerciseTab extends StatelessWidget {
  const _ExerciseTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGroup('今日运动', [
          _buildListItem(Icons.directions_run, '晨跑', '5.2公里 • 32分钟', () {}),
          _buildListItem(Icons.fitness_center, '力量训练', '45分钟 • 消耗280卡路里', () {}),
        ]),
        _buildGroup('运动计划', [
          _buildListItem(Icons.schedule, '本周目标', '跑步30公里 • 已完成20公里', () {}),
          _buildListItem(Icons.trending_up, '月度挑战', '完成100公里跑步挑战', () {}),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _HealthTab extends StatelessWidget {
  const _HealthTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGroup('身体指标', [
          _buildListItem(Icons.monitor_heart, '心率', '静息心率 65 bpm', () {}),
          _buildListItem(Icons.scale, '体重', '70.5 kg • BMI 22.1', () {}),
          _buildListItem(Icons.height, '身高', '175 cm', () {}),
        ]),
        _buildGroup('睡眠分析', [
          _buildListItem(Icons.bedtime, '昨晚睡眠', '7小时32分钟 • 深度睡眠2小时15分钟', () {}),
          _buildListItem(Icons.trending_up, '睡眠趋势', '本周平均睡眠7.2小时', () {}),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundColor: Colors.green, child: const Icon(Icons.person, color: Colors.white, size: 30)),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('健身达人', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    SizedBox(height: 4),
                    Text('坚持运动，健康生活', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        _buildGroup('运动成就', [
          _buildListItem(Icons.emoji_events, '连续运动', '已连续运动 15 天', () {}),
          _buildListItem(Icons.trending_up, '总运动时长', '本月累计运动 45 小时', () {}),
        ]),
        _buildGroup('应用设置', [
          _buildListItem(Icons.notifications, '运动提醒', '', () {}),
          _buildListItem(Icons.share, '分享成就', '', () {}),
          _buildListItem(Icons.help, '帮助中心', '', () {}),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
