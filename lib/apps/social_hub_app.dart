import 'package:flutter/material.dart';
import '../core/theme/wechat_theme.dart';

void main() {
  runApp(const SocialHubApp());
}

class SocialHubApp extends StatelessWidget {
  const SocialHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SocialHub',
      theme: WeChatTheme.themeData,
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
        selectedItemColor: WeChatTheme.primaryGreen,
        unselectedItemColor: WeChatTheme.textTertiary,
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
                icon: Icon(Icons.search, color: WeChatTheme.textTertiary),
              ),
            ),
          ),
          
          // 聊天列表
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/40',
                  size: 40,
                ),
                title: '张三',
                subtitle: '你好，最近怎么样？',
                trailing: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('14:30', style: TextStyle(fontSize: 12, color: WeChatTheme.textTertiary)),
                    SizedBox(height: 4),
                    Icon(Icons.music_note, color: WeChatTheme.primaryGreen, size: 16),
                  ],
                ),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/40',
                  size: 40,
                ),
                title: '工作群',
                subtitle: '李四: 今天的会议改到下午3点',
                trailing: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('13:45', style: TextStyle(fontSize: 12, color: WeChatTheme.textTertiary)),
                    SizedBox(height: 4),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Center(
                        child: Text('5', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/40',
                  size: 40,
                ),
                title: '王五',
                subtitle: '[图片]',
                trailing: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('昨天', style: TextStyle(fontSize: 12, color: WeChatTheme.textTertiary)),
                    SizedBox(height: 4),
                    Icon(Icons.notifications_off, color: WeChatTheme.textTertiary, size: 16),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
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
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.person_add, color: WeChatTheme.primaryGreen),
                title: '新的朋友',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.group_add, color: WeChatTheme.primaryGreen),
                title: '群聊',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.tag, color: WeChatTheme.primaryGreen),
                title: '标签',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.public, color: WeChatTheme.primaryGreen),
                title: '公众号',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: 'A',
            children: [
              WeChatComponents.listItem(
                leading: WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/40',
                  size: 40,
                ),
                title: 'Alice',
                subtitle: '在线',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: 'Z',
            children: [
              WeChatComponents.listItem(
                leading: WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/40',
                  size: 40,
                ),
                title: '张三',
                subtitle: '离线',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/40',
                  size: 40,
                ),
                title: '李四',
                subtitle: '在线',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
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
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.camera_alt, color: WeChatTheme.primaryGreen),
                title: '朋友圈',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.qr_code_scanner, color: WeChatTheme.primaryGreen),
                title: '扫一扫',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.shopping_cart, color: WeChatTheme.primaryGreen),
                title: '购物',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.games, color: WeChatTheme.primaryGreen),
                title: '游戏',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.public, color: WeChatTheme.primaryGreen),
                title: '小程序',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
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
                WeChatComponents.avatar(
                  imageUrl: 'https://via.placeholder.com/60',
                  size: 60,
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
                          color: WeChatTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '微信号: social_hub_2024',
                        style: TextStyle(
                          fontSize: 14,
                          color: WeChatTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.qr_code, color: WeChatTheme.primaryGreen),
              ],
            ),
          ),
          
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.payment, color: WeChatTheme.primaryGreen),
                title: '支付',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.favorite, color: WeChatTheme.primaryGreen),
                title: '收藏',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.photo_camera, color: WeChatTheme.primaryGreen),
                title: '相册',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.card_giftcard, color: WeChatTheme.primaryGreen),
                title: '卡包',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.emoji_emotions, color: WeChatTheme.primaryGreen),
                title: '表情',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.settings, color: WeChatTheme.primaryGreen),
                title: '设置',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
