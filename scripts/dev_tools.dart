#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// QAToolBox 开发工具套件
/// 提供开发、测试、部署的一站式解决方案
class DevTools {
  static const String version = '1.0.0';
  
  /// 主入口函数
  static Future<void> main(List<String> args) async {
    print('🛠️  QAToolBox 开发工具套件 v$version');
    print('=========================================');
    
    if (args.isEmpty) {
      await _showHelp();
      return;
    }
    
    final command = args[0];
    final subArgs = args.skip(1).toList();
    
    switch (command) {
      case 'init':
        await _initProject(subArgs);
        break;
      case 'generate':
        await _generateCode(subArgs);
        break;
      case 'dev':
        await _startDev(subArgs);
        break;
      case 'build':
        await _buildProject(subArgs);
        break;
      case 'test':
        await _runTests(subArgs);
        break;
      case 'deploy':
        await _deployProject(subArgs);
        break;
      case 'clean':
        await _cleanProject(subArgs);
        break;
      case 'doctor':
        await _checkHealth(subArgs);
        break;
      case 'version':
        await _showVersion();
        break;
      default:
        print('❌ 未知命令: $command');
        await _showHelp();
    }
  }
  
  /// 初始化项目
  static Future<void> _initProject(List<String> args) async {
    print('🚀 初始化QAToolBox项目...');
    
    // 1. 检查环境
    await _checkEnvironment();
    
    // 2. 安装依赖
    await _installDependencies();
    
    // 3. 初始化数据库
    await _initDatabase();
    
    // 4. 生成初始配置
    await _generateInitialConfig();
    
    print('✅ 项目初始化完成！');
    print('');
    print('接下来你可以：');
    print('  dart scripts/dev_tools.dart generate    # 生成应用代码');
    print('  dart scripts/dev_tools.dart dev         # 启动开发服务器');
    print('  dart scripts/dev_tools.dart test        # 运行测试');
  }
  
  /// 检查开发环境
  static Future<void> _checkEnvironment() async {
    print('🔍 检查开发环境...');
    
    // 检查Flutter
    final flutterResult = await Process.run('flutter', ['--version']);
    if (flutterResult.exitCode != 0) {
      throw Exception('Flutter未安装或配置错误');
    }
    print('✅ Flutter: 已安装');
    
    // 检查Dart
    final dartResult = await Process.run('dart', ['--version']);
    if (dartResult.exitCode != 0) {
      throw Exception('Dart未安装或配置错误');
    }
    print('✅ Dart: 已安装');
    
    // 检查Docker
    final dockerResult = await Process.run('docker', ['--version']);
    if (dockerResult.exitCode != 0) {
      print('⚠️  Docker未安装，部分功能将不可用');
    } else {
      print('✅ Docker: 已安装');
    }
    
    // 检查Go (用于后端服务)
    final goResult = await Process.run('go', ['version']);
    if (goResult.exitCode != 0) {
      print('⚠️  Go未安装，无法构建后端服务');
    } else {
      print('✅ Go: 已安装');
    }
  }
  
  /// 安装依赖
  static Future<void> _installDependencies() async {
    print('📦 安装依赖...');
    
    // Flutter依赖
    final pubGetResult = await Process.run('flutter', ['pub', 'get']);
    if (pubGetResult.exitCode != 0) {
      throw Exception('Flutter依赖安装失败');
    }
    print('✅ Flutter依赖安装完成');
    
    // 代码生成
    final buildRunnerResult = await Process.run('dart', ['run', 'build_runner', 'build']);
    if (buildRunnerResult.exitCode != 0) {
      print('⚠️  代码生成失败，请手动运行: dart run build_runner build');
    } else {
      print('✅ 代码生成完成');
    }
  }
  
  /// 初始化数据库
  static Future<void> _initDatabase() async {
    print('🗄️ 初始化数据库...');
    
    // 检查Docker是否运行
    final dockerPsResult = await Process.run('docker', ['ps']);
    if (dockerPsResult.exitCode != 0) {
      print('⚠️  Docker未运行，跳过数据库初始化');
      return;
    }
    
    // 启动数据库服务
    final composeResult = await Process.run('docker-compose', ['up', '-d', 'postgres', 'redis']);
    if (composeResult.exitCode != 0) {
      print('⚠️  数据库服务启动失败');
      return;
    }
    
    // 等待数据库就绪
    print('⏳ 等待数据库就绪...');
    await Future.delayed(Duration(seconds: 10));
    
    // 运行数据库迁移
    final migrationResult = await Process.run('docker-compose', ['exec', 'postgres', 'psql', '-U', 'postgres', '-f', '/docker-entrypoint-initdb.d/init.sql']);
    if (migrationResult.exitCode == 0) {
      print('✅ 数据库初始化完成');
    } else {
      print('⚠️  数据库迁移失败');
    }
  }
  
