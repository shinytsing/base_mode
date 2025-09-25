key在这里
# 🔑 项目API密钥汇总

## 📋 概述

本文档汇总了modeshift_django项目中所有使用的API密钥和第三方服务配置，方便在其他项目中复用。

## 🎯 核心AI服务API密钥

### 1. DeepSeek AI (主要AI服务)
- **环境变量**: `DEEPSEEK_API_KEY`
- **当前值**: `sk-c4a84c8bbff341cbb3006ecaf84030fe`
- **用途**: 主要AI对话和内容生成服务
- **状态**: ✅ 已配置，余额不足需充值
- **API文档**: https://api.deepseek.com/

### 2. AIMLAPI (聚合AI服务)
- **环境变量**: `AIMLAPI_API_KEY`
- **当前值**: `d78968b01cd8440eb7b28d683f3230da`
- **用途**: 支持200+种AI模型的聚合服务
- **状态**: ⚠️ 需要验证
- **验证页面**: https://aimlapi.com/app/billing/verification

### 3. 腾讯混元大模型 (推荐使用)
- **环境变量**: `TENCENT_SECRET_ID`, `TENCENT_SECRET_KEY`
- **当前值**: 
  - `TENCENT_SECRET_ID`: `100032618506_100032618506_16a17a3a4bc2eba0534e7b25c4363fc8`
  - `TENCENT_SECRET_KEY`: `sk-O5tVxVeCGTtSgPlaHMuPe9CdmgEUuy2d79yK5rf5Rp5qsI3m`
- **用途**: 腾讯云混元大模型服务，国内访问稳定
- **状态**: ✅ 已配置，推荐优先使用
- **API文档**: https://cloud.tencent.com/document/product/1729/101848

## 🌐 其他AI服务配置

### 免费AI服务 (推荐配置)
```bash
# Groq API - 免费额度大，速度快
GROQ_API_KEY=your_groq_api_key_here

# AI Tools API - 无需登录，兼容OpenAI
AITOOLS_API_KEY=your_aitools_key_here

# Together AI - 有免费额度
TOGETHER_API_KEY=your_together_api_key_here

# OpenRouter - 聚合多个模型
OPENROUTER_API_KEY=your_openrouter_api_key_here

# 讯飞星火 - 完全免费
XUNFEI_API_KEY=your_xunfei_key_here

# 百度千帆 - 免费额度
BAIDU_API_KEY=your_baidu_key_here

# 字节扣子 - 开发者免费
BYTEDANCE_API_KEY=your_bytedance_key_here

# 硅基流动 - 免费额度
SILICONFLOW_API_KEY=your_siliconflow_key_here
```

## 🗺️ 地图和位置服务

### 高德地图API
- **环境变量**: `AMAP_API_KEY`
- **当前值**: `a825cd9231f473717912d3203a62c53e`
- **用途**: 地图服务、位置查询、路径规划
- **API文档**: https://lbs.amap.com/

## 🖼️ 图片和媒体服务

### Pixabay图片API
- **环境变量**: `PIXABAY_API_KEY`
- **当前值**: `36817612-8c0c4c8c8c8c8c8c8c8c8c8c`
- **用途**: 免费图片素材获取
- **API文档**: https://pixabay.com/api/docs/

## 🌤️ 天气服务

### OpenWeather API
- **环境变量**: `OPENWEATHER_API_KEY`
- **用途**: 天气信息查询
- **API文档**: https://openweathermap.org/api

## 🔍 搜索引擎服务

### Google API
- **环境变量**: `GOOGLE_API_KEY`, `GOOGLE_CSE_ID`
- **用途**: Google搜索和自定义搜索
- **API文档**: https://developers.google.com/custom-search/v1/introduction

## 🔐 OAuth认证服务

### Google OAuth
- **环境变量**: `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`
- **当前值**:
  - `GOOGLE_OAUTH_CLIENT_ID`: `1046109123456-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com`
  - `GOOGLE_OAUTH_CLIENT_SECRET`: `GOCSPX-abcdefghijklmnopqrstuvwxyz123456`
- **用途**: Google用户认证和授权
- **API文档**: https://developers.google.com/identity/protocols/oauth2

## 📧 邮件服务

### SMTP邮件配置
- **环境变量**: `EMAIL_HOST`, `EMAIL_PORT`, `EMAIL_HOST_USER`, `EMAIL_HOST_PASSWORD`
- **当前配置**:
  - `EMAIL_HOST`: `smtp.qq.com`
  - `EMAIL_PORT`: `587`
  - `EMAIL_HOST_USER`: `your-email@qq.com`
  - `EMAIL_HOST_PASSWORD`: `your-email-password`
- **用途**: 系统邮件发送

## 📱 社交媒体API (预留配置)

```bash
# 小红书API
XIAOHONGSHU_API_KEY=your-xiaohongshu-api-key

# 抖音API
DOUYIN_API_KEY=your-douyin-api-key

# 网易API
NETEASE_API_KEY=your-netease-api-key

# 微博API
WEIBO_API_KEY=your-weibo-api-key

# B站API
BILIBILI_API_KEY=your-bilibili-api-key

# 知乎API
ZHIHU_API_KEY=your-zhihu-api-key
```

