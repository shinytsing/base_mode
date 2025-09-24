#!/bin/bash

# QAToolBox 部署脚本

set -e

echo "🚀 开始部署 QAToolBox..."

# 配置变量
ENVIRONMENT=${1:-staging}
VERSION=${2:-latest}
REGISTRY=${3:-your-registry.com}
PROJECT_NAME="qa-toolbox"

# 验证参数
if [[ ! "$ENVIRONMENT" =~ ^(staging|production)$ ]]; then
    echo "❌ 环境参数错误，请使用: staging 或 production"
    exit 1
fi

echo "📋 部署配置:"
echo "  环境: $ENVIRONMENT"
echo "  版本: $VERSION"
echo "  镜像仓库: $REGISTRY"
echo "  项目名称: $PROJECT_NAME"

# 检查必要工具
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "❌ $1 未安装，请先安装 $1"
        exit 1
    fi
}

echo "🔍 检查部署工具..."
check_tool "docker"
check_tool "kubectl"

# 设置环境变量
export FLUTTER_ENV=production
export DOCKER_BUILDKIT=1

# 构建Flutter应用
echo "📱 构建Flutter应用..."
flutter clean
flutter pub get
flutter packages pub run build_runner build --delete-conflicting-outputs

# 构建Android APK
echo "🤖 构建Android APK..."
flutter build apk --release --target-platform android-arm64

# 构建iOS应用
echo "🍎 构建iOS应用..."
flutter build ios --release --no-codesign

# 构建Web应用
echo "🌐 构建Web应用..."
flutter build web --release

# 构建Docker镜像
echo "🐳 构建Docker镜像..."
docker build -t $REGISTRY/$PROJECT_NAME:$VERSION .
docker build -t $REGISTRY/$PROJECT_NAME:latest .

# 推送镜像
echo "📤 推送Docker镜像..."
docker push $REGISTRY/$PROJECT_NAME:$VERSION
docker push $REGISTRY/$PROJECT_NAME:latest

# 部署到Kubernetes
echo "☸️ 部署到Kubernetes..."
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap-$ENVIRONMENT.yaml
kubectl apply -f k8s/secrets-$ENVIRONMENT.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress-$ENVIRONMENT.yaml

# 等待部署完成
echo "⏳ 等待部署完成..."
kubectl rollout status deployment/$PROJECT_NAME -n $PROJECT_NAME

# 健康检查
echo "🏥 执行健康检查..."
kubectl get pods -n $PROJECT_NAME
kubectl get services -n $PROJECT_NAME
kubectl get ingress -n $PROJECT_NAME

# 显示访问信息
echo "🌐 部署完成！"
echo "📱 应用访问地址:"
kubectl get ingress -n $PROJECT_NAME -o jsonpath='{.items[0].spec.rules[0].host}'
echo ""

# 清理本地构建文件
echo "🧹 清理构建文件..."
rm -rf build/
rm -rf .dart_tool/

echo "✅ 部署完成！"
echo ""
echo "📊 监控和日志:"
echo "  kubectl logs -f deployment/$PROJECT_NAME -n $PROJECT_NAME"
echo "  kubectl port-forward svc/$PROJECT_NAME 8080:80 -n $PROJECT_NAME"
echo ""
echo "🔄 回滚命令:"
echo "  kubectl rollout undo deployment/$PROJECT_NAME -n $PROJECT_NAME"
