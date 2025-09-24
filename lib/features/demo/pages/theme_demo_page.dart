import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/ui_kit/ui_kit.dart';
import '../../../core/config/app_config.dart';
import '../../../core/theme/app_theme_config.dart';

class ThemeDemoPage extends ConsumerWidget {
  const ThemeDemoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final config = AppConfig.themeConfig;

    return Scaffold(
      appBar: AppBar(
        title: Text('${config.appName} - 主题演示'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 应用信息卡片
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '应用信息',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('应用名称', config.appName),
                  _buildInfoRow('主题类型', config.name),
                  _buildInfoRow('主色调', _colorToString(config.primaryColor)),
                  _buildInfoRow('次色调', _colorToString(config.secondaryColor)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 按钮演示
            Text(
              '按钮组件',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                AppButton(
                  text: '主要按钮',
                  onPressed: () {},
                  type: AppButtonType.primary,
                ),
                AppButton(
                  text: '次要按钮',
                  onPressed: () {},
                  type: AppButtonType.secondary,
                ),
                AppButton(
                  text: '轮廓按钮',
                  onPressed: () {},
                  type: AppButtonType.outline,
                ),
                AppButton(
                  text: '文本按钮',
                  onPressed: () {},
                  type: AppButtonType.text,
                ),
                AppButton(
                  text: '危险按钮',
                  onPressed: () {},
                  type: AppButtonType.danger,
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 输入框演示
            Text(
              '输入框组件',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: '用户名',
              hint: '请输入用户名',
              prefixIcon: const Icon(Icons.person),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: '邮箱',
              hint: '请输入邮箱地址',
              type: AppTextFieldType.email,
              prefixIcon: const Icon(Icons.email),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: '密码',
              hint: '请输入密码',
              type: AppTextFieldType.password,
              prefixIcon: const Icon(Icons.lock),
            ),

            const SizedBox(height: 24),

            // 卡片演示
            Text(
              '卡片组件',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AppCard(
              type: AppCardType.elevated,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '阴影卡片',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '这是一个带有阴影效果的卡片组件。',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              type: AppCardType.outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '边框卡片',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '这是一个带有边框的卡片组件。',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              type: AppCardType.filled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '填充卡片',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '这是一个填充背景的卡片组件。',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 颜色演示
            Text(
              '主题色彩',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildColorChip('主色', config.primaryColor),
                _buildColorChip('次色', config.secondaryColor),
                _buildColorChip('错误', config.errorColor),
                _buildColorChip('表面', config.surfaceColor),
                _buildColorChip('背景', config.backgroundColor),
              ],
            ),

            const SizedBox(height: 24),

            // 功能开关演示
            Text(
              '功能开关',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                children: AppConfig.featureFlags.entries.map((entry) {
                  return SwitchListTile(
                    title: Text(entry.key),
                    subtitle: Text(entry.value ? '已启用' : '已禁用'),
                    value: entry.value,
                    onChanged: null, // 只读演示
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // 自定义配置演示
            Text(
              '自定义配置',
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AppConfig.customConfig.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.key,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            entry.value.toString(),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildColorChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _getContrastColor(color),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _colorToString(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _getContrastColor(Color color) {
    // 简单的对比色计算
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
