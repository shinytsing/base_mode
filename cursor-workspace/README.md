# Cursor AI 工作区最佳实践

## 🎯 Cursor工作区配置

### 1. 项目Context设置

将以下核心文件加入Cursor的Context中：

```json
{
  "context_files": [
    "docs/architecture/project_structure.md",
    "lib/core/ui_kit/ui_kit.dart",
    "lib/core/theme/app_theme.dart",
    "lib/core/router/app_router.dart",
    "lib/core/providers/auth_provider.dart",
    "config/apps.yaml",
    "config/services.yaml",
    "scripts/enhanced_generator.dart"
  ]
}
```

### 2. 代码风格指南

#### Flutter/Dart 代码规范
```dart
// ✅ 好的命名
class QAToolBoxService {
  Future<List<TestCase>> generateTestCases(String code) async {
    // 实现逻辑
  }
}

// ❌ 避免的命名
class qa_service {
  Future<List> get_data() async {
    // 实现逻辑
  }
}
```

#### 文件组织规范
```
lib/features/qa_toolbox/
├── pages/                    # 页面文件
│   ├── qa_toolbox_page.dart
│   ├── test_case_generator_page.dart
│   └── pdf_converter_page.dart
├── widgets/                  # 组件文件
│   ├── test_case_card.dart
│   ├── pdf_converter_widget.dart
│   └── task_manager_widget.dart
├── services/                 # 服务层
│   ├── qa_toolbox_service.dart
│   ├── test_case_service.dart
│   └── pdf_service.dart
├── models/                   # 数据模型
│   ├── qa_toolbox_model.dart
│   ├── test_case_model.dart
│   └── pdf_model.dart
├── providers/                # 状态管理
│   ├── qa_toolbox_provider.dart
│   ├── test_case_provider.dart
│   └── pdf_provider.dart
└── utils/                    # 工具类
    ├── qa_toolbox_utils.dart
    └── validation_utils.dart
```

### 3. 组件使用指南

#### UI组件库使用
```dart
// 使用标准化的UI组件
import 'package:qa_toolbox_base/core/ui_kit/ui_kit.dart';

class TestCaseGeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('测试用例生成器')),
      body: Column(
        children: [
          AppCard(
            child: AppTextField(
              label: '输入代码',
              hintText: '请输入要生成测试用例的代码',
              onChanged: (value) {
                // 处理输入
              },
            ),
          ),
          SizedBox(height: 16),
          AppButton(
            text: '生成测试用例',
            onPressed: () {
              // 生成逻辑
            },
          ),
        ],
      ),
    );
  }
}
```

#### 状态管理使用
```dart
// 使用Riverpod进行状态管理
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestCaseGeneratorPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testCaseState = ref.watch(testCaseProvider);
    
    return Scaffold(
      body: testCaseState.when(
        data: (testCases) => TestCaseList(testCases: testCases),
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => ErrorWidget(error),
      ),
    );
  }
}
```

## 🚀 批量代码生成流程

### 1. 基础框架生成
```bash
# 生成应用基础框架
dart scripts/enhanced_generator.dart create qa_toolbox --ai --verbose

# 生成微服务架构
dart scripts/enhanced_generator.dart generate-microservice qa_toolbox

# 生成数据库迁移
dart scripts/enhanced_generator.dart generate-migration qa_toolbox
```

### 2. 功能模块生成
```bash
# 生成测试用例生成器功能
dart scripts/enhanced_generator.dart generate-feature qa_toolbox test_case_generator

# 生成PDF转换器功能
dart scripts/enhanced_generator.dart generate-feature qa_toolbox pdf_converter

# 生成任务管理器功能
dart scripts/enhanced_generator.dart generate-feature qa_toolbox task_manager
```

### 3. 集成和优化
```bash
# 运行集成测试
dart scripts/dev_tools.dart test integration

# 性能优化
dart scripts/dev_tools.dart optimize

# 代码质量检查
dart scripts/dev_tools.dart lint
```

## 📋 代码审查清单

### 功能完整性检查
- [ ] 所有必需的功能都已实现
- [ ] 错误处理机制完善
- [ ] 用户输入验证完整
- [ ] 边界条件处理正确

### 代码质量检查
- [ ] 代码风格符合规范
- [ ] 变量和函数命名清晰
- [ ] 注释和文档完整
- [ ] 没有重复代码

### 测试覆盖检查
- [ ] 单元测试覆盖率≥80%
- [ ] 关键业务逻辑有测试
- [ ] 错误场景有测试覆盖
- [ ] 集成测试通过

### 性能和安全检查
- [ ] 没有内存泄漏
- [ ] 网络请求有超时处理
- [ ] 敏感数据加密存储
- [ ] API接口有权限验证

## 🔧 开发工具配置

### VS Code/Cursor 设置
```json
{
  "dart.flutterSdkPath": "./flutter_sdk",
  "dart.lineLength": 120,
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "files.associations": {
    "*.yaml": "yaml",
    "*.yml": "yaml"
  }
}
```

### 代码生成模板
```dart
// 页面模板
class {{featureName}}Page extends ConsumerWidget {
  const {{featureName}}Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch({{featureId}}Provider);
    
    return Scaffold(
      appBar: AppBar(title: Text('{{featureName}}')),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, {{featureName}}State state) {
    if (state.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (state.error != null) {
      return _buildErrorView(context, ref, state.error);
    }
    
    return _buildContent(context, ref, state);
  }
}
```

## 📊 质量监控

### 代码质量指标
- **圈复杂度**: ≤ 10
- **函数长度**: ≤ 50行
- **类长度**: ≤ 500行
- **测试覆盖率**: ≥ 80%

### 性能指标
- **启动时间**: ≤ 3秒
- **页面加载**: ≤ 1秒
- **内存使用**: ≤ 100MB
- **网络请求**: ≤ 2秒超时

### 用户体验指标
- **崩溃率**: ≤ 0.1%
- **ANR率**: ≤ 0.05%
- **用户满意度**: ≥ 4.5/5
- **功能使用率**: ≥ 70%

---

**Cursor AI** - 让开发更智能！ 🤖
