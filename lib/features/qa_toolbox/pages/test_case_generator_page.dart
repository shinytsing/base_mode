import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/qa_toolbox_provider.dart';
import '../models/qa_toolbox_model.dart';

class TestCaseGeneratorPage extends ConsumerWidget {
  const TestCaseGeneratorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qa_toolboxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('测试用例生成器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              _showHelp(context);
            },
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onActionPressed(context, ref),
        tooltip: '开始测试用例生成器',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, dynamic state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null) {
      return _buildErrorView(context, ref, state.error);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureIntro(context),
          const SizedBox(height: 24),
          _buildFeatureContent(context, ref),
          const SizedBox(height: 24),
          _buildFeatureActions(context, ref),
        ],
      ),
    );
  }

  Widget _buildFeatureIntro(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.star_outline,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '测试用例生成器',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '智能化的测试用例生成器功能，让您的工作更高效',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureContent(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '功能设置',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              context,
              '自动模式',
              '启用智能自动处理',
              Icons.auto_awesome,
              true,
              (value) {},
            ),
            _buildSettingItem(
              context,
              '高级选项',
              '开启更多自定义设置',
              Icons.settings,
              false,
              (value) {},
            ),
            _buildSettingItem(
              context,
              '结果保存',
              '自动保存处理结果',
              Icons.save,
              true,
              (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFeatureActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '快速操作',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                '开始处理',
                Icons.play_arrow,
                AppTheme.successColor,
                () => _onActionPressed(context, ref),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                '查看历史',
                Icons.history,
                AppTheme.infoColor,
                () => _showHistory(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                '导出结果',
                Icons.download,
                AppTheme.warningColor,
                () => _exportResults(context),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                '分享',
                Icons.share,
                AppTheme.primaryColor,
                () => _shareResults(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppTheme.errorColor,
          ),
          const SizedBox(height: 16),
          Text(
            '出现错误',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ref.read(qa_toolboxProvider.notifier).clearError();
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  void _onActionPressed(BuildContext context, WidgetRef ref) {
    // 显示测试用例生成器对话框
    _showTestGeneratorDialog(context, ref);
  }

  void _showTestGeneratorDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _TestGeneratorDialog(),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('测试用例生成器帮助'),
        content: const Text(
          '这是测试用例生成器功能的帮助信息。\n\n'
          '您可以在这里了解如何使用此功能的详细说明。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context) {
    // 显示历史记录
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('查看测试用例生成器历史记录'),
      ),
    );
  }

  void _exportResults(BuildContext context) {
    // 导出结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('导出测试用例生成器结果'),
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // 分享结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('分享测试用例生成器结果'),
      ),
    );
  }
}

// 测试用例生成器对话框
class _TestGeneratorDialog extends StatefulWidget {
  @override
  _TestGeneratorDialogState createState() => _TestGeneratorDialogState();
}

