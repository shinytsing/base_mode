# Go 后端 Dockerfile - 多阶段构建优化版本
FROM golang:1.21-alpine AS builder

# 安装必要的包
RUN apk add --no-cache git ca-certificates tzdata

# 设置工作目录
WORKDIR /app

# 复制 go mod 文件
COPY go.mod go.sum ./

# 下载依赖
RUN go mod download

# 复制源代码
COPY . .

# 构建应用 - 优化构建参数
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' \
    -a -installsuffix cgo \
    -o main .

# 运行阶段 - 使用scratch镜像减少体积
FROM scratch

# 从构建阶段复制证书和时区数据
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo

# 设置工作目录
WORKDIR /app

# 复制构建的二进制文件
COPY --from=builder /app/main .

# 创建必要的目录
RUN mkdir -p uploads logs

# 创建非root用户
USER 1000:1000

# 暴露端口
EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD ["/app/main", "health"]

# 运行应用
ENTRYPOINT ["./main"]
