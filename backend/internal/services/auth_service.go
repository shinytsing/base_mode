package services

import (
	"context"
	"crypto/rand"
	"database/sql"
	"encoding/hex"
	"fmt"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type AuthService struct {
	db        *database.DB
	redis     *database.RedisClient
	jwtSecret string
}

func NewAuthService(db *database.DB, redis *database.RedisClient, jwtSecret string) *AuthService {
	return &AuthService{
		db:        db,
		redis:     redis,
		jwtSecret: jwtSecret,
	}
}

// Register 用户注册
func (s *AuthService) Register(req *models.UserRegistrationRequest) (*models.UserResponse, error) {
	// 检查邮箱是否已存在
	var count int
	err := s.db.QueryRow("SELECT COUNT(*) FROM users WHERE email = $1", req.Email).Scan(&count)
	if err != nil {
		return nil, fmt.Errorf("failed to check email: %w", err)
	}
	if count > 0 {
		return nil, fmt.Errorf("email already exists")
	}

	// 检查用户名是否已存在
	err = s.db.QueryRow("SELECT COUNT(*) FROM users WHERE username = $1", req.Username).Scan(&count)
	if err != nil {
		return nil, fmt.Errorf("failed to check username: %w", err)
	}
	if count > 0 {
		return nil, fmt.Errorf("username already exists")
	}

	// 加密密码
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("failed to hash password: %w", err)
	}

	// 生成用户ID
	userID := generateUUID()

	// 插入用户
	query := `
		INSERT INTO users (id, email, username, password_hash, first_name, last_name, subscription_type, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, 'free', NOW(), NOW())
		RETURNING id, email, username, first_name, last_name, avatar_url, is_active, is_premium, subscription_type, subscription_expires_at, created_at
	`

	user := &models.UserResponse{}
	err = s.db.QueryRow(query, userID, req.Email, req.Username, string(hashedPassword), req.FirstName, req.LastName).Scan(
		&user.ID, &user.Email, &user.Username, &user.FirstName, &user.LastName, &user.AvatarURL,
		&user.IsActive, &user.IsPremium, &user.SubscriptionType, &user.SubscriptionExpiresAt, &user.CreatedAt,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to create user: %w", err)
	}

	return user, nil
}

// Login 用户登录
func (s *AuthService) Login(req *models.UserLoginRequest) (*models.UserResponse, string, error) {
	// 查询用户
	query := `
		SELECT id, email, username, password_hash, first_name, last_name, avatar_url, 
		       is_active, is_premium, subscription_type, subscription_expires_at, created_at
		FROM users WHERE email = $1
	`

	user := &models.User{}
	var firstName, lastName, avatarURL sql.NullString
	var subscriptionExpiresAt sql.NullTime
	
	err := s.db.QueryRow(query, req.Email).Scan(
		&user.ID, &user.Email, &user.Username, &user.PasswordHash, &firstName, &lastName, &avatarURL,
		&user.IsActive, &user.IsPremium, &user.SubscriptionType, &subscriptionExpiresAt, &user.CreatedAt,
	)
	
	// 处理NULL值
	if firstName.Valid {
		user.FirstName = firstName.String
	}
	if lastName.Valid {
		user.LastName = lastName.String
	}
	if avatarURL.Valid {
		user.AvatarURL = avatarURL.String
	}
	if subscriptionExpiresAt.Valid {
		user.SubscriptionExpiresAt = &subscriptionExpiresAt.Time
	}
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, "", fmt.Errorf("invalid email or password")
		}
		return nil, "", fmt.Errorf("failed to query user: %w", err)
	}

	// 验证密码
	err = bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password))
	if err != nil {
		return nil, "", fmt.Errorf("invalid email or password")
	}

	// 检查用户是否激活
	if !user.IsActive {
		return nil, "", fmt.Errorf("account is deactivated")
	}

	// 生成JWT token
	token, err := s.generateJWTToken(user)
	if err != nil {
		return nil, "", fmt.Errorf("failed to generate token: %w", err)
	}

	// 将token存储到Redis
	err = s.storeTokenInRedis(user.ID, token)
	if err != nil {
		return nil, "", fmt.Errorf("failed to store token: %w", err)
	}

	// 返回用户信息（不包含密码）
	userResponse := &models.UserResponse{
		ID:                   user.ID,
		Email:                user.Email,
		Username:             user.Username,
		FirstName:            user.FirstName,
		LastName:             user.LastName,
		AvatarURL:            user.AvatarURL,
		IsActive:             user.IsActive,
		IsPremium:            user.IsPremium,
		SubscriptionType:    user.SubscriptionType,
		SubscriptionExpiresAt: user.SubscriptionExpiresAt,
		CreatedAt:            user.CreatedAt,
	}

	return userResponse, token, nil
}

// Logout 用户登出
func (s *AuthService) Logout(userID, token string) error {
	// 从Redis中删除token
	return s.RemoveTokenFromRedis(userID, token)
}

// GetUserByID 根据ID获取用户
func (s *AuthService) GetUserByID(userID string) (*models.UserResponse, error) {
	query := `
		SELECT id, email, username, first_name, last_name, avatar_url, 
		       is_active, is_premium, subscription_type, subscription_expires_at, created_at
		FROM users WHERE id = $1
	`

	user := &models.UserResponse{}
	var firstName, lastName, avatarURL sql.NullString
	var subscriptionExpiresAt sql.NullTime
	
	err := s.db.QueryRow(query, userID).Scan(
		&user.ID, &user.Email, &user.Username, &firstName, &lastName, &avatarURL,
		&user.IsActive, &user.IsPremium, &user.SubscriptionType, &subscriptionExpiresAt, &user.CreatedAt,
	)
	
	// 处理NULL值
	if firstName.Valid {
		user.FirstName = firstName.String
	}
	if lastName.Valid {
		user.LastName = lastName.String
	}
	if avatarURL.Valid {
		user.AvatarURL = avatarURL.String
	}
	if subscriptionExpiresAt.Valid {
		user.SubscriptionExpiresAt = &subscriptionExpiresAt.Time
	}
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("user not found")
		}
		return nil, fmt.Errorf("failed to query user: %w", err)
	}

	return user, nil
}

