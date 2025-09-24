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
        primarySwatch: Colors.purple,
        primaryColor: const Color(0xFF9C27B0),
        scaffoldBackgroundColor: const Color(0xFFEDEDED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF9C27B0),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _ChatTab(),
          _ContactsTab(),
          _DiscoverTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF9C27B0),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: '微信',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            activeIcon: Icon(Icons.contacts),
            label: '通讯录',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '我',
          ),
        ],
      ),
    );
  }
}

class _ChatTab extends StatelessWidget {
  const _ChatTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SocialHub'),
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
          // 搜索栏
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: '搜索',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          
          // 聊天列表
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildChatItem(
                  avatar: 'https://via.placeholder.com/40',
                  name: '张三',
                  lastMessage: '你好，最近怎么样？',
                  time: '14:30',
                  unreadCount: 0,
                  hasMusic: true,
                ),
                const Divider(height: 0.5, indent: 16),
                _buildChatItem(
                  avatar: 'https://via.placeholder.com/40',
                  name: '工作群',
                  lastMessage: '李四: 今天的会议改到下午3点',
                  time: '13:45',
                  unreadCount: 5,
                  hasMusic: false,
                ),
                const Divider(height: 0.5, indent: 16),
                _buildChatItem(
                  avatar: 'https://via.placeholder.com/40',
                  name: '王五',
                  lastMessage: '[图片]',
                  time: '昨天',
                  unreadCount: 0,
                  hasMusic: false,
                  muted: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required String avatar,
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required bool hasMusic,
    bool muted = false,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.person, color: Colors.grey),
      ),
      title: Text(name),
      subtitle: Text(lastMessage),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          if (unreadCount > 0)
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            )
          else if (hasMusic)
            const Icon(Icons.music_note, color: Color(0xFF9C27B0), size: 16)
          else if (muted)
            const Icon(Icons.notifications_off, color: Colors.grey, size: 16),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('通讯录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
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
                  icon: Icons.person_add,
                  title: '新的朋友',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.group_add,
                  title: '群聊',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.tag,
                  title: '标签',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.public,
                  title: '公众号',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          // 联系人分组
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: const Color(0xFFEDEDED),
                  child: const Text(
                    'A',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: _buildContactItem(
                    name: 'Alice',
                    status: '在线',
                  ),
                ),
                const Divider(height: 0.5, indent: 16),
                Container(
                  color: Colors.white,
                  child: _buildContactItem(
                    name: '张三',
                    status: '离线',
                  ),
                ),
                const Divider(height: 0.5, indent: 16),
                Container(
                  color: Colors.white,
                  child: _buildContactItem(
                    name: '李四',
                    status: '在线',
                  ),
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9C27B0)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildContactItem({
    required String name,
    required String status,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.grey[300],
        ),
        child: const Icon(Icons.person, color: Colors.grey),
      ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现'),
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
                  title: '朋友圈',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.qr_code_scanner,
                  title: '扫一扫',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.shopping_cart,
                  title: '购物',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.games,
                  title: '游戏',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 8),
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.public,
                  title: '小程序',
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9C27B0)),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('我'),
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
                        '社交达人',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '微信号: social_hub_2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.qr_code, color: Color(0xFF9C27B0)),
              ],
            ),
          ),
          
          // 功能列表
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.payment,
                  title: '支付',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 8),
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.favorite,
                  title: '收藏',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.photo_camera,
                  title: '相册',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.card_giftcard,
                  title: '卡包',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.emoji_emotions,
                  title: '表情',
                  onTap: () {},
                ),
              ],
            ),
          ),
          
          Container(
            margin: const EdgeInsets.only(top: 8),
            color: Colors.white,
            child: Column(
              children: [
                _buildListItem(
                  icon: Icons.settings,
                  title: '设置',
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
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9C27B0)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
