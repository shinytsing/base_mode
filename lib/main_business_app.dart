import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_themes.dart';
import 'core/router/app_router.dart';

void main() {
  // 设置Business App主题
  AppConfig.setFlavor(AppFlavor.businessApp);
  
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
      title: 'LifeMode',
      theme: AppThemeManager.getThemeForApp('life_mode'),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
