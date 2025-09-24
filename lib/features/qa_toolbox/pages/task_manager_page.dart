import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/qa_toolbox_provider.dart';
import '../models/qa_toolbox_model.dart';

class TaskManagerPage extends ConsumerWidget {
  const TaskManagerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(qa_toolboxProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('任务管理器'),
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
        tooltip: '开始任务管理器',
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
                        '任务管理器',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '智能化的任务管理器功能，让您的工作更高效',
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
    // 显示任务管理器对话框
    _showTaskManagerDialog(context, ref);
  }

  void _showTaskManagerDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _TaskManagerDialog(),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('任务管理器帮助'),
        content: const Text(
          '这是任务管理器功能的帮助信息。\n\n'
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
        content: Text('查看任务管理器历史记录'),
      ),
    );
  }

  void _exportResults(BuildContext context) {
    // 导出结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('导出任务管理器结果'),
      ),
    );
  }

  void _shareResults(BuildContext context) {
    // 分享结果
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('分享任务管理器结果'),
      ),
    );
  }
}

// 任务管理器对话框
class _TaskManagerDialog extends StatefulWidget {
  @override
  _TaskManagerDialogState createState() => _TaskManagerDialogState();
}

class _TaskManagerDialogState extends State<_TaskManagerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _projectDescriptionController = TextEditingController();
  final _taskTitleController = TextEditingController();
  final _taskDescriptionController = TextEditingController();
  
  String _selectedPriority = 'medium';
  String _selectedStatus = 'todo';
  DateTime? _selectedDueDate;
  bool _isCreatingProject = true;
  bool _isLoading = false;

  final List<String> _priorities = ['low', 'medium', 'high', 'urgent'];
  final List<String> _statuses = ['todo', 'in_progress', 'review', 'done'];

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
              child: _isLoading ? _buildLoadingView() : _buildContent(),
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
            '任务管理器',
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

  Widget _buildContent() {
    return Column(
      children: [
        _buildModeSelector(),
        const SizedBox(height: 20),
        Expanded(
          child: _isCreatingProject ? _buildProjectForm() : _buildTaskForm(),
        ),
      ],
    );
  }

  Widget _buildModeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('创建项目'),
                subtitle: const Text('新建项目并添加任务'),
                value: true,
                groupValue: _isCreatingProject,
                onChanged: (value) {
                  setState(() {
                    _isCreatingProject = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text('添加任务'),
                subtitle: const Text('向现有项目添加任务'),
                value: false,
                groupValue: _isCreatingProject,
                onChanged: (value) {
                  setState(() {
                    _isCreatingProject = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectInputs(),
            const SizedBox(height: 20),
            _buildTaskInputs(),
            const SizedBox(height: 20),
            _buildTaskOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectSelector(),
            const SizedBox(height: 20),
            _buildTaskInputs(),
            const SizedBox(height: 20),
            _buildTaskOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '项目信息',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _projectNameController,
          decoration: InputDecoration(
            labelText: '项目名称',
            hintText: '输入项目名称',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入项目名称';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _projectDescriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: '项目描述',
            hintText: '描述项目目标和范围',
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

  Widget _buildProjectSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择项目',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: '项目',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          items: [
            'QAToolBox Pro 开发',
            'PDF转换器优化',
            '测试用例生成器',
            '网络爬虫项目',
          ].map((project) {
            return DropdownMenuItem(
              value: project,
              child: Text(project),
            );
          }).toList(),
          onChanged: (value) {
            // 处理项目选择
          },
        ),
      ],
    );
  }

  Widget _buildTaskInputs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '任务信息',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _taskTitleController,
          decoration: InputDecoration(
            labelText: '任务标题',
            hintText: '输入任务标题',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '请输入任务标题';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _taskDescriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: '任务描述',
            hintText: '详细描述任务内容和要求',
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

  Widget _buildTaskOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '任务选项',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: '优先级',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                ),
                items: _priorities.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(_getPriorityDisplayName(priority)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: '状态',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: AppTheme.surfaceColor,
                ),
                items: _statuses.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusDisplayName(status)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: _selectDueDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderColor),
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.surfaceColor,
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppTheme.primaryColor),
                const SizedBox(width: 12),
                Text(
                  _selectedDueDate != null
                      ? '截止日期: ${_formatDate(_selectedDueDate!)}'
                      : '选择截止日期（可选）',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            '正在创建${_isCreatingProject ? '项目' : '任务'}...',
            style: Theme.of(context).textTheme.titleMedium,
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
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _createProjectOrTask,
            child: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isCreatingProject ? '创建项目' : '添加任务'),
          ),
        ),
      ],
    );
  }

  String _getPriorityDisplayName(String priority) {
    switch (priority) {
      case 'low':
        return '低';
      case 'medium':
        return '中';
      case 'high':
        return '高';
      case 'urgent':
        return '紧急';
      default:
        return priority;
    }
  }

  String _getStatusDisplayName(String status) {
    switch (status) {
      case 'todo':
        return '待办';
      case 'in_progress':
        return '进行中';
      case 'review':
        return '审核中';
      case 'done':
        return '已完成';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDueDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    
    if (date != null) {
      setState(() {
        _selectedDueDate = date;
      });
    }
  }

  Future<void> _createProjectOrTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 模拟创建过程
      await Future.delayed(const Duration(seconds: 2));
      
      if (_isCreatingProject) {
        // 创建项目
        final project = Project(
          id: 'proj_${DateTime.now().millisecondsSinceEpoch}',
          name: _projectNameController.text,
          description: _projectDescriptionController.text,
          status: 'active',
          ownerId: 'user_1',
          memberIds: ['user_1'],
          taskCount: 1,
          completedTasks: 0,
          createdAt: DateTime.now(),
        );

        // 创建任务
        final task = Task(
          id: 'task_${DateTime.now().millisecondsSinceEpoch}',
          projectId: project.id,
          title: _taskTitleController.text,
          description: _taskDescriptionController.text,
          status: _selectedStatus,
          priority: _selectedPriority,
          assigneeId: 'user_1',
          creatorId: 'user_1',
          dueDate: _selectedDueDate,
          createdAt: DateTime.now(),
        );

        Navigator.of(context).pop();
        _showSuccessDialog(context, '项目创建成功', '项目"${project.name}"已创建，包含1个任务');
        
      } else {
        // 只创建任务
        final task = Task(
          id: 'task_${DateTime.now().millisecondsSinceEpoch}',
          projectId: 'selected_project',
          title: _taskTitleController.text,
          description: _taskDescriptionController.text,
          status: _selectedStatus,
          priority: _selectedPriority,
          assigneeId: 'user_1',
          creatorId: 'user_1',
          dueDate: _selectedDueDate,
          createdAt: DateTime.now(),
        );

        Navigator.of(context).pop();
        _showSuccessDialog(context, '任务创建成功', '任务"${task.title}"已添加到项目中');
      }
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('创建失败: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectDescriptionController.dispose();
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }
}
