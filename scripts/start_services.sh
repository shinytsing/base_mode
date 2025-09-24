#!/bin/bash

# QAToolBox 服务启动脚本
# 用于快速启动所有必要的服务

set -e

echo "🚀 QAToolBox 服务启动脚本"
echo "=========================="

# 检查必要的命令
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 未安装，请先安装 $1"
        exit 1
    fi
}

# 检查环境
echo "🔍 检查环境..."
check_command "go"
check_command "flutter"
check_command "docker"
check_command "docker-compose"

# 设置环境变量
export GO111MODULE=on
export CGO_ENABLED=1

# 创建必要的目录
echo "📁 创建必要的目录..."
mkdir -p backend/logs
mkdir -p backend/uploads
mkdir -p backend/tmp

# 检查数据库连接
echo "🗄️ 检查数据库连接..."
if ! pg_isready -h localhost -p 5432 &> /dev/null; then
    echo "⚠️ PostgreSQL 未运行，尝试启动..."
    if command -v brew &> /dev/null; then
        brew services start postgresql
    elif command -v systemctl &> /dev/null; then
        sudo systemctl start postgresql
    else
        echo "❌ 无法启动 PostgreSQL，请手动启动"
        exit 1
    fi
fi

# 检查Redis连接
echo "🔴 检查Redis连接..."
if ! redis-cli ping &> /dev/null; then
    echo "⚠️ Redis 未运行，尝试启动..."
    if command -v brew &> /dev/null; then
        brew services start redis
    elif command -v systemctl &> /dev/null; then
        sudo systemctl start redis
    else
        echo "❌ 无法启动 Redis，请手动启动"
        exit 1
    fi
fi

# 初始化数据库
echo "🗃️ 初始化数据库..."
cd backend
if [ -f "scripts/init.sql" ]; then
    psql -h localhost -U gaojie -d qatoolbox_local -f scripts/init.sql || {
        echo "⚠️ 数据库初始化失败，可能是数据库不存在"
        echo "创建数据库..."
        createdb -h localhost -U gaojie qatoolbox_local || {
            echo "❌ 无法创建数据库，请检查PostgreSQL配置"
            exit 1
        }
        echo "重新初始化数据库..."
        psql -h localhost -U gaojie -d qatoolbox_local -f scripts/init.sql
    }
else
    echo "⚠️ 未找到数据库初始化脚本"
fi

# 安装Go依赖
echo "📦 安装Go依赖..."
go mod tidy
go mod download

# 构建Go应用
echo "🔨 构建Go应用..."
go build -o bin/qatoolbox main.go

# 启动后端服务
echo "🚀 启动后端服务..."
if [ -f "env.local" ]; then
    cp env.local .env
fi

# 在后台启动后端服务
nohup ./bin/qatoolbox > logs/app.log 2>&1 &
BACKEND_PID=$!
echo "✅ 后端服务已启动 (PID: $BACKEND_PID)"

# 等待后端服务启动
echo "⏳ 等待后端服务启动..."
sleep 5

# 检查后端服务状态
if curl -s http://localhost:8080/api/v1/health > /dev/null; then
    echo "✅ 后端服务运行正常"
else
    echo "❌ 后端服务启动失败"
    kill $BACKEND_PID 2>/dev/null || true
    exit 1
fi

# 返回项目根目录
cd ..

# 安装Flutter依赖
echo "📱 安装Flutter依赖..."
flutter pub get

# 生成代码
echo "🔧 生成代码..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# 启动Flutter应用
echo "📱 启动Flutter应用..."
if [ "$1" = "web" ]; then
    flutter run -d web-server --web-port 3000
elif [ "$1" = "macos" ]; then
    flutter run -d macos
elif [ "$1" = "ios" ]; then
    flutter run -d ios
elif [ "$1" = "android" ]; then
    flutter run -d android
else
    echo "请指定运行平台: web, macos, ios, android"
    echo "例如: ./scripts/start_services.sh web"
fi

# 清理函数
cleanup() {
    echo "🛑 停止服务..."
    kill $BACKEND_PID 2>/dev/null || true
    echo "✅ 服务已停止"
}

# 设置信号处理
trap cleanup EXIT INT TERM

echo "🎉 所有服务已启动！"
echo "📊 后端API: http://localhost:8080"
echo "📱 前端应用: http://localhost:3000 (如果选择web)"
echo "📋 日志文件: backend/logs/app.log"
echo ""
echo "按 Ctrl+C 停止所有服务"
