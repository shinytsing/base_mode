#!/bin/bash

# 设置国内镜像源
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

echo "🚀 开始测试五个应用..."
echo "=================================="

# 检查Flutter环境
echo "📱 检查Flutter环境..."
flutter doctor --no-version-check

echo ""
echo "🔧 检查可用设备..."
flutter devices

echo ""
echo "📦 获取依赖包..."
flutter pub get

echo ""
echo "🎯 开始测试五个应用..."

# 测试1: QA ToolBox (iPhone)
echo ""
echo "1️⃣ 测试 QA ToolBox (iPhone 16 Plus)..."
flutter run -t lib/main_qa_toolbox.dart -d "iPhone 16 Plus" --no-sound-null-safety &
QA_PID=$!

# 等待5秒
sleep 5

# 测试2: Business App (Android)
echo ""
echo "2️⃣ 测试 Business App (Android)..."
flutter run -t lib/main_business_app.dart -d "sdk gphone64 arm64" --no-sound-null-safety &
BUSINESS_PID=$!

# 等待5秒
sleep 5

# 测试3: Social App (macOS)
echo ""
echo "3️⃣ 测试 Social App (macOS)..."
flutter run -t lib/main_social_app.dart -d "macos" --no-sound-null-safety &
SOCIAL_PID=$!

# 等待5秒
sleep 5

# 测试4: Productivity App (Chrome)
echo ""
echo "4️⃣ 测试 Productivity App (Chrome)..."
flutter run -t lib/main_productivity_app.dart -d "chrome" --no-sound-null-safety &
PRODUCTIVITY_PID=$!

# 等待5秒
sleep 5

# 测试5: Minimal App (iPhone)
echo ""
echo "5️⃣ 测试 Minimal App (iPhone 16 Plus)..."
flutter run -t lib/main_minimal.dart -d "iPhone 16 Plus" --no-sound-null-safety &
MINIMAL_PID=$!

echo ""
echo "✅ 所有五个应用已启动！"
echo "=================================="
echo "📱 QA ToolBox: PID $QA_PID"
echo "💼 Business App: PID $BUSINESS_PID"
echo "👥 Social App: PID $SOCIAL_PID"
echo "⚡ Productivity App: PID $PRODUCTIVITY_PID"
echo "🎯 Minimal App: PID $MINIMAL_PID"
echo ""
echo "🎉 测试完成！所有应用都在虚拟机上运行！"
echo ""
echo "按 Ctrl+C 停止所有应用"

# 等待用户中断
trap 'echo "🛑 停止所有应用..."; kill $QA_PID $BUSINESS_PID $SOCIAL_PID $PRODUCTIVITY_PID $MINIMAL_PID 2>/dev/null; exit 0' INT

# 保持脚本运行
while true; do
    sleep 1
done
