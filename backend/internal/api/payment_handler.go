package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type PaymentHandler struct {
	paymentService *services.PaymentService
}

func NewPaymentHandler(paymentService *services.PaymentService) *PaymentHandler {
	return &PaymentHandler{
		paymentService: paymentService,
	}
}

// CreatePaymentIntent 创建支付意图
func (h *PaymentHandler) CreatePaymentIntent(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req models.PaymentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID

	payment, err := h.paymentService.CreatePaymentIntent(&req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建支付意图失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建支付意图成功",
		Data:    payment,
	})
}

// HandleWebhook 处理支付webhook
func (h *PaymentHandler) HandleWebhook(c *gin.Context) {
	// 这里应该处理Stripe webhook
	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Webhook处理成功",
	})
}

// GetPaymentHistory 获取支付历史
func (h *PaymentHandler) GetPaymentHistory(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	// 实现获取支付历史的逻辑
	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取支付历史成功",
		Data:    []interface{}{},
	})
}
