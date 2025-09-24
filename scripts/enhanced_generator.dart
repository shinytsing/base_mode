#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';
import '../lib/core/generator/template_manager.dart';
import '../lib/core/generator/config_manager.dart';

/// 增强版代码生成器 - 支持配置驱动和AI集成
class EnhancedCodeGenerator {
  final bool useAI;
  final bool verbose;
  
  EnhancedCodeGenerator({
    this.useAI = false,
    this.verbose = false,
  });
  
  /// 生成单个应用
  Future<void> generateApp(AppConfig config) async {
    if (verbose) {
      print('🚀 开始生成应用: ${config.name}');
      print('   ID: ${config.id}');
      print('   描述: ${config.description}');
      print('   功能数量: ${config.features.length}');
    }
    
    final generator = EnhancedAppGenerator(
      config: config,
      useAI: useAI,
    );
    
    await generator.generateApp();
    
    // 生成微服务代码
    await _generateMicroservice(config);
    
    // 生成数据库迁移
    await _generateDatabaseMigrations(config);
    
    // 生成API文档
    await _generateAPIDocumentation(config);
    
    // 生成测试套件
    await _generateTestSuite(config);
    
    if (verbose) {
      print('✅ 应用 ${config.name} 生成完成！');
    }
  }
  
  /// 批量生成所有应用
  Future<void> generateAllApps() async {
    print('🔄 开始批量生成所有应用...');
    
    final configs = await AppConfigManager.getAllAppConfigs();
    
    if (configs.isEmpty) {
      print('❌ 未找到任何应用配置');
      return;
    }
    
    for (final config in configs) {
      try {
        await generateApp(config);
        print('✅ ${config.name} 生成成功');
      } catch (e) {
        print('❌ ${config.name} 生成失败: $e');
      }
    }
    
    // 生成统一的配置文件
    await _generateUnifiedConfigs(configs);
    
    print('🎉 批量生成完成！');
  }
  
  /// 生成微服务代码
  Future<void> _generateMicroservice(AppConfig config) async {
    if (verbose) print('🔧 生成微服务代码...');
    
    // 创建微服务目录
    final serviceDir = 'backend/services/${config.id}';
    await Directory(serviceDir).create(recursive: true);
    
    // 生成Go服务代码
    await _generateGoService(config, serviceDir);
    
    // 生成Docker配置
    await _generateDockerConfig(config, serviceDir);
    
    // 生成Kubernetes配置
    await _generateKubernetesConfig(config);
  }
  
  /// 生成Go服务代码
  Future<void> _generateGoService(AppConfig config, String serviceDir) async {
    // main.go
    final mainGoContent = '''
package main

import (
    "log"
    "net/http"
    "os"
    
    "github.com/gin-gonic/gin"
    "github.com/qatoolbox/${config.id}/internal/handlers"
    "github.com/qatoolbox/${config.id}/internal/middleware"
    "github.com/qatoolbox/${config.id}/internal/config"
)

func main() {
    cfg := config.Load()
    
    r := gin.Default()
    
    // 中间件
    r.Use(middleware.CORS())
    r.Use(middleware.Logger())
    r.Use(middleware.ErrorHandler())
    r.Use(middleware.Auth())
    
    // 路由
    api := r.Group("/api/v1")
    handlers.RegisterRoutes(api, cfg)
    
    port := os.Getenv("PORT")
    if port == "" {
        port = "${config.servicePort ?? "8080"}"
    }
    
    log.Printf("${config.name} 服务启动在端口 %s", port)
    log.Fatal(http.ListenAndServe(":"+port, r))
}
''';
    
    await File('$serviceDir/main.go').writeAsString(mainGoContent);
    
    // go.mod
    final goModContent = '''
module github.com/qatoolbox/${config.id}

go 1.21

require (
    github.com/gin-gonic/gin v1.9.1
    github.com/golang-jwt/jwt/v5 v5.0.0
    gorm.io/gorm v1.25.4
    gorm.io/driver/postgres v1.5.2
    github.com/redis/go-redis/v9 v9.2.1
)
''';
    
    await File('$serviceDir/go.mod').writeAsString(goModContent);
    
    // 生成处理器
    await _generateHandlers(config, serviceDir);
    
    // 生成模型
    await _generateModels(config, serviceDir);
    
    // 生成中间件
    await _generateMiddleware(config, serviceDir);
  }
  
