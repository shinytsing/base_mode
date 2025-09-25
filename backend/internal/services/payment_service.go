package services

import (
	"database/sql"
	"fmt"
	"time"

	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type PaymentService struct {
	db    *database.DB
	redis *database.RedisClient
}

func NewPaymentService(db *database.DB, redis *database.RedisClient) *PaymentService {
	return &PaymentService{
		db:    db,
		redis: redis,
	}
}

// CreatePaymentIntent 创建支付意图
func (s *PaymentService) CreatePaymentIntent(req *models.PaymentRequest) (*models.PaymentResponse, error) {
	// 验证用户和计划
	var plan models.MembershipPlan
	err := s.db.QueryRow(`
		SELECT id, name, description, price, currency, duration, max_apps, features, is_active
		FROM membership_plans WHERE id = $1 AND is_active = TRUE
	`, req.PlanID).Scan(
		&plan.ID, &plan.Name, &plan.Description, &plan.Price, &plan.Currency,
		&plan.Duration, &plan.MaxApps, &plan.Features, &plan.IsActive,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("membership plan not found")
		}
		return nil, fmt.Errorf("failed to query membership plan: %w", err)
	}

	// 验证金额
	if req.Amount != plan.Price {
		return nil, fmt.Errorf("payment amount does not match plan price")
	}

	// 创建支付记录
	paymentID := generateUUID()
	_, err = s.db.Exec(`
		INSERT INTO payments (id, user_id, amount, currency, status, payment_method, payment_id, created_at)
		VALUES ($1, $2, $3, $4, 'pending', $5, $6, NOW())
	`, paymentID, req.UserID, req.Amount, req.Currency, req.PaymentMethod, paymentID)
	if err != nil {
		return nil, fmt.Errorf("failed to create payment record: %w", err)
	}

	// 生成支付URL（这里简化处理，实际应该调用支付网关）
	paymentURL := fmt.Sprintf("https://payment.example.com/pay/%s", paymentID)
	clientSecret := generateClientSecret()

	response := &models.PaymentResponse{
		ID:           paymentID,
		UserID:       req.UserID,
		Status:       "pending",
		PaymentURL:   paymentURL,
		ClientSecret: clientSecret,
		Amount:       req.Amount,
		Currency:     req.Currency,
		CreatedAt:    time.Now(),
	}

	return response, nil
}

// HandleWebhook 处理支付回调
func (s *PaymentService) HandleWebhook(webhookData map[string]interface{}) error {
	// 这里应该验证webhook签名和解析支付状态
	paymentID, ok := webhookData["payment_id"].(string)
	if !ok {
		return fmt.Errorf("invalid webhook data: missing payment_id")
	}

	status, ok := webhookData["status"].(string)
	if !ok {
		return fmt.Errorf("invalid webhook data: missing status")
	}

	// 更新支付状态
	_, err := s.db.Exec(`
		UPDATE payments 
		SET status = $1, gateway_response = $2, completed_at = NOW()
		WHERE payment_id = $3
	`, status, webhookData, paymentID)
	if err != nil {
		return fmt.Errorf("failed to update payment status: %w", err)
	}

	// 如果支付成功，激活订阅
	if status == "completed" {
		err = s.activateSubscription(paymentID)
		if err != nil {
			return fmt.Errorf("failed to activate subscription: %w", err)
		}
	}

	return nil
}

// GetPaymentHistory 获取支付历史
func (s *PaymentService) GetPaymentHistory(userID string, page, perPage int) ([]models.PaymentResponse, int, error) {
	offset := (page - 1) * perPage

	// 查询总数
	var total int
	err := s.db.QueryRow("SELECT COUNT(*) FROM payments WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to count payments: %w", err)
	}

	// 查询支付记录
	query := `
		SELECT id, user_id, amount, currency, status, payment_method, payment_id, created_at, completed_at
		FROM payments 
		WHERE user_id = $1
		ORDER BY created_at DESC
		LIMIT $2 OFFSET $3
	`

	rows, err := s.db.Query(query, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("failed to query payments: %w", err)
	}
	defer rows.Close()

	var payments []models.PaymentResponse
	for rows.Next() {
		var payment models.PaymentResponse
		var completedAt sql.NullTime

		err := rows.Scan(
			&payment.ID, &payment.UserID, &payment.Amount, &payment.Currency,
			&payment.Status, &payment.CreatedAt, &completedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("failed to scan payment: %w", err)
		}

		if completedAt.Valid {
			payment.CompletedAt = &completedAt.Time
		}

		payments = append(payments, payment)
	}

	return payments, total, nil
}

// activateSubscription 激活订阅
func (s *PaymentService) activateSubscription(paymentID string) error {
	// 获取支付信息
	var userID, planID string
	err := s.db.QueryRow(`
		SELECT user_id, 
		       (SELECT plan_id FROM subscriptions WHERE user_id = payments.user_id ORDER BY created_at DESC LIMIT 1)
		FROM payments WHERE payment_id = $1
	`, paymentID).Scan(&userID, &planID)
	if err != nil {
		return fmt.Errorf("failed to get payment info: %w", err)
	}

	// 更新订阅状态
	_, err = s.db.Exec(`
		UPDATE subscriptions 
		SET status = 'active', updated_at = NOW()
		WHERE user_id = $1 AND plan_id = $2 AND status = 'pending'
	`, userID, planID)
	if err != nil {
		return fmt.Errorf("failed to activate subscription: %w", err)
	}

	// 更新用户订阅类型
	_, err = s.db.Exec(`
		UPDATE users 
		SET subscription_type = (SELECT name FROM membership_plans WHERE id = $2),
		    subscription_expires_at = (SELECT end_date FROM subscriptions WHERE user_id = $1 AND plan_id = $2),
		    is_premium = TRUE,
		    updated_at = NOW()
		WHERE id = $1
	`, userID, planID)
	if err != nil {
		return fmt.Errorf("failed to update user subscription: %w", err)
	}

	return nil
}

// generateClientSecret 生成客户端密钥
func generateClientSecret() string {
	// 这里应该生成一个安全的客户端密钥
	return "client_secret_" + generateUUID()
}