import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_themes.dart';
import 'core/router/app_router.dart';

void main() {
  // 设置QA ToolBox主题
  AppConfig.setFlavor(AppFlavor.qaToolbox);
  
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: 'QA ToolBox Pro',
      theme: AppThemeManager.getThemeForApp('qa_toolbox'),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
