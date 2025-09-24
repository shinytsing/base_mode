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
        primaryColor: const Color(0xFF4CAF50),
        scaffoldBackgroundColor: const Color(0xFFEDEDED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _ExerciseTab(),
          _HealthTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            activeIcon: Icon(Icons.fitness_center),
            label: '运动',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: '健康',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FitTracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 今日数据卡片
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '今日健康数据',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDataCard('步数', '8,456', '步', const Color(0xFF4CAF50)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDataCard('卡路里', '324', 'kcal', Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDataCard('运动时长', '45', '分钟', Colors.blue),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDataCard('心率', '72', 'bpm', Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 功能列表
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _buildListItem(
                    icon: Icons.directions_run,
                    title: '跑步记录',
                    subtitle: '记录跑步距离和时长',
                    onTap: () {},
                  ),
                  const Divider(height: 0.5, indent: 16),
                  _buildListItem(
                    icon: Icons.pool,
                    title: '游泳记录',
                    subtitle: '记录游泳圈数和时间',
                    onTap: () {},
                  ),
                  const Divider(height: 0.5, indent: 16),
                  _buildListItem(
                    icon: Icons.directions_bike,
                    title: '骑行记录',
                    subtitle: '记录骑行距离和路线',
                    onTap: () {},
                  ),
                  const Divider(height: 0.5, indent: 16),
                  _buildListItem(
                    icon: Icons.monitor_heart,
                    title: '心率监测',
                    subtitle: '实时监测心率变化',
                    onTap: () {},
                  ),
                  const Divider(height: 0.5, indent: 16),
                  _buildListItem(
                    icon: Icons.bedtime,
                    title: '睡眠分析',
                    subtitle: '分析睡眠质量和时长',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard(String title, String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('运动记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.directions_run,
                  title: '晨跑',
                  subtitle: '5.2公里 • 32分钟',
                  trailing: const Text('完成', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.fitness_center,
                  title: '力量训练',
                  subtitle: '45分钟 • 消耗280卡路里',
                  trailing: const Text('完成', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.schedule,
                  title: '本周目标',
                  subtitle: '跑步30公里 • 已完成20公里',
                  trailing: const Text('67%', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.trending_up,
                  title: '月度挑战',
                  subtitle: '完成100公里跑步挑战',
                  trailing: const Text('80%', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _HealthTab extends StatelessWidget {
  const _HealthTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健康数据'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.monitor_heart,
                  title: '心率',
                  subtitle: '静息心率 65 bpm',
                  trailing: const Text('正常', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.scale,
                  title: '体重',
                  subtitle: '70.5 kg • BMI 22.1',
                  trailing: const Text('正常', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.height,
                  title: '身高',
                  subtitle: '175 cm',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.bedtime,
                  title: '昨晚睡眠',
                  subtitle: '7小时32分钟 • 深度睡眠2小时15分钟',
                  trailing: const Text('良好', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.trending_up,
                  title: '睡眠趋势',
                  subtitle: '本周平均睡眠7.2小时',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // 用户信息
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey[300],
                  ),
                  child: const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '健身达人',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '坚持运动，健康生活',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          
          // 功能列表
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.emoji_events,
                  title: '连续运动',
                  subtitle: '已连续运动 15 天',
                  trailing: const Text('15天', style: TextStyle(color: Colors.amber)),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.trending_up,
                  title: '总运动时长',
                  subtitle: '本月累计运动 45 小时',
                  trailing: const Text('45h', style: TextStyle(color: Color(0xFF4CAF50))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.notifications,
                  title: '运动提醒',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.share,
                  title: '分享成就',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.help,
                  title: '帮助中心',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF4CAF50)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
