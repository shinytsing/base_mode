import 'package:flutter/material.dart';

void main() {
  runApp(const QAToolBoxApp());
}

class QAToolBoxApp extends StatelessWidget {
  const QAToolBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA ToolBox Pro',
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: const Color(0xFF07C160),
        scaffoldBackgroundColor: const Color(0xFFEDEDED),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF07C160),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const QAToolBoxHomePage(),
    );
  }
}

class QAToolBoxHomePage extends StatefulWidget {
  const QAToolBoxHomePage({super.key});

  @override
  State<QAToolBoxHomePage> createState() => _QAToolBoxHomePageState();
}

class _QAToolBoxHomePageState extends State<QAToolBoxHomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _ToolsTab(),
          _ReportsTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF07C160),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined),
            activeIcon: Icon(Icons.build),
            label: '工具',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics),
            label: '报告',
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
        title: const Text('QA ToolBox Pro'),
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
                  '欢迎使用 QA ToolBox Pro',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '专业的质量保证工具集，提升您的测试效率',
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
                          backgroundColor: const Color(0xFF07C160),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('开始测试'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF07C160),
                          side: const BorderSide(color: Color(0xFF07C160)),
                        ),
                        child: const Text('查看报告'),
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
                  icon: Icons.bug_report,
                  title: 'Bug 管理',
                  subtitle: '跟踪和管理软件缺陷',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.science,
                  title: '测试用例',
                  subtitle: '创建和执行测试用例',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.analytics,
                  title: '数据分析',
                  subtitle: '分析测试数据和报告',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.settings,
                  title: '系统设置',
                  subtitle: '配置和管理系统参数',
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
      leading: Icon(icon, color: const Color(0xFF07C160)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ToolsTab extends StatelessWidget {
  const _ToolsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试工具'),
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
                  icon: Icons.play_arrow,
                  title: '单元测试',
                  subtitle: '自动生成和执行单元测试',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.integration_instructions,
                  title: '集成测试',
                  subtitle: '系统集成测试工具',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.speed,
                  title: '性能分析',
                  subtitle: '应用性能监控和分析',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.security,
                  title: '安全扫描',
                  subtitle: '代码安全漏洞检测',
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
      leading: Icon(icon, color: const Color(0xFF07C160)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _ReportsTab extends StatelessWidget {
  const _ReportsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试报告'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
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
                  icon: Icons.description,
                  title: '测试覆盖率报告',
                  subtitle: '2024-01-15 14:30',
                  trailing: const Text('95%', style: TextStyle(color: Color(0xFF07C160))),
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.bug_report,
                  title: 'Bug 统计报告',
                  subtitle: '2024-01-14 16:45',
                  trailing: const Text('12', style: TextStyle(color: Colors.red)),
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
      leading: Icon(icon, color: const Color(0xFF07C160)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing ?? const Icon(Icons.chevron_right),
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
                        '测试工程师',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '专业版用户',
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
                  icon: Icons.account_circle,
                  title: '个人资料',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.star,
                  title: '会员中心',
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
                  icon: Icons.help,
                  title: '帮助中心',
                  onTap: () {},
                ),
                const Divider(height: 0.5, indent: 16),
                _buildListItem(
                  icon: Icons.info,
                  title: '关于我们',
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
      leading: Icon(icon, color: const Color(0xFF07C160)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