class _TestGeneratorDialogState extends State<_TestGeneratorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedLanguage = 'dart';
  String _selectedFramework = 'flutter';
  String _testType = 'comprehensive';
  bool _includeEdgeCases = true;
  bool _includePerformanceTests = false;
  bool _includeSecurityTests = false;
  bool _isGenerating = false;

  final List<String> _languages = [
    'dart', 'javascript', 'python', 'java', 'typescript', 'go', 'rust'
  ];
  
  final List<String> _frameworks = [
    'flutter', 'react', 'vue', 'angular', 'spring', 'express', 'django'
  ];
  
  final List<String> _testTypes = [
    'comprehensive', 'unit', 'integration', 'performance', 'security'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: _isGenerating ? _buildGeneratingView() : _buildForm(),
            ),
            const SizedBox(height: 24),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'AI测试用例生成器',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCodeInput(),
            const SizedBox(height: 20),
            _buildDescriptionInput(),
            const SizedBox(height: 20),
            _buildLanguageSelector(),
            const SizedBox(height: 20),
            _buildFrameworkSelector(),
            const SizedBox(height: 20),
            _buildTestTypeSelector(),
            const SizedBox(height: 20),
            _buildOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '源代码',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _codeController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: '请输入要生成测试用例的源代码...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入源代码';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '功能描述（可选）',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: '描述代码的功能和预期行为...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '编程语言',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedLanguage,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          items: _languages.map((language) {
            return DropdownMenuItem(
              value: language,
              child: Text(language.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildFrameworkSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '框架',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedFramework,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          items: _frameworks.map((framework) {
            return DropdownMenuItem(
              value: framework,
              child: Text(framework.toUpperCase()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedFramework = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTestTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '测试类型',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _testType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          items: _testTypes.map((type) {
            return DropdownMenuItem(
              value: type,
              child: Text(_getTestTypeDisplayName(type)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _testType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '生成选项',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('包含边界情况测试'),
          subtitle: const Text('生成边界值和异常情况的测试用例'),
          value: _includeEdgeCases,
          onChanged: (value) {
            setState(() {
              _includeEdgeCases = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('包含性能测试'),
          subtitle: const Text('生成性能基准和压力测试用例'),
          value: _includePerformanceTests,
          onChanged: (value) {
            setState(() {
              _includePerformanceTests = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('包含安全测试'),
          subtitle: const Text('生成安全漏洞和攻击测试用例'),
          value: _includeSecurityTests,
          onChanged: (value) {
            setState(() {
              _includeSecurityTests = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildGeneratingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'AI正在分析代码并生成测试用例...',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '这可能需要几秒钟时间',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isGenerating ? null : () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isGenerating ? null : _generateTestCases,
            child: _isGenerating 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('生成测试用例'),
          ),
        ),
      ],
    );
  }

  String _getTestTypeDisplayName(String type) {
    switch (type) {
      case 'comprehensive':
        return '综合测试';
      case 'unit':
        return '单元测试';
      case 'integration':
        return '集成测试';
      case 'performance':
        return '性能测试';
      case 'security':
        return '安全测试';
      default:
        return type;
    }
  }

  Future<void> _generateTestCases() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    try {
      // 模拟AI生成过程
      await Future.delayed(const Duration(seconds: 3));
      
      // 这里应该调用真实的API
      final request = TestGenerationRequest(
        code: _codeController.text,
        language: _selectedLanguage,
        framework: _selectedFramework,
        testType: _testType,
        includeEdgeCases: _includeEdgeCases,
        includePerformanceTests: _includePerformanceTests,
        includeSecurityTests: _includeSecurityTests,
        options: {
          'description': _descriptionController.text,
        },
      );

      // 模拟生成的测试用例
      final mockTestCases = _generateMockTestCases(request);
      
      setState(() {
        _isGenerating = false;
      });

      Navigator.of(context).pop();
      _showResults(context, mockTestCases);
      
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('生成失败: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  List<TestCase> _generateMockTestCases(TestGenerationRequest request) {
    // 模拟生成测试用例
    return [
      TestCase(
        id: 'test_1',
        name: '${request.language.toUpperCase()} 基础功能测试',
        description: '测试${request.language}代码的基本功能',
        code: _generateMockTestCode(request.language, 'basic'),
        type: 'unit',
        tags: ['basic', 'unit'],
        priority: 1,
        isAutomated: true,
      ),
      TestCase(
        id: 'test_2',
        name: '${request.language.toUpperCase()} 边界情况测试',
        description: '测试边界值和异常情况',
        code: _generateMockTestCode(request.language, 'edge'),
        type: 'unit',
        tags: ['edge', 'boundary'],
        priority: 2,
        isAutomated: true,
      ),
      if (request.includePerformanceTests)
        TestCase(
          id: 'test_3',
          name: '${request.language.toUpperCase()} 性能测试',
          description: '测试代码性能和响应时间',
          code: _generateMockTestCode(request.language, 'performance'),
          type: 'performance',
          tags: ['performance', 'benchmark'],
          priority: 3,
          isAutomated: true,
        ),
      if (request.includeSecurityTests)
        TestCase(
          id: 'test_4',
          name: '${request.language.toUpperCase()} 安全测试',
          description: '测试安全漏洞和攻击防护',
          code: _generateMockTestCode(request.language, 'security'),
          type: 'security',
          tags: ['security', 'vulnerability'],
          priority: 4,
          isAutomated: true,
        ),
    ];
  }

  String _generateMockTestCode(String language, String type) {
    switch (language) {
      case 'dart':
        return _generateDartTestCode(type);
      case 'javascript':
        return _generateJavaScriptTestCode(type);
      case 'python':
        return _generatePythonTestCode(type);
      default:
        return _generateGenericTestCode(language, type);
    }
  }

  String _generateDartTestCode(String type) {
    switch (type) {
      case 'basic':
        return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/your_file.dart';

void main() {
  group('基础功能测试', () {
    test('应该正确执行基本功能', () {
      // Arrange
      final input = 'test input';
      
      // Act
      final result = yourFunction(input);
      
      // Assert
      expect(result, isNotNull);
      expect(result, isA<String>());
    });
  });
}
''';
      case 'edge':
        return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/your_file.dart';

void main() {
  group('边界情况测试', () {
    test('应该处理空输入', () {
      expect(() => yourFunction(''), throwsArgumentError);
    });
    
    test('应该处理null输入', () {
      expect(() => yourFunction(null), throwsArgumentError);
    });
  });
}
''';
      case 'performance':
        return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/your_file.dart';

void main() {
  group('性能测试', () {
    test('应该在合理时间内完成', () {
      final stopwatch = Stopwatch()..start();
      
      yourFunction('performance test');
      
      stopwatch.stop();
      expect(stopwatch.elapsedMilliseconds, lessThan(100));
    });
  });
}
''';
      case 'security':
        return '''
import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/your_file.dart';

void main() {
  group('安全测试', () {
    test('应该防止SQL注入', () {
      final maliciousInput = "'; DROP TABLE users; --";
      
      expect(() => yourFunction(maliciousInput), throwsFormatException);
    });
  });
}
''';
      default:
        return '// 测试代码';
    }
  }

  String _generateJavaScriptTestCode(String type) {
    return '''
describe('${type}测试', () => {
  test('应该正确执行功能', () => {
    // 测试实现
  });
});
''';
  }

  String _generatePythonTestCode(String type) {
    return '''
import unittest

class TestYourFunction(unittest.TestCase):
    def test_${type}_functionality(self):
        # 测试实现
        pass
''';
  }

  String _generateGenericTestCode(String language, String type) {
    return '''
// ${language.toUpperCase()} ${type}测试
// 测试实现
''';
  }

  void _showResults(BuildContext context, List<TestCase> testCases) {
    showDialog(
      context: context,
      builder: (context) => _TestResultsDialog(testCases: testCases),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// 测试结果对话框
class _TestResultsDialog extends StatelessWidget {
  final List<TestCase> testCases;

  const _TestResultsDialog({required this.testCases});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '生成的测试用例 (${testCases.length}个)',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: testCases.length,
                itemBuilder: (context, index) {
                  final testCase = testCases[index];
                  return _TestResultCard(testCase: testCase);
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _exportTestCases(context),
                    icon: const Icon(Icons.download),
                    label: const Text('导出'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _copyToClipboard(context),
                    icon: const Icon(Icons.copy),
                    label: const Text('复制'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _exportTestCases(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('测试用例已导出')),
    );
  }

  void _copyToClipboard(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('测试用例已复制到剪贴板')),
    );
  }
}

// 测试结果卡片
class _TestResultCard extends StatelessWidget {
  final TestCase testCase;

  const _TestResultCard({required this.testCase});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          testCase.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(testCase.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildTag(context, testCase.type),
                    const SizedBox(width: 8),
                    _buildTag(context, '优先级: ${testCase.priority}'),
                    const Spacer(),
                    if (testCase.isAutomated)
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.borderColor),
                  ),
                  child: Text(
                    testCase.code,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppTheme.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
