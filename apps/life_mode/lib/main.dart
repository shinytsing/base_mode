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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
      appBar: AppBar(
        title: const Text('LifeMode'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
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
        selectedItemColor: Colors.orange,
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
    return SingleChildScrollView(
      child: Column(
        children: [
          // 欢迎卡片
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
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
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('记录生活'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.orange,
                          side: const BorderSide(color: Colors.orange),
                        ),
                        child: const Text('查看记录'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 功能分组
          _buildGroup(
            title: '生活记录',
            children: [
              _buildListItem(
                icon: Icons.camera_alt,
                title: '拍照记录',
                subtitle: '记录生活中的美好瞬间',
                onTap: () {},
              ),
              _buildListItem(
                icon: Icons.note_add,
                title: '日记本',
                subtitle: '写下你的心情和感悟',
                onTap: () {},
              ),
              _buildListItem(
                icon: Icons.location_on,
                title: '足迹地图',
                subtitle: '记录你去过的地方',
                onTap: () {},
              ),
            ],
          ),
          
          _buildGroup(
            title: '娱乐活动',
            children: [
              _buildListItem(
                icon: Icons.movie,
                title: '电影推荐',
                subtitle: '发现好看的电影',
                onTap: () {},
              ),
              _buildListItem(
                icon: Icons.music_note,
                title: '音乐分享',
                subtitle: '分享你喜欢的音乐',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
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
    return ListView(
      children: [
        _buildGroup(
          title: '今日记录',
          children: [
            _buildListItem(
              icon: Icons.camera_alt,
              title: '早餐时光',
              subtitle: '2024-01-15 08:30',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.note_add,
              title: '工作感悟',
              subtitle: '2024-01-15 12:00',
              onTap: () {},
            ),
          ],
        ),
        
        _buildGroup(
          title: '本周统计',
          children: [
            _buildListItem(
              icon: Icons.photo_camera,
              title: '照片记录',
              subtitle: '本周共拍摄 25 张照片',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.edit_note,
              title: '日记篇数',
              subtitle: '本周写了 7 篇日记',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _EntertainmentTab extends StatelessWidget {
  const _EntertainmentTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildGroup(
          title: '热门推荐',
          children: [
            _buildListItem(
              icon: Icons.movie,
              title: '《流浪地球3》',
              subtitle: '科幻大片，值得一看',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.music_note,
              title: '《夜曲》',
              subtitle: '周杰伦经典歌曲',
              onTap: () {},
            ),
          ],
        ),
        
        _buildGroup(
          title: '我的收藏',
          children: [
            _buildListItem(
              icon: Icons.favorite,
              title: '收藏的电影',
              subtitle: '共收藏 12 部电影',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.favorite,
              title: '收藏的音乐',
              subtitle: '共收藏 28 首歌曲',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
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
        // 用户信息
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
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
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.orange,
                child: const Icon(Icons.person, color: Colors.white, size: 30),
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
        
        _buildGroup(
          title: '我的数据',
          children: [
            _buildListItem(
              icon: Icons.photo_camera,
              title: '照片总数',
              subtitle: '共拍摄 1,234 张照片',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.edit_note,
              title: '日记总数',
              subtitle: '共写了 89 篇日记',
              onTap: () {},
            ),
          ],
        ),
        
        _buildGroup(
          title: '应用设置',
          children: [
            _buildListItem(
              icon: Icons.notifications,
              title: '消息通知',
              subtitle: '',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.privacy_tip,
              title: '隐私设置',
              subtitle: '',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.help,
              title: '帮助中心',
              subtitle: '',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[100],
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}