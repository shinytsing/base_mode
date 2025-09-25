package services

import (
	"database/sql"
	"fmt"

	"github.com/lib/pq"
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type AppService struct {
	db *database.DB
}

func NewAppService(db *database.DB) *AppService {
	return &AppService{
		db: db,
	}
}

// GetApps 获取应用列表
func (s *AppService) GetApps(page, perPage int, category string) ([]models.App, int, error) {
	offset := (page - 1) * perPage

	// 查询总数 - 使用简单查询
	var total int
	var countQuery string
	var countArgs []interface{}

	if category != "" {
		countQuery = "SELECT COUNT(*) FROM apps WHERE is_active = TRUE AND category = $1"
		countArgs = []interface{}{category}
	} else {
		countQuery = "SELECT COUNT(*) FROM apps WHERE is_active = TRUE"
		countArgs = []interface{}{}
	}

	err := s.db.QueryRow(countQuery, countArgs...).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count apps: %w", err)
	}

	// 查询应用列表 - 使用简单查询
	var query string
	var args []interface{}

	if category != "" {
		query = `
			SELECT id, name, description, category, icon, color, version, is_premium, is_active,
			       features, screenshots, created_at, updated_at
			FROM apps 
			WHERE is_active = TRUE AND category = $1
			ORDER BY created_at DESC
			LIMIT $2 OFFSET $3
		`
		args = []interface{}{category, perPage, offset}
	} else {
		query = `
			SELECT id, name, description, category, icon, color, version, is_premium, is_active,
			       features, screenshots, created_at, updated_at
			FROM apps 
			WHERE is_active = TRUE
			ORDER BY created_at DESC
			LIMIT $1 OFFSET $2
		`
		args = []interface{}{perPage, offset}
	}

	rows, err := s.db.Query(query, args...)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query apps: %w", err)
	}
	defer rows.Close()

	var apps []models.App
	for rows.Next() {
		var app models.App
		var features, screenshots pq.StringArray
		err := rows.Scan(
			&app.ID, &app.Name, &app.Description, &app.Category, &app.Icon, &app.Color,
			&app.Version, &app.IsPremium, &app.IsActive, &features, &screenshots, &app.CreatedAt, &app.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan app: %w", err)
		}
		
		// 转换PostgreSQL数组到Go切片
		app.Features = []string(features)
		app.Screenshots = []string(screenshots)
		
		apps = append(apps, app)
	}

	return apps, total, nil
}

// GetAppByID 根据ID获取应用
func (s *AppService) GetAppByID(appID string) (*models.App, error) {
	query := `
		SELECT id, name, description, category, icon, color, version, is_premium, 
		       features, screenshots, created_at, updated_at
		FROM apps WHERE id = $1 AND is_active = TRUE
	`

	app := &models.App{}
	var features, screenshots pq.StringArray
	err := s.db.QueryRow(query, appID).Scan(
		&app.ID, &app.Name, &app.Description, &app.Category, &app.Icon, &app.Color,
		&app.Version, &app.IsPremium, &features, &screenshots, &app.CreatedAt, &app.UpdatedAt,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("app not found")
		}
		return nil, fmt.Errorf("failed to query app: %w", err)
	}

	// 转换PostgreSQL数组到Go切片
	app.Features = []string(features)
	app.Screenshots = []string(screenshots)

	return app, nil
}

