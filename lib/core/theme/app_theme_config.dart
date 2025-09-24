import 'package:flutter/material.dart';

enum AppThemeType {
  qaToolbox,
  businessApp,
  socialApp,
  productivityApp,
}

class AppThemeConfig {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color errorColor;
  final Color surfaceColor;
  final Color backgroundColor;
  final String logoPath;
  final String appName;
  final Map<String, dynamic> customColors;

  const AppThemeConfig({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.errorColor,
    required this.surfaceColor,
    required this.backgroundColor,
    required this.logoPath,
    required this.appName,
    this.customColors = const {},
  });

  static const Map<AppThemeType, AppThemeConfig> themes = {
    AppThemeType.qaToolbox: AppThemeConfig(
      name: 'QAToolBox',
      primaryColor: Color(0xFF2196F3),
      secondaryColor: Color(0xFF03DAC6),
      errorColor: Color(0xFFB00020),
      surfaceColor: Color(0xFFFFFBFE),
      backgroundColor: Color(0xFFF5F5F5),
      logoPath: 'assets/images/qa_toolbox_logo.png',
      appName: 'QAToolBox',
      customColors: {
        'accent': Color(0xFF4CAF50),
        'warning': Color(0xFFFF9800),
      },
    ),
    AppThemeType.businessApp: AppThemeConfig(
      name: 'BusinessApp',
      primaryColor: Color(0xFF1976D2),
      secondaryColor: Color(0xFF424242),
      errorColor: Color(0xFFD32F2F),
      surfaceColor: Color(0xFFFFFFFF),
      backgroundColor: Color(0xFFFAFAFA),
      logoPath: 'assets/images/business_logo.png',
      appName: 'Business Suite',
      customColors: {
        'accent': Color(0xFF388E3C),
        'warning': Color(0xFFF57C00),
      },
    ),
    AppThemeType.socialApp: AppThemeConfig(
      name: 'SocialApp',
      primaryColor: Color(0xFFE91E63),
      secondaryColor: Color(0xFF9C27B0),
      errorColor: Color(0xFFE53E3E),
      surfaceColor: Color(0xFFFFFBFE),
      backgroundColor: Color(0xFFF7FAFC),
      logoPath: 'assets/images/social_logo.png',
      appName: 'Social Connect',
      customColors: {
        'accent': Color(0xFF00BCD4),
        'warning': Color(0xFFFFC107),
      },
    ),
    AppThemeType.productivityApp: AppThemeConfig(
      name: 'ProductivityApp',
      primaryColor: Color(0xFF2E7D32),
      secondaryColor: Color(0xFF546E7A),
      errorColor: Color(0xFFC62828),
      surfaceColor: Color(0xFFFFFFFF),
      backgroundColor: Color(0xFFF1F8E9),
      logoPath: 'assets/images/productivity_logo.png',
      appName: 'Productivity Pro',
      customColors: {
        'accent': Color(0xFF00ACC1),
        'warning': Color(0xFFFF8F00),
      },
    ),
  };

  static AppThemeConfig getTheme(AppThemeType type) {
    return themes[type] ?? themes[AppThemeType.qaToolbox]!;
  }

  ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      surface: surfaceColor,
      background: backgroundColor,
    );
  }
}
