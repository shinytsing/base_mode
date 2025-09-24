#!/bin/bash

# 构建所有五个独立应用
echo "🚀 开始构建所有五个独立应用..."
echo "=================================="

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装或未添加到PATH"
    exit 1
fi

echo "✅ Flutter环境检查通过"

# 构建创意工作室
echo ""
echo "🎨 构建创意工作室..."
bash build_creative_studio.sh

# 构建健身助手
echo ""
echo "💪 构建健身助手..."
bash build_fit_tracker.sh

# 构建生活模式
echo ""
echo "🏠 构建生活模式..."
bash build_life_mode.sh

# 构建质量工具箱
echo ""
echo "🔧 构建质量工具箱..."
bash build_qa_toolbox.sh

# 构建社交中心
echo ""
echo "👥 构建社交中心..."
bash build_social_hub.sh

echo ""
echo "🎉 所有五个应用构建完成！"
echo "=================================="
echo "📱 Android APK文件位置："
echo "  - 创意工作室: apps/creative_studio/build/app/outputs/flutter-apk/app-release.apk"
echo "  - 健身助手: apps/fit_tracker/build/app/outputs/flutter-apk/app-release.apk"
echo "  - 生活模式: apps/life_mode/build/app/outputs/flutter-apk/app-release.apk"
echo "  - 质量工具箱: apps/qa_toolbox_pro/build/app/outputs/flutter-apk/app-release.apk"
echo "  - 社交中心: apps/social_hub/build/app/outputs/flutter-apk/app-release.apk"
echo ""
echo "🍎 iOS应用位置："
echo "  - 创意工作室: apps/creative_studio/build/ios/iphoneos/Runner.app"
echo "  - 健身助手: apps/fit_tracker/build/ios/iphoneos/Runner.app"
echo "  - 生活模式: apps/life_mode/build/ios/iphoneos/Runner.app"
echo "  - 质量工具箱: apps/qa_toolbox_pro/build/ios/iphoneos/Runner.app"
echo "  - 社交中心: apps/social_hub/build/ios/iphoneos/Runner.app"
echo ""
echo "💡 提示："
echo "  - Android应用可以直接安装到设备上"
echo "  - iOS应用需要Xcode进行签名和安装"
echo "  - 每个应用都有独立的包名和Bundle ID"
