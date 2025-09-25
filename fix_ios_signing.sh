#!/bin/bash

# iOS代码签名修复脚本
echo "🔧 修复iOS代码签名问题..."

cd apps/fit_tracker

# 清理iOS构建
echo "🧹 清理iOS构建..."
flutter clean
rm -rf ios/Pods
rm -rf ios/Podfile.lock

# 重新安装Pods
echo "📦 重新安装Pods..."
cd ios
pod install --repo-update
cd ..

# 更新iOS配置
echo "⚙️ 更新iOS配置..."

# 更新Info.plist
cat > ios/Runner/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleDisplayName</key>
	<string>FitMatrix</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>fitmatrix</string>
	<key>CFBundlePackageType</key>
	<string>APPL</string>
	<key>CFBundleShortVersionString</key>
	<string>$(FLUTTER_BUILD_NAME)</string>
	<key>CFBundleSignature</key>
	<string>????</string>
	<key>CFBundleVersion</key>
	<string>$(FLUTTER_BUILD_NUMBER)</string>
	<key>LSRequiresIPhoneOS</key>
	<true/>
	<key>UILaunchStoryboardName</key>
	<string>LaunchScreen</string>
	<key>UIMainStoryboardFile</key>
	<string>Main</string>
	<key>UISupportedInterfaceOrientations</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>UISupportedInterfaceOrientations~ipad</key>
	<array>
		<string>UIInterfaceOrientationPortrait</string>
		<string>UIInterfaceOrientationPortraitUpsideDown</string>
		<string>UIInterfaceOrientationLandscapeLeft</string>
		<string>UIInterfaceOrientationLandscapeRight</string>
	</array>
	<key>CADisableMinimumFrameDurationOnPhone</key>
	<true/>
	<key>UIApplicationSupportsIndirectInputEvents</key>
	<true/>
</dict>
</plist>
EOF

echo "✅ iOS配置更新完成！"

# 尝试构建iOS应用（无签名）
echo "🍎 尝试构建iOS应用（无签名）..."
flutter build ios --simulator --no-codesign

if [ $? -eq 0 ]; then
    echo "✅ iOS应用构建成功！"
    echo "📱 应用位置: build/ios/Debug-iphonesimulator/Runner.app"
else
    echo "❌ iOS应用构建失败，但配置已更新"
    echo "💡 建议："
    echo "   1. 在Xcode中打开 ios/Runner.xcworkspace"
    echo "   2. 选择Runner项目"
    echo "   3. 在Signing & Capabilities中配置开发团队"
    echo "   4. 重新构建应用"
fi

echo "🎉 iOS修复脚本执行完成！"
