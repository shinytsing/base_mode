package services

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/google/uuid"
	"github.com/stripe/stripe-go/v75"
	"github.com/stripe/stripe-go/v75/checkout/session"
	"github.com/stripe/stripe-go/v75/customer"
	"github.com/stripe/stripe-go/v75/refund"
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
	// 设置Stripe密钥
	stripe.Key = "sk_test_your_stripe_secret_key" // 应该从环境变量获取

	// 获取会员计划信息
	plan, err := s.getMembershipPlan(req.PlanID)
	if err != nil {
		return nil, fmt.Errorf("获取会员计划失败: %w", err)
	}

	// 创建或获取Stripe客户
	customerID, err := s.getOrCreateStripeCustomer(req.UserID)
	if err != nil {
		return nil, fmt.Errorf("创建Stripe客户失败: %w", err)
	}

	// 创建支付会话
	params := &stripe.CheckoutSessionParams{
		Customer: stripe.String(customerID),
		PaymentMethodTypes: stripe.StringSlice([]string{
			"card",
		}),
		LineItems: []*stripe.CheckoutSessionLineItemParams{
			{
				PriceData: &stripe.CheckoutSessionLineItemPriceDataParams{
					Currency: stripe.String(req.Currency),
					ProductData: &stripe.CheckoutSessionLineItemPriceDataProductDataParams{
						Name: stripe.String(plan.Name),
						Description: stripe.String(plan.Description),
					},
					UnitAmount: stripe.Int64(int64(req.Amount * 100)), // 转换为分
					Recurring: &stripe.CheckoutSessionLineItemPriceDataRecurringParams{
						Interval: stripe.String("month"),
					},
				},
				Quantity: stripe.Int64(1),
			},
		},
		Mode: stripe.String(string(stripe.CheckoutSessionModeSubscription)),
		SuccessURL: stripe.String(req.ReturnURL + "?session_id={CHECKOUT_SESSION_ID}"),
		CancelURL: stripe.String(req.CancelURL),
		Metadata: map[string]string{
			"user_id": req.UserID,
			"plan_id": req.PlanID,
		},
	}

	session, err := session.New(params)
	if err != nil {
		return nil, fmt.Errorf("创建支付会话失败: %w", err)
	}

	// 保存支付记录到数据库
	paymentID := uuid.New().String()
	_, err = s.db.Exec(`
		INSERT INTO payments (id, user_id, amount, currency, status, payment_method, payment_id, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`, paymentID, req.UserID, req.Amount, req.Currency, "pending", req.PaymentMethod, session.ID, time.Now())

	if err != nil {
		return nil, fmt.Errorf("保存支付记录失败: %w", err)
	}

	return &models.PaymentResponse{
		ID:           paymentID,
		Status:       "pending",
		PaymentURL:   session.URL,
		ClientSecret: session.ID,
		Amount:       req.Amount,
		Currency:     req.Currency,
		CreatedAt:    time.Now(),
	}, nil
}

// HandleWebhook 处理Stripe webhook
func (s *PaymentService) HandleWebhook(event stripe.Event) error {
	// 记录webhook事件
	log.Printf("收到Stripe webhook事件: %s, ID: %s", event.Type, event.ID)
	
	switch event.Type {
	case "checkout.session.completed":
		return s.handleCheckoutSessionCompleted(event)
	case "invoice.payment_succeeded":
		return s.handleInvoicePaymentSucceeded(event)
	case "invoice.payment_failed":
		return s.handleInvoicePaymentFailed(event)
	case "customer.subscription.deleted":
		return s.handleSubscriptionDeleted(event)
	case "customer.subscription.updated":
		return s.handleSubscriptionUpdated(event)
	case "invoice.created":
		return s.handleInvoiceCreated(event)
	case "payment_intent.succeeded":
		return s.handlePaymentIntentSucceeded(event)
	case "payment_intent.payment_failed":
		return s.handlePaymentIntentFailed(event)
	default:
		log.Printf("未处理的webhook事件类型: %s", event.Type)
		return nil
	}
}