  /// 生成处理器
  Future<void> _generateHandlers(AppConfig config, String serviceDir) async {
    final handlersDir = '$serviceDir/internal/handlers';
    await Directory(handlersDir).create(recursive: true);
    
    final handlerContent = '''
package handlers

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "github.com/qatoolbox/${config.id}/internal/config"
    "github.com/qatoolbox/${config.id}/internal/models"
    "github.com/qatoolbox/${config.id}/internal/services"
)

type ${_toPascalCase(config.name)}Handler struct {
    service *services.${_toPascalCase(config.name)}Service
}

func New${_toPascalCase(config.name)}Handler(service *services.${_toPascalCase(config.name)}Service) *${_toPascalCase(config.name)}Handler {
    return &${_toPascalCase(config.name)}Handler{
        service: service,
    }
}

// 注册路由
func RegisterRoutes(r *gin.RouterGroup, cfg *config.Config) {
    service := services.New${_toPascalCase(config.name)}Service(cfg)
    handler := New${_toPascalCase(config.name)}Handler(service)
    
    ${config.id} := r.Group("/${config.id.replaceAll('_', '-')}")
    {
        ${config.id}.GET("/health", handler.Health)
        ${config.id}.GET("/data", handler.GetData)
        ${config.id}.POST("/data", handler.CreateData)
        ${config.id}.PUT("/data/:id", handler.UpdateData)
        ${config.id}.DELETE("/data/:id", handler.DeleteData)
        
        // 功能特定的端点
${config.features.map((feature) => '        ${config.id}.POST("/${_toKebabCase(feature)}", handler.${_toPascalCase(feature)})').join('\n')}
    }
}

func (h *${_toPascalCase(config.name)}Handler) Health(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{
        "status": "healthy",
        "service": "${config.name}",
        "version": "1.0.0",
    })
}

func (h *${_toPascalCase(config.name)}Handler) GetData(c *gin.Context) {
    data, err := h.service.GetData()
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    
    c.JSON(http.StatusOK, data)
}

func (h *${_toPascalCase(config.name)}Handler) CreateData(c *gin.Context) {
    var req models.${_toPascalCase(config.name)}Request
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    
    data, err := h.service.CreateData(&req)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    
    c.JSON(http.StatusCreated, data)
}

func (h *${_toPascalCase(config.name)}Handler) UpdateData(c *gin.Context) {
    id := c.Param("id")
    
    var req models.${_toPascalCase(config.name)}Request
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    
    data, err := h.service.UpdateData(id, &req)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    
    c.JSON(http.StatusOK, data)
}

func (h *${_toPascalCase(config.name)}Handler) DeleteData(c *gin.Context) {
    id := c.Param("id")
    
    err := h.service.DeleteData(id)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    
    c.JSON(http.StatusNoContent, nil)
}

${config.features.map((feature) => '''
func (h *${_toPascalCase(config.name)}Handler) ${_toPascalCase(feature)}(c *gin.Context) {
    var req models.${_toPascalCase(feature)}Request
    if err := c.ShouldBindJSON(&req); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    
    result, err := h.service.${_toPascalCase(feature)}(&req)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    
    c.JSON(http.StatusOK, result)
}''').join('\n\n')}
''';
    
    await File('$handlersDir/handlers.go').writeAsString(handlerContent);
  }
  
