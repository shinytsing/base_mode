#!/bin/bash

# QAToolBox 项目初始化脚本
# 用于快速设置开发环境

set -e

echo "🚀 QAToolBox 项目初始化开始..."

# 检查必要的工具
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 未安装，请先安装 $1"
        exit 1
    else
        echo "✅ $1 已安装"
    fi
}

echo "📋 检查必要工具..."
check_tool "flutter"
check_tool "dart"
check_tool "docker"
check_tool "docker-compose"
check_tool "git"

# 检查Flutter版本
echo "📱 检查Flutter版本..."
flutter --version

# 获取Flutter依赖
echo "📦 安装Flutter依赖..."
flutter pub get

# 生成代码
echo "🔧 生成代码..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# 创建必要的目录
echo "📁 创建必要目录..."
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/fonts
mkdir -p scripts
mkdir -p monitoring/grafana/dashboards
mkdir -p monitoring/grafana/datasources
mkdir -p nginx/ssl

# 设置权限
echo "🔐 设置文件权限..."
chmod +x scripts/generate_app.dart
chmod +x scripts/setup.sh

# 创建环境配置文件
echo "⚙️ 创建环境配置..."
if [ ! -f .env ]; then
    cat > .env << EOF
# 环境配置
FLUTTER_ENV=development
APP_NAME=QAToolBox
APP_VERSION=1.0.0

# 数据库配置
DATABASE_URL=postgresql://qa_user:qa_password@localhost:5432/qa_toolbox
REDIS_URL=redis://localhost:6379

# API配置
API_BASE_URL=http://localhost:8080
API_TIMEOUT=30000

# 支付配置
STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
STRIPE_SECRET_KEY=sk_test_your_key_here

# 监控配置
PROMETHEUS_URL=http://localhost:9090
GRAFANA_URL=http://localhost:3000
EOF
    echo "✅ 创建 .env 文件"
else
    echo "⚠️ .env 文件已存在，跳过创建"
fi

# 创建开发环境配置
echo "🛠️ 创建开发环境配置..."
if [ ! -f .env.development ]; then
    cat > .env.development << EOF
# 开发环境配置
FLUTTER_ENV=development
DEBUG_MODE=true
LOG_LEVEL=debug

# 开发数据库
DATABASE_URL=postgresql://qa_user:qa_password@localhost:5432/qa_toolbox_dev
REDIS_URL=redis://localhost:6379/0

# 开发API
API_BASE_URL=http://localhost:8080
EOF
    echo "✅ 创建 .env.development 文件"
fi

# 创建生产环境配置
echo "🏭 创建生产环境配置..."
if [ ! -f .env.production ]; then
    cat > .env.production << EOF
# 生产环境配置
FLUTTER_ENV=production
DEBUG_MODE=false
LOG_LEVEL=info

# 生产数据库
DATABASE_URL=postgresql://qa_user:qa_password@prod-db:5432/qa_toolbox
REDIS_URL=redis://prod-redis:6379/0

# 生产API
API_BASE_URL=https://api.qatoolbox.com
EOF
    echo "✅ 创建 .env.production 文件"
fi

# 启动Docker服务
echo "🐳 启动Docker服务..."
if command -v docker-compose &> /dev/null; then
    docker-compose up -d postgres redis
    echo "✅ Docker服务已启动"
else
    echo "⚠️ docker-compose 未安装，跳过Docker服务启动"
fi

# 等待数据库启动
echo "⏳ 等待数据库启动..."
sleep 10

# 运行数据库迁移
echo "🗄️ 初始化数据库..."
if [ -f scripts/init.sql ]; then
    # 这里需要根据实际情况调整数据库连接命令
    echo "📝 数据库初始化脚本已准备就绪"
    echo "💡 请手动执行: psql -h localhost -U qa_user -d qa_toolbox -f scripts/init.sql"
else
    echo "⚠️ 数据库初始化脚本不存在"
fi

# 运行测试
echo "🧪 运行测试..."
flutter test

# 运行代码分析
echo "🔍 运行代码分析..."
flutter analyze

# 检查代码格式
echo "📐 检查代码格式..."
dart format --set-exit-if-changed .

echo ""
echo "🎉 QAToolBox 项目初始化完成！"
echo ""
echo "📋 下一步操作："
echo "1. 启动开发服务器: flutter run"
echo "2. 查看API文档: http://localhost:8080/docs"
echo "3. 访问监控面板: http://localhost:3000 (Grafana)"
echo "4. 查看Prometheus: http://localhost:9090"
echo ""
echo "🛠️ 开发工具："
echo "- 代码生成器: dart scripts/generate_app.dart"
echo "- Docker管理: docker-compose up/down"
echo "- 数据库管理: psql -h localhost -U qa_user -d qa_toolbox"
echo ""
echo "📚 更多信息请查看 README.md"
