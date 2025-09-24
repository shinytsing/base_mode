package api

import (
	"net/http"

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

// GetFoodRecommendation 获取美食推荐
func (h *LifeModeHandler) GetFoodRecommendation(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Preferences map[string]interface{} `json:"preferences"`
		Location    string                 `json:"location"`
		Budget      float64                `json:"budget"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	recommendations, err := h.lifeModeService.GetFoodRecommendation(userID, req.Preferences, req.Location, req.Budget)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "获取美食推荐失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取美食推荐成功",
		Data:    recommendations,
	})
}

// CreateTravelPlan 创建旅行计划
func (h *LifeModeHandler) CreateTravelPlan(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Destination string                 `json:"destination" validate:"required"`
		StartDate   string                 `json:"start_date" validate:"required"`
		EndDate     string                 `json:"end_date" validate:"required"`
		Budget      float64                `json:"budget"`
		Preferences map[string]interface{} `json:"preferences"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	plan, err := h.lifeModeService.CreateTravelPlan(userID, req.Destination, req.StartDate, req.EndDate, req.Budget, req.Preferences)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建旅行计划失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建旅行计划成功",
		Data:    plan,
	})
}

// CreateMoodEntry 创建情绪记录
func (h *LifeModeHandler) CreateMoodEntry(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Mood        string `json:"mood" validate:"required"`
		Intensity   int    `json:"intensity" validate:"min=1,max=10"`
		Description string `json:"description"`
		Tags        []string `json:"tags"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	entry, err := h.lifeModeService.CreateMoodEntry(userID, req.Mood, req.Intensity, req.Description, req.Tags)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建情绪记录失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建情绪记录成功",
		Data:    entry,
	})
}

// GetMoodHistory 获取情绪历史
func (h *LifeModeHandler) GetMoodHistory(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	history, err := h.lifeModeService.GetMoodHistory(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取情绪历史失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取情绪历史成功",
		Data:    history,
	})
}

// StartMeditationSession 开始冥想会话
func (h *LifeModeHandler) StartMeditationSession(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Type        string `json:"type" validate:"required"`
		Duration    int    `json:"duration" validate:"min=1"`
		Background  string `json:"background"`
		Guidance    bool   `json:"guidance"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	session, err := h.lifeModeService.StartMeditationSession(userID, req.Type, req.Duration, req.Background, req.Guidance)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "开始冥想会话失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "开始冥想会话成功",
		Data:    session,
	})
}

// GetMeditationHistory 获取冥想历史
func (h *LifeModeHandler) GetMeditationHistory(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	history, err := h.lifeModeService.GetMeditationHistory(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取冥想历史失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取冥想历史成功",
		Data:    history,
	})
}
