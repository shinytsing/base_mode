package services

import (
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/hex"
	"fmt"
	"log"
	"time"

	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/middleware"
	"qa-toolbox-backend/internal/models"
)

type AuthService struct {
	db    *database.DB
	redis *database.RedisClient
}

func NewAuthService(db *database.DB, redis *database.RedisClient) *AuthService {
	return &AuthService{
		db:    db,
		redis: redis,
	}
}

// Register 用户注册
func (s *AuthService) Register(req *models.UserRegistrationRequest) (*models.UserResponse, error) {
	// 检查邮箱是否已存在
	var count int
	err := s.db.QueryRow("SELECT COUNT(*) FROM users WHERE email = $1", req.Email).Scan(&count)
	if err != nil {
		return nil, fmt.Errorf("检查邮箱失败: %w", err)
	}
	if count > 0 {
		return nil, fmt.Errorf("邮箱已被注册")
	}

	// 检查用户名是否已存在
	err = s.db.QueryRow("SELECT COUNT(*) FROM users WHERE username = $1", req.Username).Scan(&count)
	if err != nil {
		return nil, fmt.Errorf("检查用户名失败: %w", err)
	}
	if count > 0 {
		return nil, fmt.Errorf("用户名已被使用")
	}

	// 加密密码
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("密码加密失败: %w", err)
	}

	// 生成用户ID
	userID := uuid.New().String()

	// 创建用户
	_, err = s.db.Exec(`
		INSERT INTO users (id, email, username, password_hash, first_name, last_name, is_active, is_premium, subscription_type, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
	`, userID, req.Email, req.Username, string(hashedPassword), req.FirstName, req.LastName, true, false, "free", time.Now(), time.Now())

	if err != nil {
		return nil, fmt.Errorf("创建用户失败: %w", err)
	}

	// 返回用户信息
	return s.GetUserByID(userID)
}

// Login 用户登录
func (s *AuthService) Login(req *models.UserLoginRequest, jwtSecret string) (*models.UserResponse, string, error) {
	// 获取用户信息
	var user models.User
	var avatarURL sql.NullString
	err := s.db.QueryRow(`
		SELECT id, email, username, password_hash, first_name, last_name, avatar_url, is_active, is_premium, subscription_type, subscription_expires_at, created_at
		FROM users WHERE email = $1
	`, req.Email).Scan(
		&user.ID, &user.Email, &user.Username, &user.PasswordHash,
		&user.FirstName, &user.LastName, &avatarURL, &user.IsActive,
		&user.IsPremium, &user.SubscriptionType, &user.SubscriptionExpiresAt, &user.CreatedAt,
	)
	
	if avatarURL.Valid {
		user.AvatarURL = avatarURL.String
	}

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, "", fmt.Errorf("用户不存在")
		}
		return nil, "", fmt.Errorf("查询用户失败: %w", err)
	}

	// 检查用户是否激活
	if !user.IsActive {
		return nil, "", fmt.Errorf("账户已被禁用")
	}

	// 验证密码
	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password))
	if err != nil {
		return nil, "", fmt.Errorf("密码错误")
	}

	// 生成JWT令牌
	token, err := middleware.GenerateJWT(user.ID, user.Email, user.Username, jwtSecret)
	if err != nil {
		return nil, "", fmt.Errorf("生成令牌失败: %w", err)
	}

	// 更新最后登录时间
	_, err = s.db.Exec("UPDATE users SET updated_at = $1 WHERE id = $2", time.Now(), user.ID)
	if err != nil {
		log.Printf("更新最后登录时间失败: %v", err)
	}

	// 缓存用户会话
	s.cacheUserSession(user.ID, token)

	// 返回用户信息和令牌
	userResponse := &models.UserResponse{
		ID:                   user.ID,
		Email:                user.Email,
		Username:             user.Username,
		FirstName:            user.FirstName,
		LastName:             user.LastName,
		AvatarURL:            user.AvatarURL,
		IsActive:             user.IsActive,
		IsPremium:            user.IsPremium,
		SubscriptionType:     user.SubscriptionType,
		SubscriptionExpiresAt: user.SubscriptionExpiresAt,
		CreatedAt:            user.CreatedAt,
	}

	return userResponse, token, nil
}

// GetUserByID 根据ID获取用户信息
func (s *AuthService) GetUserByID(userID string) (*models.UserResponse, error) {
	var user models.User
	var avatarURL sql.NullString
	err := s.db.QueryRow(`
		SELECT id, email, username, first_name, last_name, avatar_url, is_active, is_premium, subscription_type, subscription_expires_at, created_at
		FROM users WHERE id = $1
	`, userID).Scan(
		&user.ID, &user.Email, &user.Username, &user.FirstName,
		&user.LastName, &avatarURL, &user.IsActive, &user.IsPremium,
		&user.SubscriptionType, &user.SubscriptionExpiresAt, &user.CreatedAt,
	)
	
	if avatarURL.Valid {
		user.AvatarURL = avatarURL.String
	}

	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("用户不存在")
		}
		return nil, fmt.Errorf("查询用户失败: %w", err)
	}

	return &models.UserResponse{
		ID:                   user.ID,
		Email:                user.Email,
		Username:             user.Username,
		FirstName:            user.FirstName,
		LastName:             user.LastName,
		AvatarURL:            user.AvatarURL,
		IsActive:             user.IsActive,
		IsPremium:            user.IsPremium,
		SubscriptionType:     user.SubscriptionType,
		SubscriptionExpiresAt: user.SubscriptionExpiresAt,
		CreatedAt:            user.CreatedAt,
	}, nil
}

