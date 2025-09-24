import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/qa_toolbox_provider.dart';
import '../models/qa_toolbox_model.dart';

class PDFConverterPage extends ConsumerWidget {
  const PDFConverterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qa_toolboxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF转换器'),
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
        tooltip: '开始PDF转换器',
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
                        'PDF转换器',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '智能化的PDF转换器功能，让您的工作更高效',
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
    // 显示PDF转换器对话框
    _showPDFConverterDialog(context, ref);
  }

  void _showPDFConverterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _PDFConverterDialog(),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('PDF转换器帮助'),
        content: const Text(
          '这是PDF转换器功能的帮助信息。\n\n'
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
        content: Text('查看PDF转换器历史记录'),
      ),
    );
  }

  void _exportResults(BuildContext context) {
    // 导出结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('导出PDF转换器结果'),
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // 分享结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('分享PDF转换器结果'),
      ),
    );
  }
}

// PDF转换器对话框
class _PDFConverterDialog extends StatefulWidget {
  @override
  _PDFConverterDialogState createState() => _PDFConverterDialogState();
}

class _PDFConverterDialogState extends State<_PDFConverterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fileUrlController = TextEditingController();
  final _passwordController = TextEditingController();
  
  String _sourceFormat = 'word';
  String _targetFormat = 'pdf';
  bool _compress = false;
  bool _encrypt = false;
  bool _isConverting = false;

  final List<String> _sourceFormats = [
    'word', 'excel', 'powerpoint', 'image', 'html', 'text'
  ];
  
  final List<String> _targetFormats = [
    'pdf', 'word', 'excel', 'powerpoint', 'image', 'html'
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
              child: _isConverting ? _buildConvertingView() : _buildForm(),
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
            'PDF转换器',
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
            _buildFileInput(),
            const SizedBox(height: 20),
            _buildFormatSelectors(),
            const SizedBox(height: 20),
            _buildOptions(),
            const SizedBox(height: 20),
            _buildPasswordInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildFileInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '文件输入',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _fileUrlController,
                decoration: InputDecoration(
                  hintText: '输入文件URL或选择本地文件',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入文件URL或选择文件';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _selectFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('选择文件'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormatSelectors() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '源格式',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _sourceFormat,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                ),
                items: _sourceFormats.map((format) {
                  return DropdownMenuItem(
                    value: format,
                    child: Text(format.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _sourceFormat = value!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Icon(Icons.arrow_forward, color: AppTheme.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '目标格式',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _targetFormat,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                ),
                items: _targetFormats.map((format) {
                  return DropdownMenuItem(
                    value: format,
                    child: Text(format.toUpperCase()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _targetFormat = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '转换选项',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          title: const Text('压缩文件'),
          subtitle: const Text('减小文件大小'),
          value: _compress,
          onChanged: (value) {
            setState(() {
              _compress = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('加密保护'),
          subtitle: const Text('为PDF添加密码保护'),
          value: _encrypt,
          onChanged: (value) {
            setState(() {
              _encrypt = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPasswordInput() {
    if (!_encrypt) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '密码设置',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: '输入PDF密码',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          validator: _encrypt ? (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入密码';
            }
            if (value.length < 6) {
              return '密码至少6位';
            }
            return null;
          } : null,
        ),
      ],
    );
  }

  Widget _buildConvertingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '正在转换文件...',
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
            onPressed: _isConverting ? null : () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isConverting ? null : _convertFile,
            child: _isConverting 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('开始转换'),
          ),
        ),
      ],
    );
  }

  void _selectFile() {
    // 模拟文件选择
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('文件选择功能')),
    );
  }

  Future<void> _convertFile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isConverting = true;
    });

    try {
      // 模拟转换过程
      await Future.delayed(const Duration(seconds: 3));
      
      // 这里应该调用真实的API
      final request = PDFConversionRequest(
        fileUrl: _fileUrlController.text,
        sourceFormat: _sourceFormat,
        targetFormat: _targetFormat,
        compress: _compress,
        encrypt: _encrypt,
        password: _encrypt ? _passwordController.text : null,
      );

      // 模拟转换结果
      final mockResult = _generateMockConversionResult(request);
      
      setState(() {
        _isConverting = false;
      });

      Navigator.of(context).pop();
      _showConversionResult(context, mockResult);
      
    } catch (e) {
      setState(() {
        _isConverting = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('转换失败: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  PDFConversionResponse _generateMockConversionResult(PDFConversionRequest request) {
    return PDFConversionResponse(
      id: 'conv_${DateTime.now().millisecondsSinceEpoch}',
      downloadUrl: 'https://example.com/converted_file.pdf',
      status: 'completed',
      fileSize: 1024 * 1024, // 1MB
      pageCount: 10,
      createdAt: DateTime.now(),
    );
  }

  void _showConversionResult(BuildContext context, PDFConversionResponse result) {
    showDialog(
      context: context,
      builder: (context) => _ConversionResultDialog(result: result),
    );
  }

  @override
  void dispose() {
    _fileUrlController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// 转换结果对话框
class _ConversionResultDialog extends StatelessWidget {
  final PDFConversionResponse result;

  const _ConversionResultDialog({required this.result});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '转换完成',
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
            _buildResultInfo(context),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _downloadFile(context),
                    icon: const Icon(Icons.download),
                    label: const Text('下载文件'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _shareFile(context),
                    icon: const Icon(Icons.share),
                    label: const Text('分享'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultInfo(BuildContext context) {
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
          _buildInfoRow(context, '状态', result.status),
          _buildInfoRow(context, '文件大小', _formatFileSize(result.fileSize)),
          _buildInfoRow(context, '页数', '${result.pageCount} 页'),
          _buildInfoRow(context, '转换时间', _formatDateTime(result.createdAt)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '未知';
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _downloadFile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('开始下载文件')),
    );
  }

  void _shareFile(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('分享文件')),
    );
  }
}
