import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化屏幕适配
  await ScreenUtil.ensureScreenSize();
  
  runApp(
    ProviderScope(
      child: SimpleQAToolBoxApp(),
    ),
  );
}

class SimpleQAToolBoxApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'QA ToolBox',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const MainScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const QAToolboxScreen(),
    const LifeModeScreen(),
    const SocialHubScreen(),
    const CreativeStudioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'QA工具箱',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '生活模式',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '社交中心',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.palette),
            label: '创意工作室',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QA ToolBox'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '欢迎使用 QA ToolBox',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '这是一个多功能的应用平台，包含以下功能模块：',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    context,
                    'QA工具箱',
                    Icons.build,
                    Colors.orange,
                    () => _showFeatureInfo(context, 'QA工具箱', '测试用例生成、PDF转换、网络爬虫、API测试等功能'),
                  ),
                  _buildFeatureCard(
                    context,
                    '生活模式',
                    Icons.favorite,
                    Colors.pink,
                    () => _showFeatureInfo(context, '生活模式', '食物推荐、旅行规划、心情记录、冥想会话等功能'),
                  ),
                  _buildFeatureCard(
                    context,
                    '社交中心',
                    Icons.people,
                    Colors.green,
                    () => _showFeatureInfo(context, '社交中心', '匹配系统、活动创建、聊天功能、消息管理等功能'),
                  ),
                  _buildFeatureCard(
                    context,
                    '创意工作室',
                    Icons.palette,
                    Colors.purple,
                    () => _showFeatureInfo(context, '创意工作室', 'AI写作、头像生成、音乐创作、设计工具等功能'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeatureInfo(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class QAToolboxScreen extends StatelessWidget {
  const QAToolboxScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QA工具箱'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'QA工具箱功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildToolItem('测试用例生成', '自动生成测试用例', Icons.assignment),
                  _buildToolItem('PDF转换', '文档格式转换', Icons.picture_as_pdf),
                  _buildToolItem('网络爬虫', '数据抓取工具', Icons.web),
                  _buildToolItem('API测试', '接口测试工具', Icons.api),
                  _buildToolItem('任务管理', '项目管理工具', Icons.task),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolItem(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: 实现具体功能
        },
      ),
    );
  }
}

class LifeModeScreen extends StatelessWidget {
  const LifeModeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('生活模式'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '生活助手功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildLifeItem('食物推荐', '智能美食推荐', Icons.restaurant),
                  _buildLifeItem('旅行规划', '行程规划助手', Icons.travel_explore),
                  _buildLifeItem('心情记录', '情绪管理工具', Icons.mood),
                  _buildLifeItem('冥想会话', '放松训练', Icons.self_improvement),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLifeItem(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.pink),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: 实现具体功能
        },
      ),
    );
  }
}

class SocialHubScreen extends StatelessWidget {
  const SocialHubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('社交中心'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '社交功能',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSocialItem('匹配系统', '智能匹配推荐', Icons.favorite),
                  _buildSocialItem('活动创建', '组织社交活动', Icons.event),
                  _buildSocialItem('聊天功能', '实时消息交流', Icons.chat),
                  _buildSocialItem('消息管理', '消息中心', Icons.message),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialItem(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: 实现具体功能
        },
      ),
    );
  }
}

class CreativeStudioScreen extends StatelessWidget {
  const CreativeStudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创意工作室'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '创意工具',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildCreativeItem('AI写作', '智能写作助手', Icons.edit),
                  _buildCreativeItem('头像生成', '个性化头像', Icons.face),
                  _buildCreativeItem('音乐创作', '音乐制作工具', Icons.music_note),
                  _buildCreativeItem('设计工具', '图形设计', Icons.design_services),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreativeItem(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.purple),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // TODO: 实现具体功能
        },
      ),
    );
  }
}