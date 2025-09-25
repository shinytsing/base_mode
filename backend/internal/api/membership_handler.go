package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type MembershipHandler struct {
	membershipService *services.MembershipService
}

func NewMembershipHandler(membershipService *services.MembershipService) *MembershipHandler {
	return &MembershipHandler{
		membershipService: membershipService,
	}
}

// GetPlans 获取会员计划列表
func (h *MembershipHandler) GetPlans(c *gin.Context) {
	plans, err := h.membershipService.GetPlans()
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get membership plans",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Membership plans retrieved successfully",
		Data:    plans,
	})
}

// Subscribe 订阅会员计划
func (h *MembershipHandler) Subscribe(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req struct {
		PlanID string `json:"plan_id" validate:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	subscription, err := h.membershipService.Subscribe(userID.(string), req.PlanID)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Failed to subscribe to plan",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Subscription created successfully",
		Data:    subscription,
	})
}

// GetStatus 获取订阅状态
func (h *MembershipHandler) GetStatus(c *gin.Context) {
	userID, _ := c.Get("user_id")

	subscription, err := h.membershipService.GetStatus(userID.(string))
	if err != nil {
		c.JSON(http.StatusNotFound, models.APIResponse{
			Success: false,
			Message: "No active subscription found",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Subscription status retrieved successfully",
		Data:    subscription,
	})
}

// CancelSubscription 取消订阅
func (h *MembershipHandler) CancelSubscription(c *gin.Context) {
	userID, _ := c.Get("user_id")

	err := h.membershipService.CancelSubscription(userID.(string))
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Failed to cancel subscription",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Subscription cancelled successfully",
	})
}