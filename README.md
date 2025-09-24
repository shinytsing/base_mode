# QAToolBox App 流水线生产基座

🚀 一个基于Flutter的流水线化App生产平台，支持快速生成和部署多个应用。

## 📱 应用矩阵

- **QAToolBox Pro** - 工作效率工具
- **LifeMode** - 生活娱乐助手  
- **FitTracker** - 健康管理平台
- **SocialHub** - 社交互动中心
- **CreativeStudio** - 创作工具套件

## 🏗️ 技术架构

### 前端技术栈
- **Flutter 3.16+** - 跨平台UI框架
- **Riverpod** - 状态管理
- **Go Router** - 路由导航
- **Retrofit** - 网络请求
- **Hive** - 本地存储

### 后端技术栈
- **Go** - 高性能后端服务
- **PostgreSQL** - 主数据库
- **Redis** - 缓存和会话存储
- **Docker** - 容器化部署
- **Kubernetes** - 容器编排

### 开发工具
- **代码生成器** - 自动生成应用模板
- **CI/CD流水线** - 自动化构建部署
- **监控系统** - 性能监控和告警

## 🚀 快速开始

### 环境要求
- Flutter 3.16+
- Dart 3.0+
- Go 1.21+
- Docker & Docker Compose
- PostgreSQL 15+
- Redis 7+

### 安装步骤

1. **克隆项目**
```bash
git clone <repository-url>
cd base_mode
```

2. **安装Flutter依赖**
```bash
flutter pub get
```

3. **生成代码**
```bash
flutter packages pub run build_runner build
```

4. **启动开发环境**
```bash
docker-compose up -d
```

5. **运行应用**
```bash
flutter run
```

## 🛠️ 代码生成器

使用内置的代码生成器快速创建新应用：

```bash
dart scripts/generate_app.dart "MyApp" "my_app" "我的应用" "工具" "Icons.tool" "AppTheme.primaryColor" "功能1" "功能2"
```

### 生成器功能
- ✅ 自动创建目录结构
- ✅ 生成标准页面模板
- ✅ 创建服务层代码
- ✅ 生成数据模型
- ✅ 配置状态管理
- ✅ 更新路由配置

## 📦 项目结构

```
lib/
├── core/                    # 核心模块
│   ├── config/             # 应用配置
│   ├── models/             # 数据模型
│   ├── providers/          # 状态提供者
│   ├── router/             # 路由配置
│   ├── services/           # 网络服务
│   ├── theme/              # 主题配置
│   └── utils/              # 工具类
├── features/               # 功能模块
│   ├── auth/               # 认证模块
│   ├── home/               # 首页模块
│   ├── apps/               # 应用中心
│   ├── profile/            # 个人中心
│   └── membership/         # 会员系统
└── main.dart               # 应用入口
```

## 🔧 开发指南

### 添加新应用

1. **使用代码生成器**
```bash
dart scripts/generate_app.dart "NewApp" "new_app" "新应用描述" "分类" "Icons.icon" "AppTheme.color" "功能1" "功能2"
```

2. **手动添加应用**
- 在 `lib/features/` 下创建应用目录
- 实现页面、服务、模型等组件
- 更新路由配置
- 添加应用配置

### 自定义主题

修改 `lib/core/theme/app_theme.dart` 文件：

```dart
class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color secondaryColor = Color(0xFF8B5CF6);
  // ... 其他颜色配置
}
```

### 添加新功能

1. 在对应功能模块下创建组件
2. 实现业务逻辑
3. 添加状态管理
4. 更新路由配置
5. 编写测试用例

## 🚀 部署指南

### Docker部署

1. **构建镜像**
```bash
docker build -t qa-toolbox-app .
```

2. **启动服务**
```bash
docker-compose up -d
```

3. **查看日志**
```bash
docker-compose logs -f
```

### 生产环境部署

1. **配置环境变量**
```bash
export FLUTTER_ENV=production
export DATABASE_URL=postgresql://user:pass@host:port/db
export REDIS_URL=redis://host:port
```

2. **构建生产版本**
```bash
flutter build apk --release
flutter build ios --release
```

3. **部署到服务器**
```bash
# 使用CI/CD流水线自动部署
git push origin main
```

## 📊 监控和运维

### 监控面板
- **Grafana**: http://localhost:3000 (admin/admin)
- **Prometheus**: http://localhost:9090

### 日志查看
```bash
# 查看应用日志
docker-compose logs -f flutter-app

# 查看数据库日志
docker-compose logs -f postgres

# 查看Redis日志
docker-compose logs -f redis
```

### 性能监控
- 应用性能指标
- 数据库查询性能
- 缓存命中率
- 用户行为分析

## 🔐 安全配置

### 认证系统
- JWT Token认证
- 统一用户中心
- 跨应用权限管理
- 会员状态同步

### 数据安全
- 数据加密存储
- HTTPS传输
- 敏感信息脱敏
- 定期安全审计

## 📈 性能优化

### 前端优化
- 代码分割和懒加载
- 图片压缩和缓存
- 状态管理优化
- 内存泄漏检测

### 后端优化
- 数据库索引优化
- 缓存策略优化
- API响应压缩
- 负载均衡配置

## 🤝 贡献指南

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🆘 支持

- 📧 邮箱: support@qatoolbox.com
- 💬 微信群: 扫码加入开发者群
- 📖 文档: [docs.qatoolbox.com](https://docs.qatoolbox.com)
- 🐛 问题反馈: [GitHub Issues](https://github.com/qatoolbox/issues)

## 🎯 路线图

### 第一阶段 (1-2个月)
- [x] 搭建Flutter基座
- [x] 实现统一认证
- [x] 建立CI/CD流水线
- [ ] 开发第一个应用

### 第二阶段 (2-3个月)
- [ ] 完善代码生成器
- [ ] 建立监控系统
- [ ] 批量生产应用
- [ ] 内测优化

### 第三阶段 (3-4个月)
- [ ] 商业化功能
- [ ] 用户增长体系
- [ ] 企业版开发
- [ ] 正式上线

---

**QAToolBox** - 让App开发更高效！ 🚀
