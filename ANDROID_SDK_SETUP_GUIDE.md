# Android SDK 配置指南

## 🎯 当前问题

```
ANDROID_HOME = /Users/gaojie/Library/Android/sdk
but Android SDK not found at this location.
```

## 🔧 解决方案

### 方案1: 通过Android Studio安装 (推荐)

1. **打开Android Studio**
   ```bash
   open -a "Android Studio"
   ```

2. **进入SDK Manager**
   - 打开Android Studio
   - 点击 `Tools` → `SDK Manager`
   - 或者点击 `More Actions` → `SDK Manager`

3. **安装必要组件**
   - **SDK Platforms**: 选择最新的Android版本 (API 34)
   - **SDK Tools**: 
     - Android SDK Build-Tools
     - Android SDK Platform-Tools
     - Android SDK Tools
     - Android Emulator
     - Intel x86 Emulator Accelerator (HAXM installer)

4. **设置SDK路径**
   - 在SDK Manager中，记下 `Android SDK Location`
   - 通常是: `/Users/gaojie/Library/Android/sdk`

### 方案2: 手动下载安装

1. **创建SDK目录**
   ```bash
   mkdir -p ~/Library/Android/sdk
   ```

2. **下载命令行工具**
   - 访问: https://developer.android.com/studio#command-tools
   - 下载: `commandlinetools-mac-11076708_latest.zip`
   - 解压到: `~/Library/Android/sdk/cmdline-tools/latest/`

3. **安装SDK组件**
   ```bash
   cd ~/Library/Android/sdk/cmdline-tools/latest/bin
   
   # 接受许可证
   ./sdkmanager --licenses
   
   # 安装平台
   ./sdkmanager "platforms;android-34"
   
   # 安装构建工具
   ./sdkmanager "build-tools;34.0.0"
   
   # 安装平台工具
   ./sdkmanager "platform-tools"
   
   # 安装模拟器
   ./sdkmanager "emulator"
   ```

### 方案3: 使用Homebrew (已停用)

```bash
# 注意: 此方法已停用
brew install --cask android-sdk  # 不再可用
```

## 🔧 环境变量配置

### 1. 设置环境变量
```bash
# 添加到 ~/.zshrc
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/emulator
```

### 2. 重新加载配置
```bash
source ~/.zshrc
```

### 3. 验证配置
```bash
echo $ANDROID_HOME
flutter doctor
```

## 📱 创建Android模拟器

### 1. 通过Android Studio创建
- 打开Android Studio
- 点击 `Tools` → `AVD Manager`
- 点击 `Create Virtual Device`
- 选择设备 (如 Pixel 7)
- 选择系统镜像 (API 34)
- 完成创建

### 2. 通过命令行创建
```bash
# 列出可用的系统镜像
flutter emulators

# 创建模拟器
flutter emulators --create --name Pixel_7_API_34

# 启动模拟器
flutter emulators --launch Pixel_7_API_34
```

## 🚀 启动Android应用

### 1. 检查设备
```bash
flutter devices
```

### 2. 启动应用
```bash
flutter run -d <device_id>
```

## 🧪 测试步骤

### 1. 验证SDK安装
```bash
flutter doctor
```

预期输出:
```
[✓] Android toolchain - develop for Android devices
    • Android SDK at /Users/gaojie/Library/Android/sdk
    • Platform android-34, build-tools 34.0.0
    • Java binary at: /Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/java
    • Java version: 17.0.9
    • ANDROID_HOME = /Users/gaojie/Library/Android/sdk
```

### 2. 验证模拟器
```bash
flutter emulators
```

预期输出:
```
Pixel_7_API_34 • Pixel 7 API 34 • Google • android
```

### 3. 启动应用
```bash
flutter run -d Pixel_7_API_34
```

## 🔍 故障排除

### 问题1: SDK路径错误
```bash
# 检查SDK路径
ls -la $ANDROID_HOME

# 重新设置路径
export ANDROID_HOME=/correct/path/to/sdk
```

### 问题2: 许可证未接受
```bash
# 接受许可证
flutter doctor --android-licenses
```

### 问题3: 模拟器创建失败
```bash
# 检查可用镜像
flutter emulators

# 手动创建
flutter emulators --create --name Test_Device
```

### 问题4: 网络连接问题
- 使用VPN或代理
- 检查防火墙设置
- 尝试使用移动热点

## 📊 完整配置检查清单

- [ ] Android Studio已安装
- [ ] SDK Manager已打开
- [ ] Android SDK Platform (API 34)已安装
- [ ] Android SDK Build-Tools已安装
- [ ] Android SDK Platform-Tools已安装
- [ ] Android Emulator已安装
- [ ] 环境变量已设置
- [ ] 许可证已接受
- [ ] 模拟器已创建
- [ ] Flutter doctor检查通过

## 🎯 快速启动命令

```bash
# 1. 设置环境变量
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# 2. 检查Flutter环境
flutter doctor

# 3. 创建模拟器
flutter emulators --create --name Pixel_7_API_34

# 4. 启动模拟器
flutter emulators --launch Pixel_7_API_34

# 5. 运行应用
flutter run -d Pixel_7_API_34
```

## 📞 技术支持

如果遇到问题，请检查：
1. Android Studio版本是否最新
2. SDK路径是否正确
3. 环境变量是否设置
4. 网络连接是否正常
5. 磁盘空间是否充足

---

**配置完成后，您就可以启动Android版本的QA ToolBox应用了！**
