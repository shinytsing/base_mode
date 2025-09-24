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
