import 'package:flutter/material.dart';

void main() {
  runApp(const LifeModeApp());
}

class LifeModeApp extends StatelessWidget {
  const LifeModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeMode',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFFF6B35),
        scaffoldBackgroundColor: const Color(0xFFEDEDED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF6B35),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const LifeModeHomePage(),
    );
  }
}

class LifeModeHomePage extends StatefulWidget {
  const LifeModeHomePage({super.key});

  @override
  State<LifeModeHomePage> createState() => _LifeModeHomePageState();
}

class _LifeModeHomePageState extends State<LifeModeHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _LifeTab(),
          _EntertainmentTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF6B35),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: '生活',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie_outlined),
            activeIcon: Icon(Icons.movie),
            label: '娱乐',
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
        title: const Text('LifeMode'),
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
      body: ListView(
        children: [
          // 欢迎卡片
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
                  '欢迎使用 LifeMode',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '记录美好生活，享受精彩时光',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('记录生活'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFFFF6B35),
                          side: const BorderSide(color: Color(0xFFFF6B35)),
                        ),
                        child: const Text('查看记录'),
                      ),
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
                  icon: Icons.camera_alt,
                  title: '拍照记录',
                  subtitle: '记录生活中的美好瞬间',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.note_add,
                  title: '日记本',
                  subtitle: '写下你的心情和感悟',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.location_on,
                  title: '足迹地图',
                  subtitle: '记录你去过的地方',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.movie,
                  title: '电影推荐',
                  subtitle: '发现好看的电影',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.music_note,
                  title: '音乐分享',
                  subtitle: '分享你喜欢的音乐',
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF6B35)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _LifeTab extends StatelessWidget {
  const _LifeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生活记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
                  icon: Icons.camera_alt,
                  title: '早餐时光',
                  subtitle: '2024-01-15 08:30',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.note_add,
                  title: '工作感悟',
                  subtitle: '2024-01-15 12:00',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.photo_camera,
                  title: '照片记录',
                  subtitle: '本周共拍摄 25 张照片',
                  trailing: const Text('25', style: TextStyle(color: Color(0xFFFF6B35))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.edit_note,
                  title: '日记篇数',
                  subtitle: '本周写了 7 篇日记',
                  trailing: const Text('7', style: TextStyle(color: Color(0xFFFF6B35))),
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
      leading: Icon(icon, color: const Color(0xFFFF6B35)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _EntertainmentTab extends StatelessWidget {
  const _EntertainmentTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('娱乐中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
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
                  icon: Icons.movie,
                  title: '《流浪地球3》',
                  subtitle: '科幻大片，值得一看',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.music_note,
                  title: '《夜曲》',
                  subtitle: '周杰伦经典歌曲',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.favorite,
                  title: '收藏的电影',
                  subtitle: '共收藏 12 部电影',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.favorite,
                  title: '收藏的音乐',
                  subtitle: '共收藏 28 首歌曲',
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF6B35)),
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
                        '生活达人',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '热爱生活，记录美好',
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
                  icon: Icons.photo_camera,
                  title: '照片总数',
                  subtitle: '共拍摄 1,234 张照片',
                  trailing: const Text('1,234', style: TextStyle(color: Color(0xFFFF6B35))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.edit_note,
                  title: '日记总数',
                  subtitle: '共写了 89 篇日记',
                  trailing: const Text('89', style: TextStyle(color: Color(0xFFFF6B35))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.notifications,
                  title: '消息通知',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.privacy_tip,
                  title: '隐私设置',
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
      leading: Icon(icon, color: const Color(0xFFFF6B35)),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
