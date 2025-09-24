#!/bin/bash

# 部署五个独立应用的脚本
# 每个应用都有独立的包名、应用名称和图标

echo "🚀 开始部署五个独立的应用程序..."

# 设置环境变量
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 检查Flutter环境
echo "📱 检查Flutter环境..."
flutter doctor

# 获取可用的设备
echo "📱 获取可用设备..."
flutter devices

# 1. 部署 QA ToolBox Pro
echo "📱 部署 QA ToolBox Pro..."
cd apps/qa_toolbox_pro
flutter clean
flutter pub get
flutter run -d "sdk gphone64 arm64" &
QA_TOOLBOX_PID=$!
cd ../..

# 等待一下再部署下一个
sleep 10

# 2. 部署 LifeMode
echo "📱 部署 LifeMode..."
cd apps/life_mode
flutter clean
flutter pub get
flutter run -d "sdk gphone64 arm64" &
LIFE_MODE_PID=$!
cd ../..

sleep 10

# 3. 部署 FitTracker
echo "📱 部署 FitTracker..."
cd apps/fit_tracker
flutter clean
flutter pub get
flutter run -d "sdk gphone64 arm64" &
FIT_TRACKER_PID=$!
cd ../..

sleep 10

# 4. 部署 SocialHub
echo "📱 部署 SocialHub..."
cd apps/social_hub
flutter clean
flutter pub get
flutter run -d "sdk gphone64 arm64" &
SOCIAL_HUB_PID=$!
cd ../..

sleep 10

# 5. 部署 CreativeStudio
echo "📱 部署 CreativeStudio..."
cd apps/creative_studio
flutter clean
flutter pub get
flutter run -d "sdk gphone64 arm64" &
CREATIVE_STUDIO_PID=$!
cd ../..

echo "✅ 所有应用部署完成！"
echo ""
echo "📱 应用列表："
echo "1. QA ToolBox Pro (com.qatoolbox.pro) - 专业质量保证工具"
echo "2. LifeMode (com.lifemode.app) - 生活记录和娱乐"
echo "3. FitTracker (com.fittracker.app) - 健康管理和运动追踪"
echo "4. SocialHub (com.socialhub.app) - 社交互动平台"
echo "5. CreativeStudio (com.creativestudio.app) - 创意创作工具"
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
echo ""
echo "🎉 现在您可以在Android模拟器上看到五个不同的应用入口！"
