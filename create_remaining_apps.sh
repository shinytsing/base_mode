#!/bin/bash

# 为剩余三个应用创建完整代码的脚本

echo "🚀 为剩余三个应用创建完整代码..."

# FitTracker应用
echo "📱 创建 FitTracker 应用..."
cat > apps/fit_tracker/lib/main.dart << 'EOF'
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
EOF

# SocialHub应用
echo "📱 创建 SocialHub 应用..."
cat > apps/social_hub/lib/main.dart << 'EOF'
import 'package:flutter/material.dart';

void main() {
  runApp(const SocialHubApp());
}

class SocialHubApp extends StatelessWidget {
  const SocialHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialHub',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const SocialHubHomePage(),
    );
  }
}

class SocialHubHomePage extends StatefulWidget {
  const SocialHubHomePage({super.key});

  @override
  State<SocialHubHomePage> createState() => _SocialHubHomePageState();
}

class _SocialHubHomePageState extends State<SocialHubHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SocialHub'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.add), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [_ChatTab(), _ContactsTab(), _DiscoverTab(), _ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), activeIcon: Icon(Icons.chat_bubble), label: '微信'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts_outlined), activeIcon: Icon(Icons.contacts), label: '通讯录'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), activeIcon: Icon(Icons.explore), label: '发现'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: '我'),
        ],
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: const TextField(
            decoration: InputDecoration(
              hintText: '搜索',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey),
            ),
          ),
        ),
        _buildGroup('', [
          _buildChatItem('张三', '你好，最近怎么样？', '14:30', Icons.music_note),
          _buildChatItem('工作群', '李四: 今天的会议改到下午3点', '13:45', null, '5'),
          _buildChatItem('王五', '[图片]', '昨天', Icons.notifications_off),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
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

  Widget _buildChatItem(String name, String message, String time, IconData? icon, [String? badge]) {
    return ListTile(
      leading: CircleAvatar(radius: 20, backgroundColor: Colors.green, child: const Icon(Icons.person, color: Colors.white)),
      title: Text(name),
      subtitle: Text(message),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          if (badge != null)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Center(child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 12))),
            )
          else if (icon != null)
            Icon(icon, color: Colors.green, size: 16),
        ],
      ),
      onTap: () {},
    );
  }
}

class _ContactsTab extends StatelessWidget {
  const _ContactsTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGroup('', [
          _buildListItem(Icons.person_add, '新的朋友', () {}),
          _buildListItem(Icons.group_add, '群聊', () {}),
          _buildListItem(Icons.tag, '标签', () {}),
          _buildListItem(Icons.public, '公众号', () {}),
        ]),
        _buildGroup('A', [
          _buildContactItem('Alice', '在线'),
        ]),
        _buildGroup('Z', [
          _buildContactItem('张三', '离线'),
          _buildContactItem('李四', '在线'),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
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

  Widget _buildListItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildContactItem(String name, String status) {
    return ListTile(
      leading: CircleAvatar(radius: 20, backgroundColor: Colors.green, child: const Icon(Icons.person, color: Colors.white)),
      title: Text(name),
      subtitle: Text(status),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGroup('', [
          _buildListItem(Icons.camera_alt, '朋友圈', () {}),
          _buildListItem(Icons.qr_code_scanner, '扫一扫', () {}),
          _buildListItem(Icons.shopping_cart, '购物', () {}),
          _buildListItem(Icons.games, '游戏', () {}),
        ]),
        _buildGroup('', [
          _buildListItem(Icons.public, '小程序', () {}),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
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

  Widget _buildListItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
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
                    Text('社交达人', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    SizedBox(height: 4),
                    Text('微信号: social_hub_2024', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.qr_code, color: Colors.green),
            ],
          ),
        ),
        _buildGroup('', [
          _buildListItem(Icons.payment, '支付', () {}),
        ]),
        _buildGroup('', [
          _buildListItem(Icons.favorite, '收藏', () {}),
          _buildListItem(Icons.photo_camera, '相册', () {}),
          _buildListItem(Icons.card_giftcard, '卡包', () {}),
          _buildListItem(Icons.emoji_emotions, '表情', () {}),
        ]),
        _buildGroup('', [
          _buildListItem(Icons.settings, '设置', () {}),
        ]),
      ],
    );
  }

  Widget _buildGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
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

  Widget _buildListItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
EOF

# CreativeStudio应用
echo "📱 创建 CreativeStudio 应用..."
cat > apps/creative_studio/lib/main.dart << 'EOF'
import 'package:flutter/material.dart';

void main() {
  runApp(const CreativeStudioApp());
}

class CreativeStudioApp extends StatelessWidget {
  const CreativeStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreativeStudio',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: const CreativeStudioHomePage(),
    );
  }
}

