package api

import (
	"net/http"

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

// FindMatches 寻找匹配
func (h *SocialHubHandler) FindMatches(c *gin.Context) {
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
		Radius      int                    `json:"radius"`
		MaxResults  int                    `json:"max_results"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	matches, err := h.socialHubService.FindMatches(userID, req.Preferences, req.Location, req.Radius, req.MaxResults)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "寻找匹配失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "寻找匹配成功",
		Data:    matches,
	})
}

// GetMatches 获取匹配列表
func (h *SocialHubHandler) GetMatches(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	matches, err := h.socialHubService.GetMatches(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取匹配列表失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取匹配列表成功",
		Data:    matches,
	})
}

// CreateActivity 创建活动
func (h *SocialHubHandler) CreateActivity(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Title       string                 `json:"title" validate:"required"`
		Description string                 `json:"description"`
		Type        string                 `json:"type" validate:"required"`
		Location    string                 `json:"location"`
		StartTime   string                 `json:"start_time" validate:"required"`
		EndTime     string                 `json:"end_time"`
		MaxParticipants int               `json:"max_participants"`
		Tags        []string               `json:"tags"`
		Settings    map[string]interface{} `json:"settings"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	activity, err := h.socialHubService.CreateActivity(userID, req.Title, req.Description, req.Type, req.Location, req.StartTime, req.EndTime, req.MaxParticipants, req.Tags, req.Settings)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建活动失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建活动成功",
		Data:    activity,
	})
}

// GetActivities 获取活动列表
func (h *SocialHubHandler) GetActivities(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	activities, err := h.socialHubService.GetActivities(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取活动列表失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取活动列表成功",
		Data:    activities,
	})
}

// JoinActivity 参加活动
func (h *SocialHubHandler) JoinActivity(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	activityID := c.Param("id")
	if activityID == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "活动ID不能为空",
		})
		return
	}

	err := h.socialHubService.JoinActivity(userID, activityID)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "参加活动失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "参加活动成功",
	})
}

// SendMessage 发送消息
func (h *SocialHubHandler) SendMessage(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		RecipientID string `json:"recipient_id" validate:"required"`
		Content     string `json:"content" validate:"required"`
		Type        string `json:"type"`
		Attachments []string `json:"attachments"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	message, err := h.socialHubService.SendMessage(userID, req.RecipientID, req.Content, req.Type, req.Attachments)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "发送消息失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "发送消息成功",
		Data:    message,
	})
}

// GetMessages 获取消息
func (h *SocialHubHandler) GetMessages(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	chatID := c.Param("id")
	if chatID == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "聊天ID不能为空",
		})
		return
	}

	messages, err := h.socialHubService.GetMessages(userID, chatID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取消息失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取消息成功",
		Data:    messages,
	})
}
