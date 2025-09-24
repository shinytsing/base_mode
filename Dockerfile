# 使用官方Flutter镜像
FROM ghcr.io/cirruslabs/flutter:stable AS build

# 设置工作目录
WORKDIR /app

# 复制pubspec文件
COPY pubspec.yaml pubspec.lock ./

# 安装依赖
RUN flutter pub get

# 复制源代码
COPY . .

# 生成代码
RUN flutter packages pub run build_runner build --delete-conflicting-outputs

# 构建APK
RUN flutter build apk --release

# 使用Alpine Linux作为运行时镜像
FROM alpine:latest

# 安装必要的工具
RUN apk --no-cache add ca-certificates

# 创建非root用户
RUN addgroup -g 1001 -S appgroup && \
    adduser -u 1001 -S appuser -G appgroup

# 设置工作目录
WORKDIR /app

# 复制构建的APK
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk ./app.apk

# 更改文件所有者
RUN chown -R appuser:appgroup /app

# 切换到非root用户
USER appuser

# 暴露端口（如果需要）
EXPOSE 8080

# 启动命令
CMD ["sh", "-c", "echo 'Flutter app built successfully' && ls -la /app"]
