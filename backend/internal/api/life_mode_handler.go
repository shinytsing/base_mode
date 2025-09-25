package api

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type LifeModeHandler struct {
	lifeModeService *services.LifeModeService
}

func NewLifeModeHandler(lifeModeService *services.LifeModeService) *LifeModeHandler {
	return &LifeModeHandler{
		lifeModeService: lifeModeService,
	}
}

// GetFoodRecommendation 获取食物推荐
func (h *LifeModeHandler) GetFoodRecommendation(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.FoodRecommendationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.lifeModeService.GetFoodRecommendation(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get food recommendation",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Food recommendation generated successfully",
		Data:    response,
	})
}

// CreateTravelPlan 创建旅行计划
func (h *LifeModeHandler) CreateTravelPlan(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.TravelPlanRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.lifeModeService.CreateTravelPlan(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to create travel plan",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Travel plan created successfully",
		Data:    response,
	})
}

// CreateMoodEntry 创建情绪记录
func (h *LifeModeHandler) CreateMoodEntry(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.MoodEntryRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.lifeModeService.CreateMoodEntry(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to create mood entry",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Mood entry created successfully",
		Data:    response,
	})
}

// GetMoodHistory 获取情绪历史
func (h *LifeModeHandler) GetMoodHistory(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	entries, total, err := h.lifeModeService.GetMoodHistory(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get mood history",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: entries,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// StartMeditationSession 开始冥想会话
func (h *LifeModeHandler) StartMeditationSession(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.MeditationSessionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.lifeModeService.StartMeditationSession(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to start meditation session",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Meditation session started successfully",
		Data:    response,
	})
}

// GetMeditationHistory 获取冥想历史
func (h *LifeModeHandler) GetMeditationHistory(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	sessions, total, err := h.lifeModeService.GetMeditationHistory(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get meditation history",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: sessions,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}