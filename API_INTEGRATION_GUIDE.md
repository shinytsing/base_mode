# 🔑 QAToolBox API集成指南

## 📋 概述

本文档详细说明了QAToolBox项目中集成的所有API服务，包括AI服务和第三方服务的使用方法。

## 🎯 已集成的API服务

### 🤖 AI服务 (按优先级排序)

1. **AIMLAPI** - 聚合AI服务，支持200+种模型
2. **AI Tools** - 无需登录，兼容OpenAI
3. **Groq** - 免费额度大，速度快
4. **讯飞星火** - 完全免费
5. **百度千帆** - 免费额度
6. **腾讯混元** - 免费版本
7. **字节扣子** - 开发者免费
8. **硅基流动** - 免费额度
9. **DeepSeek** - 备用服务
10. **Together AI** - 有免费额度
11. **OpenRouter** - 聚合多个模型

### 🌐 第三方服务

1. **高德地图** - 地图服务、位置查询、路径规划
2. **Pixabay** - 免费图片素材获取
3. **OpenWeather** - 天气信息查询
4. **Google搜索** - Google搜索和自定义搜索
5. **邮件服务** - SMTP邮件发送

## 🚀 快速开始

### 1. 环境配置

复制环境变量配置文件：

```bash
cp backend/env.example backend/.env
```

编辑 `backend/.env` 文件，填入你的API密钥：

```bash
# AI服务API密钥
DEEPSEEK_API_KEY=sk-c4a84c8bbff341cbb3006ecaf84030fe
AIMLAPI_API_KEY=d78968b01cd8440eb7b28d683f3230da
TENCENT_SECRET_ID=100032618506_100032618506_16a17a3a4bc2eba0534e7b25c4363fc8
TENCENT_SECRET_KEY=sk-O5tVxVeCGTtSgPlaHMuPe9CdmgEUuy2d79yK5rf5Rp5qsI3m

# 第三方服务API密钥
AMAP_API_KEY=a825cd9231f473717912d3203a62c53e
PIXABAY_API_KEY=36817612-8c0c4c8c8c8c8c8c8c8c8c8c
GOOGLE_OAUTH_CLIENT_ID=1046109123456-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=GOCSPX-abcdefghijklmnopqrstuvwxyz123456
```

### 2. 启动服务

使用快速启动脚本：

```bash
# 启动所有服务（Web版本）
./scripts/start_services.sh web

# 启动所有服务（macOS版本）
./scripts/start_services.sh macos

# 启动所有服务（iOS版本）
./scripts/start_services.sh ios

# 启动所有服务（Android版本）
./scripts/start_services.sh android
```

### 3. 测试API

运行API测试脚本：

```bash
dart scripts/test_api.dart
```

## 📚 API使用指南

### 🤖 AI服务API

#### 生成文本

```bash
curl -X POST http://localhost:8080/api/v1/ai/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "user",
        "content": "你好，请介绍一下你自己"
      }
    ],
    "temperature": 0.7,
    "max_tokens": 1000
  }'
```

#### 获取可用服务

```bash
curl http://localhost:8080/api/v1/ai/services
```

#### 测试特定服务

```bash
curl http://localhost:8080/api/v1/ai/services/deepseek/test
```

#### 获取服务统计

```bash
curl http://localhost:8080/api/v1/ai/stats
```

### 🌐 第三方服务API

#### 高德地图 - 地理编码

```bash
curl -X POST http://localhost:8080/api/v1/third-party/amap/geocode \
  -H "Content-Type: application/json" \
  -d '{
    "address": "北京市天安门广场"
  }'
```

#### 高德地图 - 逆地理编码

```bash
curl -X POST http://localhost:8080/api/v1/third-party/amap/regeocode \
  -H "Content-Type: application/json" \
  -d '{
    "longitude": 116.397128,
    "latitude": 39.916527
  }'
```

#### Pixabay - 搜索图片

```bash
curl -X POST http://localhost:8080/api/v1/third-party/pixabay/search \
  -H "Content-Type: application/json" \
  -d '{
    "query": "nature",
    "category": "nature",
    "per_page": 20
  }'
```

#### OpenWeather - 获取天气

```bash
curl -X POST http://localhost:8080/api/v1/third-party/weather \
  -H "Content-Type: application/json" \
  -d '{
    "city": "Beijing",
    "country_code": "CN"
  }'
```

#### Google - 搜索

```bash
curl -X POST http://localhost:8080/api/v1/third-party/google/search \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Flutter开发",
    "num": 10
  }'
```

#### 邮件服务 - 发送邮件

```bash
curl -X POST http://localhost:8080/api/v1/third-party/email/send \
  -H "Content-Type: application/json" \
  -d '{
    "to": ["user@example.com"],
    "subject": "测试邮件",
    "body": "这是一封测试邮件",
    "is_html": false
  }'
```