// handleCheckoutSessionCompleted 处理支付会话完成
func (s *PaymentService) handleCheckoutSessionCompleted(event stripe.Event) error {
	var session stripe.CheckoutSession
	err := json.Unmarshal(event.Data.Raw, &session)
	if err != nil {
		return fmt.Errorf("解析webhook数据失败: %w", err)
	}

	userID := session.Metadata["user_id"]
	planID := session.Metadata["plan_id"]

	// 更新支付状态
	_, err = s.db.Exec(`
		UPDATE payments 
		SET status = 'completed', completed_at = $1, transaction_id = $2
		WHERE payment_id = $3
	`, time.Now(), session.ID, session.ID)

	if err != nil {
		return fmt.Errorf("更新支付状态失败: %w", err)
	}

	// 创建订阅记录
	subscriptionID := uuid.New().String()
	_, err = s.db.Exec(`
		INSERT INTO subscriptions (id, user_id, plan_id, status, start_date, end_date, auto_renew, payment_method, payment_id, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	`, subscriptionID, userID, planID, "active", time.Now(), time.Now().AddDate(0, 1, 0), true, "stripe", session.ID, time.Now())

	if err != nil {
		return fmt.Errorf("创建订阅记录失败: %w", err)
	}

	// 更新用户会员等级
	_, err = s.db.Exec(`
		UPDATE users 
		SET membership_level = $1, subscription_type = $2, subscription_expires_at = $3
		WHERE id = $4
	`, planID, planID, time.Now().AddDate(0, 1, 0), userID)

	if err != nil {
		return fmt.Errorf("更新用户会员等级失败: %w", err)
	}

	return nil
}

// handleInvoicePaymentSucceeded 处理发票支付成功
func (s *PaymentService) handleInvoicePaymentSucceeded(event stripe.Event) error {
	var invoice stripe.Invoice
	err := json.Unmarshal(event.Data.Raw, &invoice)
	if err != nil {
		return fmt.Errorf("解析发票数据失败: %w", err)
	}

	// 更新订阅到期时间
	_, err = s.db.Exec(`
		UPDATE subscriptions 
		SET end_date = $1, status = 'active'
		WHERE payment_id = $2
	`, time.Unix(invoice.PeriodEnd, 0), invoice.Subscription.ID)

	if err != nil {
		return fmt.Errorf("更新订阅到期时间失败: %w", err)
	}

	return nil
}

// handleInvoicePaymentFailed 处理发票支付失败
func (s *PaymentService) handleInvoicePaymentFailed(event stripe.Event) error {
	var invoice stripe.Invoice
	err := json.Unmarshal(event.Data.Raw, &invoice)
	if err != nil {
		return fmt.Errorf("解析发票数据失败: %w", err)
	}

	// 更新订阅状态为失败
	_, err = s.db.Exec(`
		UPDATE subscriptions 
		SET status = 'failed'
		WHERE payment_id = $1
	`, invoice.Subscription.ID)

	if err != nil {
		return fmt.Errorf("更新订阅状态失败: %w", err)
	}

	return nil
}

// handleSubscriptionDeleted 处理订阅删除
func (s *PaymentService) handleSubscriptionDeleted(event stripe.Event) error {
	var subscription stripe.Subscription
	err := json.Unmarshal(event.Data.Raw, &subscription)
	if err != nil {
		return fmt.Errorf("解析订阅数据失败: %w", err)
	}

	// 更新订阅状态为已取消
	_, err = s.db.Exec(`
		UPDATE subscriptions 
		SET status = 'cancelled', updated_at = $1
		WHERE payment_id = $2
	`, time.Now(), subscription.ID)

	if err != nil {
		return fmt.Errorf("更新订阅状态失败: %w", err)
	}

	// 更新用户会员等级为免费版
	_, err = s.db.Exec(`
		UPDATE users 
		SET membership_level = 'free', subscription_type = 'free', subscription_expires_at = NULL
		WHERE id IN (
			SELECT user_id FROM subscriptions WHERE payment_id = $1
		)
	`, subscription.ID)

	if err != nil {
		return fmt.Errorf("更新用户会员等级失败: %w", err)
	}

	return nil
}

// handleSubscriptionUpdated 处理订阅更新
func (s *PaymentService) handleSubscriptionUpdated(event stripe.Event) error {
	var subscription stripe.Subscription
	err := json.Unmarshal(event.Data.Raw, &subscription)
	if err != nil {
		return fmt.Errorf("解析订阅数据失败: %w", err)
	}

	// 更新订阅信息
	_, err = s.db.Exec(`
		UPDATE subscriptions 
		SET status = $1, updated_at = $2
		WHERE payment_id = $3
	`, subscription.Status, time.Now(), subscription.ID)

	if err != nil {
		return fmt.Errorf("更新订阅状态失败: %w", err)
	}

	return nil
}

