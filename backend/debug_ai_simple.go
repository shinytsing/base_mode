package main

import (
	"context"
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
	fmt.Printf("Tencent Secret ID: %s\n", cfg.TencentSecretID)

	// 创建AI客户端管理器
	aiManager := services.NewAIClientManager(cfg)
	
	// 获取可用的客户端
	clients := aiManager.GetAvailableClients()
	fmt.Printf("可用客户端数量: %d\n", len(clients))
	
	for _, client := range clients {
		fmt.Printf("客户端类型: %s, 是否可用: %t\n", client.GetServiceType(), client.IsAvailable())
	}

	// 测试简单的AI请求
	req := &services.AIRequest{
		Model: "auto",
		Messages: []services.AIMessage{
			{Role: "user", Content: "你好"},
		},
		Temperature: 0.7,
		MaxTokens:   50,
	}

	fmt.Println("\n测试AI请求...")
	resp, err := aiManager.GenerateText(context.Background(), req)
	if err != nil {
		fmt.Printf("AI请求失败: %v\n", err)
		
		// 尝试每个客户端
		for _, client := range clients {
			fmt.Printf("\n尝试客户端: %s\n", client.GetServiceType())
			resp, err := client.GenerateText(context.Background(), req)
			if err != nil {
				fmt.Printf("  失败: %v\n", err)
			} else {
				if len(resp.Choices) > 0 {
					fmt.Printf("  成功: %s\n", resp.Choices[0].Message.Content)
					break
				} else {
					fmt.Printf("  返回空响应\n")
				}
			}
		}
	} else {
		if len(resp.Choices) > 0 {
			fmt.Printf("AI请求成功: %s\n", resp.Choices[0].Message.Content)
		} else {
			fmt.Printf("AI请求返回空响应\n")
		}
	}
}