#### 检查服务状态

```bash
# 检查特定服务状态
curl http://localhost:8080/api/v1/third-party/status/amap

# 检查所有服务状态
curl http://localhost:8080/api/v1/third-party/status
```

## 📱 Flutter客户端使用

### AI服务客户端

```dart
import 'package:qa_toolbox_base/core/services/ai_service.dart';

// 生成文本
final text = await AIServiceClient.generateText(
  prompt: '请介绍一下Flutter',
  model: 'gpt-3.5-turbo',
  temperature: 0.7,
  maxTokens: 1000,
);

// 生成对话
final response = await AIServiceClient.generateConversation(
  messages: [
    AIMessage(role: 'user', content: '你好'),
    AIMessage(role: 'assistant', content: '你好！有什么可以帮助你的吗？'),
    AIMessage(role: 'user', content: '请介绍一下AI'),
  ],
);

// 获取可用服务
final services = await AIServiceClient.getAvailableServices();
```

### 第三方服务客户端

```dart
import 'package:qa_toolbox_base/core/services/third_party_service.dart';

// 高德地图地理编码
final geocodeResponse = await ThirdPartyServiceClient.geocode('北京市天安门广场');

// 高德地图逆地理编码
final regeocodeResponse = await ThirdPartyServiceClient.regeocode(116.397128, 39.916527);

// Pixabay搜索图片
final imagesResponse = await ThirdPartyServiceClient.searchImages(
  query: 'nature',
  category: 'nature',
  perPage: 20,
);

// OpenWeather获取天气
final weatherResponse = await ThirdPartyServiceClient.getWeather(
  city: 'Beijing',
  countryCode: 'CN',
);

// Google搜索
final searchResponse = await ThirdPartyServiceClient.search(
  query: 'Flutter开发',
  num: 10,
);

// 发送邮件
final emailResponse = await ThirdPartyServiceClient.sendEmail(
  to: ['user@example.com'],
  subject: '测试邮件',
  body: '这是一封测试邮件',
);

// 检查服务状态
final status = await ThirdPartyServiceClient.checkServiceStatus('amap');
```

## 🔧 配置说明

### AI服务配置

系统会自动按优先级选择可用的AI服务：

1. **AIMLAPI** (你的密钥) - 最高优先级
2. **AI Tools** (无需登录) - 立即可用
3. **Groq** (免费额度大) - 推荐
4. **讯飞星火** (完全免费) - 国内服务
5. **百度千帆** (免费额度) - 国内服务
6. **腾讯混元** (免费版本) - 国内服务
7. **字节扣子** (开发者免费) - 国内服务
8. **硅基流动** (免费额度) - 国内服务
9. **DeepSeek** (备用) - 费用较高

### 第三方服务配置

- **高德地图**: 需要申请API密钥
- **Pixabay**: 需要注册账号获取API密钥
- **OpenWeather**: 需要注册账号获取API密钥
- **Google搜索**: 需要Google Cloud Console配置
- **邮件服务**: 需要SMTP服务器配置

## 🛠️ 开发指南

### 添加新的AI服务

1. 在 `backend/internal/services/ai_client.go` 中添加新的客户端
2. 在 `backend/internal/config/config.go` 中添加配置项
3. 在 `backend/env.example` 中添加环境变量
4. 更新服务优先级列表

### 添加新的第三方服务

1. 在 `backend/internal/services/third_party_client.go` 中添加新的客户端
2. 在 `backend/internal/api/third_party_handler.go` 中添加API处理器
3. 在 `lib/core/services/third_party_service.dart` 中添加Flutter客户端
4. 更新API配置

## 🔒 安全注意事项

1. **永远不要**将API密钥提交到版本控制
2. **永远不要**在日志中输出API密钥
3. **永远不要**在错误消息中暴露API密钥
4. 使用 `.gitignore` 忽略包含密钥的文件
5. 定期审查代码中的密钥使用情况
6. 定期轮换API密钥
7. 监控API使用情况

## 📞 获取帮助

- **DeepSeek**: https://api.deepseek.com/
- **AIMLAPI**: https://aimlapi.com/app/billing/verification
- **AI Tools**: https://platform.aitools.cfd/
- **Groq**: https://console.groq.com/
- **腾讯混元**: https://hunyuan.tencent.com/
- **高德地图**: https://lbs.amap.com/
- **Pixabay**: https://pixabay.com/api/docs/
- **Google OAuth**: https://developers.google.com/identity/protocols/oauth2

## 📝 更新记录

- **2024-12-29**: 初始版本，集成所有API服务
- **2025-01-07**: 添加Flutter客户端和测试脚本

---

**注意**: 请根据实际需要选择合适的API服务，并确保在生产环境中正确配置所有必要的环境变量。
