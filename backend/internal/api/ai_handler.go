package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type AIHandler struct {
	services *services.Services
}

func NewAIHandler(services *services.Services) *AIHandler {
	return &AIHandler{
		services: services,
	}
}

// RegisterRoutes 注册AI服务路由
func (h *AIHandler) RegisterRoutes(router *gin.RouterGroup) {
	ai := router.Group("/ai")
	{
		ai.POST("/generate-test-cases", h.GenerateTestCases)
		ai.POST("/analyze-code", h.AnalyzeCode)
		ai.POST("/generate-content", h.GenerateContent)
	}
	
	// LLM大服务路由
	llm := router.Group("/llm")
	{
		llm.POST("/chat", h.Chat)
		llm.POST("/generate", h.GenerateText)
		llm.GET("/models", h.GetAvailableModels)
		llm.GET("/health", h.HealthCheck)
	}
}

// GenerateTestCases 生成测试用例
func (h *AIHandler) GenerateTestCases(c *gin.Context) {
	var req struct {
		Code     string `json:"code" validate:"required"`
		Language string `json:"language" validate:"required"`
		TestType string `json:"test_type" validate:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	response, err := h.services.AIClientManager.GenerateTestCases(req.Code, req.Language, req.TestType)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to generate test cases",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Test cases generated successfully",
		Data: gin.H{
			"test_cases": response,
		},
	})
}

// AnalyzeCode 分析代码
func (h *AIHandler) AnalyzeCode(c *gin.Context) {
	var req struct {
		Code     string `json:"code" validate:"required"`
		Language string `json:"language" validate:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	response, err := h.services.AIClientManager.AnalyzeCode(req.Code, req.Language)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to analyze code",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Code analysis completed successfully",
		Data: gin.H{
			"analysis": response,
		},
	})
}

// GenerateContent 生成内容
func (h *AIHandler) GenerateContent(c *gin.Context) {
	var req struct {
		Prompt      string `json:"prompt" validate:"required"`
		ContentType string `json:"content_type" validate:"required"`
		Requirements string `json:"requirements"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	response, err := h.services.AIClientManager.GenerateContent(req.ContentType, req.Prompt, req.Requirements)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to generate content",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Content generated successfully",
		Data: gin.H{
			"content": response,
		},
	})
}

// ChatRequest LLM对话请求
type ChatRequest struct {
	Messages    []services.AIMessage `json:"messages" validate:"required"`
	Model       string               `json:"model,omitempty"`
	Temperature float64              `json:"temperature,omitempty"`
	MaxTokens   int                  `json:"max_tokens,omitempty"`
	Stream      bool                 `json:"stream,omitempty"`
}

// ChatResponse LLM对话响应
type ChatResponse struct {
	ID      string `json:"id"`
	Model   string `json:"model"`
	Message struct {
		Role    string `json:"role"`
		Content string `json:"content"`
	} `json:"message"`
	Usage struct {
		PromptTokens     int `json:"prompt_tokens"`
		CompletionTokens int `json:"completion_tokens"`
		TotalTokens      int `json:"total_tokens"`
	} `json:"usage"`
}

// Chat LLM对话接口
func (h *AIHandler) Chat(c *gin.Context) {
	var req ChatRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	// 设置默认值
	if req.Model == "" {
		req.Model = "auto" // 自动选择最佳模型
	}
	if req.Temperature == 0 {
		req.Temperature = 0.7
	}
	if req.MaxTokens == 0 {
		req.MaxTokens = 2000
	}

	// 构建AI请求
	aiReq := &services.AIRequest{
		Model:       req.Model,
		Messages:    req.Messages,
		Temperature: req.Temperature,
		MaxTokens:   req.MaxTokens,
		Stream:      req.Stream,
	}

	// 调用AI服务
	resp, err := h.services.AIClientManager.GenerateText(c.Request.Context(), aiReq)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "LLM服务调用失败",
			Error:   err.Error(),
		})
		return
	}

	if len(resp.Choices) == 0 {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "LLM服务返回空响应",
		})
		return
	}

	// 构建响应
	chatResp := ChatResponse{
		ID:    resp.ID,
		Model: resp.Model,
		Message: struct {
			Role    string `json:"role"`
			Content string `json:"content"`
		}{
			Role:    resp.Choices[0].Message.Role,
			Content: resp.Choices[0].Message.Content,
		},
		Usage: struct {
			PromptTokens     int `json:"prompt_tokens"`
			CompletionTokens int `json:"completion_tokens"`
			TotalTokens      int `json:"total_tokens"`
		}{
			PromptTokens:     resp.Usage.PromptTokens,
			CompletionTokens: resp.Usage.CompletionTokens,
			TotalTokens:      resp.Usage.TotalTokens,
		},
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "LLM对话成功",
		Data:    chatResp,
	})
}

// GenerateText 文本生成接口
func (h *AIHandler) GenerateText(c *gin.Context) {
	var req struct {
		Prompt      string  `json:"prompt" validate:"required"`
		Model       string  `json:"model,omitempty"`
		Temperature float64 `json:"temperature,omitempty"`
		MaxTokens   int     `json:"max_tokens,omitempty"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	// 设置默认值
	if req.Model == "" {
		req.Model = "auto"
	}
	if req.Temperature == 0 {
		req.Temperature = 0.7
	}
	if req.MaxTokens == 0 {
		req.MaxTokens = 1000
	}

	// 构建AI请求
	aiReq := &services.AIRequest{
		Model: req.Model,
		Messages: []services.AIMessage{
			{Role: "user", Content: req.Prompt},
		},
		Temperature: req.Temperature,
		MaxTokens:   req.MaxTokens,
	}

	// 调用AI服务
	resp, err := h.services.AIClientManager.GenerateText(c.Request.Context(), aiReq)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "文本生成失败",
			Error:   err.Error(),
		})
		return
	}

	if len(resp.Choices) == 0 {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "LLM服务返回空响应",
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "文本生成成功",
		Data: map[string]interface{}{
			"text":   resp.Choices[0].Message.Content,
			"model":  resp.Model,
			"usage":  resp.Usage,
		},
	})
}

