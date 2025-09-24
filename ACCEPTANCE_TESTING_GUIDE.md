# QA ToolBox 验收测试指南

## 🎯 项目概述

QA ToolBox 是一个多功能的质量保证工具箱，包含以下核心功能：

### 📱 前端应用 (Flutter)
- **多应用架构**：支持 QA ToolBox、Business App、Social App、Productivity App
- **响应式设计**：适配 Web、iOS、Android 平台
- **现代化UI**：基于 Material Design 3

### ⚙️ 后端服务 (Go)
- **RESTful API**：完整的 API 服务
- **数据库支持**：PostgreSQL + Redis
- **第三方集成**：AI 服务、地图、支付等

## 🚀 快速启动

### 1. 启动基础服务

```bash
# 启动数据库和缓存
cd /Users/gaojie/Desktop/base_mode
docker-compose up -d postgres redis

# 等待服务启动
sleep 10
```

### 2. 启动后端服务

```bash
# 启动 Go 后端
cd backend
go run main.go
```

后端将在 `http://localhost:8080` 启动

### 3. 启动前端应用

```bash
# 安装依赖
flutter pub get

# 启动 Web 应用
flutter run -d web-server --web-port 3000
```

前端将在 `http://localhost:3000` 启动

## 🧪 功能验收测试

### 1. 后端 API 测试

#### 健康检查
```bash
curl http://localhost:8080/api/v1/health
```
预期返回：
```json
{
  "status": "ok",
  "timestamp": "2025-09-24T07:20:00Z",
  "services": {
    "database": "connected",
    "redis": "connected"
  }
}
```

#### 用户注册
```bash
curl -X POST http://localhost:8080/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser2",
    "password": "password123",
    "first_name": "测试",
    "last_name": "用户"
  }'
```

#### 用户登录
```bash
curl -X POST http://localhost:8080/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

#### 获取应用列表
```bash
curl http://localhost:8080/api/v1/apps
```

#### 第三方服务状态
```bash
curl http://localhost:8080/api/v1/third-party/status
```

### 2. 前端功能测试

#### 主要页面
1. **首页** (`http://localhost:3000`)
   - 显示应用概览
   - 导航菜单正常工作
   - 响应式布局

2. **应用页面** (`http://localhost:3000/apps`)
   - 显示应用列表
   - 应用安装功能
   - 应用详情页面

3. **个人中心** (`http://localhost:3000/profile`)
   - 用户信息显示
   - 会员中心入口
   - 设置页面

#### 核心功能模块

1. **QA 工具箱**
   - 测试用例生成
   - PDF 转换工具
   - 网络爬虫
   - 任务管理
   - 代码审查

2. **AI 服务**
   - 文本生成
   - 多模型支持
   - 服务状态监控

3. **第三方服务**
   - 地图服务（高德）
   - 图片搜索（Pixabay）
   - 天气查询
   - 邮件发送

4. **生活模式**
   - 食物推荐
   - 旅行规划
   - 音乐推荐
   - 健康追踪

5. **社交中心**
   - 用户匹配
   - 活动创建
   - 聊天功能
   - 社区互动

## 📊 技术栈验收

### 后端技术
- ✅ Go 1.21
- ✅ Gin Web 框架
- ✅ PostgreSQL 15 数据库
- ✅ Redis 缓存
- ✅ JWT 认证
- ✅ Docker 容器化

### 前端技术
- ✅ Flutter 3.35.4
- ✅ Dart 语言
- ✅ Riverpod 状态管理
- ✅ GoRouter 路由
- ✅ Material Design 3
- ✅ 响应式设计

### 第三方集成
- ✅ DeepSeek AI
- ✅ 腾讯混元大模型
- ✅ 高德地图 API
- ✅ Pixabay 图片 API
- ✅ Stripe 支付

## 🔧 开发环境配置

### 环境变量
```bash
# 数据库配置
DATABASE_URL=postgres://qa_toolbox_user:qa_toolbox_password@localhost:5432/qa_toolbox?sslmode=disable

# Redis 配置
REDIS_URL=redis://localhost:6379

# JWT 密钥
JWT_SECRET=your-super-secret-jwt-key

# 第三方 API 密钥
DEEPSEEK_API_KEY=sk-c4a84c8bbff341cbb3006ecaf84030fe
AIMLAPI_KEY=d78968b01cd8440eb7b28d683f3230da
TENCENT_SECRET_ID=your-secret-id
TENCENT_SECRET_KEY=your-secret-key
AMAP_API_KEY=a825cd9231f473717912d3203a62c53e
PIXABAY_API_KEY=36817612-8c0c4c8c8c8c8c8c8c8c8c8c
```

### 数据库结构
- ✅ 用户管理表
- ✅ 应用管理表
- ✅ 会员体系表
- ✅ 支付记录表
- ✅ 日志审计表

## 🐛 已知问题和解决方案

### 1. 网络连接问题
如果遇到网络连接错误，请检查：
- Docker 容器是否正常运行
- 端口是否被占用
- 防火墙设置

### 2. 依赖安装问题
如果 Flutter 或 Go 依赖安装失败：
```bash
# Flutter
flutter clean && flutter pub get

# Go
go mod tidy && go mod download
```

### 3. 数据库连接问题
如果数据库连接失败：
```bash
# 重启数据库容器
docker-compose restart postgres

# 检查数据库状态
docker logs qa_toolbox_postgres
```

## 📝 验收清单

### 基础功能 ✅
- [x] 应用启动正常
- [x] 数据库连接成功
- [x] API 服务响应正常
- [x] 前端页面加载正常

### 核心功能 ✅
- [x] 用户认证系统
- [x] 应用管理功能
- [x] 第三方服务集成
- [x] AI 服务调用
- [x] 支付系统集成

### 高级功能 ✅
- [x] 多应用架构
- [x] 响应式设计
- [x] 实时功能
- [x] 数据分析
- [x] 监控告警

### 部署相关 ✅
- [x] Docker 容器化
- [x] 环境配置
- [x] 日志系统
- [x] 备份策略

## 🎉 验收结论

QA ToolBox 项目已完成主要功能开发，包括：

1. **完整的全栈架构**：前后端分离，技术栈现代化
2. **丰富的功能模块**：涵盖 QA 工具、AI 服务、生活应用等
3. **完善的第三方集成**：支持多种 AI 模型和外部服务
4. **生产级部署方案**：Docker 容器化，支持扩展

项目代码结构清晰，文档完善，可以进行生产环境部署和进一步开发。

## 📞 技术支持

如有问题或需要支持，请联系开发团队。

---

**验收时间**: 2025-09-24  
**项目版本**: 1.0.0  
**验收状态**: ✅ 通过
