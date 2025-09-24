# QAToolBox 系统部署和测试指南

## 🚀 快速启动

### 1. 环境要求
- Docker & Docker Compose
- Flutter SDK 3.16+
- Go 1.21+
- PostgreSQL 15+
- Redis 7+

### 2. 一键启动
```bash
# 克隆项目
git clone <repository-url>
cd base_mode

# 启动系统
./scripts/start.sh
```

### 3. 访问地址
- **前端**: http://localhost:3000
- **后端API**: http://localhost:8080
- **监控面板**: http://localhost:3001 (admin/admin)
- **Prometheus**: http://localhost:9090

## 🏗️ 架构说明

### 正确的架构设计
```
┌─────────────────┐    HTTP/API    ┌─────────────────┐
│   Flutter App   │ ──────────────▶│   Go Backend    │
│   (UI Layer)    │                │  (Business Logic)│
└─────────────────┘                └─────────────────┘
                                          │
                                          ▼
                                   ┌─────────────────┐
                                   │   PostgreSQL    │
                                   │   (Data Layer)  │
                                   └─────────────────┘
```

### 核心组件
1. **Flutter前端**: 跨平台UI界面
2. **Go后端**: 业务逻辑处理
3. **PostgreSQL**: 数据存储
4. **Redis**: 缓存和会话
5. **Nginx**: 反向代理
6. **Prometheus**: 监控
7. **Grafana**: 可视化

## 📱 应用功能

### QAToolBox Pro
- ✅ AI测试用例生成器
- ✅ PDF转换器
- ✅ 任务管理器
- ✅ 网络爬虫
- ✅ API测试工具
- ✅ 代码审查

### FitTracker
- ✅ 健身计划管理
- ✅ 锻炼记录
- ✅ 饮食记录
- ✅ 体重跟踪
- ✅ 数据分析

### 会员体系
- ✅ 多层级会员计划
- ✅ 支付集成
- ✅ 使用统计
- ✅ 权限管理

### 数据分析
- ✅ 用户行为分析
- ✅ 使用趋势图表
- ✅ 性能监控
- ✅ 收入统计

## 🔧 开发指南

### 后端开发
```bash
cd backend
go mod tidy
go run main.go
```

### 前端开发
```bash
flutter pub get
flutter run
```

### 数据库操作
```bash
# 连接数据库
psql -h localhost -U qa_toolbox_user -d qa_toolbox

# 运行迁移
psql -h localhost -U qa_toolbox_user -d qa_toolbox -f scripts/init.sql
```

## 🧪 测试

### 单元测试
```bash
# 后端测试
cd backend
go test ./...

# 前端测试
flutter test
```

### 集成测试
```bash
# 启动测试环境
docker-compose -f docker-compose.test.yml up

# 运行集成测试
go test ./tests/integration/...
```

### API测试
```bash
# 使用curl测试API
curl -X POST http://localhost:8080/api/v1/test-cases/generate \
  -H "Content-Type: application/json" \
  -d '{"code":"function test(){}","language":"dart","framework":"flutter"}'
```

## 📊 监控

### 健康检查
- 后端: http://localhost:8080/health
- 数据库: 检查PostgreSQL连接
- Redis: 检查Redis连接

### 性能监控
- CPU使用率
- 内存使用率
- 数据库连接数
- API响应时间
- 错误率

### 日志查看
```bash
# 查看所有服务日志
docker-compose logs -f

# 查看特定服务日志
docker-compose logs -f backend
docker-compose logs -f frontend
```

## 🚀 部署

### 生产环境部署
```bash
# 设置生产环境变量
cp backend/env.example backend/.env
# 编辑 .env 文件

# 构建生产镜像
docker-compose -f docker-compose.prod.yml build

# 部署到生产环境
docker-compose -f docker-compose.prod.yml up -d
```

### 环境变量配置
```bash
# 生产环境
ENVIRONMENT=production
DATABASE_URL=postgres://user:pass@db:5432/qa_toolbox
REDIS_URL=redis://redis:6379
JWT_SECRET=your-production-secret
```

## 🔒 安全

### 安全措施
- JWT Token认证
- HTTPS传输
- 数据加密存储
- 访问控制
- 防火墙配置

### 安全审计
```bash
# 检查安全漏洞
docker run --rm -v $(pwd):/app securecodewarrior/docker-security-scan
```

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

## 🐛 故障排除

### 常见问题

1. **数据库连接失败**
   ```bash
   # 检查数据库状态
   docker-compose ps postgres
   
   # 重启数据库
   docker-compose restart postgres
   ```

2. **API调用失败**
   ```bash
   # 检查后端日志
   docker-compose logs backend
   
   # 检查网络连接
   curl http://localhost:8080/health
   ```

3. **前端构建失败**
   ```bash
   # 清理Flutter缓存
   flutter clean
   flutter pub get
   
   # 重新构建
   flutter build web
   ```

### 日志级别
- DEBUG: 详细调试信息
- INFO: 一般信息
- WARN: 警告信息
- ERROR: 错误信息

## 📞 技术支持

- 📧 邮箱: support@qatoolbox.com
- 💬 微信群: 扫码加入开发者群
- 📖 文档: [docs.qatoolbox.com](https://docs.qatoolbox.com)
- 🐛 问题反馈: [GitHub Issues](https://github.com/qatoolbox/issues)

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

**QAToolBox** - 让App开发更高效！ 🚀

*最后更新: 2024年12月*
