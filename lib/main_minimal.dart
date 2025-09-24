import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化屏幕适配
  await ScreenUtil.ensureScreenSize();
  
  runApp(
    ProviderScope(
      child: QAToolBoxApp(),
    ),
  );
}

class QAToolBoxApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'CreativeStudio',
          debugShowCheckedModeBanner: false,
          theme: AppThemeManager.getThemeForApp('creative_studio'),
          home: const MainScreen(),
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CreativeStudio'),
        backgroundColor: CreativeStudioTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '欢迎使用 CreativeStudio',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: CreativeStudioTheme.primaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '功能模块',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildFeatureItem(
                      icon: Icons.palette,
                      title: '创意设计',
                      description: 'AI驱动的创意设计工具',
                    ),
                    SizedBox(height: 8.h),
                    _buildFeatureItem(
                      icon: Icons.music_note,
                      title: '音乐创作',
                      description: '智能音乐制作和编辑',
                    ),
                    SizedBox(height: 8.h),
                    _buildFeatureItem(
                      icon: Icons.videocam,
                      title: '视频制作',
                      description: '专业视频编辑和特效',
                    ),
                    SizedBox(height: 8.h),
                    _buildFeatureItem(
                      icon: Icons.edit,
                      title: '文字创作',
                      description: 'AI辅助写作和内容生成',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '快速操作',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('创意设计功能开发中...')),
                              );
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('新建项目'),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('音乐创作功能开发中...')),
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('开始创作'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: CreativeStudioTheme.primaryColor,
          size: 20.sp,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