  /// 生成模型
  Future<void> _generateModels(AppConfig config, String serviceDir) async {
    final modelsDir = '$serviceDir/internal/models';
    await Directory(modelsDir).create(recursive: true);
    
    final modelContent = '''
package models

import (
    "time"
    "gorm.io/gorm"
)

type ${_toPascalCase(config.name)} struct {
    ID          string                 \`gorm:"primarykey;type:uuid;default:gen_random_uuid()" json:"id"\`
    Title       string                 \`gorm:"not null" json:"title"\`
    Description string                 \`json:"description"\`
    Metadata    map[string]interface{} \`gorm:"type:jsonb" json:"metadata"\`
    CreatedAt   time.Time              \`json:"created_at"\`
    UpdatedAt   time.Time              \`json:"updated_at"\`
    DeletedAt   gorm.DeletedAt         \`gorm:"index" json:"-"\`
}

type ${_toPascalCase(config.name)}Request struct {
    Title       string                 \`json:"title" binding:"required"\`
    Description string                 \`json:"description"\`
    Metadata    map[string]interface{} \`json:"metadata"\`
}

type ${_toPascalCase(config.name)}Response struct {
    ID          string                 \`json:"id"\`
    Title       string                 \`json:"title"\`
    Description string                 \`json:"description"\`
    Metadata    map[string]interface{} \`json:"metadata"\`
    CreatedAt   time.Time              \`json:"created_at"\`
    UpdatedAt   time.Time              \`json:"updated_at"\`
}

${config.features.map((feature) => '''
type ${_toPascalCase(feature)}Request struct {
    Data map[string]interface{} \`json:"data" binding:"required"\`
}

type ${_toPascalCase(feature)}Response struct {
    Result map[string]interface{} \`json:"result"\`
}''').join('\n\n')}
''';
    
    await File('$modelsDir/models.go').writeAsString(modelContent);
  }
  
  /// 生成中间件
  Future<void> _generateMiddleware(AppConfig config, String serviceDir) async {
    final middlewareDir = '$serviceDir/internal/middleware';
    await Directory(middlewareDir).create(recursive: true);
    
    final middlewareContent = '''
package middleware

import (
    "time"
    "github.com/gin-gonic/gin"
    "github.com/gin-contrib/cors"
)

func CORS() gin.HandlerFunc {
    return cors.New(cors.Config{
        AllowOrigins:     []string{"*"},
        AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
        AllowHeaders:     []string{"*"},
        ExposeHeaders:    []string{"Content-Length"},
        AllowCredentials: true,
        MaxAge:          12 * time.Hour,
    })
}

func Logger() gin.HandlerFunc {
    return gin.LoggerWithFormatter(func(param gin.LogFormatterParams) string {
        return fmt.Sprintf("[%s] %s %s %d %s\n",
            param.TimeStamp.Format("2006/01/02 - 15:04:05"),
            param.Method,
            param.Path,
            param.StatusCode,
            param.Latency,
        )
    })
}

func ErrorHandler() gin.HandlerFunc {
    return gin.CustomRecovery(func(c *gin.Context, recovered interface{}) {
        c.JSON(500, gin.H{
            "error": "Internal server error",
        })
    })
}

func Auth() gin.HandlerFunc {
    return func(c *gin.Context) {
        // TODO: 实现JWT认证
        c.Next()
    }
}
''';
    
    await File('$middlewareDir/middleware.go').writeAsString(middlewareContent);
  }
  
  /// 生成Docker配置
  Future<void> _generateDockerConfig(AppConfig config, String serviceDir) async {
    final dockerfileContent = '''
FROM golang:1.21-alpine AS builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/

COPY --from=builder /app/main .

EXPOSE ${config.servicePort ?? "8080"}

CMD ["./main"]
''';
    
    await File('$serviceDir/Dockerfile').writeAsString(dockerfileContent);
  }
  
  /// 生成Kubernetes配置
  Future<void> _generateKubernetesConfig(AppConfig config) async {
    final k8sDir = 'k8s/apps/${config.id}';
    await Directory(k8sDir).create(recursive: true);
    
    final deploymentContent = '''
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${config.id}-service
  namespace: qatoolbox
spec:
  replicas: 2
  selector:
    matchLabels:
      app: ${config.id}-service
  template:
    metadata:
      labels:
        app: ${config.id}-service
    spec:
      containers:
      - name: ${config.id}
        image: qatoolbox/${config.id}:latest
        ports:
        - containerPort: ${config.servicePort ?? "8080"}
        env:
        - name: DB_HOST
          value: "postgres-service"
        - name: REDIS_HOST
          value: "redis-service"
        resources:
          requests:
            memory: "64Mi"
            cpu: "50m"
          limits:
            memory: "128Mi"
            cpu: "100m"
---
apiVersion: v1
kind: Service
metadata:
  name: ${config.id}-service
  namespace: qatoolbox
spec:
  selector:
    app: ${config.id}-service
  ports:
  - port: 80
    targetPort: ${config.servicePort ?? "8080"}
  type: ClusterIP
''';
    
    await File('$k8sDir/deployment.yaml').writeAsString(deploymentContent);
  }
  
  /// 生成数据库迁移
  Future<void> _generateDatabaseMigrations(AppConfig config) async {
    if (verbose) print('🗄️ 生成数据库迁移...');
    
    final migrationsDir = 'backend/migrations/${config.id}';
    await Directory(migrationsDir).create(recursive: true);
    
    final migrationContent = '''
-- +goose Up
CREATE TABLE IF NOT EXISTS ${config.id}_data (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    deleted_at TIMESTAMP
);

CREATE INDEX idx_${config.id}_data_created_at ON ${config.id}_data(created_at);
CREATE INDEX idx_${config.id}_data_deleted_at ON ${config.id}_data(deleted_at);

${config.features.map((feature) => '''
CREATE TABLE IF NOT EXISTS ${config.id}_${_toSnakeCase(feature)} (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data_id UUID REFERENCES ${config.id}_data(id),
    result JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT NOW()
);
''').join('\n')}

-- +goose Down
${config.features.map((feature) => 'DROP TABLE IF EXISTS ${config.id}_${_toSnakeCase(feature)};').join('\n')}
DROP TABLE IF EXISTS ${config.id}_data;
''';
    
    await File('$migrationsDir/001_create_${config.id}_tables.sql').writeAsString(migrationContent);
  }
  
  /// 生成API文档
  Future<void> _generateAPIDocumentation(AppConfig config) async {
    if (verbose) print('📖 生成API文档...');
    
    final docsDir = 'docs/api/${config.id}';
    await Directory(docsDir).create(recursive: true);
    
    final apiDocContent = '''
# ${config.name} API 文档

## 概述
${config.description}

## 基础信息
- 基础URL: \`http://localhost:${config.servicePort ?? "8080"}/api/v1/${config.id.replaceAll('_', '-')}\`
- 认证方式: Bearer Token (JWT)

## 端点

### 健康检查
\`\`\`
GET /health
\`\`\`

响应:
\`\`\`json
{
  "status": "healthy",
  "service": "${config.name}",
  "version": "1.0.0"
}
\`\`\`

### 数据管理

#### 获取数据列表
\`\`\`
GET /data
\`\`\`

#### 创建数据
\`\`\`
POST /data
Content-Type: application/json

{
  "title": "标题",
  "description": "描述",
  "metadata": {}
}
\`\`\`

#### 更新数据
\`\`\`
PUT /data/{id}
Content-Type: application/json

{
  "title": "新标题",
  "description": "新描述",
  "metadata": {}
}
\`\`\`

#### 删除数据
\`\`\`
DELETE /data/{id}
\`\`\`

### 功能端点

${config.features.map((feature) => '''
#### ${feature}
\`\`\`
POST /${_toKebabCase(feature)}
Content-Type: application/json

{
  "data": {}
}
\`\`\`

响应:
\`\`\`json
{
  "result": {}
}
\`\`\`
''').join('\n')}

## 错误码

| 状态码 | 说明 |
|--------|------|
| 200    | 成功 |
| 201    | 创建成功 |
| 400    | 请求参数错误 |
| 401    | 未授权 |
| 404    | 资源不存在 |
| 500    | 服务器内部错误 |
''';
    
    await File('$docsDir/api.md').writeAsString(apiDocContent);
  }
  
  /// 生成测试套件
  Future<void> _generateTestSuite(AppConfig config) async {
    if (verbose) print('🧪 生成测试套件...');
    
    final testDir = 'backend/services/${config.id}/tests';
    await Directory(testDir).create(recursive: true);
    
    // 生成API测试
    final apiTestContent = '''
package tests

import (
    "bytes"
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
    
    "github.com/gin-gonic/gin"
    "github.com/stretchr/testify/assert"
    "github.com/qatoolbox/${config.id}/internal/handlers"
)

func TestHealth(t *testing.T) {
    router := gin.Default()
    api := router.Group("/api/v1")
    
    // 注册路由
    handlers.RegisterRoutes(api, nil)
    
    w := httptest.NewRecorder()
    req, _ := http.NewRequest("GET", "/api/v1/${config.id.replaceAll('_', '-')}/health", nil)
    router.ServeHTTP(w, req)
    
    assert.Equal(t, 200, w.Code)
    
    var response map[string]interface{}
    err := json.Unmarshal(w.Body.Bytes(), &response)
    assert.NoError(t, err)
    assert.Equal(t, "healthy", response["status"])
}

func TestCreateData(t *testing.T) {
    router := gin.Default()
    api := router.Group("/api/v1")
    
    // 注册路由
    handlers.RegisterRoutes(api, nil)
    
    payload := map[string]interface{}{
        "title": "测试标题",
        "description": "测试描述",
    }
    
    jsonPayload, _ := json.Marshal(payload)
    
    w := httptest.NewRecorder()
    req, _ := http.NewRequest("POST", "/api/v1/${config.id.replaceAll('_', '-')}/data", bytes.NewBuffer(jsonPayload))
    req.Header.Set("Content-Type", "application/json")
    router.ServeHTTP(w, req)
    
    assert.Equal(t, 201, w.Code)
}

${config.features.map((feature) => '''
func Test${_toPascalCase(feature)}(t *testing.T) {
    router := gin.Default()
    api := router.Group("/api/v1")
    
    // 注册路由
    handlers.RegisterRoutes(api, nil)
    
    payload := map[string]interface{}{
        "data": map[string]interface{}{
            "test": "value",
        },
    }
    
    jsonPayload, _ := json.Marshal(payload)
    
    w := httptest.NewRecorder()
    req, _ := http.NewRequest("POST", "/api/v1/${config.id.replaceAll('_', '-')}/${_toKebabCase(feature)}", bytes.NewBuffer(jsonPayload))
    req.Header.Set("Content-Type", "application/json")
    router.ServeHTTP(w, req)
    
    assert.Equal(t, 200, w.Code)
}''').join('\n\n')}
''';
    
    await File('$testDir/api_test.go').writeAsString(apiTestContent);
    
    // 生成性能测试
    final benchmarkContent = '''
package tests

import (
    "bytes"
    "encoding/json"
    "net/http"
    "net/http/httptest"
    "testing"
    
    "github.com/gin-gonic/gin"
    "github.com/qatoolbox/${config.id}/internal/handlers"
)

func BenchmarkHealth(b *testing.B) {
    router := gin.Default()
    api := router.Group("/api/v1")
    handlers.RegisterRoutes(api, nil)
    
    for i := 0; i < b.N; i++ {
        w := httptest.NewRecorder()
        req, _ := http.NewRequest("GET", "/api/v1/${config.id.replaceAll('_', '-')}/health", nil)
        router.ServeHTTP(w, req)
    }
}

${config.features.map((feature) => '''
func Benchmark${_toPascalCase(feature)}(b *testing.B) {
    router := gin.Default()
    api := router.Group("/api/v1")
    handlers.RegisterRoutes(api, nil)
    
    payload := map[string]interface{}{
        "data": map[string]interface{}{
            "test": "value",
        },
    }
    jsonPayload, _ := json.Marshal(payload)
    
    for i := 0; i < b.N; i++ {
        w := httptest.NewRecorder()
        req, _ := http.NewRequest("POST", "/api/v1/${config.id.replaceAll('_', '-')}/${_toKebabCase(feature)}", bytes.NewBuffer(jsonPayload))
        req.Header.Set("Content-Type", "application/json")
        router.ServeHTTP(w, req)
    }
}''').join('\n\n')}
''';
    
    await File('$testDir/benchmark_test.go').writeAsString(benchmarkContent);
  }
  
  /// 生成统一配置文件
  Future<void> _generateUnifiedConfigs(List<AppConfig> configs) async {
    if (verbose) print('⚙️ 生成统一配置文件...');
    
    // 生成docker-compose.yml
    await _generateDockerCompose(configs);
    
    // 生成nginx配置
    await _generateNginxConfig(configs);
    
    // 生成Makefile
    await _generateMakefile(configs);
    
    // 生成CI/CD配置
    await _generateCIConfig(configs);
  }
  
  /// 生成Docker Compose配置
  Future<void> _generateDockerCompose(List<AppConfig> configs) async {
    final services = configs.map((AppConfig config) => '''
  ${config.id}:
    build: ./backend/services/${config.id}
    ports:
      - "${config.servicePort ?? "8080"}:${config.servicePort ?? "8080"}"
    environment:
      - DB_HOST=postgres
      - REDIS_HOST=redis
      - JWT_SECRET=your_jwt_secret
    depends_on:
      - postgres
      - redis
    restart: unless-stopped''').join('\n\n');
    
    final composeContent = '''
version: '3.8'

services:
  # 基础服务
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: qatoolbox
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/migrations:/docker-entrypoint-initdb.d
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    restart: unless-stopped

  # API网关
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
    depends_on:
${configs.map((AppConfig config) => '      - ${config.id}').join('\n')}
    restart: unless-stopped

  # 监控服务
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
    restart: unless-stopped

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    restart: unless-stopped

  # 应用服务
$services

volumes:
  postgres_data:
  grafana_data:

networks:
  default:
    name: qatoolbox-network
''';
    
    await File('docker-compose.yml').writeAsString(composeContent);
  }
  
  /// 生成Nginx配置
  Future<void> _generateNginxConfig(List<AppConfig> configs) async {
    final upstreams = configs.map((AppConfig config) => '''
upstream ${config.id}_backend {
    server ${config.id}:${config.servicePort ?? "8080"};
}''').join('\n\n');
    
    final locations = configs.map((AppConfig config) => '''
    location /api/v1/${config.id.replaceAll('_', '-')}/ {
        proxy_pass http://${config.id}_backend/;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }''').join('\n\n');
    
    final nginxContent = '''
events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format main '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                   '\$status \$body_bytes_sent "\$http_referer" '
                   '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log;

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;

    # 上游服务器配置
$upstreams

    server {
        listen 80;
        server_name localhost;

        # 跨域配置
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods 'GET, POST, PUT, DELETE, OPTIONS';
        add_header Access-Control-Allow-Headers 'DNT,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Range,Authorization';

        # 处理OPTIONS请求
        if (\$request_method = 'OPTIONS') {
            return 204;
        }

        # 健康检查
        location /health {
            access_log off;
            return 200 "healthy\\n";
            add_header Content-Type text/plain;
        }

        # API路由
$locations

        # 静态文件
        location / {
            root /usr/share/nginx/html;
            index index.html index.htm;
            try_files \$uri \$uri/ /index.html;
        }

        # 错误页面
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/html;
        }
    }
}
''';
    
    await File('nginx/nginx.conf').writeAsString(nginxContent);
  }
  
  /// 生成Makefile
  Future<void> _generateMakefile(List<AppConfig> configs) async {
    final buildTargets = configs.map((AppConfig config) => '''
build-${config.id}:
\t@echo "Building ${config.name}..."
\t@cd backend/services/${config.id} && go build -o bin/${config.id} .

test-${config.id}:
\t@echo "Testing ${config.name}..."
\t@cd backend/services/${config.id} && go test ./... -v

docker-build-${config.id}:
\t@echo "Building Docker image for ${config.name}..."
\t@docker build -t qatoolbox/${config.id}:latest backend/services/${config.id}''').join('\n\n');
    
    final makefileContent = '''
.PHONY: help build test docker-build docker-up docker-down clean

# 默认目标
help:
\t@echo "QAToolBox 开发工具"
\t@echo ""
\t@echo "可用命令:"
\t@echo "  build         - 构建所有服务"
\t@echo "  test          - 运行所有测试"
\t@echo "  docker-build  - 构建所有Docker镜像"
\t@echo "  docker-up     - 启动所有服务"
\t@echo "  docker-down   - 停止所有服务"
\t@echo "  clean         - 清理构建文件"
\t@echo "  generate      - 生成应用代码"

# 构建所有服务
build: ${configs.map((AppConfig config) => 'build-${config.id}').join(' ')}

# 测试所有服务
test: ${configs.map((AppConfig config) => 'test-${config.id}').join(' ')}

# 构建所有Docker镜像
docker-build: ${configs.map((AppConfig config) => 'docker-build-${config.id}').join(' ')}

# 启动所有服务
docker-up:
\t@echo "Starting all services..."
\t@docker-compose up -d

# 停止所有服务
docker-down:
\t@echo "Stopping all services..."
\t@docker-compose down

# 清理构建文件
clean:
\t@echo "Cleaning build files..."
${configs.map((AppConfig config) => '\t@rm -rf backend/services/${config.id}/bin').join('\n')}
\t@docker system prune -f

# 生成应用代码
generate:
\t@echo "Generating application code..."
\t@dart scripts/enhanced_generator.dart batch

# 数据库迁移
migrate:
\t@echo "Running database migrations..."
\t@docker exec -it qatoolbox_postgres_1 psql -U postgres -d qatoolbox -f /docker-entrypoint-initdb.d/migrations.sql

# 部署到K8s
deploy:
\t@echo "Deploying to Kubernetes..."
\t@kubectl apply -f k8s/

# 监控
logs:
\t@docker-compose logs -f

stats:
\t@docker stats

# 单个服务的目标
$buildTargets
''';
    
    await File('Makefile').writeAsString(makefileContent);
  }
  
  /// 生成CI/CD配置
  Future<void> _generateCIConfig(List<AppConfig> configs) async {
    final ciDir = '.github/workflows';
    await Directory(ciDir).create(recursive: true);
    
    final services = configs.map((AppConfig config) => '''
      - name: Test ${config.name}
        run: |
          cd backend/services/${config.id}
          go test ./... -v
          
      - name: Build ${config.name}
        run: |
          cd backend/services/${config.id}
          go build -o bin/${config.id} .
          
      - name: Build Docker image for ${config.name}
        run: |
          docker build -t qatoolbox/${config.id}:\${{ github.sha }} backend/services/${config.id}
          docker tag qatoolbox/${config.id}:\${{ github.sha }} qatoolbox/${config.id}:latest''').join('\n\n');
    
    final ciContent = '''
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: password
          POSTGRES_DB: qatoolbox_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
          
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Go
      uses: actions/setup-go@v4
      with:
        go-version: '1.21'
        
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
        
    - name: Cache Go modules
      uses: actions/cache@v3
      with:
        path: ~/go/pkg/mod
        key: \${{ runner.os }}-go-\${{ hashFiles('**/go.sum') }}
        restore-keys: |
          \${{ runner.os }}-go-
          
    - name: Cache Flutter packages
      uses: actions/cache@v3
      with:
        path: ~/.pub-cache
        key: \${{ runner.os }}-flutter-\${{ hashFiles('**/pubspec.lock') }}
        restore-keys: |
          \${{ runner.os }}-flutter-

    # 前端测试
    - name: Flutter test
      run: |
        flutter pub get
        flutter test
        flutter build apk --debug

    # 后端测试和构建
$services

  docker:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: \${{ secrets.DOCKER_USERNAME }}
        password: \${{ secrets.DOCKER_PASSWORD }}
        
    - name: Build and push all images
      run: |
        make docker-build
${configs.map((AppConfig config) => '        docker push qatoolbox/${config.id}:latest').join('\n')}

  deploy:
    runs-on: ubuntu-latest
    needs: docker
    if: github.ref == 'refs/heads/main'
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Deploy to K8s
      run: |
        # 这里添加部署到Kubernetes的步骤
        echo "Deploying to Kubernetes..."
        # kubectl apply -f k8s/
''';
    
    await File('$ciDir/ci.yml').writeAsString(ciContent);
  }
  
  /// 工具方法：转换为PascalCase
  String _toPascalCase(String input) {
    return input
        .split(RegExp(r'[_\s-]+'))
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join('');
  }
  
  /// 工具方法：转换为snake_case
  String _toSnakeCase(String input) {
    return input
        .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'[_\s-]+'), '_')
        .toLowerCase();
  }
  
  /// 工具方法：转换为kebab-case
  String _toKebabCase(String input) {
    return _toSnakeCase(input).replaceAll('_', '-');
  }
}

/// 增强版主函数 - 支持配置文件和交互式生成
void main(List<String> args) async {
  print('🚀 QAToolBox 增强版代码生成器');
  print('=====================================');
  
  final generator = EnhancedCodeGenerator(
    useAI: args.contains('--ai'),
    verbose: args.contains('--verbose') || args.contains('-v'),
  );
  
  if (args.isEmpty || args.first == 'help') {
    await _showHelp();
    return;
  }
  
  final command = args.first;
  
  switch (command) {
    case 'create':
      await _createFromConfig(args.skip(1).toList(), generator);
      break;
    case 'batch':
      await generator.generateAllApps();
      break;
    case 'list':
      await _listApps();
      break;
    case 'interactive':
      await _interactiveMode(generator);
      break;
    default:
      print('未知命令: $command');
      await _showHelp();
  }
}

/// 从配置文件创建应用
Future<void> _createFromConfig(List<String> args, EnhancedCodeGenerator generator) async {
  if (args.isEmpty) {
    print('用法: dart enhanced_generator.dart create <appId>');
    exit(1);
  }
  
  final appId = args[0];
  final config = await AppConfigManager.getAppConfig(appId);
  
  if (config == null) {
    print('❌ 未找到应用配置: $appId');
    print('可用的应用ID:');
    final configs = await AppConfigManager.getAllAppConfigs();
    for (final c in configs) {
      print('  - ${c.id}');
    }
    exit(1);
  }
  
  await generator.generateApp(config);
}

/// 列出所有应用
Future<void> _listApps() async {
  final configs = await AppConfigManager.getAllAppConfigs();
  
  if (configs.isEmpty) {
    print('📝 暂无应用配置');
    print('请先创建配置文件: config/apps.yaml');
    return;
  }
  
  print('📱 现有应用列表:');
  print('=====================================');
  
  for (final config in configs) {
    print('📦 ${config.name} (${config.id})');
    print('   描述: ${config.description}');
    print('   分类: ${config.category}');
    print('   端口: ${config.servicePort ?? "8080"}');
    print('   功能: ${config.features.join(', ')}');
    print('');
  }
}

/// 交互式模式
Future<void> _interactiveMode(EnhancedCodeGenerator generator) async {
  print('进入交互式模式...');
  print('请选择操作:');
  print('1. 创建单个应用');
  print('2. 批量生成应用');
  print('3. 查看现有应用');
  print('请输入选项 (1-3): ');
  
  final input = stdin.readLineSync();
  
  switch (input) {
    case '1':
      await _createInteractive(generator);
      break;
    case '2':
      await generator.generateAllApps();
      break;
    case '3':
      await _listApps();
      break;
    default:
      print('无效选项');
  }
}

/// 交互式创建应用
Future<void> _createInteractive(EnhancedCodeGenerator generator) async {
  await _listApps();
  
  print('请输入要生成的应用ID: ');
  final appId = stdin.readLineSync() ?? '';
  
  await _createFromConfig([appId], generator);
}

/// 显示帮助信息
Future<void> _showHelp() async {
  print('''
QAToolBox 增强版代码生成器

用法:
  dart enhanced_generator.dart <command> [options]

命令:
  create <appId>    - 从配置创建单个应用
  batch             - 批量生成所有应用
  list              - 列出所有可用应用
  interactive       - 交互式模式
  help              - 显示帮助信息

选项:
  --ai              - 启用AI代码生成
  --verbose, -v     - 详细输出

示例:
  dart enhanced_generator.dart create qa_toolbox --ai -v
  dart enhanced_generator.dart batch
  dart enhanced_generator.dart list
  dart enhanced_generator.dart interactive
  
配置文件: config/apps.yaml
''');
}
