#!/bin/bash

# 在Android桌面显示五个应用的脚本
echo "🚀 启动五个独立应用..."

# 启动所有应用
echo "📱 启动创意工作室..."
adb shell am start -n com.wechat.creativestudio/com.wechat.creativestudio.MainActivity
sleep 2

echo "💪 启动健身助手..."
adb shell am start -n com.wechat.fittracker/com.wechat.fittracker.MainActivity  
sleep 2

echo "🏠 启动生活模式..."
adb shell am start -n com.wechat.lifemode/com.wechat.lifemode.MainActivity
sleep 2

echo "🔧 启动质量工具箱..."
adb shell am start -n com.wechat.qatoolbox/com.wechat.qatoolbox.MainActivity
sleep 2

echo "👥 启动社交中心..."
adb shell am start -n com.wechat.socialhub/com.wechat.socialhub.MainActivity
sleep 2

echo "✅ 所有应用已启动！"
echo ""
echo "📝 如何查看应用："
echo "1. 按Android设备的多任务按钮（方块按钮）查看最近应用"
echo "2. 或者从桌面上拉打开应用抽屉查找应用"
echo "3. 应用名称："
echo "   - 创意工作室 (Creative Studio)"
echo "   - 健身助手 (Fit Tracker)" 
echo "   - 生活模式 (Life Mode)"
echo "   - 质量工具箱 (QA Toolbox Pro)"
echo "   - 社交中心 (Social Hub)"
echo ""
echo "💡 提示：如果应用没有显示在桌面，请尝试："
echo "   - 重启Android模拟器"
echo "   - 清除启动器缓存"
echo "   - 或从应用抽屉中查找"
