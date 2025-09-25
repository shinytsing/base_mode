#!/bin/bash

# QAToolBox Backend 启动脚本

echo "🚀 启动 QAToolBox Backend..."

# 检查Go是否安装
if ! command -v go &> /dev/null; then
    echo "❌ Go 未安装，请先安装 Go 1.21+"
    exit 1
fi

# 检查PostgreSQL是否运行
if ! pg_isready -q; then
    echo "❌ PostgreSQL 未运行，请先启动 PostgreSQL"
    exit 1
fi

# 检查Redis是否运行
if ! redis-cli ping &> /dev/null; then
    echo "❌ Redis 未运行，请先启动 Redis"
    exit 1
fi

# 创建必要的目录
mkdir -p logs
mkdir -p uploads

# 设置环境变量
export APP_ENV=development
export APP_PORT=8080
export DATABASE_URL="postgres://gaojie@localhost/qatoolbox_local?sslmode=disable"
export REDIS_URL="redis://localhost:6379/0"
export JWT_SECRET="your-super-secret-jwt-key-change-this-in-production"

# 下载依赖
echo "📦 下载依赖..."
go mod tidy

# 运行数据库迁移
echo "🗄️ 运行数据库迁移..."
if [ -f "scripts/init.sql" ]; then
    psql -d qatoolbox_local -f scripts/init.sql
    echo "✅ 数据库迁移完成"
else
    echo "⚠️ 未找到数据库迁移脚本"
fi

# 启动服务器
echo "🌟 启动服务器..."
go run main.go
