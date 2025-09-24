# 启动脚本
#!/bin/bash

echo "🚀 启动 QAToolBox 系统..."

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "❌ Docker 未安装，请先安装 Docker"
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

# 创建必要的目录
mkdir -p backend/uploads backend/logs nginx/ssl monitoring

# 复制环境变量文件
if [ ! -f backend/.env ]; then
    cp backend/env.example backend/.env
    echo "📝 已创建环境变量文件，请根据需要修改 backend/.env"
fi

# 构建并启动服务
echo "🔨 构建并启动服务..."
docker-compose up --build -d

# 等待服务启动
echo "⏳ 等待服务启动..."
sleep 30

# 检查服务状态
echo "📊 检查服务状态..."
docker-compose ps

# 显示访问信息
echo ""
echo "🎉 QAToolBox 系统启动完成！"
echo ""
echo "📱 前端访问地址:"
echo "   http://localhost:3000"
echo ""
echo "🔧 后端API地址:"
echo "   http://localhost:8080"
echo ""
echo "📊 监控面板:"
echo "   Prometheus: http://localhost:9090"
echo "   Grafana: http://localhost:3001 (admin/admin)"
echo ""
echo "🗄️ 数据库:"
echo "   PostgreSQL: localhost:5432"
echo "   Redis: localhost:6379"
echo ""
echo "📝 查看日志:"
echo "   docker-compose logs -f"
echo ""
echo "🛑 停止服务:"
echo "   docker-compose down"
