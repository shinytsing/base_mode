package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type FitTrackerHandler struct {
	fitTrackerService *services.FitTrackerService
}

func NewFitTrackerHandler(fitTrackerService *services.FitTrackerService) *FitTrackerHandler {
	return &FitTrackerHandler{
		fitTrackerService: fitTrackerService,
	}
}

// CreateWorkout 创建锻炼记录
func (h *FitTrackerHandler) CreateWorkout(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Type        string                 `json:"type" validate:"required"`
		Duration    int                    `json:"duration" validate:"min=1"`
		Intensity   string                 `json:"intensity"`
		Calories    int                    `json:"calories"`
		Notes       string                 `json:"notes"`
		Exercises   []map[string]interface{} `json:"exercises"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	workout, err := h.fitTrackerService.CreateWorkout(userID, req.Type, req.Duration, req.Intensity, req.Calories, req.Notes, req.Exercises)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建锻炼记录失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建锻炼记录成功",
		Data:    workout,
	})
}

// GetWorkouts 获取锻炼记录
func (h *FitTrackerHandler) GetWorkouts(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	workouts, err := h.fitTrackerService.GetWorkouts(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取锻炼记录失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取锻炼记录成功",
		Data:    workouts,
	})
}

// LogNutrition 记录营养摄入
func (h *FitTrackerHandler) LogNutrition(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		MealType    string                 `json:"meal_type" validate:"required"`
		Foods       []map[string]interface{} `json:"foods" validate:"required"`
		TotalCalories int                  `json:"total_calories"`
		Notes       string                 `json:"notes"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	nutrition, err := h.fitTrackerService.LogNutrition(userID, req.MealType, req.Foods, req.TotalCalories, req.Notes)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "记录营养摄入失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "记录营养摄入成功",
		Data:    nutrition,
	})
}

// GetNutritionHistory 获取营养历史
func (h *FitTrackerHandler) GetNutritionHistory(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	history, err := h.fitTrackerService.GetNutritionHistory(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取营养历史失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取营养历史成功",
		Data:    history,
	})
}

// LogHealthMetric 记录健康指标
func (h *FitTrackerHandler) LogHealthMetric(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		MetricType  string  `json:"metric_type" validate:"required"`
		Value       float64 `json:"value" validate:"required"`
		Unit        string  `json:"unit"`
		Notes       string  `json:"notes"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	metric, err := h.fitTrackerService.LogHealthMetric(userID, req.MetricType, req.Value, req.Unit, req.Notes)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "记录健康指标失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "记录健康指标成功",
		Data:    metric,
	})
}

// GetHealthMetrics 获取健康指标
func (h *FitTrackerHandler) GetHealthMetrics(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	metrics, err := h.fitTrackerService.GetHealthMetrics(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取健康指标失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取健康指标成功",
		Data:    metrics,
	})
}

// CheckInHabit 习惯打卡
func (h *FitTrackerHandler) CheckInHabit(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		HabitID string `json:"habit_id" validate:"required"`
		Notes   string `json:"notes"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	checkin, err := h.fitTrackerService.CheckInHabit(userID, req.HabitID, req.Notes)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "习惯打卡失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "习惯打卡成功",
		Data:    checkin,
	})
}

// GetHabits 获取习惯列表
func (h *FitTrackerHandler) GetHabits(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	habits, err := h.fitTrackerService.GetHabits(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取习惯列表失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取习惯列表成功",
		Data:    habits,
	})
}