  /// 生成初始配置
  static Future<void> _generateInitialConfig() async {
    print('⚙️ 生成初始配置...');
    
    // 创建.env文件
    final envFile = File('.env');
    if (!await envFile.exists()) {
      final envContent = '''
# 开发环境配置
FLUTTER_ENV=development
DATABASE_URL=postgresql://postgres:password@localhost:5432/qatoolbox
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_jwt_secret_here
OPENAI_API_KEY=your_openai_api_key_here

# 服务端口配置
AUTH_SERVICE_PORT=8001
USER_SERVICE_PORT=8002
PAYMENT_SERVICE_PORT=8003
NOTIFICATION_SERVICE_PORT=8004
ANALYTICS_SERVICE_PORT=8005

# 应用服务端口
QA_TOOLBOX_SERVICE_PORT=8010
LIFE_MODE_SERVICE_PORT=8011
FIT_TRACKER_SERVICE_PORT=8012
SOCIAL_HUB_SERVICE_PORT=8013
CREATIVE_STUDIO_SERVICE_PORT=8014
''';
      await envFile.writeAsString(envContent);
      print('✅ 环境配置文件已创建');
    }
    
    // 创建本地配置文件
    final localConfigFile = File('config/local.yaml');
    if (!await localConfigFile.exists()) {
      await localConfigFile.parent.create(recursive: true);
      final localConfigContent = '''
# 本地开发配置
debug: true
hot_reload: true
mock_ai: true
skip_auth: true

# 开发者选项
auto_generate: true
watch_files: true
enable_logging: true
log_level: debug
''';
      await localConfigFile.writeAsString(localConfigContent);
      print('✅ 本地配置文件已创建');
    }
  }
  
  /// 生成代码
  static Future<void> _generateCode(List<String> args) async {
    print('🔧 生成应用代码...');
    
    if (args.isEmpty) {
      // 生成所有应用
      final result = await Process.run('dart', ['scripts/enhanced_generator.dart', 'batch', '--ai', '--verbose']);
      print(result.stdout);
      if (result.stderr.isNotEmpty) {
        print('错误输出: ${result.stderr}');
      }
    } else {
      // 生成特定应用
      final appId = args[0];
      final result = await Process.run('dart', ['scripts/enhanced_generator.dart', 'create', appId, '--ai', '--verbose']);
      print(result.stdout);
      if (result.stderr.isNotEmpty) {
        print('错误输出: ${result.stderr}');
      }
    }
  }
  
  /// 启动开发服务器
  static Future<void> _startDev(List<String> args) async {
    print('🚀 启动开发环境...');
    
    // 启动后端服务
    print('📡 启动后端服务...');
    final backendProcess = await Process.start('docker-compose', ['up', '--build']);
    
    // 等待服务启动
    await Future.delayed(Duration(seconds: 15));
    
    // 启动Flutter应用
    print('📱 启动Flutter应用...');
    final platform = args.isNotEmpty ? args[0] : 'chrome';
    final flutterProcess = await Process.start('flutter', ['run', '-d', platform, '--hot']);
    
    // 监听进程输出
    backendProcess.stdout.listen((data) {
      print('[后端] ${String.fromCharCodes(data)}');
    });
    
    flutterProcess.stdout.listen((data) {
      print('[前端] ${String.fromCharCodes(data)}');
    });
    
    print('🎉 开发环境启动完成！');
    print('');
    print('📊 服务地址:');
    print('  前端应用: http://localhost:8080');
    print('  API网关: http://localhost:80');
    print('  监控面板: http://localhost:3000');
    print('  数据库: localhost:5432');
    print('');
    print('按 Ctrl+C 停止服务');
    
    // 等待用户中断
    await flutterProcess.exitCode;
  }
  
