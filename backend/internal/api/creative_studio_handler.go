package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type CreativeStudioHandler struct {
	creativeStudioService *services.CreativeStudioService
}

func NewCreativeStudioHandler(creativeStudioService *services.CreativeStudioService) *CreativeStudioHandler {
	return &CreativeStudioHandler{
		creativeStudioService: creativeStudioService,
	}
}

// GenerateContent AI写作
func (h *CreativeStudioHandler) GenerateContent(c *gin.Context) {
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
		Topic       string                 `json:"topic" validate:"required"`
		Length      int                    `json:"length"`
		Style       string                 `json:"style"`
		Keywords    []string               `json:"keywords"`
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

	content, err := h.creativeStudioService.GenerateContent(userID, req.Type, req.Topic, req.Length, req.Style, req.Keywords, req.Settings)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "AI写作失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "AI写作成功",
		Data:    content,
	})
}

// GetWritingHistory 获取写作历史
func (h *CreativeStudioHandler) GetWritingHistory(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	history, err := h.creativeStudioService.GetWritingHistory(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取写作历史失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取写作历史成功",
		Data:    history,
	})
}

// GenerateAvatar 生成头像
func (h *CreativeStudioHandler) GenerateAvatar(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Style       string                 `json:"style" validate:"required"`
		Gender      string                 `json:"gender"`
		Age         string                 `json:"age"`
		HairColor   string                 `json:"hair_color"`
		EyeColor    string                 `json:"eye_color"`
		Clothing    string                 `json:"clothing"`
		Background  string                 `json:"background"`
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

	avatar, err := h.creativeStudioService.GenerateAvatar(userID, req.Style, req.Gender, req.Age, req.HairColor, req.EyeColor, req.Clothing, req.Background, req.Settings)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "生成头像失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "生成头像成功",
		Data:    avatar,
	})
}

// GetAvatars 获取头像列表
func (h *CreativeStudioHandler) GetAvatars(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	avatars, err := h.creativeStudioService.GetAvatars(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取头像列表失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取头像列表成功",
		Data:    avatars,
	})
}

// ComposeMusic 音乐创作
func (h *CreativeStudioHandler) ComposeMusic(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req struct {
		Genre       string                 `json:"genre" validate:"required"`
		Mood        string                 `json:"mood"`
		Duration    int                    `json:"duration"`
		Instruments []string               `json:"instruments"`
		Tempo       int                    `json:"tempo"`
		Key         string                 `json:"key"`
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

	music, err := h.creativeStudioService.ComposeMusic(userID, req.Genre, req.Mood, req.Duration, req.Instruments, req.Tempo, req.Key, req.Settings)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "音乐创作失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "音乐创作成功",
		Data:    music,
	})
}

// GetMusicCompositions 获取音乐作品
func (h *CreativeStudioHandler) GetMusicCompositions(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	compositions, err := h.creativeStudioService.GetMusicCompositions(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取音乐作品失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取音乐作品成功",
		Data:    compositions,
	})
}

// CreateDesign 创建设计
func (h *CreativeStudioHandler) CreateDesign(c *gin.Context) {
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
		Title       string                 `json:"title" validate:"required"`
		Description string                 `json:"description"`
		Dimensions  map[string]interface{} `json:"dimensions"`
		Colors      []string               `json:"colors"`
		Elements    []map[string]interface{} `json:"elements"`
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

	design, err := h.creativeStudioService.CreateDesign(userID, req.Type, req.Title, req.Description, req.Dimensions, req.Colors, req.Elements, req.Settings)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建设计失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建设计成功",
		Data:    design,
	})
}

// GetDesigns 获取设计作品
func (h *CreativeStudioHandler) GetDesigns(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	designs, err := h.creativeStudioService.GetDesigns(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取设计作品失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取设计作品成功",
		Data:    designs,
	})
}
