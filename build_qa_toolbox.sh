#!/bin/bash

# 质量工具箱 - 独立构建脚本
echo "🔧 构建质量工具箱应用..."

cd apps/qa_toolbox_pro

# 清理之前的构建
echo "🧹 清理之前的构建..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 构建Android APK
echo "🤖 构建Android APK..."
flutter build apk --release

# 构建iOS应用
echo "🍎 构建iOS应用..."
flutter build ios --release

echo "✅ 质量工具箱构建完成！"
echo "📱 Android APK: apps/qa_toolbox_pro/build/app/outputs/flutter-apk/app-release.apk"
echo "🍎 iOS应用: apps/qa_toolbox_pro/build/ios/iphoneos/Runner.app"

# 安装到Android设备（如果有连接）
if command -v adb &> /dev/null; then
    echo "📲 尝试安装到Android设备..."
    adb install build/app/outputs/flutter-apk/app-release.apk
fi
