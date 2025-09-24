package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/services"
)

// AI处理器
type AIHandler struct {
	services *services.Services
}

// 创建AI处理器
func NewAIHandler(services *services.Services) *AIHandler {
	return &AIHandler{
		services: services,
	}
}

// AI文本生成请求
type AIGenerateTextRequest struct {
	Model       string   `json:"model" binding:"required"`
	Messages    []AIMessage `json:"messages" binding:"required"`
	Temperature float64  `json:"temperature,omitempty"`
	MaxTokens   int      `json:"max_tokens,omitempty"`
	Stream      bool     `json:"stream,omitempty"`
}

// AI消息
type AIMessage struct {
	Role    string `json:"role" binding:"required"`
	Content string `json:"content" binding:"required"`
}

// AI文本生成响应
type AIGenerateTextResponse struct {
	ID      string `json:"id"`
	Object  string `json:"object"`
	Created int64  `json:"created"`
	Model   string `json:"model"`
	Choices []struct {
		Index   int `json:"index"`
		Message struct {
			Role    string `json:"role"`
			Content string `json:"content"`
		} `json:"message"`
		FinishReason string `json:"finish_reason"`
	} `json:"choices"`
	Usage struct {
		PromptTokens     int `json:"prompt_tokens"`
		CompletionTokens int `json:"completion_tokens"`
		TotalTokens      int `json:"total_tokens"`
	} `json:"usage"`
	ServiceType string `json:"service_type"`
}

// 生成文本
func (h *AIHandler) GenerateText(c *gin.Context) {
	var req AIGenerateTextRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	// 转换请求格式
	aiReq := &services.AIRequest{
		Model:       req.Model,
		Temperature: req.Temperature,
		MaxTokens:   req.MaxTokens,
		Stream:      req.Stream,
	}

	// 转换消息格式
	for _, msg := range req.Messages {
		aiReq.Messages = append(aiReq.Messages, services.AIMessage{
			Role:    msg.Role,
			Content: msg.Content,
		})
	}

	// 调用AI服务
	resp, err := h.services.AIClientManager.GenerateText(c.Request.Context(), aiReq)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "AI服务调用失败: " + err.Error(),
		})
		return
	}

	// 转换响应格式
	response := AIGenerateTextResponse{
		ID:      resp.ID,
		Object:  resp.Object,
		Created: resp.Created,
		Model:   resp.Model,
		Usage:   resp.Usage,
		ServiceType: "auto", // 自动选择的服务类型
	}

	// 转换选择结果
	for _, choice := range resp.Choices {
		response.Choices = append(response.Choices, struct {
			Index   int `json:"index"`
			Message struct {
				Role    string `json:"role"`
				Content string `json:"content"`
			} `json:"message"`
			FinishReason string `json:"finish_reason"`
		}{
			Index: choice.Index,
			Message: struct {
				Role    string `json:"role"`
				Content string `json:"content"`
			}{
				Role:    choice.Message.Role,
				Content: choice.Message.Content,
			},
			FinishReason: choice.FinishReason,
		})
	}

	c.JSON(http.StatusOK, response)
}

