#!/bin/bash

# 部署五个独立应用的脚本
# 每个应用都有独立的包名和入口

echo "🚀 开始部署五个独立的应用程序..."

# 设置环境变量
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 清理项目
echo "🧹 清理项目..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

# 1. 部署 QA ToolBox Pro
echo "📱 部署 QA ToolBox Pro..."
flutter run -t lib/apps/qa_toolbox_app.dart -d "sdk gphone64 arm64" &
QA_TOOLBOX_PID=$!

# 等待一下再部署下一个
sleep 5

# 2. 部署 LifeMode
echo "📱 部署 LifeMode..."
flutter run -t lib/apps/life_mode_app.dart -d "sdk gphone64 arm64" &
LIFE_MODE_PID=$!

sleep 5

# 3. 部署 FitTracker
echo "📱 部署 FitTracker..."
flutter run -t lib/apps/fit_tracker_app.dart -d "sdk gphone64 arm64" &
FIT_TRACKER_PID=$!

sleep 5

# 4. 部署 SocialHub
echo "📱 部署 SocialHub..."
flutter run -t lib/apps/social_hub_app.dart -d "sdk gphone64 arm64" &
SOCIAL_HUB_PID=$!

sleep 5

# 5. 部署 CreativeStudio
echo "📱 部署 CreativeStudio..."
flutter run -t lib/apps/creative_studio_app.dart -d "sdk gphone64 arm64" &
CREATIVE_STUDIO_PID=$!

echo "✅ 所有应用部署完成！"
echo ""
echo "📱 应用列表："
echo "1. QA ToolBox Pro - 专业质量保证工具"
echo "2. LifeMode - 生活记录和娱乐"
echo "3. FitTracker - 健康管理和运动追踪"
echo "4. SocialHub - 社交互动平台"
echo "5. CreativeStudio - 创意创作工具"
echo ""
echo "🎨 所有应用都采用微信风格的UI设计"
echo "📱 每个应用都有独立的入口和功能"
echo ""
echo "进程ID："
echo "QA ToolBox Pro: $QA_TOOLBOX_PID"
echo "LifeMode: $LIFE_MODE_PID"
echo "FitTracker: $FIT_TRACKER_PID"
echo "SocialHub: $SOCIAL_HUB_PID"
echo "CreativeStudio: $CREATIVE_STUDIO_PID"
