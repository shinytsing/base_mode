#!/bin/bash

# 部署五个简化版独立应用的脚本
# 每个应用都有独立的入口和微信风格UI

echo "🚀 开始部署五个简化版独立应用程序..."

# 设置环境变量
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 清理项目
echo "🧹 清理项目..."
flutter clean

# 获取依赖
echo "📦 获取依赖..."
flutter pub get

echo ""
echo "📱 开始部署五个独立应用..."
echo ""

# 1. 部署 QA ToolBox Pro
echo "📱 部署 QA ToolBox Pro (绿色主题)..."
flutter run -t lib/apps/simple_qa_toolbox.dart -d "sdk gphone64 arm64" &
QA_TOOLBOX_PID=$!
echo "   PID: $QA_TOOLBOX_PID"

# 等待一下再部署下一个
sleep 8

# 2. 部署 LifeMode
echo "📱 部署 LifeMode (橙色主题)..."
flutter run -t lib/apps/simple_life_mode.dart -d "sdk gphone64 arm64" &
LIFE_MODE_PID=$!
echo "   PID: $LIFE_MODE_PID"

sleep 8

# 3. 部署 FitTracker
echo "📱 部署 FitTracker (绿色主题)..."
flutter run -t lib/apps/simple_fit_tracker.dart -d "sdk gphone64 arm64" &
FIT_TRACKER_PID=$!
echo "   PID: $FIT_TRACKER_PID"

sleep 8

# 4. 部署 SocialHub
echo "📱 部署 SocialHub (紫色主题)..."
flutter run -t lib/apps/simple_social_hub.dart -d "sdk gphone64 arm64" &
SOCIAL_HUB_PID=$!
echo "   PID: $SOCIAL_HUB_PID"

sleep 8

# 5. 部署 CreativeStudio
echo "📱 部署 CreativeStudio (青色主题)..."
flutter run -t lib/apps/simple_creative_studio.dart -d "sdk gphone64 arm64" &
CREATIVE_STUDIO_PID=$!
echo "   PID: $CREATIVE_STUDIO_PID"

echo ""
echo "✅ 所有应用部署完成！"
echo ""
echo "📱 应用列表："
echo "1. QA ToolBox Pro - 专业质量保证工具 (绿色主题)"
echo "2. LifeMode - 生活记录和娱乐 (橙色主题)"
echo "3. FitTracker - 健康管理和运动追踪 (绿色主题)"
echo "4. SocialHub - 社交互动平台 (紫色主题)"
echo "5. CreativeStudio - 创意创作工具 (青色主题)"
echo ""
echo "🎨 所有应用都采用微信风格的UI设计"
echo "📱 每个应用都有独立的入口和功能"
echo ""
echo "🔧 管理命令："
echo "停止所有应用: kill $QA_TOOLBOX_PID $LIFE_MODE_PID $FIT_TRACKER_PID $SOCIAL_HUB_PID $CREATIVE_STUDIO_PID"
echo ""
echo "📊 部署状态："
echo "QA ToolBox Pro: 运行中 (PID: $QA_TOOLBOX_PID)"
echo "LifeMode: 运行中 (PID: $LIFE_MODE_PID)"
echo "FitTracker: 运行中 (PID: $FIT_TRACKER_PID)"
echo "SocialHub: 运行中 (PID: $SOCIAL_HUB_PID)"
echo "CreativeStudio: 运行中 (PID: $CREATIVE_STUDIO_PID)"
echo ""
echo "🎉 现在您可以在Android模拟器上看到五个不同的应用入口！"
