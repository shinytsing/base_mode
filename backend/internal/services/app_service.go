package services

import (
	"fmt"
	"time"

	"github.com/google/uuid"
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type AppService struct {
	db *database.DB
}

func NewAppService(db *database.DB) *AppService {
	return &AppService{db: db}
}

// GetApps 获取所有应用
func (s *AppService) GetApps() ([]models.App, error) {
	rows, err := s.db.Query(`
		SELECT id, name, description, category, icon, color, version, is_active, created_at, updated_at
		FROM apps WHERE is_active = true
		ORDER BY created_at DESC
	`)
	if err != nil {
		return nil, fmt.Errorf("查询应用失败: %w", err)
	}
	defer rows.Close()

	var apps []models.App
	for rows.Next() {
		var app models.App
		err := rows.Scan(
			&app.ID, &app.Name, &app.Description, &app.Category,
			&app.Icon, &app.Color, &app.Version, &app.IsActive,
			&app.CreatedAt, &app.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("扫描应用数据失败: %w", err)
		}
		app.IsPremium = false // 默认设置为false，因为数据库中没有这个字段
		app.Features = []string{}
		app.Screenshots = []string{}
		apps = append(apps, app)
	}

	return apps, nil
}

// GetAppByID 根据ID获取应用
func (s *AppService) GetAppByID(appID string) (*models.App, error) {
	var app models.App
	err := s.db.QueryRow(`
		SELECT id, name, description, category, icon, color, version, is_active, created_at, updated_at
		FROM apps WHERE id = $1 AND is_active = true
	`, appID).Scan(
		&app.ID, &app.Name, &app.Description, &app.Category,
		&app.Icon, &app.Color, &app.Version, &app.IsActive,
		&app.CreatedAt, &app.UpdatedAt,
	)

	if err != nil {
		return nil, fmt.Errorf("查询应用失败: %w", err)
	}

	app.IsPremium = false // 默认设置为false，因为数据库中没有这个字段
	app.Features = []string{}
	app.Screenshots = []string{}
	return &app, nil
}

// InstallApp 安装应用
func (s *AppService) InstallApp(userID, appID string) error {
	// 检查应用是否存在
	var exists bool
	err := s.db.QueryRow("SELECT EXISTS(SELECT 1 FROM apps WHERE id = $1 AND is_active = true)", appID).Scan(&exists)
	if err != nil {
		return fmt.Errorf("检查应用是否存在失败: %w", err)
	}
	if !exists {
		return fmt.Errorf("应用不存在")
	}

	// 检查是否已安装
	var alreadyInstalled bool
	err = s.db.QueryRow("SELECT EXISTS(SELECT 1 FROM user_apps WHERE user_id = $1 AND app_id = $2)", userID, appID).Scan(&alreadyInstalled)
	if err != nil {
		return fmt.Errorf("检查应用是否已安装失败: %w", err)
	}
	if alreadyInstalled {
		return fmt.Errorf("应用已安装")
	}

	// 安装应用
	_, err = s.db.Exec(`
		INSERT INTO user_apps (id, user_id, app_id, installed_at, last_used_at, usage_count)
		VALUES ($1, $2, $3, $4, $5, $6)
	`, uuid.New().String(), userID, appID, time.Now(), time.Now(), 0)

	if err != nil {
		return fmt.Errorf("安装应用失败: %w", err)
	}

	return nil
}

// UninstallApp 卸载应用
func (s *AppService) UninstallApp(userID, appID string) error {
	_, err := s.db.Exec("DELETE FROM user_apps WHERE user_id = $1 AND app_id = $2", userID, appID)
	if err != nil {
		return fmt.Errorf("卸载应用失败: %w", err)
	}

	return nil
}

// GetInstalledApps 获取已安装的应用
func (s *AppService) GetInstalledApps(userID string) ([]models.App, error) {
	rows, err := s.db.Query(`
		SELECT a.id, a.name, a.description, a.category, a.icon, a.color, a.version, a.is_premium, a.is_active, a.created_at, a.updated_at
		FROM apps a
		INNER JOIN user_apps ua ON a.id = ua.app_id
		WHERE ua.user_id = $1 AND a.is_active = true
		ORDER BY ua.last_used_at DESC
	`, userID)
	if err != nil {
		return nil, fmt.Errorf("查询已安装应用失败: %w", err)
	}
	defer rows.Close()

	var apps []models.App
	for rows.Next() {
		var app models.App
		err := rows.Scan(
			&app.ID, &app.Name, &app.Description, &app.Category,
			&app.Icon, &app.Color, &app.Version, &app.IsPremium, &app.IsActive,
			&app.CreatedAt, &app.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("扫描应用数据失败: %w", err)
		}
		app.Features = []string{}
		app.Screenshots = []string{}
		apps = append(apps, app)
	}

	return apps, nil
}