// handleInvoiceCreated 处理发票创建
func (s *PaymentService) handleInvoiceCreated(event stripe.Event) error {
	var invoice stripe.Invoice
	err := json.Unmarshal(event.Data.Raw, &invoice)
	if err != nil {
		return fmt.Errorf("解析发票数据失败: %w", err)
	}

	// 记录发票创建事件
	log.Printf("发票创建: %s, 金额: %d, 客户: %s", invoice.ID, invoice.AmountDue, invoice.Customer.ID)
	
	return nil
}

// handlePaymentIntentSucceeded 处理支付意图成功
func (s *PaymentService) handlePaymentIntentSucceeded(event stripe.Event) error {
	var paymentIntent stripe.PaymentIntent
	err := json.Unmarshal(event.Data.Raw, &paymentIntent)
	if err != nil {
		return fmt.Errorf("解析支付意图数据失败: %w", err)
	}

	// 更新支付状态
	_, err = s.db.Exec(`
		UPDATE payments 
		SET status = 'completed', completed_at = $1, transaction_id = $2
		WHERE payment_id = $3
	`, time.Now(), paymentIntent.ID, paymentIntent.ID)

	if err != nil {
		return fmt.Errorf("更新支付状态失败: %w", err)
	}

	return nil
}

// handlePaymentIntentFailed 处理支付意图失败
func (s *PaymentService) handlePaymentIntentFailed(event stripe.Event) error {
	var paymentIntent stripe.PaymentIntent
	err := json.Unmarshal(event.Data.Raw, &paymentIntent)
	if err != nil {
		return fmt.Errorf("解析支付意图数据失败: %w", err)
	}

	// 更新支付状态
	_, err = s.db.Exec(`
		UPDATE payments 
		SET status = 'failed', completed_at = $1, transaction_id = $2
		WHERE payment_id = $3
	`, time.Now(), paymentIntent.ID, paymentIntent.ID)

	if err != nil {
		return fmt.Errorf("更新支付状态失败: %w", err)
	}

	// 触发支付失败重试逻辑
	go s.retryFailedPayment(paymentIntent.ID)

	return nil
}

// retryFailedPayment 重试失败的支付
func (s *PaymentService) retryFailedPayment(paymentID string) {
	// 等待5分钟后重试
	time.Sleep(5 * time.Minute)
	
	// 查询失败的支付记录
	var userID string
	var amount float64
	err := s.db.QueryRow(`
		SELECT user_id, amount FROM payments 
		WHERE payment_id = $1 AND status = 'failed'
	`, paymentID).Scan(&userID, &amount)
	
	if err != nil {
		log.Printf("查询失败支付记录错误: %v", err)
		return
	}
	
	// 尝试重新创建支付
	log.Printf("重试支付: %s, 用户: %s, 金额: %.2f", paymentID, userID, amount)
	
	// 这里可以实现重试逻辑，比如发送邮件通知用户更新支付方式
	// 或者自动尝试其他支付方式
}

// GenerateInvoice 生成发票
func (s *PaymentService) GenerateInvoice(paymentID string) (*models.Invoice, error) {
	// 查询支付记录
	var payment models.PaymentResponse
	err := s.db.QueryRow(`
		SELECT id, user_id, amount, currency, status, created_at, completed_at
		FROM payments WHERE id = $1
	`, paymentID).Scan(&payment.ID, &payment.UserID, &payment.Amount, 
		&payment.Currency, &payment.Status, &payment.CreatedAt, &payment.CompletedAt)
	
	if err != nil {
		return nil, fmt.Errorf("查询支付记录失败: %w", err)
	}
	
	// 查询用户信息
	var userName, userEmail string
	err = s.db.QueryRow(`
		SELECT username, email FROM users WHERE id = $1
	`, payment.UserID).Scan(&userName, &userEmail)
	
	if err != nil {
		return nil, fmt.Errorf("查询用户信息失败: %w", err)
	}
	
	// 生成发票
	invoiceID := uuid.New().String()
	invoice := &models.Invoice{
		ID:           invoiceID,
		PaymentID:    paymentID,
		UserID:       payment.UserID,
		UserName:     userName,
		UserEmail:    userEmail,
		Amount:       payment.Amount,
		Currency:     payment.Currency,
		Status:       "generated",
		InvoiceNumber: fmt.Sprintf("INV-%s", invoiceID[:8]),
		CreatedAt:    time.Now(),
	}
	
	// 保存发票到数据库
	_, err = s.db.Exec(`
		INSERT INTO invoices (id, payment_id, user_id, user_name, user_email, amount, currency, status, invoice_number, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	`, invoice.ID, invoice.PaymentID, invoice.UserID, invoice.UserName, 
		invoice.UserEmail, invoice.Amount, invoice.Currency, invoice.Status, 
		invoice.InvoiceNumber, invoice.CreatedAt)
	
	if err != nil {
		return nil, fmt.Errorf("保存发票失败: %w", err)
	}
	
	return invoice, nil
}

