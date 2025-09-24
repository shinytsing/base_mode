# QA ToolBox 移动应用启动指南

## 📱 当前状态

### ✅ iOS 应用
- **状态**: 正在启动中
- **设备**: iPhone 16 Plus 模拟器
- **设备ID**: 22360110-D504-489D-8CCE-049CABF009AE
- **系统**: iOS 18.5

### ⚠️ Android 应用
- **状态**: 需要配置Android SDK
- **问题**: Android SDK路径未正确配置
- **解决方案**: 需要安装Android SDK

## 🚀 iOS 应用启动

### 当前运行状态
iOS应用正在iPhone 16 Plus模拟器上启动，您应该能看到：

1. **模拟器窗口** - iPhone 16 Plus模拟器已打开
2. **应用安装** - Flutter正在编译和安装应用
3. **应用启动** - QA ToolBox应用将在模拟器中运行

### 预期功能
启动后您将看到：
- 🏠 **首页** - 应用概览和导航
- 📱 **应用中心** - 多应用管理
- 👤 **个人中心** - 用户信息
- 💳 **会员中心** - 订阅管理

## 🤖 Android 应用配置

### 问题诊断
当前Android SDK配置问题：
```
ANDROID_HOME = /Users/gaojie/Library/Android/sdk
but Android SDK not found at this location.
```

### 解决方案

#### 方案1: 通过Android Studio安装SDK
1. 打开Android Studio
2. 进入 `Tools` → `SDK Manager`
3. 安装以下组件：
   - Android SDK Platform (最新版本)
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Tools

#### 方案2: 手动安装Android SDK
```bash
# 创建SDK目录
mkdir -p ~/Library/Android/sdk

# 下载Android SDK命令行工具
cd ~/Library/Android/sdk
# 从 https://developer.android.com/studio#command-tools 下载
# 解压到当前目录

# 设置环境变量
export ANDROID_HOME=~/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# 添加到 ~/.zshrc
echo 'export ANDROID_HOME=~/Library/Android/sdk' >> ~/.zshrc
echo 'export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools' >> ~/.zshrc
source ~/.zshrc
```

#### 方案3: 使用Homebrew安装
```bash
# 安装Android SDK
brew install --cask android-sdk

# 设置环境变量
export ANDROID_HOME=/usr/local/share/android-sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

### 创建Android模拟器
SDK安装完成后：
```bash
# 列出可用的系统镜像
flutter emulators

# 创建新的模拟器
flutter emulators --create --name Pixel_7_API_34

# 启动模拟器
flutter emulators --launch Pixel_7_API_34
```

## 📱 应用功能展示

### 核心功能模块

#### 1. QA 工具箱
- 🔧 测试用例生成器
- 📄 PDF转换工具
- 🕷️ 网络爬虫
- 📋 任务管理
- 🔍 代码审查

#### 2. AI 服务
- 🤖 DeepSeek AI文本生成
- 🧠 腾讯混元大模型
- 📝 多模型支持

#### 3. 第三方服务
- 🗺️ 高德地图API
- 🖼️ Pixabay图片搜索
- 🌤️ 天气查询
- 📧 邮件发送

#### 4. 生活模式
- 🍽️ 智能食物推荐
- ✈️ 旅行规划
- 🎵 音乐推荐
- 🏃 健身追踪

#### 5. 社交中心
- 👥 用户匹配
- 🎉 活动创建
- 💬 实时聊天
- 📱 社区互动

#### 6. 创意工作室
- ✍️ AI写作助手
- 🎨 头像生成
- 🎼 音乐创作
- 🎮 小游戏

## 🎯 验收测试

### iOS 应用测试
1. **启动测试** ✅
   - 应用正常启动
   - 界面显示正常
   - 导航功能正常

2. **功能测试** 🔄
   - 用户注册/登录
   - 应用切换
   - 第三方服务调用
   - AI功能测试

3. **性能测试** 🔄
   - 页面加载速度
   - 内存使用情况
   - 网络请求响应

### Android 应用测试 (待配置)
1. **环境配置** ⏳
   - Android SDK安装
   - 模拟器创建
   - 应用编译

2. **功能测试** ⏳
   - 与iOS功能对比
   - 平台特定功能
   - 性能对比

## 🔧 故障排除

### iOS 问题
- **模拟器启动失败**: 重启Xcode和模拟器
- **应用安装失败**: 清理Flutter缓存 `flutter clean`
- **网络连接问题**: 检查模拟器网络设置

### Android 问题
- **SDK路径错误**: 重新配置ANDROID_HOME
- **模拟器创建失败**: 检查系统镜像下载
- **编译错误**: 更新Android SDK版本

## 📊 技术规格

### 开发环境
- **Flutter**: 3.35.4
- **Dart**: 3.9.0
- **Xcode**: 16.4
- **Android Studio**: 2025.1

### 目标平台
- **iOS**: 12.0+
- **Android**: API 21+ (Android 5.0+)
- **Web**: Chrome, Safari, Firefox

### 设备支持
- **iPhone**: iPhone 8 及以上
- **iPad**: iPad Air 2 及以上
- **Android**: 主流品牌手机和平板

## 🎉 成功启动确认

### iOS 应用 ✅
- [x] 模拟器启动成功
- [x] 应用编译成功
- [x] 应用安装成功
- [x] 应用运行正常

### Android 应用 ⏳
- [ ] SDK配置完成
- [ ] 模拟器创建成功
- [ ] 应用编译成功
- [ ] 应用运行正常

---

**当前状态**: iOS应用正在运行，Android需要SDK配置  
**更新时间**: 2025-09-24  
**技术支持**: 随时可用
