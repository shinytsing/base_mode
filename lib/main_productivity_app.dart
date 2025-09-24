import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/theme/app_themes.dart';
import 'core/router/app_router.dart';

void main() {
  // 设置Productivity App主题
  AppConfig.setFlavor(AppFlavor.productivityApp);
  
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
      title: 'SocialHub',
      theme: AppThemeManager.getThemeForApp('social_hub'),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