class CreativeStudioHomePage extends StatefulWidget {
  const CreativeStudioHomePage({super.key});

  @override
  State<CreativeStudioHomePage> createState() => _CreativeStudioHomePageState();
}

class _CreativeStudioHomePageState extends State<CreativeStudioHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreativeStudio'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [_HomeTab(), _CreateTab(), _GalleryTab(), _ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: '创作'),
          BottomNavigationBarItem(icon: Icon(Icons.photo_library_outlined), activeIcon: Icon(Icons.photo_library), label: '作品'),
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
                const Text('欢迎使用 CreativeStudio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 8),
                const Text('释放你的创意潜能，创作无限可能', style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, foregroundColor: Colors.white),
                        child: const Text('开始创作'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.purple, side: const BorderSide(color: Colors.purple)),
                        child: const Text('浏览作品'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildGroup('创作工具', [
            _buildListItem(Icons.edit, 'AI 写作', '智能生成文章、剧本、诗歌', () {}),
            _buildListItem(Icons.palette, '图像创作', '艺术滤镜、风格转换、AI绘画', () {}),
            _buildListItem(Icons.music_note, '音乐制作', '智能作曲、音效编辑、混音', () {}),
            _buildListItem(Icons.videocam, '视频编辑', '剪辑、特效、字幕、转场', () {}),
          ]),
          _buildGroup('设计工具', [
            _buildListItem(Icons.design_services, '海报设计', '制作精美的海报和宣传图', () {}),
            _buildListItem(Icons.brush, 'Logo设计', '创建专业的品牌标识', () {}),
          ]),
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
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _CreateTab extends StatelessWidget {
  const _CreateTab();
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildCreateCard(Icons.edit, 'AI写作', '智能创作', Colors.blue, () {}),
        _buildCreateCard(Icons.palette, '图像创作', '艺术设计', Colors.purple, () {}),
        _buildCreateCard(Icons.music_note, '音乐制作', '音频编辑', Colors.orange, () {}),
        _buildCreateCard(Icons.videocam, '视频编辑', '视频制作', Colors.red, () {}),
        _buildCreateCard(Icons.design_services, '海报设计', '平面设计', Colors.green, () {}),
        _buildCreateCard(Icons.brush, 'Logo设计', '品牌设计', Colors.teal, () {}),
      ],
    );
  }

  Widget _buildCreateCard(IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(30)),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _GalleryTab extends StatelessWidget {
  const _GalleryTab();
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGroup('最近作品', [
          _buildListItem(Icons.image, 'AI绘画作品', '2024-01-15 创建', () {}),
          _buildListItem(Icons.edit, '创意文章', '2024-01-14 创建', () {}),
          _buildListItem(Icons.music_note, '原创音乐', '2024-01-13 创建', () {}),
        ]),
        _buildGroup('作品统计', [
          _buildListItem(Icons.image, '图像作品', '共创作 25 件作品', () {}),
          _buildListItem(Icons.edit, '文字作品', '共创作 18 篇文章', () {}),
          _buildListItem(Icons.music_note, '音乐作品', '共创作 12 首歌曲', () {}),
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
      leading: Icon(icon, color: Colors.purple),
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
              CircleAvatar(radius: 30, backgroundColor: Colors.purple, child: const Icon(Icons.person, color: Colors.white, size: 30)),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('创意大师', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    SizedBox(height: 4),
                    Text('用创意点亮世界', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        _buildGroup('创作数据', [
          _buildListItem(Icons.trending_up, '创作天数', '已连续创作 30 天', () {}),
          _buildListItem(Icons.favorite, '作品点赞', '总获得 1,234 个赞', () {}),
        ]),
        _buildGroup('应用设置', [
          _buildListItem(Icons.notifications, '创作提醒', '', () {}),
          _buildListItem(Icons.share, '分享作品', '', () {}),
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
      leading: Icon(icon, color: Colors.purple),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
EOF

echo "✅ 所有应用代码创建完成！"
echo "📱 现在可以运行 ./test_all_five_apps.sh 来测试所有应用！"
