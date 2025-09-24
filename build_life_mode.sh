#!/bin/bash

# 生活模式 - 独立构建脚本
echo "🏠 构建生活模式应用..."

cd apps/life_mode

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

echo "✅ 生活模式构建完成！"
echo "📱 Android APK: apps/life_mode/build/app/outputs/flutter-apk/app-release.apk"
echo "🍎 iOS应用: apps/life_mode/build/ios/iphoneos/Runner.app"

# 安装到Android设备（如果有连接）
if command -v adb &> /dev/null; then
    echo "📲 尝试安装到Android设备..."
    adb install build/app/outputs/flutter-apk/app-release.apk
fi