// GetAvailableModels 获取可用模型列表
func (h *AIHandler) GetAvailableModels(c *gin.Context) {
	clients := h.services.AIClientManager.GetAvailableClients()
	
	var models []map[string]interface{}
	for _, client := range clients {
		serviceType := client.GetServiceType()
		modelInfo := map[string]interface{}{
			"service": string(serviceType),
			"available": client.IsAvailable(),
		}
		
		// 根据服务类型设置模型信息
		switch serviceType {
		case services.AIServiceTencent:
			modelInfo["models"] = []string{"hunyuan-lite", "hunyuan-standard"}
			modelInfo["description"] = "腾讯混元大模型，国内访问稳定"
		case services.AIServiceDeepSeek:
			modelInfo["models"] = []string{"deepseek-chat", "deepseek-coder"}
			modelInfo["description"] = "DeepSeek AI，功能强大"
		case services.AIServiceAIMLAPI:
			modelInfo["models"] = []string{"gpt-3.5-turbo", "gpt-4", "claude-3"}
			modelInfo["description"] = "AIMLAPI聚合服务，支持多种模型"
		default:
			modelInfo["models"] = []string{"auto"}
			modelInfo["description"] = "自动选择最佳模型"
		}
		
		models = append(models, modelInfo)
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "获取可用模型成功",
		"data": gin.H{
			"models": models,
			"total": len(models),
		},
	})
}

// HealthCheck LLM服务健康检查
func (h *AIHandler) HealthCheck(c *gin.Context) {
	clients := h.services.AIClientManager.GetAvailableClients()
	
	healthStatus := map[string]interface{}{
		"status": "healthy",
		"available_services": len(clients),
		"services": make([]map[string]interface{}, 0),
	}
	
	for _, client := range clients {
		serviceInfo := map[string]interface{}{
			"service": string(client.GetServiceType()),
			"available": client.IsAvailable(),
		}
		healthStatus["services"] = append(healthStatus["services"].([]map[string]interface{}), serviceInfo)
	}
	
	if len(clients) == 0 {
		healthStatus["status"] = "unhealthy"
		healthStatus["message"] = "没有可用的LLM服务"
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "LLM服务健康检查完成",
		"data":    healthStatus,
	})
}