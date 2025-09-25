package services

import (
	"database/sql"
	"encoding/json"
	"fmt"

	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type MembershipService struct {
	db *database.DB
}

func NewMembershipService(db *database.DB) *MembershipService {
	return &MembershipService{
		db: db,
	}
}

// GetPlans 获取会员计划列表
func (s *MembershipService) GetPlans() ([]models.MembershipPlan, error) {
	query := `
		SELECT id, name, description, price, currency, duration, max_apps, features, is_active
		FROM membership_plans
		WHERE is_active = TRUE
		ORDER BY price ASC
	`

	rows, err := s.db.Query(query)
	if err != nil {
		return nil, fmt.Errorf("failed to query membership plans: %w", err)
	}
	defer rows.Close()

	var plans []models.MembershipPlan
	for rows.Next() {
		var plan models.MembershipPlan
		var featuresJSON []byte
		err := rows.Scan(
			&plan.ID, &plan.Name, &plan.Description, &plan.Price, &plan.Currency,
			&plan.Duration, &plan.MaxApps, &featuresJSON, &plan.IsActive,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan membership plan: %w", err)
		}
		
		// 解析JSON数组到字符串切片
		if len(featuresJSON) > 0 {
			err = json.Unmarshal(featuresJSON, &plan.Features)
			if err != nil {
				return nil, fmt.Errorf("failed to unmarshal features: %w", err)
			}
		}
		
		plans = append(plans, plan)
	}

	return plans, nil
}

// Subscribe 订阅会员计划
func (s *MembershipService) Subscribe(userID, planID string) (*models.Subscription, error) {
	// 检查计划是否存在
	var plan models.MembershipPlan
	err := s.db.QueryRow(`
		SELECT id, name, description, price, currency, duration, max_apps, features, is_active
		FROM membership_plans WHERE id = $1 AND is_active = TRUE
	`, planID).Scan(
		&plan.ID, &plan.Name, &plan.Description, &plan.Price, &plan.Currency,
		&plan.Duration, &plan.MaxApps, &plan.Features, &plan.IsActive,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("membership plan not found")
		}
		return nil, fmt.Errorf("failed to query membership plan: %w", err)
	}

	// 检查用户是否已有活跃订阅
	var existingSubscriptionID string
	err = s.db.QueryRow(`
		SELECT id FROM subscriptions 
		WHERE user_id = $1 AND status = 'active' AND end_date > NOW()
	`, userID).Scan(&existingSubscriptionID)
	if err != nil && err != sql.ErrNoRows {
		return nil, fmt.Errorf("failed to check existing subscription: %w", err)
	}
	if err == nil {
		return nil, fmt.Errorf("user already has an active subscription")
	}

	// 创建订阅
	subscriptionID := generateUUID()
	_, err = s.db.Exec(`
		INSERT INTO subscriptions (id, user_id, plan_id, status, start_date, end_date, auto_renew, created_at, updated_at)
		VALUES ($1, $2, $3, 'pending', NOW(), NOW() + INTERVAL '%d days', TRUE, NOW(), NOW())
	`, subscriptionID, userID, planID, plan.Duration)
	if err != nil {
		return nil, fmt.Errorf("failed to create subscription: %w", err)
	}

	// 返回订阅信息
	subscription := &models.Subscription{
		ID:           subscriptionID,
		UserID:       userID,
		PlanID:       planID,
		Status:       "pending",
		AutoRenew:    true,
		PaymentMethod: "",
	}

	return subscription, nil
}

// GetStatus 获取用户订阅状态
func (s *MembershipService) GetStatus(userID string) (*models.Subscription, error) {
	query := `
		SELECT s.id, s.user_id, s.plan_id, s.status, s.start_date, s.end_date, 
		       s.auto_renew, s.payment_method, s.created_at, s.updated_at
		FROM subscriptions s
		WHERE s.user_id = $1 AND s.status = 'active' AND s.end_date > NOW()
		ORDER BY s.created_at DESC
		LIMIT 1
	`

	subscription := &models.Subscription{}
	err := s.db.QueryRow(query, userID).Scan(
		&subscription.ID, &subscription.UserID, &subscription.PlanID, &subscription.Status,
		&subscription.StartDate, &subscription.EndDate, &subscription.AutoRenew,
		&subscription.PaymentMethod, &subscription.CreatedAt, &subscription.UpdatedAt,
	)
	if err != nil {
		if err == sql.ErrNoRows {
			return nil, fmt.Errorf("no active subscription found")
		}
		return nil, fmt.Errorf("failed to query subscription: %w", err)
	}

	return subscription, nil
}

// CancelSubscription 取消订阅
func (s *MembershipService) CancelSubscription(userID string) error {
	_, err := s.db.Exec(`
		UPDATE subscriptions 
		SET status = 'cancelled', auto_renew = FALSE, updated_at = NOW()
		WHERE user_id = $1 AND status = 'active' AND end_date > NOW()
	`, userID)
	if err != nil {
		return fmt.Errorf("failed to cancel subscription: %w", err)
	}

	return nil
}