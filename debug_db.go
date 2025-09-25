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

	// 查询表结构
	rows, err := db.Query(`
		SELECT column_name, data_type 
		FROM information_schema.columns 
		WHERE table_name = 'apps' 
		ORDER BY ordinal_position
	`)
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	fmt.Println("Apps表结构:")
	for rows.Next() {
		var columnName, dataType string
		if err := rows.Scan(&columnName, &dataType); err != nil {
			log.Fatal(err)
		}
		fmt.Printf("  %s: %s\n", columnName, dataType)
	}

	// 测试查询
	fmt.Println("\n测试查询:")
	rows2, err := db.Query("SELECT id, name, is_premium FROM apps LIMIT 3")
	if err != nil {
		log.Fatal(err)
	}
	defer rows2.Close()

	for rows2.Next() {
		var id, name string
		var isPremium bool
		if err := rows2.Scan(&id, &name, &isPremium); err != nil {
			log.Fatal(err)
		}
		fmt.Printf("  %s: %s (premium: %t)\n", id, name, isPremium)
	}
}