  /// 构建项目
  static Future<void> _buildProject(List<String> args) async {
    print('🔨 构建项目...');
    
    final target = args.isNotEmpty ? args[0] : 'all';
    
    switch (target) {
      case 'flutter':
      case 'app':
        await _buildFlutter(args.skip(1).toList());
        break;
      case 'backend':
      case 'services':
        await _buildBackend(args.skip(1).toList());
        break;
      case 'docker':
        await _buildDocker(args.skip(1).toList());
        break;
      case 'all':
      default:
        await _buildFlutter([]);
        await _buildBackend([]);
        await _buildDocker([]);
        break;
    }
  }
  
  /// 构建Flutter应用
  static Future<void> _buildFlutter(List<String> args) async {
    print('📱 构建Flutter应用...');
    
    final platforms = args.isNotEmpty ? args : ['apk', 'web'];
    
    for (final platform in platforms) {
      print('🔄 构建$platform版本...');
      final result = await Process.run('flutter', ['build', platform]);
      if (result.exitCode == 0) {
        print('✅ $platform构建成功');
      } else {
        print('❌ $platform构建失败: ${result.stderr}');
      }
    }
  }
  
  /// 构建后端服务
  static Future<void> _buildBackend(List<String> args) async {
    print('⚙️ 构建后端服务...');
    
    final servicesDir = Directory('backend/services');
    if (!await servicesDir.exists()) {
      print('⚠️  后端服务目录不存在，跳过构建');
      return;
    }
    
    await for (final entity in servicesDir.list()) {
      if (entity is Directory) {
        final serviceName = entity.path.split('/').last;
        print('🔄 构建服务: $serviceName');
        
        final result = await Process.run('go', ['build', '-o', 'bin/$serviceName', '.'], 
          workingDirectory: entity.path);
        
        if (result.exitCode == 0) {
          print('✅ $serviceName构建成功');
        } else {
          print('❌ $serviceName构建失败: ${result.stderr}');
        }
      }
    }
  }
  
  /// 构建Docker镜像
  static Future<void> _buildDocker(List<String> args) async {
    print('🐳 构建Docker镜像...');
    
    final result = await Process.run('make', ['docker-build']);
    if (result.exitCode == 0) {
      print('✅ Docker镜像构建成功');
      print(result.stdout);
    } else {
      print('❌ Docker镜像构建失败: ${result.stderr}');
    }
  }
  
  /// 运行测试
  static Future<void> _runTests(List<String> args) async {
    print('🧪 运行测试...');
    
    final testType = args.isNotEmpty ? args[0] : 'all';
    
    switch (testType) {
      case 'unit':
        await _runUnitTests();
        break;
      case 'widget':
        await _runWidgetTests();
        break;
      case 'integration':
        await _runIntegrationTests();
        break;
      case 'backend':
        await _runBackendTests();
        break;
      case 'all':
      default:
        await _runUnitTests();
        await _runWidgetTests();
        await _runBackendTests();
        break;
    }
  }
  
  /// 运行单元测试
  static Future<void> _runUnitTests() async {
    print('📋 运行单元测试...');
    
    final result = await Process.run('flutter', ['test', '--coverage']);
    if (result.exitCode == 0) {
      print('✅ 单元测试通过');
      
      // 生成覆盖率报告
      final coverageResult = await Process.run('genhtml', ['coverage/lcov.info', '-o', 'coverage/html']);
      if (coverageResult.exitCode == 0) {
        print('📊 覆盖率报告生成完成: coverage/html/index.html');
      }
    } else {
      print('❌ 单元测试失败: ${result.stderr}');
    }
  }
  
  /// 运行Widget测试
  static Future<void> _runWidgetTests() async {
    print('🎨 运行Widget测试...');
    
    final result = await Process.run('flutter', ['test', 'test/widget_test.dart']);
    if (result.exitCode == 0) {
      print('✅ Widget测试通过');
    } else {
      print('❌ Widget测试失败: ${result.stderr}');
    }
  }
  
  /// 运行集成测试
  static Future<void> _runIntegrationTests() async {
    print('🔗 运行集成测试...');
    
    final testDir = Directory('integration_test');
    if (!await testDir.exists()) {
      print('⚠️  集成测试目录不存在，跳过测试');
      return;
    }
    
    final result = await Process.run('flutter', ['test', 'integration_test']);
    if (result.exitCode == 0) {
      print('✅ 集成测试通过');
    } else {
      print('❌ 集成测试失败: ${result.stderr}');
    }
  }
  
