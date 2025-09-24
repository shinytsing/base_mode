import 'package:flutter/material.dart';
import '../core/theme/wechat_theme.dart';

void main() {
  runApp(const CreativeStudioApp());
}

class CreativeStudioApp extends StatelessWidget {
  const CreativeStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CreativeStudio',
      theme: WeChatTheme.themeData,
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
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _CreateTab(),
          _GalleryTab(),
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
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: '创作',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: '作品',
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
        title: const Text('CreativeStudio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
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
                    '欢迎使用 CreativeStudio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: WeChatTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '释放你的创意潜能，创作无限可能',
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
                          text: '开始创作',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WeChatComponents.button(
                          text: '浏览作品',
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
              title: '创作工具',
              children: [
                WeChatComponents.listItem(
                  leading: const Icon(Icons.edit, color: WeChatTheme.primaryGreen),
                  title: 'AI 写作',
                  subtitle: '智能生成文章、剧本、诗歌',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.palette, color: WeChatTheme.primaryGreen),
                  title: '图像创作',
                  subtitle: '艺术滤镜、风格转换、AI绘画',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.music_note, color: WeChatTheme.primaryGreen),
                  title: '音乐制作',
                  subtitle: '智能作曲、音效编辑、混音',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.videocam, color: WeChatTheme.primaryGreen),
                  title: '视频编辑',
                  subtitle: '剪辑、特效、字幕、转场',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            
            WeChatComponents.group(
              title: '设计工具',
              children: [
                WeChatComponents.listItem(
                  leading: const Icon(Icons.design_services, color: WeChatTheme.primaryGreen),
                  title: '海报设计',
                  subtitle: '制作精美的海报和宣传图',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.brush, color: WeChatTheme.primaryGreen),
                  title: 'Logo设计',
                  subtitle: '创建专业的品牌标识',
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

class _CreateTab extends StatelessWidget {
  const _CreateTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创作中心'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {},
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildCreateCard(
            icon: Icons.edit,
            title: 'AI写作',
            subtitle: '智能创作',
            color: Colors.blue,
            onTap: () {},
          ),
          _buildCreateCard(
            icon: Icons.palette,
            title: '图像创作',
            subtitle: '艺术设计',
            color: Colors.purple,
            onTap: () {},
          ),
          _buildCreateCard(
            icon: Icons.music_note,
            title: '音乐制作',
            subtitle: '音频编辑',
            color: Colors.orange,
            onTap: () {},
          ),
          _buildCreateCard(
            icon: Icons.videocam,
            title: '视频编辑',
            subtitle: '视频制作',
            color: Colors.red,
            onTap: () {},
          ),
          _buildCreateCard(
            icon: Icons.design_services,
            title: '海报设计',
            subtitle: '平面设计',
            color: Colors.green,
            onTap: () {},
          ),
          _buildCreateCard(
            icon: Icons.brush,
            title: 'Logo设计',
            subtitle: '品牌设计',
            color: Colors.teal,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildCreateCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                icon,
                color: color,
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: WeChatTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: WeChatTheme.textSecondary,
              ),
            ),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的作品'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          WeChatComponents.group(
            title: '最近作品',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.image, color: WeChatTheme.primaryGreen),
                title: 'AI绘画作品',
                subtitle: '2024-01-15 创建',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.edit, color: WeChatTheme.primaryGreen),
                title: '创意文章',
                subtitle: '2024-01-14 创建',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.music_note, color: WeChatTheme.primaryGreen),
                title: '原创音乐',
                subtitle: '2024-01-13 创建',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '作品统计',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.image, color: WeChatTheme.primaryGreen),
                title: '图像作品',
                subtitle: '共创作 25 件作品',
                trailing: const Text('25', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.edit, color: WeChatTheme.primaryGreen),
                title: '文字作品',
                subtitle: '共创作 18 篇文章',
                trailing: const Text('18', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.music_note, color: WeChatTheme.primaryGreen),
                title: '音乐作品',
                subtitle: '共创作 12 首歌曲',
                trailing: const Text('12', style: TextStyle(color: WeChatTheme.primaryGreen)),
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
                        '创意大师',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: WeChatTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '用创意点亮世界',
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
            title: '创作数据',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.trending_up, color: WeChatTheme.primaryGreen),
                title: '创作天数',
                subtitle: '已连续创作 30 天',
                trailing: const Text('30天', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.favorite, color: WeChatTheme.primaryGreen),
                title: '作品点赞',
                subtitle: '总获得 1,234 个赞',
                trailing: const Text('1,234', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '应用设置',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.notifications, color: WeChatTheme.primaryGreen),
                title: '创作提醒',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.share, color: WeChatTheme.primaryGreen),
                title: '分享作品',
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
