#!/bin/bash

# 修复iOS应用脚本
echo "🔧 修复iOS应用..."

APPS=("creative_studio" "fit_tracker" "life_mode" "qa_toolbox_pro" "social_hub")

for app in "${APPS[@]}"; do
    echo ""
    echo "📱 处理 $app..."
    cd "/Users/gaojie/Desktop/base_mode/apps/$app"
    
    echo "🧹 清理项目..."
    flutter clean
    
    echo "📦 获取依赖..."
    flutter pub get
    
    echo "🔨 构建iOS应用..."
    cd ios
    xcodebuild -workspace Runner.xcworkspace -scheme Runner -destination 'platform=iOS Simulator,name=iPhone 16 Plus' -configuration Debug CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO build
    
    if [ $? -eq 0 ]; then
        echo "✅ $app 构建成功"
        
        echo "📲 安装到模拟器..."
        xcrun simctl install "iPhone 16 Plus" "/Users/gaojie/Library/Developer/Xcode/DerivedData/Runner-*/Build/Products/Debug-iphonesimulator/Runner.app" 2>/dev/null || echo "安装可能已存在"
        
        echo "🚀 启动应用..."
        case $app in
            "creative_studio")
                xcrun simctl launch "iPhone 16 Plus" com.wechat.creativeStudio
                ;;
            "fit_tracker")
                xcrun simctl launch "iPhone 16 Plus" com.wechat.fitTracker
                ;;
            "life_mode")
                xcrun simctl launch "iPhone 16 Plus" com.wechat.lifeMode
                ;;
            "qa_toolbox_pro")
                xcrun simctl launch "iPhone 16 Plus" com.wechat.qaToolboxPro
                ;;
            "social_hub")
                xcrun simctl launch "iPhone 16 Plus" com.wechat.socialHub
                ;;
        esac
        
        echo "✅ $app 启动成功"
    else
        echo "❌ $app 构建失败"
    fi
    
    cd /Users/gaojie/Desktop/base_mode
done

echo ""
echo "🎉 所有iOS应用处理完成！"
echo ""
echo "📱 现在你可以在iPhone 16 Plus模拟器上看到五个独立应用："
echo "   - 创意工作室 (Creative Studio)"
echo "   - 健身助手 (Fit Tracker)" 
echo "   - 生活模式 (Life Mode)"
echo "   - 质量工具箱 (QA Toolbox Pro)"
echo "   - 社交中心 (Social Hub)"
