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
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
      appBar: AppBar(
        title: const Text('QA ToolBox Pro'),
        backgroundColor: Colors.green,
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
          _ToolsTab(),
          _ReportsTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
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
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('开始测试'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.green,
                          side: const BorderSide(color: Colors.green),
                        ),
                        child: const Text('查看报告'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 功能分组
          _buildGroup(
            title: '测试工具',
            children: [
              _buildListItem(
                icon: Icons.bug_report,
                title: 'Bug 管理',
                subtitle: '跟踪和管理软件缺陷',
                onTap: () {},
              ),
              _buildListItem(
                icon: Icons.science,
                title: '测试用例',
                subtitle: '创建和执行测试用例',
                onTap: () {},
              ),
              _buildListItem(
                icon: Icons.analytics,
                title: '数据分析',
                subtitle: '分析测试数据和报告',
                onTap: () {},
              ),
            ],
          ),
          
          _buildGroup(
            title: '系统管理',
            children: [
              _buildListItem(
                icon: Icons.settings,
                title: '系统设置',
                subtitle: '配置和管理系统参数',
                onTap: () {},
              ),
              _buildListItem(
                icon: Icons.people,
                title: '团队管理',
                subtitle: '管理团队成员和权限',
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
      leading: Icon(icon, color: Colors.green),
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
    return ListView(
      children: [
        _buildGroup(
          title: '自动化测试',
          children: [
            _buildListItem(
              icon: Icons.play_arrow,
              title: '单元测试',
              subtitle: '自动生成和执行单元测试',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.integration_instructions,
              title: '集成测试',
              subtitle: '系统集成测试工具',
              onTap: () {},
            ),
          ],
        ),
        
        _buildGroup(
          title: '性能测试',
          children: [
            _buildListItem(
              icon: Icons.speed,
              title: '性能分析',
              subtitle: '应用性能监控和分析',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.security,
              title: '安全扫描',
              subtitle: '代码安全漏洞检测',
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
      leading: Icon(icon, color: Colors.green),
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
    return ListView(
      children: [
        _buildGroup(
          title: '最近报告',
          children: [
            _buildListItem(
              icon: Icons.description,
              title: '测试覆盖率报告',
              subtitle: '2024-01-15 14:30',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.bug_report,
              title: 'Bug 统计报告',
              subtitle: '2024-01-14 16:45',
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
      leading: Icon(icon, color: Colors.green),
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
                backgroundColor: Colors.green,
                child: const Icon(Icons.person, color: Colors.white, size: 30),
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
        
        _buildGroup(
          title: '账户管理',
          children: [
            _buildListItem(
              icon: Icons.account_circle,
              title: '个人资料',
              subtitle: '',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.star,
              title: '会员中心',
              subtitle: '',
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
              icon: Icons.help,
              title: '帮助中心',
              subtitle: '',
              onTap: () {},
            ),
            _buildListItem(
              icon: Icons.info,
              title: '关于我们',
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
      leading: Icon(icon, color: Colors.green),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
