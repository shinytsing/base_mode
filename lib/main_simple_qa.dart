import 'package:flutter/material.dart';
import 'core/theme/app_themes.dart';

void main() {
  runApp(const QAToolBoxProApp());
}

class QAToolBoxProApp extends StatelessWidget {
  const QAToolBoxProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QA ToolBox Pro',
      theme: AppThemeManager.getThemeForApp('qa_toolbox'),
      debugShowCheckedModeBanner: false,
      home: const QAToolBoxProHomePage(),
    );
  }
}

class QAToolBoxProHomePage extends StatelessWidget {
  const QAToolBoxProHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QA ToolBox Pro'),
        backgroundColor: QAToolboxTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '欢迎使用 QA ToolBox Pro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: QAToolboxTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '工作效率工具',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItem(
                      icon: Icons.bug_report,
                      title: 'Bug 管理',
                      description: '跟踪和管理软件缺陷',
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      icon: Icons.science,
                      title: '测试用例',
                      description: '创建和执行测试用例',
                    ),
                    const SizedBox(height: 8),
                    _buildFeatureItem(
                      icon: Icons.analytics,
                      title: '数据分析',
                      description: '分析测试数据和报告',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: QAToolboxTheme.primaryColor,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
