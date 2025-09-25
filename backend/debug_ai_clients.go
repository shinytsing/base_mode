package main

import (
	"fmt"
	"log"

	"github.com/joho/godotenv"
	"qa-toolbox-backend/internal/config"
	"qa-toolbox-backend/internal/services"
)

func main() {
	// 加载环境变量
	if err := godotenv.Load("env.local"); err != nil {
		log.Println("No env.local file found")
	}

	// 加载配置
	cfg := config.Load()
	fmt.Printf("DeepSeek API Key: %s\n", cfg.DeepSeekAPIKey)
	fmt.Printf("AIMLAPI Key: %s\n", cfg.AIMLAPIKey)
	fmt.Printf("Tencent Secret ID: %s\n", cfg.TencentSecretID)
	fmt.Printf("Tencent Secret Key: %s\n", cfg.TencentSecretKey)

	// 创建AI客户端管理器
	aiManager := services.NewAIClientManager(cfg)
	
	// 获取可用的客户端
	clients := aiManager.GetAvailableClients()
	fmt.Printf("可用客户端数量: %d\n", len(clients))
	
	for _, client := range clients {
		fmt.Printf("客户端类型: %s, 是否可用: %t\n", client.GetServiceType(), client.IsAvailable())
	}

	// 测试AI请求
	req := &services.AIRequest{
		Model: "gpt-3.5-turbo",
		Messages: []services.AIMessage{
			{Role: "system", Content: "你是一个专业的软件测试工程师。"},
			{Role: "user", Content: "请为以下Go代码生成测试用例：func Add(a, b int) int { return a + b }"},
		},
		Temperature: 0.7,
		MaxTokens:   1000,
	}

	fmt.Println("\n测试AI请求...")
	resp, err := aiManager.GenerateText(nil, req)
	if err != nil {
		fmt.Printf("AI请求失败: %v\n", err)
	} else {
		fmt.Printf("AI请求成功: %s\n", resp.Choices[0].Message.Content)
	}
}