// InstallApp 安装应用
func (s *AppService) InstallApp(userID, appID string) error {
	// 检查应用是否存在
	var exists bool
	err := s.db.QueryRow("SELECT EXISTS(SELECT 1 FROM apps WHERE id = $1 AND is_active = TRUE)", appID).Scan(&exists)
	if err != nil {
		return fmt.Errorf("failed to check app existence: %w", err)
	}
	if !exists {
		return fmt.Errorf("app not found")
	}

	// 检查是否已安装
	err = s.db.QueryRow("SELECT EXISTS(SELECT 1 FROM user_apps WHERE user_id = $1 AND app_id = $2)", userID, appID).Scan(&exists)
	if err != nil {
		return fmt.Errorf("failed to check installation: %w", err)
	}
	if exists {
		return fmt.Errorf("app already installed")
	}

	// 检查用户应用限制
	var canInstall bool
	err = s.db.QueryRow("SELECT check_user_app_limit($1, $2)", userID, appID).Scan(&canInstall)
	if err != nil {
		return fmt.Errorf("failed to check app limit: %w", err)
	}
	if !canInstall {
		return fmt.Errorf("app installation limit exceeded")
	}

	// 安装应用
	_, err = s.db.Exec(`
		INSERT INTO user_apps (user_id, app_id, installed_at, usage_count, settings)
		VALUES ($1, $2, NOW(), 0, '{}')
	`, userID, appID)
	if err != nil {
		return fmt.Errorf("failed to install app: %w", err)
	}

	return nil
}

// UninstallApp 卸载应用
func (s *AppService) UninstallApp(userID, appID string) error {
	// 检查是否已安装
	var exists bool
	err := s.db.QueryRow("SELECT EXISTS(SELECT 1 FROM user_apps WHERE user_id = $1 AND app_id = $2)", userID, appID).Scan(&exists)
	if err != nil {
		return fmt.Errorf("failed to check installation: %w", err)
	}
	if !exists {
		return fmt.Errorf("app not installed")
	}

	// 卸载应用
	_, err = s.db.Exec("DELETE FROM user_apps WHERE user_id = $1 AND app_id = $2", userID, appID)
	if err != nil {
		return fmt.Errorf("failed to uninstall app: %w", err)
	}

	return nil
}

// GetInstalledApps 获取已安装的应用
func (s *AppService) GetInstalledApps(userID string, page, perPage int) ([]models.App, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow(`
		SELECT COUNT(*) FROM user_apps ua
		JOIN apps a ON ua.app_id = a.id
		WHERE ua.user_id = $1 AND a.is_active = TRUE
	`, userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count installed apps: %w", err)
	}

	// 查询已安装的应用
	query := `
		SELECT a.id, a.name, a.description, a.category, a.icon, a.color, a.version, a.is_premium,
		       a.features, a.screenshots, a.created_at, a.updated_at, ua.installed_at, ua.last_used_at, ua.usage_count
		FROM user_apps ua
		JOIN apps a ON ua.app_id = a.id
		WHERE ua.user_id = $1 AND a.is_active = TRUE
		ORDER BY ua.last_used_at DESC NULLS LAST, ua.installed_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query installed apps: %w", err)
	}
	defer rows.Close()

	var apps []models.App
	for rows.Next() {
		var app models.App
		var features, screenshots pq.StringArray
		var installedAt, lastUsedAt sql.NullTime
		var usageCount int

		err := rows.Scan(
			&app.ID, &app.Name, &app.Description, &app.Category, &app.Icon, &app.Color,
			&app.Version, &app.IsPremium, &features, &screenshots, &app.CreatedAt, &app.UpdatedAt,
			&installedAt, &lastUsedAt, &usageCount,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan installed app: %w", err)
		}

		// 转换PostgreSQL数组到Go切片
		app.Features = []string(features)
		app.Screenshots = []string(screenshots)

		// 这里可以添加安装时间、最后使用时间、使用次数等信息到app对象
		apps = append(apps, app)
	}

	return apps, total, nil
}

// UpdateAppUsage 更新应用使用情况
func (s *AppService) UpdateAppUsage(userID, appID string) error {
	_, err := s.db.Exec(`
		UPDATE user_apps 
		SET usage_count = usage_count + 1, last_used_at = NOW()
		WHERE user_id = $1 AND app_id = $2
	`, userID, appID)
	if err != nil {
		return fmt.Errorf("failed to update app usage: %w", err)
	}

	return nil
}