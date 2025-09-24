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