  /// 运行后端测试
  static Future<void> _runBackendTests() async {
    print('⚙️ 运行后端测试...');
    
    final servicesDir = Directory('backend/services');
    if (!await servicesDir.exists()) {
      print('⚠️  后端服务目录不存在，跳过测试');
      return;
    }
    
    await for (final entity in servicesDir.list()) {
      if (entity is Directory) {
        final serviceName = entity.path.split('/').last;
        print('🔄 测试服务: $serviceName');
        
        final result = await Process.run('go', ['test', './...', '-v'], 
          workingDirectory: entity.path);
        
        if (result.exitCode == 0) {
          print('✅ $serviceName测试通过');
        } else {
          print('❌ $serviceName测试失败: ${result.stderr}');
        }
      }
    }
  }
  
  /// 部署项目
  static Future<void> _deployProject(List<String> args) async {
    print('🚢 部署项目...');
    
    final environment = args.isNotEmpty ? args[0] : 'staging';
    final version = args.length > 1 ? args[1] : 'latest';
    
    print('🎯 部署环境: $environment');
    print('📦 版本: $version');
    
    switch (environment) {
      case 'staging':
        await _deployToStaging(version);
        break;
      case 'production':
        await _deployToProduction(version);
        break;
      case 'local':
        await _deployToLocal(version);
        break;
      default:
        print('❌ 未知部署环境: $environment');
        print('支持的环境: staging, production, local');
    }
  }
  
  /// 部署到测试环境
  static Future<void> _deployToStaging(String version) async {
    print('🧪 部署到测试环境...');
    
    // 构建项目
    await _buildProject(['all']);
    
    // 部署到K8s
    final result = await Process.run('kubectl', ['apply', '-f', 'k8s/', '--namespace=qatoolbox-staging']);
    if (result.exitCode == 0) {
      print('✅ 部署到测试环境成功');
    } else {
      print('❌ 部署失败: ${result.stderr}');
    }
  }
  
  /// 部署到生产环境
  static Future<void> _deployToProduction(String version) async {
    print('🏭 部署到生产环境...');
    
    // 安全检查
    print('⚠️  即将部署到生产环境，请确认：');
    print('  - 所有测试均已通过');
    print('  - 代码已经过review');
    print('  - 数据库备份已完成');
    print('');
    print('继续部署? (yes/no): ');
    
    final confirmation = stdin.readLineSync();
    if (confirmation?.toLowerCase() != 'yes') {
      print('❌ 部署已取消');
      return;
    }
    
    // 构建项目
    await _buildProject(['all']);
    
    // 部署到K8s
    final result = await Process.run('kubectl', ['apply', '-f', 'k8s/', '--namespace=qatoolbox-production']);
    if (result.exitCode == 0) {
      print('✅ 部署到生产环境成功');
    } else {
      print('❌ 部署失败: ${result.stderr}');
    }
  }
  
  /// 本地部署
  static Future<void> _deployToLocal(String version) async {
    print('🏠 本地部署...');
    
    final result = await Process.run('docker-compose', ['up', '--build', '-d']);
    if (result.exitCode == 0) {
      print('✅ 本地部署成功');
      print('🌐 访问地址: http://localhost');
    } else {
      print('❌ 本地部署失败: ${result.stderr}');
    }
  }
  
  /// 清理项目
  static Future<void> _cleanProject(List<String> args) async {
    print('🧹 清理项目...');
    
    final cleanType = args.isNotEmpty ? args[0] : 'all';
    
    switch (cleanType) {
      case 'flutter':
        await _cleanFlutter();
        break;
      case 'backend':
        await _cleanBackend();
        break;
      case 'docker':
        await _cleanDocker();
        break;
      case 'all':
      default:
        await _cleanFlutter();
        await _cleanBackend();
        await _cleanDocker();
        break;
    }
    
    print('✅ 清理完成');
  }
  
  /// 清理Flutter
  static Future<void> _cleanFlutter() async {
    await Process.run('flutter', ['clean']);
    await Process.run('flutter', ['pub', 'get']);
    print('✅ Flutter清理完成');
  }
  
  /// 清理后端
  static Future<void> _cleanBackend() async {
    final result = await Process.run('make', ['clean']);
    if (result.exitCode == 0) {
      print('✅ 后端清理完成');
    }
  }
  
  /// 清理Docker
  static Future<void> _cleanDocker() async {
    await Process.run('docker-compose', ['down', '--volumes']);
    await Process.run('docker', ['system', 'prune', '-f']);
    print('✅ Docker清理完成');
  }
  
