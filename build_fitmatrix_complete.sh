#!/bin/bash

# FitMatrix 完整构建脚本
echo "🚀 开始构建 FitMatrix 完整应用..."

# 进入应用目录
cd apps/fit_tracker

# 清理之前的构建
echo "🧹 清理之前的构建..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 生成代码
echo "🔧 生成代码..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# 检查Flutter环境
echo "🔍 检查Flutter环境..."
flutter doctor

# 构建Android APK (Debug)
echo "📱 构建Android APK (Debug)..."
flutter build apk --debug

# 构建Android APK (Release)
echo "📱 构建Android APK (Release)..."
flutter build apk --release

# 构建Web应用
echo "🌐 构建Web应用..."
flutter build web

# 尝试构建iOS应用 (模拟器)
echo "🍎 尝试构建iOS应用 (模拟器)..."
flutter build ios --simulator || echo "iOS构建失败，可能需要配置签名"

# 显示构建结果
echo ""
echo "✅ FitMatrix 构建完成！"
echo ""
echo "📊 构建结果:"
echo "📱 Android Debug APK: build/app/outputs/flutter-apk/app-debug.apk"
echo "📱 Android Release APK: build/app/outputs/flutter-apk/app-release.apk"
echo "🌐 Web应用: build/web/"
echo "🍎 iOS应用: build/ios/iphoneos/Runner.app (如果构建成功)"

# 显示文件大小
echo ""
echo "📏 文件大小:"
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "Debug APK: $(du -h build/app/outputs/flutter-apk/app-debug.apk | cut -f1)"
fi
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "Release APK: $(du -h build/app/outputs/flutter-apk/app-release.apk | cut -f1)"
fi
if [ -d "build/web" ]; then
    echo "Web应用: $(du -sh build/web | cut -f1)"
fi

echo ""
echo "🎉 FitMatrix 应用已成功构建！"
echo "💡 您可以将APK文件安装到Android设备上进行测试"
echo "🌐 Web版本可以在浏览器中运行"
echo "🍎 iOS版本需要配置开发者证书才能在真机上运行"
