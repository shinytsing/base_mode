import 'package:flutter/material.dart';
import '../core/theme/wechat_theme.dart';

void main() {
  runApp(const LifeModeApp());
}

class LifeModeApp extends StatelessWidget {
  const LifeModeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeMode',
      theme: WeChatTheme.themeData,
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
        selectedItemColor: WeChatTheme.primaryGreen,
        unselectedItemColor: WeChatTheme.textTertiary,
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
      body: SingleChildScrollView(
        child: Column(
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
                      color: WeChatTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '记录美好生活，享受精彩时光',
                    style: TextStyle(
                      fontSize: 14,
                      color: WeChatTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: WeChatComponents.button(
                          text: '记录生活',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WeChatComponents.button(
                          text: '查看记录',
                          onPressed: () {},
                          isPrimary: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // 功能分组
            WeChatComponents.group(
              title: '生活记录',
              children: [
                WeChatComponents.listItem(
                  leading: const Icon(Icons.camera_alt, color: WeChatTheme.primaryGreen),
                  title: '拍照记录',
                  subtitle: '记录生活中的美好瞬间',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.note_add, color: WeChatTheme.primaryGreen),
                  title: '日记本',
                  subtitle: '写下你的心情和感悟',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.location_on, color: WeChatTheme.primaryGreen),
                  title: '足迹地图',
                  subtitle: '记录你去过的地方',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            
            WeChatComponents.group(
              title: '娱乐活动',
              children: [
                WeChatComponents.listItem(
                  leading: const Icon(Icons.movie, color: WeChatTheme.primaryGreen),
                  title: '电影推荐',
                  subtitle: '发现好看的电影',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.music_note, color: WeChatTheme.primaryGreen),
                  title: '音乐分享',
                  subtitle: '分享你喜欢的音乐',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
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
          WeChatComponents.group(
            title: '今日记录',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.camera_alt, color: WeChatTheme.primaryGreen),
                title: '早餐时光',
                subtitle: '2024-01-15 08:30',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.note_add, color: WeChatTheme.primaryGreen),
                title: '工作感悟',
                subtitle: '2024-01-15 12:00',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '本周统计',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.photo_camera, color: WeChatTheme.primaryGreen),
                title: '照片记录',
                subtitle: '本周共拍摄 25 张照片',
                trailing: const Text('25', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.edit_note, color: WeChatTheme.primaryGreen),
                title: '日记篇数',
                subtitle: '本周写了 7 篇日记',
                trailing: const Text('7', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
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
          WeChatComponents.group(
            title: '热门推荐',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.movie, color: WeChatTheme.primaryGreen),
                title: '《流浪地球3》',
                subtitle: '科幻大片，值得一看',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.music_note, color: WeChatTheme.primaryGreen),
                title: '《夜曲》',
                subtitle: '周杰伦经典歌曲',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '我的收藏',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: '收藏的电影',
                subtitle: '共收藏 12 部电影',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: '收藏的音乐',
                subtitle: '共收藏 28 首歌曲',
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
                        '生活达人',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: WeChatTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '热爱生活，记录美好',
                        style: TextStyle(
                          fontSize: 14,
                          color: WeChatTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
          
          WeChatComponents.group(
            title: '我的数据',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.photo_camera, color: WeChatTheme.primaryGreen),
                title: '照片总数',
                subtitle: '共拍摄 1,234 张照片',
                trailing: const Text('1,234', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.edit_note, color: WeChatTheme.primaryGreen),
                title: '日记总数',
                subtitle: '共写了 89 篇日记',
                trailing: const Text('89', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '应用设置',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.notifications, color: WeChatTheme.primaryGreen),
                title: '消息通知',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.privacy_tip, color: WeChatTheme.primaryGreen),
                title: '隐私设置',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.help, color: WeChatTheme.primaryGreen),
                title: '帮助中心',
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
