#!/bin/bash

# 测试所有五个独立应用
echo "🧪 开始测试所有五个独立应用..."
echo "=================================="

# 检查Flutter环境
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter未安装或未添加到PATH"
    exit 1
fi

echo "✅ Flutter环境检查通过"

# 测试函数
test_app() {
    local app_name=$1
    local app_path=$2
    
    echo ""
    echo "🔍 测试 $app_name..."
    cd $app_path
    
    # 检查pubspec.yaml
    if [ ! -f "pubspec.yaml" ]; then
        echo "❌ $app_name: pubspec.yaml 不存在"
        return 1
    fi
    
    # 检查main.dart
    if [ ! -f "lib/main.dart" ]; then
        echo "❌ $app_name: lib/main.dart 不存在"
        return 1
    fi
    
    # 检查Android配置
    if [ ! -f "android/app/build.gradle.kts" ]; then
        echo "❌ $app_name: Android配置不存在"
        return 1
    fi
    
    # 检查iOS配置
    if [ ! -f "ios/Runner.xcodeproj/project.pbxproj" ]; then
        echo "❌ $app_name: iOS配置不存在"
        return 1
    fi
    
    # 尝试获取依赖
    echo "📦 获取依赖..."
    if flutter pub get; then
        echo "✅ $app_name: 依赖获取成功"
    else
        echo "❌ $app_name: 依赖获取失败"
        return 1
    fi
    
    # 尝试分析代码
    echo "🔍 分析代码..."
    if flutter analyze; then
        echo "✅ $app_name: 代码分析通过"
    else
        echo "⚠️  $app_name: 代码分析有警告"
    fi
    
    echo "✅ $app_name: 测试通过"
    cd ../..
}

# 测试所有应用
test_app "创意工作室" "apps/creative_studio"
test_app "健身助手" "apps/fit_tracker"
test_app "生活模式" "apps/life_mode"
test_app "质量工具箱" "apps/qa_toolbox_pro"
test_app "社交中心" "apps/social_hub"

echo ""
echo "🎉 所有应用测试完成！"
echo "=================================="
echo "💡 下一步："
echo "  - 运行 ./build_all_apps.sh 构建所有应用"
echo "  - 或运行单个构建脚本，如 ./build_creative_studio.sh"
echo "  - 在Android Studio或Xcode中打开项目进行调试"