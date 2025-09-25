#!/bin/bash

echo "🔧 更新所有应用的iOS配置..."

# 应用配置映射
declare -A apps=(
    ["life_mode"]="LifeMode:com.lifemode.app"
    ["qa_toolbox_pro"]="QAToolboxPro:com.qatoolboxpro.app"
    ["social_hub"]="SocialHub:com.socialhub.app"
)

# 更新每个应用的iOS配置
for app_folder in "${!apps[@]}"; do
    IFS=':' read -r display_name bundle_id <<< "${apps[$app_folder]}"
    
    echo "📱 更新 $display_name..."
    
    # 更新Info.plist
    info_plist="/Users/gaojie/Desktop/base_mode/apps/$app_folder/ios/Runner/Info.plist"
    if [ -f "$info_plist" ]; then
        echo "  更新 Info.plist..."
        sed -i '' "s/<string>.*<\/string>/<string>$display_name<\/string>/" "$info_plist" 2>/dev/null || true
        sed -i '' "s/<string>.*<\/string>/<string>${app_folder//_/}<\/string>/" "$info_plist" 2>/dev/null || true
    fi
    
    # 更新project.pbxproj
    project_file="/Users/gaojie/Desktop/base_mode/apps/$app_folder/ios/Runner.xcodeproj/project.pbxproj"
    if [ -f "$project_file" ]; then
        echo "  更新 Bundle Identifier..."
        # 更新主应用的Bundle Identifier
        sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = com\.wechat\.[^;]*;/PRODUCT_BUNDLE_IDENTIFIER = $bundle_id;/g" "$project_file"
        # 更新测试应用的Bundle Identifier
        sed -i '' "s/PRODUCT_BUNDLE_IDENTIFIER = com\.wechat\.[^;]*\.RunnerTests;/PRODUCT_BUNDLE_IDENTIFIER = $bundle_id.RunnerTests;/g" "$project_file"
    fi
    
    echo "  ✅ $display_name 配置更新完成"
done

echo "🎉 所有iOS配置更新完成！"
