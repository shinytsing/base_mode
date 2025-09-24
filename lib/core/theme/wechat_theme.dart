import 'package:flutter/material.dart';

// 微信风格主题
class WeChatTheme {
  // 微信主色调
  static const Color primaryGreen = Color(0xFF07C160); // 微信绿
  static const Color backgroundGray = Color(0xFFEDEDED); // 背景灰
  static const Color cardBackground = Colors.white; // 卡片背景
  static const Color textPrimary = Color(0xFF191919); // 主文字
  static const Color textSecondary = Color(0xFF888888); // 次要文字
  static const Color textTertiary = Color(0xFFB2B2B2); // 三级文字
  static const Color dividerColor = Color(0xFFE5E5E5); // 分割线
  
  // 微信风格主题数据
  static ThemeData get themeData => ThemeData(
    primarySwatch: Colors.green,
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: backgroundGray,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    ),
    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    ),
    dividerTheme: const DividerThemeData(
      color: dividerColor,
      thickness: 0.5,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: textTertiary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      titleTextStyle: TextStyle(
        fontSize: 16,
        color: textPrimary,
        fontWeight: FontWeight.w400,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: 14,
        color: textSecondary,
      ),
    ),
  );
}

// 微信风格组件
class WeChatComponents {
  // 微信风格列表项
  static Widget listItem({
    required Widget leading,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            leading: leading,
            title: Text(title),
            subtitle: subtitle != null ? Text(subtitle) : null,
            trailing: trailing,
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          if (showDivider)
            const Divider(height: 0.5, indent: 16),
        ],
      ),
    );
  }
  
  // 微信风格分组
  static Widget group({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: WeChatTheme.backgroundGray,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: WeChatTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ...children,
        const SizedBox(height: 8),
      ],
    );
  }
  
  // 微信风格头像
  static Widget avatar({
    required String imageUrl,
    double size = 40,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
  
  // 微信风格按钮
  static Widget button({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    bool isFullWidth = true,
  }) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? WeChatTheme.primaryGreen : Colors.white,
          foregroundColor: isPrimary ? Colors.white : WeChatTheme.primaryGreen,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: isPrimary ? BorderSide.none : const BorderSide(color: WeChatTheme.primaryGreen),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(text),
      ),
    );
  }
}
