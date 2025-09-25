package main

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"qa-toolbox-backend/internal/config"
)

func main() {
	// 加载环境变量
	if err := godotenv.Load("env.local"); err != nil {
		log.Println("No env.local file found")
	}

	// 加载配置
	cfg := config.Load()
	
	fmt.Printf("JWT Secret from config: %s\n", cfg.JWTSecret)
	fmt.Printf("JWT Secret from env: %s\n", os.Getenv("JWT_SECRET"))
	fmt.Printf("JWT Secret from env.local: %s\n", os.Getenv("JWT_SECRET"))
}
