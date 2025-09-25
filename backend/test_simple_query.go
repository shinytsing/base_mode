package main

import (
	"database/sql"
	"fmt"
	"log"

	_ "github.com/lib/pq"
)

func main() {
	// 使用相同的数据库URL
	dbURL := "postgres://gaojie@localhost/qatoolbox_local?sslmode=disable"
	
	db, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// 测试连接
	if err := db.Ping(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("数据库连接成功！")

	// 测试最简单的查询
	fmt.Println("\n=== 测试最简单的查询 ===")
	var count int
	err = db.QueryRow("SELECT COUNT(*) FROM apps").Scan(&count)
	if err != nil {
		log.Fatal("简单查询失败:", err)
	}
	fmt.Printf("apps表总记录数: %d\n", count)

	// 测试带WHERE的查询
	fmt.Println("\n=== 测试带WHERE的查询 ===")
	var activeCount int
	err = db.QueryRow("SELECT COUNT(*) FROM apps WHERE is_active = TRUE").Scan(&activeCount)
	if err != nil {
		log.Fatal("WHERE查询失败:", err)
	}
	fmt.Printf("活跃应用数: %d\n", activeCount)

	// 测试SELECT * 查询
	fmt.Println("\n=== 测试SELECT * 查询 ===")
	rows, err := db.Query("SELECT * FROM apps LIMIT 1")
	if err != nil {
		log.Fatal("SELECT * 查询失败:", err)
	}
	defer rows.Close()

	columns, err := rows.Columns()
	if err != nil {
		log.Fatal("获取列信息失败:", err)
	}
	fmt.Printf("apps表列: %v\n", columns)

	// 测试具体字段查询
	fmt.Println("\n=== 测试具体字段查询 ===")
	rows2, err := db.Query("SELECT id, name, is_premium FROM apps LIMIT 3")
	if err != nil {
		log.Fatal("具体字段查询失败:", err)
	}
	defer rows2.Close()

	for rows2.Next() {
		var id, name string
		var isPremium bool
		if err := rows2.Scan(&id, &name, &isPremium); err != nil {
			log.Fatal("扫描失败:", err)
		}
		fmt.Printf("  %s: %s (premium: %t)\n", id, name, isPremium)
	}

	fmt.Println("\n所有测试都成功了！")
}
