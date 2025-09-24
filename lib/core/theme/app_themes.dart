import 'package:flutter/material.dart';

// ==================== 五个应用的不同主题风格 ====================

// 1. QA ToolBox Pro - 工作效率主题 (专业蓝色)
class QAToolboxTheme {
  static const Color primaryColor = Color(0xFF1976D2); // 专业蓝
  static const Color secondaryColor = Color(0xFF42A5F5); // 浅蓝
  static const Color accentColor = Color(0xFF2196F3); // 强调蓝
  static const Color backgroundColor = Color(0xFFF5F7FA); // 浅灰背景
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);
  
  static ThemeData get themeData => ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
  );
}

// 2. LifeMode - 生活娱乐主题 (温暖橙色)
class LifeModeTheme {
  static const Color primaryColor = Color(0xFFFF6B35); // 温暖橙
  static const Color secondaryColor = Color(0xFFFF8A65); // 浅橙
  static const Color accentColor = Color(0xFFFF9800); // 强调橙
  static const Color backgroundColor = Color(0xFFFFF8F5); // 温暖背景
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);
  
  static ThemeData get themeData => ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
  );
}

// 3. FitTracker - 健康管理主题 (活力绿色)
class FitTrackerTheme {
  static const Color primaryColor = Color(0xFF4CAF50); // 健康绿
  static const Color secondaryColor = Color(0xFF81C784); // 浅绿
  static const Color accentColor = Color(0xFF8BC34A); // 强调绿
  static const Color backgroundColor = Color(0xFFF1F8E9); // 清新背景
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);
  
  static ThemeData get themeData => ThemeData(
    primarySwatch: Colors.green,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
  );
}

// 4. SocialHub - 社交互动主题 (热情紫色)
class SocialHubTheme {
  static const Color primaryColor = Color(0xFF9C27B0); // 社交紫
  static const Color secondaryColor = Color(0xFFBA68C8); // 浅紫
  static const Color accentColor = Color(0xFFE91E63); // 强调粉
  static const Color backgroundColor = Color(0xFFFCE4EC); // 粉色背景
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);
  
  static ThemeData get themeData => ThemeData(
    primarySwatch: Colors.purple,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
  );
}

// 5. CreativeStudio - 创作工具主题 (创意青色)
class CreativeStudioTheme {
  static const Color primaryColor = Color(0xFF00BCD4); // 创意青
  static const Color secondaryColor = Color(0xFF4DD0E1); // 浅青
  static const Color accentColor = Color(0xFF00ACC1); // 强调青
  static const Color backgroundColor = Color(0xFFE0F2F1); // 清新背景
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFE53E3E);
  static const Color successColor = Color(0xFF38A169);
  static const Color warningColor = Color(0xFFED8936);
  
  static ThemeData get themeData => ThemeData(
    primarySwatch: Colors.cyan,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      background: backgroundColor,
      error: errorColor,
    ),
  );
}

// ==================== 主题管理器 ====================
class AppThemeManager {
  static ThemeData getThemeForApp(String appName) {
    switch (appName.toLowerCase()) {
      case 'qa_toolbox':
      case 'qatoolbox':
        return QAToolboxTheme.themeData;
      case 'life_mode':
      case 'lifemode':
        return LifeModeTheme.themeData;
      case 'fit_tracker':
      case 'fittracker':
        return FitTrackerTheme.themeData;
      case 'social_hub':
      case 'socialhub':
        return SocialHubTheme.themeData;
      case 'creative_studio':
      case 'creativestudio':
        return CreativeStudioTheme.themeData;
      default:
        return QAToolboxTheme.themeData; // 默认主题
    }
  }
  
  static Color getPrimaryColorForApp(String appName) {
    switch (appName.toLowerCase()) {
      case 'qa_toolbox':
      case 'qatoolbox':
        return QAToolboxTheme.primaryColor;
      case 'life_mode':
      case 'lifemode':
        return LifeModeTheme.primaryColor;
      case 'fit_tracker':
      case 'fittracker':
        return FitTrackerTheme.primaryColor;
      case 'social_hub':
      case 'socialhub':
        return SocialHubTheme.primaryColor;
      case 'creative_studio':
      case 'creativestudio':
        return CreativeStudioTheme.primaryColor;
      default:
        return QAToolboxTheme.primaryColor;
    }
  }
  
  static Color getBackgroundColorForApp(String appName) {
    switch (appName.toLowerCase()) {
      case 'qa_toolbox':
      case 'qatoolbox':
        return QAToolboxTheme.backgroundColor;
      case 'life_mode':
      case 'lifemode':
        return LifeModeTheme.backgroundColor;
      case 'fit_tracker':
      case 'fittracker':
        return FitTrackerTheme.backgroundColor;
      case 'social_hub':
      case 'socialhub':
        return SocialHubTheme.backgroundColor;
      case 'creative_studio':
      case 'creativestudio':
        return CreativeStudioTheme.backgroundColor;
      default:
        return QAToolboxTheme.backgroundColor;
    }
  }
}
