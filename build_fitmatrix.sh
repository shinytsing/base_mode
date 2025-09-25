#!/bin/bash

# FitMatrix 构建脚本
echo "🚀 开始构建 FitMatrix 应用..."

# 进入应用目录
cd apps/fit_tracker

# 清理之前的构建
echo "🧹 清理之前的构建..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 检查Flutter环境
echo "🔍 检查Flutter环境..."
flutter doctor

# 构建Android APK
echo "📱 构建Android APK..."
flutter build apk --release

# 构建iOS应用
echo "🍎 构建iOS应用..."
flutter build ios --release

# 构建Web应用
echo "🌐 构建Web应用..."
flutter build web --release

echo "✅ FitMatrix 构建完成！"
echo "📱 Android APK: build/app/outputs/flutter-apk/app-release.apk"
echo "🍎 iOS应用: build/ios/iphoneos/Runner.app"
echo "🌐 Web应用: build/web/"

# 显示构建结果
echo ""
echo "📊 构建结果:"
ls -la build/app/outputs/flutter-apk/
ls -la build/web/