  /// 健康检查
  static Future<void> _checkHealth(List<String> args) async {
    print('🏥 系统健康检查...');
    
    // 检查开发环境
    await _checkEnvironment();
    
    // 检查项目配置
    await _checkProjectConfig();
    
    // 检查服务状态
    await _checkServices();
    
    // 检查数据库连接
    await _checkDatabase();
    
    print('✅ 健康检查完成');
  }
  
  /// 检查项目配置
  static Future<void> _checkProjectConfig() async {
    print('⚙️ 检查项目配置...');
    
    final requiredFiles = [
      'pubspec.yaml',
      'config/apps.yaml',
      'config/services.yaml',
      'config/templates.yaml',
    ];
    
    for (final file in requiredFiles) {
      if (await File(file).exists()) {
        print('✅ $file: 存在');
      } else {
        print('❌ $file: 缺失');
      }
    }
  }
  
  /// 检查服务状态
  static Future<void> _checkServices() async {
    print('📡 检查服务状态...');
    
    final services = [
      'http://localhost:8001/health',  // Auth Service
      'http://localhost:8002/health',  // User Service
      'http://localhost:8010/health',  // QA Toolbox
    ];
    
    for (final service in services) {
      try {
        final result = await Process.run('curl', ['-s', '-o', '/dev/null', '-w', '%{http_code}', service]);
        if (result.stdout.toString().trim() == '200') {
          print('✅ $service: 正常');
        } else {
          print('❌ $service: 异常 (${result.stdout})');
        }
      } catch (e) {
        print('❌ $service: 无法连接');
      }
    }
  }
  
  /// 检查数据库
  static Future<void> _checkDatabase() async {
    print('🗄️ 检查数据库连接...');
    
    try {
      final result = await Process.run('docker-compose', ['exec', '-T', 'postgres', 'pg_isready', '-U', 'postgres']);
      if (result.exitCode == 0) {
        print('✅ PostgreSQL: 连接正常');
      } else {
        print('❌ PostgreSQL: 连接异常');
      }
    } catch (e) {
      print('❌ PostgreSQL: 无法检查连接');
    }
    
    try {
      final result = await Process.run('docker-compose', ['exec', '-T', 'redis', 'redis-cli', 'ping']);
      if (result.stdout.toString().trim() == 'PONG') {
        print('✅ Redis: 连接正常');
      } else {
        print('❌ Redis: 连接异常');
      }
    } catch (e) {
      print('❌ Redis: 无法检查连接');
    }
  }
  
  /// 显示版本信息
  static Future<void> _showVersion() async {
    print('QAToolBox 开发工具套件');
    print('版本: $version');
    print('');
    print('组件版本:');
    
    // Flutter版本
    final flutterResult = await Process.run('flutter', ['--version']);
    if (flutterResult.exitCode == 0) {
      final flutterVersion = flutterResult.stdout.toString().split('\\n')[0];
      print('  $flutterVersion');
    }
    
    // Dart版本
    final dartResult = await Process.run('dart', ['--version']);
    if (dartResult.exitCode == 0) {
      print('  ${dartResult.stdout.toString().trim()}');
    }
  }
  
  /// 显示帮助信息
  static Future<void> _showHelp() async {
    print('''
QAToolBox 开发工具套件 - 一站式开发解决方案

用法:
  dart scripts/dev_tools.dart <command> [options]

命令:
  init                          初始化项目环境
  generate [app_id]             生成应用代码
  dev [platform]                启动开发环境
  build [target]                构建项目
  test [type]                   运行测试
  deploy [env] [version]        部署项目
  clean [type]                  清理项目
  doctor                        健康检查
  version                       显示版本信息

示例:
  dart scripts/dev_tools.dart init                      # 初始化项目
  dart scripts/dev_tools.dart generate qa_toolbox       # 生成QA工具箱应用
  dart scripts/dev_tools.dart dev chrome                # 在Chrome中启动开发
  dart scripts/dev_tools.dart build flutter             # 构建Flutter应用
  dart scripts/dev_tools.dart test unit                 # 运行单元测试
  dart scripts/dev_tools.dart deploy staging v1.0.0     # 部署到测试环境
  dart scripts/dev_tools.dart clean all                 # 清理所有缓存
  dart scripts/dev_tools.dart doctor                    # 系统健康检查

更多信息请访问: https://github.com/qatoolbox
''');
  }
}

/// 主入口
void main(List<String> args) async {
  try {
    await DevTools.main(args);
  } catch (e) {
    print('❌ 执行失败: $e');
    exit(1);
  }
}
