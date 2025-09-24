import 'package:flutter/material.dart';
import '../core/theme/wechat_theme.dart';

void main() {
  runApp(const QAToolBoxApp());
}

class QAToolBoxApp extends StatelessWidget {
  const QAToolBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA ToolBox Pro',
      theme: WeChatTheme.themeData,
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
        selectedItemColor: WeChatTheme.primaryGreen,
        unselectedItemColor: WeChatTheme.textTertiary,
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
                    '欢迎使用 QA ToolBox Pro',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: WeChatTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '专业的质量保证工具集，提升您的测试效率',
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
                          text: '开始测试',
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: WeChatComponents.button(
                          text: '查看报告',
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
              title: '测试工具',
              children: [
                WeChatComponents.listItem(
                  leading: const Icon(Icons.bug_report, color: WeChatTheme.primaryGreen),
                  title: 'Bug 管理',
                  subtitle: '跟踪和管理软件缺陷',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.science, color: WeChatTheme.primaryGreen),
                  title: '测试用例',
                  subtitle: '创建和执行测试用例',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.analytics, color: WeChatTheme.primaryGreen),
                  title: '数据分析',
                  subtitle: '分析测试数据和报告',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            
            WeChatComponents.group(
              title: '系统管理',
              children: [
                WeChatComponents.listItem(
                  leading: const Icon(Icons.settings, color: WeChatTheme.primaryGreen),
                  title: '系统设置',
                  subtitle: '配置和管理系统参数',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                WeChatComponents.listItem(
                  leading: const Icon(Icons.people, color: WeChatTheme.primaryGreen),
                  title: '团队管理',
                  subtitle: '管理团队成员和权限',
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
          WeChatComponents.group(
            title: '自动化测试',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.play_arrow, color: WeChatTheme.primaryGreen),
                title: '单元测试',
                subtitle: '自动生成和执行单元测试',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.integration_instructions, color: WeChatTheme.primaryGreen),
                title: '集成测试',
                subtitle: '系统集成测试工具',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
          
          WeChatComponents.group(
            title: '性能测试',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.speed, color: WeChatTheme.primaryGreen),
                title: '性能分析',
                subtitle: '应用性能监控和分析',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.security, color: WeChatTheme.primaryGreen),
                title: '安全扫描',
                subtitle: '代码安全漏洞检测',
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
          WeChatComponents.group(
            title: '最近报告',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.description, color: WeChatTheme.primaryGreen),
                title: '测试覆盖率报告',
                subtitle: '2024-01-15 14:30',
                trailing: const Text('95%', style: TextStyle(color: WeChatTheme.primaryGreen)),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.bug_report, color: WeChatTheme.primaryGreen),
                title: 'Bug 统计报告',
                subtitle: '2024-01-14 16:45',
                trailing: const Text('12', style: TextStyle(color: Colors.red)),
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
                        '测试工程师',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: WeChatTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '专业版用户',
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
            title: '账户管理',
            children: [
              WeChatComponents.listItem(
                leading: const Icon(Icons.account_circle, color: WeChatTheme.primaryGreen),
                title: '个人资料',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.star, color: WeChatTheme.primaryGreen),
                title: '会员中心',
                trailing: const Icon(Icons.chevron_right),
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
                leading: const Icon(Icons.help, color: WeChatTheme.primaryGreen),
                title: '帮助中心',
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              WeChatComponents.listItem(
                leading: const Icon(Icons.info, color: WeChatTheme.primaryGreen),
                title: '关于我们',
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
