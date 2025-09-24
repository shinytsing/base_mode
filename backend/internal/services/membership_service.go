package services

import (
	"fmt"
	"time"

	"github.com/google/uuid"
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type MembershipService struct {
	db *database.DB
}

func NewMembershipService(db *database.DB) *MembershipService {
	return &MembershipService{db: db}
}

// GetPlans 获取会员计划
func (s *MembershipService) GetPlans() ([]models.MembershipPlan, error) {
	plans := []models.MembershipPlan{
		{
			ID:          "basic",
			Name:        "基础会员",
			Description: "基础会员，可使用2个应用",
			Price:       29.9,
			Currency:    "CNY",
			Duration:    30,
			MaxApps:     2,
			Features:    []string{"基础功能", "2个应用", "邮件支持"},
			IsActive:    true,
		},
		{
			ID:          "premium",
			Name:        "高级会员",
			Description: "高级会员，可使用4个应用",
			Price:       59.9,
			Currency:    "CNY",
			Duration:    30,
			MaxApps:     4,
			Features:    []string{"高级功能", "4个应用", "优先支持", "数据分析"},
			IsActive:    true,
		},
		{
			ID:          "vip",
			Name:        "VIP会员",
			Description: "VIP会员，可使用全部应用",
			Price:       99.9,
			Currency:    "CNY",
			Duration:    30,
			MaxApps:     5,
			Features:    []string{"全部功能", "全部应用", "专属支持", "高级数据分析", "API访问"},
			IsActive:    true,
		},
	}

	return plans, nil
}

// Subscribe 订阅会员
func (s *MembershipService) Subscribe(userID, planID string) (*models.Subscription, error) {
	// 获取会员计划信息
	plans, err := s.GetPlans()
	if err != nil {
		return nil, fmt.Errorf("获取会员计划失败: %w", err)
	}

	var plan *models.MembershipPlan
	for _, p := range plans {
		if p.ID == planID {
			plan = &p
			break
		}
	}

	if plan == nil {
		return nil, fmt.Errorf("会员计划不存在")
	}

	// 创建订阅记录
	subscriptionID := uuid.New().String()
	subscription := &models.Subscription{
		ID:           subscriptionID,
		UserID:       userID,
		PlanID:       planID,
		Status:       "pending",
		StartDate:    time.Now(),
		EndDate:      time.Now().AddDate(0, 0, plan.Duration),
		AutoRenew:    true,
		PaymentMethod: "stripe",
		CreatedAt:    time.Now(),
		UpdatedAt:    time.Now(),
	}

	_, err = s.db.Exec(`
		INSERT INTO subscriptions (id, user_id, plan_id, status, start_date, end_date, auto_renew, payment_method, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	`, subscription.ID, subscription.UserID, subscription.PlanID, subscription.Status,
		subscription.StartDate, subscription.EndDate, subscription.AutoRenew,
		subscription.PaymentMethod, subscription.CreatedAt, subscription.UpdatedAt)

	if err != nil {
		return nil, fmt.Errorf("创建订阅记录失败: %w", err)
	}

	return subscription, nil
}

// GetStatus 获取会员状态
func (s *MembershipService) GetStatus(userID string) (*models.Subscription, error) {
	var subscription models.Subscription
	err := s.db.QueryRow(`
		SELECT id, user_id, plan_id, status, start_date, end_date, auto_renew, payment_method, created_at, updated_at
		FROM subscriptions 
		WHERE user_id = $1 AND status = 'active'
		ORDER BY created_at DESC
		LIMIT 1
	`, userID).Scan(
		&subscription.ID, &subscription.UserID, &subscription.PlanID, &subscription.Status,
		&subscription.StartDate, &subscription.EndDate, &subscription.AutoRenew,
		&subscription.PaymentMethod, &subscription.CreatedAt, &subscription.UpdatedAt,
	)

	if err != nil {
		return nil, fmt.Errorf("查询会员状态失败: %w", err)
	}

	return &subscription, nil
}

// CancelSubscription 取消订阅
func (s *MembershipService) CancelSubscription(userID string) error {
	_, err := s.db.Exec(`
		UPDATE subscriptions 
		SET status = 'cancelled', updated_at = $1
		WHERE user_id = $2 AND status = 'active'
	`, time.Now(), userID)

	if err != nil {
		return fmt.Errorf("取消订阅失败: %w", err)
	}

	return nil
}