// 获取可用AI服务列表
func (h *AIHandler) GetAvailableServices(c *gin.Context) {
	clients := h.services.AIClientManager.GetAvailableClients()
	
	var services []map[string]interface{}
	for _, client := range clients {
		services = append(services, map[string]interface{}{
			"type":        client.GetServiceType(),
			"available":   client.IsAvailable(),
			"name":        h.getServiceName(client.GetServiceType()),
			"description": h.getServiceDescription(client.GetServiceType()),
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"services": services,
		"count":    len(services),
	})
}

// 获取服务名称
func (h *AIHandler) getServiceName(serviceType services.AIServiceType) string {
	switch serviceType {
	case services.AIServiceDeepSeek:
		return "DeepSeek"
	case services.AIServiceAIMLAPI:
		return "AIMLAPI"
	case services.AIServiceTencent:
		return "腾讯混元"
	case services.AIServiceGroq:
		return "Groq"
	case services.AIServiceAITools:
		return "AI Tools"
	case services.AIServiceTogether:
		return "Together AI"
	case services.AIServiceOpenRouter:
		return "OpenRouter"
	case services.AIServiceXunfei:
		return "讯飞星火"
	case services.AIServiceBaidu:
		return "百度千帆"
	case services.AIServiceBytedance:
		return "字节扣子"
	case services.AIServiceSiliconFlow:
		return "硅基流动"
	default:
		return "未知服务"
	}
}

// 获取服务描述
func (h *AIHandler) getServiceDescription(serviceType services.AIServiceType) string {
	switch serviceType {
	case services.AIServiceDeepSeek:
		return "DeepSeek AI - 主要AI服务"
	case services.AIServiceAIMLAPI:
		return "AIMLAPI - 聚合AI服务，支持200+种模型"
	case services.AIServiceTencent:
		return "腾讯混元大模型 - 腾讯云AI服务"
	case services.AIServiceGroq:
		return "Groq - 免费额度大，速度快"
	case services.AIServiceAITools:
		return "AI Tools - 无需登录，兼容OpenAI"
	case services.AIServiceTogether:
		return "Together AI - 有免费额度"
	case services.AIServiceOpenRouter:
		return "OpenRouter - 聚合多个模型"
	case services.AIServiceXunfei:
		return "讯飞星火 - 完全免费"
	case services.AIServiceBaidu:
		return "百度千帆 - 免费额度"
	case services.AIServiceBytedance:
		return "字节扣子 - 开发者免费"
	case services.AIServiceSiliconFlow:
		return "硅基流动 - 免费额度"
	default:
		return "未知服务"
	}
}

// 测试AI服务连接
func (h *AIHandler) TestService(c *gin.Context) {
	serviceType := c.Param("service")
	
	// 创建测试请求
	testReq := &services.AIRequest{
		Model: "gpt-3.5-turbo",
		Messages: []services.AIMessage{
			{
				Role:    "user",
				Content: "Hello, this is a test message.",
			},
		},
		Temperature: 0.7,
		MaxTokens:   50,
	}

	// 尝试调用指定服务
	clients := h.services.AIClientManager.GetAvailableClients()
	for _, client := range clients {
		if string(client.GetServiceType()) == serviceType {
			resp, err := client.GenerateText(c.Request.Context(), testReq)
			if err != nil {
				c.JSON(http.StatusInternalServerError, gin.H{
					"error": "服务测试失败: " + err.Error(),
					"service": serviceType,
				})
				return
			}

			c.JSON(http.StatusOK, gin.H{
				"success": true,
				"service": serviceType,
				"response": resp,
			})
			return
		}
	}

	c.JSON(http.StatusNotFound, gin.H{
		"error": "服务未找到: " + serviceType,
	})
}

// 获取AI服务统计信息
func (h *AIHandler) GetServiceStats(c *gin.Context) {
	clients := h.services.AIClientManager.GetAvailableClients()
	
	stats := map[string]interface{}{
		"total_services": len(clients),
		"available_services": 0,
		"services": make([]map[string]interface{}, 0),
	}

	availableCount := 0
	for _, client := range clients {
		if client.IsAvailable() {
			availableCount++
		}
		
		serviceInfo := map[string]interface{}{
			"type":      client.GetServiceType(),
			"name":      h.getServiceName(client.GetServiceType()),
			"available": client.IsAvailable(),
		}
		
		services := stats["services"].([]map[string]interface{})
		services = append(services, serviceInfo)
		stats["services"] = services
	}

	stats["available_services"] = availableCount

	c.JSON(http.StatusOK, stats)
}

// 注册AI路由
func (h *AIHandler) RegisterRoutes(router *gin.RouterGroup) {
	ai := router.Group("/ai")
	{
		ai.POST("/generate", h.GenerateText)
		ai.GET("/services", h.GetAvailableServices)
		ai.GET("/services/:service/test", h.TestService)
		ai.GET("/stats", h.GetServiceStats)
	}
}
