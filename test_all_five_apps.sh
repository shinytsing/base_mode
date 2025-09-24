#!/bin/bash

# 测试所有五个独立应用的脚本
echo "🚀 测试所有五个独立应用..."

# 设置环境变量
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 应用列表
APPS=(
    "qa_toolbox_pro:com.qatoolbox.pro:QA ToolBox Pro"
    "life_mode:com.lifemode.app:LifeMode"
    "fit_tracker:com.fittracker.app:FitTracker"
    "social_hub:com.socialhub.app:SocialHub"
    "creative_studio:com.creativestudio.app:CreativeStudio"
)

SUCCESS_COUNT=0
TOTAL_COUNT=${#APPS[@]}

for app_info in "${APPS[@]}"; do
    IFS=':' read -r app_dir package_name app_title <<< "$app_info"
    
    echo ""
    echo "📱 测试应用: $app_title"
    echo "📁 应用目录: apps/$app_dir"
    echo "📦 包名: $package_name"
    
    # 进入应用目录
    cd "apps/$app_dir"
    
    # 清理并获取依赖
    echo "🧹 清理项目..."
    flutter clean > /dev/null 2>&1
    
    echo "📦 获取依赖..."
    flutter pub get > /dev/null 2>&1
    
    # 检查应用是否能编译
    echo "🔨 检查编译..."
    if flutter build apk --debug > /dev/null 2>&1; then
        echo "✅ $app_title 编译成功！"
        ((SUCCESS_COUNT++))
    else
        echo "❌ $app_title 编译失败！"
    fi
    
    # 返回根目录
    cd ../..
done

echo ""
echo "🎉 测试完成！"
echo "📊 结果统计："
echo "   - 成功: $SUCCESS_COUNT/$TOTAL_COUNT"
echo "   - 失败: $((TOTAL_COUNT - SUCCESS_COUNT))/$TOTAL_COUNT"

if [ $SUCCESS_COUNT -eq $TOTAL_COUNT ]; then
    echo ""
    echo "🎊 所有五个应用都编译成功！"
    echo "📱 应用列表："
    echo "   1. QA ToolBox Pro (com.qatoolbox.pro) - 专业质量保证工具"
    echo "   2. LifeMode (com.lifemode.app) - 生活记录和娱乐"
    echo "   3. FitTracker (com.fittracker.app) - 健康管理和运动追踪"
    echo "   4. SocialHub (com.socialhub.app) - 社交互动平台"
    echo "   5. CreativeStudio (com.creativestudio.app) - 创意创作工具"
    echo ""
    echo "🎨 所有应用都采用微信风格的UI设计"
    echo "📱 每个应用都有独立的入口和功能"
    echo "🚀 现在可以运行 ./deploy_five_independent_apps.sh 来部署所有应用！"
else
    echo ""
    echo "⚠️  部分应用编译失败，请检查错误信息"
fi
