package api

import (
	"net/http"
	"strconv"

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
	userID, _ := c.Get("user_id")

	var req models.PaymentRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.paymentService.CreatePaymentIntent(&req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Failed to create payment intent",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Payment intent created successfully",
		Data:    response,
	})
}

// HandleWebhook 处理支付回调
func (h *PaymentHandler) HandleWebhook(c *gin.Context) {
	var webhookData map[string]interface{}
	if err := c.ShouldBindJSON(&webhookData); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid webhook data",
			Error:   err.Error(),
		})
		return
	}

	err := h.paymentService.HandleWebhook(webhookData)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Failed to handle webhook",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Webhook handled successfully",
	})
}

// GetPaymentHistory 获取支付历史
func (h *PaymentHandler) GetPaymentHistory(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	payments, total, err := h.paymentService.GetPaymentHistory(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get payment history",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: payments,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}