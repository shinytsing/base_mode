package main

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
	"qa-toolbox-backend/internal/config"
	"qa-toolbox-backend/internal/database"
)

func main() {
	// 加载环境变量
	if err := godotenv.Load("env.local"); err != nil {
		log.Println("No env.local file found")
	}

	// 显示环境变量
	fmt.Println("=== 环境变量检查 ===")
	fmt.Printf("DATABASE_URL from env: %s\n", os.Getenv("DATABASE_URL"))

	// 加载配置
	cfg := config.Load()
	fmt.Printf("Database URL from config: %s\n", cfg.DatabaseURL)

	// 初始化数据库连接
	db, err := database.InitDB(cfg.DatabaseURL)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()

	fmt.Println("Database connection successful!")

	// 检查实际连接的数据库
	fmt.Println("\n=== 实际数据库连接检查 ===")
	var currentDB, currentUser, currentSchema string
	err = db.QueryRow("SELECT current_database(), current_user, current_schema()").Scan(&currentDB, &currentUser, &currentSchema)
	if err != nil {
		log.Fatal("Failed to query database info:", err)
	}
	fmt.Printf("当前数据库: %s\n", currentDB)
	fmt.Printf("当前用户: %s\n", currentUser)
	fmt.Printf("当前模式: %s\n", currentSchema)

	// 检查apps表是否存在
	fmt.Println("\n=== 检查apps表 ===")
	var tableExists bool
	err = db.QueryRow(`
		SELECT EXISTS (
			SELECT FROM information_schema.tables 
			WHERE table_schema = 'public' 
			AND table_name = 'apps'
		)
	`).Scan(&tableExists)
	if err != nil {
		log.Fatal("Failed to check table existence:", err)
	}
	fmt.Printf("apps表是否存在: %t\n", tableExists)

	if !tableExists {
		fmt.Println("❌ apps表不存在！这就是问题所在。")
		return
	}

	// 检查apps表的列
	fmt.Println("\n=== 检查apps表的列 ===")
	rows, err := db.Query(`
		SELECT column_name, data_type 
		FROM information_schema.columns 
		WHERE table_schema = 'public' 
		AND table_name = 'apps'
		ORDER BY ordinal_position
	`)
	if err != nil {
		log.Fatal("Failed to query table columns:", err)
	}
	defer rows.Close()

	var hasPremiumColumn bool
	for rows.Next() {
		var columnName, dataType string
		if err := rows.Scan(&columnName, &dataType); err != nil {
			log.Fatal("Failed to scan column info:", err)
		}
		fmt.Printf("  %s: %s\n", columnName, dataType)
		if columnName == "is_premium" {
			hasPremiumColumn = true
		}
	}

	if !hasPremiumColumn {
		fmt.Println("❌ is_premium列不存在！这就是问题所在。")
	} else {
		fmt.Println("✅ is_premium列存在。")
	}

	// 测试实际的查询
	fmt.Println("\n=== 测试实际查询 ===")
	testRows, err := db.Query(`
		SELECT id, name, description, category, icon, color, version, is_premium, is_active,
		       features, screenshots, created_at, updated_at
		FROM apps 
		WHERE is_active = TRUE
		ORDER BY created_at DESC
		LIMIT 2
	`)
	if err != nil {
		log.Fatal("实际查询失败:", err)
	}
	defer testRows.Close()

	fmt.Println("✅ 实际查询成功！")
}
