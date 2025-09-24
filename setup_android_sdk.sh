#!/bin/bash

# Android SDK 自动配置脚本
# 用于配置Android SDK和创建模拟器

echo "🚀 开始配置Android SDK..."

# 检查Android Studio是否安装
if [ ! -d "/Applications/Android Studio.app" ]; then
    echo "❌ Android Studio未安装，请先安装Android Studio"
    echo "下载地址: https://developer.android.com/studio"
    exit 1
fi

echo "✅ Android Studio已安装"

# 设置SDK路径
ANDROID_SDK_PATH="$HOME/Library/Android/sdk"
echo "📁 SDK路径: $ANDROID_SDK_PATH"

# 创建SDK目录
mkdir -p "$ANDROID_SDK_PATH"

# 设置环境变量
echo "🔧 设置环境变量..."
export ANDROID_HOME="$ANDROID_SDK_PATH"
export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# 添加到shell配置文件
SHELL_CONFIG=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_CONFIG="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "📝 添加到 $SHELL_CONFIG"
    cat >> "$SHELL_CONFIG" << EOF

# Android SDK Configuration
export ANDROID_HOME=\$HOME/Library/Android/sdk
export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=\$PATH:\$ANDROID_HOME/platform-tools
export PATH=\$PATH:\$ANDROID_HOME/emulator
EOF
fi

echo "✅ 环境变量已设置"

# 检查Flutter环境
echo "🔍 检查Flutter环境..."
flutter doctor

echo ""
echo "📋 接下来的步骤:"
echo "1. 打开Android Studio"
echo "2. 进入 Tools → SDK Manager"
echo "3. 安装以下组件:"
echo "   - Android SDK Platform (API 34)"
echo "   - Android SDK Build-Tools"
echo "   - Android SDK Platform-Tools"
echo "   - Android Emulator"
echo "4. 进入 Tools → AVD Manager"
echo "5. 创建新的虚拟设备"
echo "6. 运行: flutter run -d <device_id>"
echo ""
echo "🎯 或者使用以下命令创建模拟器:"
echo "flutter emulators --create --name Pixel_7_API_34"
echo "flutter emulators --launch Pixel_7_API_34"
echo ""
echo "✨ 配置完成！"
