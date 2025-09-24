#!/bin/bash

# 测试单个应用的脚本
echo "🚀 测试单个独立应用..."

# 设置环境变量
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 选择要测试的应用
APP_NAME="qa_toolbox_pro"
APP_DIR="apps/$APP_NAME"

echo "📱 测试应用: $APP_NAME"
echo "📁 应用目录: $APP_DIR"

# 进入应用目录
cd $APP_DIR

# 清理并获取依赖
echo "🧹 清理项目..."
flutter clean

echo "📦 获取依赖..."
flutter pub get

# 检查应用是否能编译
echo "🔨 检查编译..."
flutter build apk --debug

if [ $? -eq 0 ]; then
    echo "✅ 应用编译成功！"
    echo "📱 应用信息："
    echo "   - 包名: com.qatoolbox.pro"
    echo "   - 应用名: QA ToolBox Pro"
    echo "   - 主题: 微信风格"
else
    echo "❌ 应用编译失败！"
    exit 1
fi

echo "🎉 测试完成！"