// UpdateProfile 更新用户资料
func (s *AuthService) UpdateProfile(userID string, updates map[string]interface{}) (*models.UserResponse, error) {
	// 构建更新SQL
	setParts := []string{}
	args := []interface{}{}
	argIndex := 1

	for key, value := range updates {
		switch key {
		case "first_name", "last_name", "avatar_url":
			setParts = append(setParts, fmt.Sprintf("%s = $%d", key, argIndex))
			args = append(args, value)
			argIndex++
		}
	}

	if len(setParts) == 0 {
		return nil, fmt.Errorf("没有有效的更新字段")
	}

	// 添加更新时间
	setParts = append(setParts, fmt.Sprintf("updated_at = $%d", argIndex))
	args = append(args, time.Now())
	argIndex++

	// 添加用户ID参数
	args = append(args, userID)

	// 执行更新
	query := fmt.Sprintf("UPDATE users SET %s WHERE id = $%d", 
		fmt.Sprintf("%s", setParts[0]), argIndex)
	for i := 1; i < len(setParts); i++ {
		query = fmt.Sprintf("UPDATE users SET %s WHERE id = $%d", 
			fmt.Sprintf("%s, %s", query, setParts[i]), argIndex)
	}

	_, err := s.db.Exec(query, args...)
	if err != nil {
		return nil, fmt.Errorf("更新用户资料失败: %w", err)
	}

	// 清除用户缓存
	s.clearUserCache(userID)

	// 返回更新后的用户信息
	return s.GetUserByID(userID)
}

// ChangePassword 修改密码
func (s *AuthService) ChangePassword(userID, oldPassword, newPassword string) error {
	// 获取当前密码哈希
	var currentPasswordHash string
	err := s.db.QueryRow("SELECT password_hash FROM users WHERE id = $1", userID).Scan(&currentPasswordHash)
	if err != nil {
		return fmt.Errorf("获取用户信息失败: %w", err)
	}

	// 验证旧密码
	err = bcrypt.CompareHashAndPassword([]byte(currentPasswordHash), []byte(oldPassword))
	if err != nil {
		return fmt.Errorf("旧密码错误")
	}

	// 加密新密码
	newPasswordHash, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("密码加密失败: %w", err)
	}

	// 更新密码
	_, err = s.db.Exec(`
		UPDATE users 
		SET password_hash = $1, updated_at = $2 
		WHERE id = $3
	`, string(newPasswordHash), time.Now(), userID)

	if err != nil {
		return fmt.Errorf("更新密码失败: %w", err)
	}

	// 清除用户会话缓存
	s.clearUserSessions(userID)

	return nil
}

// Logout 用户登出
func (s *AuthService) Logout(userID, token string) error {
	// 从Redis中删除会话
	err := s.redis.Del(context.Background(), "session_"+userID+"_"+token).Err()
	if err != nil {
		log.Printf("删除会话缓存失败: %v", err)
	}

	return nil
}

// GenerateResetToken 生成密码重置令牌
func (s *AuthService) GenerateResetToken(email string) (string, error) {
	// 检查用户是否存在
	var userID string
	err := s.db.QueryRow("SELECT id FROM users WHERE email = $1", email).Scan(&userID)
	if err != nil {
		if err == sql.ErrNoRows {
			return "", fmt.Errorf("用户不存在")
		}
		return "", fmt.Errorf("查询用户失败: %w", err)
	}

	// 生成随机令牌
	tokenBytes := make([]byte, 32)
	_, err = rand.Read(tokenBytes)
	if err != nil {
		return "", fmt.Errorf("生成令牌失败: %w", err)
	}
	token := hex.EncodeToString(tokenBytes)

	// 将令牌存储到Redis，设置15分钟过期
	err = s.redis.Set(context.Background(), "reset_token_"+token, userID, 15*time.Minute).Err()
	if err != nil {
		return "", fmt.Errorf("存储重置令牌失败: %w", err)
	}

	return token, nil
}

// ResetPassword 重置密码
func (s *AuthService) ResetPassword(token, newPassword string) error {
	// 从Redis获取用户ID
	userID, err := s.redis.Get(context.Background(), "reset_token_"+token).Result()
	if err != nil {
		return fmt.Errorf("重置令牌无效或已过期")
	}

	// 加密新密码
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("密码加密失败: %w", err)
	}

	// 更新密码
	_, err = s.db.Exec(`
		UPDATE users 
		SET password_hash = $1, updated_at = $2 
		WHERE id = $3
	`, string(hashedPassword), time.Now(), userID)

	if err != nil {
		return fmt.Errorf("更新密码失败: %w", err)
	}

	// 删除重置令牌
	s.redis.Del(context.Background(), "reset_token_"+token)

	// 清除用户所有会话
	s.clearUserSessions(userID)

	return nil
}

// cacheUserSession 缓存用户会话
func (s *AuthService) cacheUserSession(userID, token string) {
	key := "session_" + userID + "_" + token
	s.redis.Set(context.Background(), key, userID, 24*time.Hour)
}

// clearUserCache 清除用户缓存
func (s *AuthService) clearUserCache(userID string) {
	s.redis.Del(context.Background(), "user_"+userID)
}

// clearUserSessions 清除用户所有会话
func (s *AuthService) clearUserSessions(userID string) {
	// 这里应该实现清除用户所有会话的逻辑
	// 可以通过扫描Redis中的session_*键来实现
	pattern := "session_" + userID + "_*"
	keys, err := s.redis.Keys(context.Background(), pattern).Result()
	if err != nil {
		log.Printf("获取用户会话键失败: %v", err)
		return
	}

	if len(keys) > 0 {
		s.redis.Del(context.Background(), keys...)
	}
}
