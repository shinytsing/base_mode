package api

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type SocialHubHandler struct {
	socialHubService *services.SocialHubService
}

func NewSocialHubHandler(socialHubService *services.SocialHubService) *SocialHubHandler {
	return &SocialHubHandler{
		socialHubService: socialHubService,
	}
}

// FindMatches 查找匹配
func (h *SocialHubHandler) FindMatches(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.MatchRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.socialHubService.FindMatches(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to find matches",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Matches found successfully",
		Data:    response,
	})
}

// GetMatches 获取匹配历史
func (h *SocialHubHandler) GetMatches(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	matches, total, err := h.socialHubService.GetMatches(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get matches",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: matches,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// CreateActivity 创建活动
func (h *SocialHubHandler) CreateActivity(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.ActivityRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.socialHubService.CreateActivity(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to create activity",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Activity created successfully",
		Data:    response,
	})
}

// GetActivities 获取活动列表
func (h *SocialHubHandler) GetActivities(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	activities, total, err := h.socialHubService.GetActivities(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get activities",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: activities,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// JoinActivity 参与活动
func (h *SocialHubHandler) JoinActivity(c *gin.Context) {
	userID, _ := c.Get("user_id")
	activityID := c.Param("id")

	if activityID == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Activity ID is required",
		})
		return
	}

	err := h.socialHubService.JoinActivity(userID.(string), activityID)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Failed to join activity",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Joined activity successfully",
	})
}

// SendMessage 发送消息
func (h *SocialHubHandler) SendMessage(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req services.MessageRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.socialHubService.SendMessage(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to send message",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Message sent successfully",
		Data:    response,
	})
}

// GetMessages 获取消息列表
func (h *SocialHubHandler) GetMessages(c *gin.Context) {
	chatID := c.Param("id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	if chatID == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Chat ID is required",
		})
		return
	}

	messages, total, err := h.socialHubService.GetMessages(chatID, page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get messages",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: messages,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}