// ProcessRefund 处理退款
func (s *PaymentService) ProcessRefund(paymentID string, reason string) (*models.Refund, error) {
	// 查询支付记录
	var stripePaymentID string
	var amount float64
	err := s.db.QueryRow(`
		SELECT payment_id, amount FROM payments WHERE id = $1 AND status = 'completed'
	`, paymentID).Scan(&stripePaymentID, &amount)
	
	if err != nil {
		return nil, fmt.Errorf("查询支付记录失败: %w", err)
	}
	
	// 创建Stripe退款
	params := &stripe.RefundParams{
		PaymentIntent: stripe.String(stripePaymentID),
		Reason:        stripe.String(reason),
	}
	
	refund, err := refund.New(params)
	if err != nil {
		return nil, fmt.Errorf("创建Stripe退款失败: %w", err)
	}
	
	// 保存退款记录
	refundID := uuid.New().String()
	refundRecord := &models.Refund{
		ID:           refundID,
		PaymentID:    paymentID,
		Amount:       float64(refund.Amount) / 100, // 转换为元
		Currency:     string(refund.Currency),
		Status:       string(refund.Status),
		Reason:       reason,
		StripeRefundID: refund.ID,
		CreatedAt:    time.Now(),
	}
	
	_, err = s.db.Exec(`
		INSERT INTO refunds (id, payment_id, amount, currency, status, reason, stripe_refund_id, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`, refundRecord.ID, refundRecord.PaymentID, refundRecord.Amount, 
		refundRecord.Currency, refundRecord.Status, refundRecord.Reason, 
		refundRecord.StripeRefundID, refundRecord.CreatedAt)
	
	if err != nil {
		return nil, fmt.Errorf("保存退款记录失败: %w", err)
	}
	
	// 更新支付状态
	_, err = s.db.Exec(`
		UPDATE payments SET status = 'refunded' WHERE id = $1
	`, paymentID)
	
	if err != nil {
		return nil, fmt.Errorf("更新支付状态失败: %w", err)
	}
	
	return refundRecord, nil
}

// getMembershipPlan 获取会员计划信息
func (s *PaymentService) getMembershipPlan(planID string) (*models.MembershipPlan, error) {
	// 这里应该从数据库或配置中获取会员计划信息
	plans := map[string]*models.MembershipPlan{
		"basic": {
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
		"premium": {
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
		"vip": {
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

	plan, exists := plans[planID]
	if !exists {
		return nil, fmt.Errorf("会员计划不存在: %s", planID)
	}

	return plan, nil
}

// getOrCreateStripeCustomer 获取或创建Stripe客户
func (s *PaymentService) getOrCreateStripeCustomer(userID string) (string, error) {
	// 先从Redis缓存中查找
	cachedCustomerID, err := s.redis.Get(context.Background(), "stripe_customer_"+userID).Result()
	if err == nil && cachedCustomerID != "" {
		return cachedCustomerID, nil
	}

	// 从数据库获取用户信息
	var email string
	err = s.db.QueryRow("SELECT email FROM users WHERE id = $1", userID).Scan(&email)
	if err != nil {
		return "", fmt.Errorf("获取用户信息失败: %w", err)
	}

	// 创建Stripe客户
	params := &stripe.CustomerParams{
		Email: stripe.String(email),
		Metadata: map[string]string{
			"user_id": userID,
		},
	}

	customer, err := customer.New(params)
	if err != nil {
		return "", fmt.Errorf("创建Stripe客户失败: %w", err)
	}

	// 缓存客户ID
	s.redis.Set(context.Background(), "stripe_customer_"+userID, customer.ID, 24*time.Hour)

	return customer.ID, nil
}
