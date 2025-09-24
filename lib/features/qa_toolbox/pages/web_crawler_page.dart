import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/qa_toolbox_provider.dart';
import '../models/qa_toolbox_model.dart';

class WebCrawlerPage extends ConsumerWidget {
  const WebCrawlerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qa_toolboxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('网络爬虫'),
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
        tooltip: '开始网络爬虫',
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
                        '网络爬虫',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '智能化的网络爬虫功能，让您的工作更高效',
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
    // 显示网络爬虫对话框
    _showWebCrawlerDialog(context, ref);
  }

  void _showWebCrawlerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _WebCrawlerDialog(),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('网络爬虫帮助'),
        content: const Text(
          '这是网络爬虫功能的帮助信息。\n\n'
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
        content: Text('查看网络爬虫历史记录'),
      ),
    );
  }

  void _exportResults(BuildContext context) {
    // 导出结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('导出网络爬虫结果'),
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // 分享结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('分享网络爬虫结果'),
      ),
    );
  }
}

// 网络爬虫对话框
class _WebCrawlerDialog extends StatefulWidget {
  @override
  _WebCrawlerDialogState createState() => _WebCrawlerDialogState();
}

class _WebCrawlerDialogState extends State<_WebCrawlerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();
  final _selectorsController = TextEditingController();
  
  int _maxPages = 10;
  int _delayMs = 1000;
  bool _followLinks = false;
  bool _respectRobots = true;
  bool _isCrawling = false;

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
              child: _isCrawling ? _buildCrawlingView() : _buildForm(),
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
            '网络爬虫',
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
            _buildBasicSettings(),
            const SizedBox(height: 20),
            _buildAdvancedSettings(),
            const SizedBox(height: 20),
            _buildSelectorSettings(),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '基本设置',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: '任务名称',
            hintText: '输入爬虫任务名称',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入任务名称';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _urlController,
          decoration: InputDecoration(
            labelText: '目标URL',
            hintText: 'https://example.com',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入目标URL';
            }
            if (!Uri.tryParse(value)?.hasAbsolutePath ?? true) {
              return '请输入有效的URL';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '高级设置',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '最大页面数: $_maxPages',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Slider(
                    value: _maxPages.toDouble(),
                    min: 1,
                    max: 100,
                    divisions: 99,
                    onChanged: (value) {
                      setState(() {
                        _maxPages = value.round();
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '延迟时间: ${_delayMs}ms',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Slider(
                    value: _delayMs.toDouble(),
                    min: 100,
                    max: 5000,
                    divisions: 49,
                    onChanged: (value) {
                      setState(() {
                        _delayMs = value.round();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('跟随链接'),
          subtitle: const Text('自动爬取页面中的链接'),
          value: _followLinks,
          onChanged: (value) {
            setState(() {
              _followLinks = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('遵守robots.txt'),
          subtitle: const Text('遵循网站的爬虫规则'),
          value: _respectRobots,
          onChanged: (value) {
            setState(() {
              _respectRobots = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSelectorSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '数据选择器',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _selectorsController,
          maxLines: 4,
          decoration: InputDecoration(
            labelText: 'CSS选择器',
            hintText: '输入要提取数据的CSS选择器，每行一个\n例如:\n.title\n.content\n.price',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '提示: 每行输入一个CSS选择器，用于提取特定元素的数据',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCrawlingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '正在爬取网页...',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            '已爬取 $_maxPages 个页面',
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
            onPressed: _isCrawling ? null : () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isCrawling ? null : _startCrawling,
            child: _isCrawling 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('开始爬取'),
          ),
        ),
      ],
    );
  }

  Future<void> _startCrawling() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCrawling = true;
    });

    try {
      // 模拟爬取过程
      await Future.delayed(const Duration(seconds: 5));
      
      // 创建爬虫任务
      final crawlerTask = CrawlerTask(
        id: 'crawler_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        url: _urlController.text,
        status: 'completed',
        config: {
          'maxPages': _maxPages,
          'delayMs': _delayMs,
          'followLinks': _followLinks,
          'respectRobots': _respectRobots,
        },
        selectors: _selectorsController.text.split('\n').where((s) => s.trim().isNotEmpty).toList(),
        maxPages: _maxPages,
        delayMs: _delayMs,
        followLinks: _followLinks,
        respectRobots: _respectRobots,
        createdAt: DateTime.now(),
        completedAt: DateTime.now(),
      );

      // 模拟爬取结果
      final mockResults = _generateMockCrawlerResults(crawlerTask);
      
      setState(() {
        _isCrawling = false;
      });

      Navigator.of(context).pop();
      _showCrawlerResults(context, crawlerTask, mockResults);
      
    } catch (e) {
      setState(() {
        _isCrawling = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('爬取失败: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  List<CrawlerResult> _generateMockCrawlerResults(CrawlerTask task) {
    return List.generate(task.maxPages, (index) {
      return CrawlerResult(
        id: 'result_${index + 1}',
        taskId: task.id,
        url: '${task.url}/page${index + 1}',
        data: {
          'title': '页面标题 ${index + 1}',
          'content': '这是第${index + 1}页的内容...',
          'links': ['链接1', '链接2', '链接3'],
          'images': ['图片1.jpg', '图片2.jpg'],
        },
        statusCode: 200,
        responseTime: 500 + (index * 100),
        crawledAt: DateTime.now().subtract(Duration(minutes: task.maxPages - index)),
      );
    });
  }

  void _showCrawlerResults(BuildContext context, CrawlerTask task, List<CrawlerResult> results) {
    showDialog(
      context: context,
      builder: (context) => _CrawlerResultsDialog(task: task, results: results),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _nameController.dispose();
    _selectorsController.dispose();
    super.dispose();
  }
}

// 爬虫结果对话框
class _CrawlerResultsDialog extends StatelessWidget {
  final CrawlerTask task;
  final List<CrawlerResult> results;

  const _CrawlerResultsDialog({
    required this.task,
    required this.results,
  });

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
                    '爬取结果 (${results.length}个页面)',
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
            _buildTaskInfo(context),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return _CrawlerResultCard(result: result);
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _exportResults(context),
                    icon: const Icon(Icons.download),
                    label: const Text('导出数据'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _viewDetails(context),
                    icon: const Icon(Icons.analytics),
                    label: const Text('查看详情'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '任务信息',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(context, '任务名称', task.name),
          _buildInfoRow(context, '目标URL', task.url),
          _buildInfoRow(context, '爬取页面', '${results.length} 页'),
          _buildInfoRow(context, '完成时间', _formatDateTime(task.completedAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '未知';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _exportResults(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('数据导出功能')),
    );
  }

  void _viewDetails(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('查看详细分析')),
    );
  }
}

// 爬虫结果卡片
class _CrawlerResultCard extends StatelessWidget {
  final CrawlerResult result;

  const _CrawlerResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          result.url,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('状态码: ${result.statusCode} | 响应时间: ${result.responseTime}ms'),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '提取的数据',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.data.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 80,
                          child: Text(
                            '${entry.key}:',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