## 🗄️ 数据库配置

### PostgreSQL数据库
- **环境变量**: `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`
- **当前配置**:
  - `DB_NAME`: `qatoolbox_production`
  - `DB_USER`: `qatoolbox`
  - `DB_PASSWORD`: `qatoolbox123`
  - `DB_HOST`: `localhost`
  - `DB_PORT`: `5432`

### Redis缓存
- **环境变量**: `REDIS_URL`, `REDIS_PASSWORD`
- **当前配置**:
  - `REDIS_URL`: `redis://localhost:6379/0`
  - `REDIS_PASSWORD`: `redis123`

## 🔧 环境变量文件结构

### 开发环境 (.env)
```bash
# Django基础配置
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_DEBUG=True
DJANGO_SETTINGS_MODULE=config.settings.development

# AI服务API密钥
DEEPSEEK_API_KEY=your-deepseek-api-key
AIMLAPI_API_KEY=d78968b01cd8440eb7b28d683f3230da
GROQ_API_KEY=your-groq-api-key
AITOOLS_API_KEY=your-aitools-api-key

# 地图和图片服务
AMAP_API_KEY=a825cd9231f473717912d3203a62c53e
PIXABAY_API_KEY=36817612-8c0c4c8c8c8c8c8c8c8c8c8c

# Google服务
GOOGLE_API_KEY=your-google-api-key
GOOGLE_CSE_ID=your-google-custom-search-engine-id
GOOGLE_OAUTH_CLIENT_ID=your-google-oauth-client-id
GOOGLE_OAUTH_CLIENT_SECRET=your-google-oauth-client-secret

# 天气服务
OPENWEATHER_API_KEY=your-openweather-api-key

# 腾讯混元
TENCENT_SECRET_ID=100032618506_100032618506_16a17a3a4bc2eba0534e7b25c4363fc8
TENCENT_SECRET_KEY=sk-O5tVxVeCGTtSgPlaHMuPe9CdmgEUuy2d79yK5rf5Rp5qsI3m

# 数据库配置
DB_NAME=qatoolbox_local
DB_USER=gaojie
DB_PASSWORD=
DB_HOST=localhost
DB_PORT=5432

# Redis配置
REDIS_URL=redis://localhost:6379/0
```

### 生产环境 (env.production)
```bash
# Django基础配置
DJANGO_SECRET_KEY=django-aliyun-production-key-$(openssl rand -hex 32)
DEBUG=False
DJANGO_SETTINGS_MODULE=config.settings.production

# 主机配置
ALLOWED_HOSTS=shenyiqing.xin,www.shenyiqing.xin,47.103.143.152,localhost,127.0.0.1

# AI服务API密钥
DEEPSEEK_API_KEY=sk-c4a84c8bbff341cbb3006ecaf84030fe
AIMLAPI_API_KEY=d78968b01cd8440eb7b28d683f3230da

# 地图和图片服务
AMAP_API_KEY=a825cd9231f473717912d3203a62c53e
PIXABAY_API_KEY=36817612-8c0c4c8c8c8c8c8c8c8c8c8c

# Google OAuth配置
GOOGLE_OAUTH_CLIENT_ID=1046109123456-abcdefghijklmnopqrstuvwxyz123456.apps.googleusercontent.com
GOOGLE_OAUTH_CLIENT_SECRET=GOCSPX-abcdefghijklmnopqrstuvwxyz123456

# 腾讯混元
TENCENT_SECRET_ID=100032618506_100032618506_16a17a3a4bc2eba0534e7b25c4363fc8
TENCENT_SECRET_KEY=sk-O5tVxVeCGTtSgPlaHMuPe9CdmgEUuy2d79yK5rf5Rp5qsI3m

# 数据库配置
DB_NAME=qatoolbox
DB_USER=qatoolbox
DB_PASSWORD=qatoolbox123
DB_HOST=localhost
DB_PORT=5432

# Redis配置
REDIS_URL=redis://localhost:6379/0
```

## 🚀 快速配置脚本

### 1. 配置AI Tools API (推荐，无需登录)
```bash
python setup_aitools_api.py
```

### 2. 配置Groq API (推荐，免费额度大)
```bash
python quick_setup_groq.py
```

### 3. 配置腾讯混元API
```bash
python setup_tencent_hunyuan.py
```

## 📊 服务优先级

系统会按以下优先级自动选择可用的AI服务：

1. **AIMLAPI** (你的密钥) - 最高优先级
2. **AI Tools** (无需登录) - 立即可用
3. **Groq** (免费额度大) - 推荐
4. **讯飞星火** (完全免费) - 国内服务
5. **百度千帆** (免费额度) - 国内服务
6. **腾讯混元** (免费版本) - 国内服务
7. **字节扣子** (开发者免费) - 国内服务
8. **硅基流动** (免费额度) - 国内服务
9. **DeepSeek** (备用) - 费用较高

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

- **2024-12-29**: 初始版本，汇总所有API密钥配置
- **2025-01-07**: 添加免费AI服务配置指南

---

**注意**: 请根据实际需要选择合适的API服务，并确保在生产环境中正确配置所有必要的环境变量。


更新下