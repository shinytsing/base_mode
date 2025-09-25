package main

import (
	"fmt"
	"log"

	"github.com/joho/godotenv"
	"qa-toolbox-backend/internal/config"
	"qa-toolbox-backend/internal/database"
)

func main() {
	// 加载环境变量
	if err := godotenv.Load("env.local"); err != nil {
		log.Println("No env.local file found")
	}

	// 加载配置
	cfg := config.Load()
	fmt.Printf("Database URL: %s\n", cfg.DatabaseURL)

	// 初始化数据库连接
	db, err := database.InitDB(cfg.DatabaseURL)
	if err != nil {
		log.Fatal("Failed to connect to database:", err)
	}
	defer db.Close()

	fmt.Println("Database connection successful!")

	// 测试apps表查询
	fmt.Println("\n=== 测试apps表查询 ===")
	rows, err := db.Query(`
		SELECT id, name, description, category, icon, color, version, is_premium, is_active,
		       created_at, updated_at
		FROM apps
		WHERE is_active = TRUE
		ORDER BY created_at DESC
		LIMIT 5
	`)
	if err != nil {
		log.Fatal("查询失败:", err)
	}
	defer rows.Close()

	fmt.Println("查询成功！结果:")
	count := 0
	for rows.Next() {
		var id, name, description, category, icon, color, version string
		var isPremium, isActive bool
		var createdAt, updatedAt string

		err := rows.Scan(
			&id, &name, &description, &category, &icon, &color, &version,
			&isPremium, &isActive, &createdAt, &updatedAt,
		)
		if err != nil {
			log.Fatal("扫描失败:", err)
		}

		fmt.Printf("  %d. %s (ID: %s, Premium: %t)\n", count+1, name, id, isPremium)
		count++
	}

	if count == 0 {
		fmt.Println("  没有找到数据")
	}

	// 测试新表
	fmt.Println("\n=== 测试新创建的表 ===")
	tables := []string{"mood_entries", "workouts", "matches", "writings"}
	for _, table := range tables {
		var count int
		err := db.QueryRow(fmt.Sprintf("SELECT COUNT(*) FROM %s", table)).Scan(&count)
		if err != nil {
			fmt.Printf("  %s: 查询失败 - %v\n", table, err)
		} else {
			fmt.Printf("  %s: %d 条记录\n", table, count)
		}
	}
}
