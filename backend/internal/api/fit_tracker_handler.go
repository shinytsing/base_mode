package api

import (
	"net/http"
	"strconv"

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

// CreateWorkout 创建运动记录
func (h *FitTrackerHandler) CreateWorkout(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.WorkoutRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.fitTrackerService.CreateWorkout(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to create workout",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Workout created successfully",
		Data:    response,
	})
}

// GetWorkouts 获取运动记录
func (h *FitTrackerHandler) GetWorkouts(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	workouts, total, err := h.fitTrackerService.GetWorkouts(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get workouts",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: workouts,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// LogNutrition 记录营养
func (h *FitTrackerHandler) LogNutrition(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.NutritionLogRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.fitTrackerService.LogNutrition(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to log nutrition",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Nutrition logged successfully",
		Data:    response,
	})
}

// GetNutritionHistory 获取营养历史
func (h *FitTrackerHandler) GetNutritionHistory(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	logs, total, err := h.fitTrackerService.GetNutritionHistory(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get nutrition history",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: logs,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// LogHealthMetric 记录健康指标
func (h *FitTrackerHandler) LogHealthMetric(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.HealthMetricRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.fitTrackerService.LogHealthMetric(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to log health metric",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Health metric logged successfully",
		Data:    response,
	})
}

// GetHealthMetrics 获取健康指标
func (h *FitTrackerHandler) GetHealthMetrics(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	metrics, total, err := h.fitTrackerService.GetHealthMetrics(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get health metrics",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: metrics,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// CheckInHabit 习惯打卡
func (h *FitTrackerHandler) CheckInHabit(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.HabitCheckInRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.fitTrackerService.CheckInHabit(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to check in habit",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Habit checked in successfully",
		Data:    response,
	})
}

// GetHabits 获取习惯列表
func (h *FitTrackerHandler) GetHabits(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	habits, total, err := h.fitTrackerService.GetHabits(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get habits",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: habits,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}