// UpdateUser 更新用户信息
func (s *AuthService) UpdateUser(userID string, updates map[string]interface{}) (*models.UserResponse, error) {
	// 构建更新查询
	setParts := []string{}
	args := []interface{}{}
	argIndex := 1

	for key, value := range updates {
		setParts = append(setParts, fmt.Sprintf("%s = $%d", key, argIndex))
		args = append(args, value)
		argIndex++
	}

	if len(setParts) == 0 {
		return s.GetUserByID(userID)
	}

	query := fmt.Sprintf(`
		UPDATE users SET %s, updated_at = NOW()
		WHERE id = $%d
		RETURNING id, email, username, first_name, last_name, avatar_url, 
		          is_active, is_premium, subscription_type, subscription_expires_at, created_at
	`, fmt.Sprintf("%s", setParts[0]), argIndex)

	args = append(args, userID)

	user := &models.UserResponse{}
	err := s.db.QueryRow(query, args...).Scan(
		&user.ID, &user.Email, &user.Username, &user.FirstName, &user.LastName, &user.AvatarURL,
		&user.IsActive, &user.IsPremium, &user.SubscriptionType, &user.SubscriptionExpiresAt, &user.CreatedAt,
	)
	if err != nil {
		return nil, fmt.Errorf("failed to update user: %w", err)
	}

	return user, nil
}

// ChangePassword 修改密码
func (s *AuthService) ChangePassword(userID, oldPassword, newPassword string) error {
	// 获取当前密码
	var currentPasswordHash string
	err := s.db.QueryRow("SELECT password_hash FROM users WHERE id = $1", userID).Scan(&currentPasswordHash)
	if err != nil {
		return fmt.Errorf("failed to get current password: %w", err)
	}

	// 验证旧密码
	err = bcrypt.CompareHashAndPassword([]byte(currentPasswordHash), []byte(oldPassword))
	if err != nil {
		return fmt.Errorf("invalid old password")
	}

	// 加密新密码
	newPasswordHash, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("failed to hash new password: %w", err)
	}

	// 更新密码
	_, err = s.db.Exec("UPDATE users SET password_hash = $1, updated_at = NOW() WHERE id = $2", string(newPasswordHash), userID)
	if err != nil {
		return fmt.Errorf("failed to update password: %w", err)
	}

	return nil
}

// ForgotPassword 忘记密码
func (s *AuthService) ForgotPassword(email string) (string, error) {
	// 检查用户是否存在
	var userID string
	err := s.db.QueryRow("SELECT id FROM users WHERE email = $1", email).Scan(&userID)
	if err != nil {
		if err == sql.ErrNoRows {
			return "", fmt.Errorf("user not found")
		}
		return "", fmt.Errorf("failed to query user: %w", err)
	}

	// 生成重置token
	resetToken := generateResetToken()

	// 存储重置token到Redis（24小时过期）
	err = s.redis.Set(context.Background(), "password_reset:"+resetToken, userID, 24*time.Hour).Err()
	if err != nil {
		return "", fmt.Errorf("failed to store reset token: %w", err)
	}

	return resetToken, nil
}

// ResetPassword 重置密码
func (s *AuthService) ResetPassword(resetToken, newPassword string) error {
	// 从Redis获取用户ID
	userID, err := s.redis.Get(context.Background(), "password_reset:"+resetToken).Result()
	if err != nil {
		return fmt.Errorf("invalid or expired reset token")
	}

	// 加密新密码
	newPasswordHash, err := bcrypt.GenerateFromPassword([]byte(newPassword), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("failed to hash new password: %w", err)
	}

	// 更新密码
	_, err = s.db.Exec("UPDATE users SET password_hash = $1, updated_at = NOW() WHERE id = $2", string(newPasswordHash), userID)
	if err != nil {
		return fmt.Errorf("failed to update password: %w", err)
	}

	// 删除重置token
	s.redis.Del(context.Background(), "password_reset:"+resetToken)

	return nil
}

// generateJWTToken 生成JWT token
func (s *AuthService) generateJWTToken(user *models.User) (string, error) {
	claims := jwt.MapClaims{
		"user_id":  user.ID,
		"username": user.Username,
		"email":    user.Email,
		"exp":      time.Now().Add(time.Hour * 24).Unix(),
		"iat":      time.Now().Unix(),
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	return token.SignedString([]byte(s.jwtSecret))
}

// storeTokenInRedis 将token存储到Redis
func (s *AuthService) storeTokenInRedis(userID, token string) error {
	return s.redis.Set(context.Background(), "user_token:"+userID, token, 24*time.Hour).Err()
}

// RemoveTokenFromRedis 从Redis中删除token
func (s *AuthService) RemoveTokenFromRedis(userID, token string) error {
	return s.redis.Del(context.Background(), "user_token:"+userID).Err()
}

// generateUUID 生成UUID
func generateUUID() string {
	b := make([]byte, 16)
	rand.Read(b)
	return fmt.Sprintf("%x-%x-%x-%x-%x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:])
}

// generateResetToken 生成重置token
func generateResetToken() string {
	b := make([]byte, 32)
	rand.Read(b)
	return hex.EncodeToString(b)
}