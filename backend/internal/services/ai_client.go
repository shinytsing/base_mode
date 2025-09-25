package services

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"qa-toolbox-backend/internal/config"
)

// AI服务类型
type AIServiceType string

const (
	AIServiceDeepSeek    AIServiceType = "deepseek"
	AIServiceAIMLAPI     AIServiceType = "aimlapi"
	AIServiceTencent     AIServiceType = "tencent"
	AIServiceGroq        AIServiceType = "groq"
	AIServiceAITools     AIServiceType = "aitools"
	AIServiceTogether    AIServiceType = "together"
	AIServiceOpenRouter  AIServiceType = "openrouter"
	AIServiceXunfei      AIServiceType = "xunfei"
	AIServiceBaidu       AIServiceType = "baidu"
	AIServiceBytedance   AIServiceType = "bytedance"
	AIServiceSiliconFlow AIServiceType = "siliconflow"
)

// AI请求结构
type AIRequest struct {
	Model       string                 `json:"model"`
	Messages    []AIMessage           `json:"messages"`
	Temperature float64               `json:"temperature,omitempty"`
	MaxTokens   int                   `json:"max_tokens,omitempty"`
	Stream      bool                  `json:"stream,omitempty"`
	Extra       map[string]interface{} `json:"-"`
}

// AI消息结构
type AIMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

// AI响应结构
type AIResponse struct {
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
}

// AI客户端接口
type AIClient interface {
	GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error)
	GetServiceType() AIServiceType
	IsAvailable() bool
}

// AI客户端管理器
type AIClientManager struct {
	clients map[AIServiceType]AIClient
	config  *config.Config
}

// 创建AI客户端管理器
func NewAIClientManager(cfg *config.Config) *AIClientManager {
	manager := &AIClientManager{
		clients: make(map[AIServiceType]AIClient),
		config:  cfg,
	}
	
	// 初始化所有可用的AI客户端
	manager.initClients()
	
	return manager
}

// 初始化所有AI客户端
func (m *AIClientManager) initClients() {
	// DeepSeek客户端
	if m.config.DeepSeekAPIKey != "" {
		m.clients[AIServiceDeepSeek] = NewDeepSeekClient(m.config)
	}
	
	// AIMLAPI客户端
	if m.config.AIMLAPIKey != "" {
		m.clients[AIServiceAIMLAPI] = NewAIMLAPIClient(m.config)
	}
	
	// 腾讯混元客户端
	if m.config.TencentSecretID != "" && m.config.TencentSecretKey != "" {
		m.clients[AIServiceTencent] = NewTencentClient(m.config)
	}
	
	// Groq客户端
	if m.config.GroqAPIKey != "" {
		m.clients[AIServiceGroq] = NewGroqClient(m.config)
	}
	
	// AI Tools客户端
	if m.config.AIToolsAPIKey != "" {
		m.clients[AIServiceAITools] = NewAIToolsClient(m.config)
	}
	
	// Together AI客户端
	if m.config.TogetherAPIKey != "" {
		m.clients[AIServiceTogether] = NewTogetherClient(m.config)
	}
	
	// OpenRouter客户端
	if m.config.OpenRouterAPIKey != "" {
		m.clients[AIServiceOpenRouter] = NewOpenRouterClient(m.config)
	}
	
	// 讯飞星火客户端
	if m.config.XunfeiAPIKey != "" && m.config.XunfeiAppID != "" {
		m.clients[AIServiceXunfei] = NewXunfeiClient(m.config)
	}
	
	// 百度千帆客户端
	if m.config.BaiduAPIKey != "" && m.config.BaiduSecretKey != "" {
		m.clients[AIServiceBaidu] = NewBaiduClient(m.config)
	}
	
	// 字节扣子客户端
	if m.config.BytedanceAPIKey != "" {
		m.clients[AIServiceBytedance] = NewBytedanceClient(m.config)
	}
	
	// 硅基流动客户端
	if m.config.SiliconFlowAPIKey != "" {
		m.clients[AIServiceSiliconFlow] = NewSiliconFlowClient(m.config)
	}
}

// 获取可用的AI客户端（按优先级）
func (m *AIClientManager) GetAvailableClients() []AIClient {
	var clients []AIClient
	
	// 按优先级排序
	priority := []AIServiceType{
		AIServiceTencent,     // 最高优先级 - 腾讯混元，国内稳定
		AIServiceDeepSeek,    // 第二优先级 - DeepSeek，功能强大
		AIServiceAIMLAPI,     // 第三优先级 - 聚合服务
		AIServiceAITools,     // 无需登录
		AIServiceGroq,        // 免费额度大
		AIServiceXunfei,      // 完全免费
		AIServiceBaidu,       // 免费额度
		AIServiceBytedance,   // 开发者免费
		AIServiceSiliconFlow, // 免费额度
		AIServiceTogether,    // 有免费额度
		AIServiceOpenRouter,  // 聚合多个模型
	}
	
	for _, serviceType := range priority {
		if client, exists := m.clients[serviceType]; exists && client.IsAvailable() {
			clients = append(clients, client)
		}
	}
	
	return clients
}

// 生成文本（自动选择最佳可用服务）
func (m *AIClientManager) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	clients := m.GetAvailableClients()
	
	if len(clients) == 0 {
		return nil, fmt.Errorf("没有可用的AI服务")
	}
	
	// 尝试使用第一个可用的客户端
	for _, client := range clients {
		resp, err := client.GenerateText(ctx, req)
		if err == nil {
			return resp, nil
		}
		// 如果失败，尝试下一个客户端
	}
	
	return nil, fmt.Errorf("所有AI服务都不可用")
}

// GenerateTestCases 生成测试用例
func (m *AIClientManager) GenerateTestCases(code, language, testType string) (string, error) {
	prompt := fmt.Sprintf(`
请为以下%s代码生成%s测试用例：

代码：
%s

要求：
1. 生成完整的测试用例代码
2. 包含边界条件测试
3. 包含异常情况测试
4. 使用适当的测试框架
5. 代码要有注释说明

请直接返回测试用例代码，不要其他解释。
`, language, testType, code)

	req := &AIRequest{
		Model: "gpt-3.5-turbo",
		Messages: []AIMessage{
			{Role: "system", Content: "你是一个专业的软件测试工程师，擅长生成高质量的测试用例。"},
			{Role: "user", Content: prompt},
		},
		Temperature: 0.7,
		MaxTokens:   2000,
	}

	ctx := context.Background()
	resp, err := m.GenerateText(ctx, req)
	if err != nil {
		return "", fmt.Errorf("生成测试用例失败: %w", err)
	}

	if len(resp.Choices) == 0 {
		return "", fmt.Errorf("AI响应中没有生成内容")
	}

	return resp.Choices[0].Message.Content, nil
}

// AnalyzeCode 分析代码
func (m *AIClientManager) AnalyzeCode(code, language string) (string, error) {
	prompt := fmt.Sprintf(`
请分析以下%s代码：

代码：
%s

请从以下方面进行分析：
1. 代码质量和可读性
2. 潜在的安全问题
3. 性能优化建议
4. 代码规范问题
5. 改进建议

请提供详细的分析报告。
`, language, code)

	req := &AIRequest{
		Model: "gpt-3.5-turbo",
		Messages: []AIMessage{
			{Role: "system", Content: "你是一个资深的代码审查专家，擅长发现代码中的问题和改进点。"},
			{Role: "user", Content: prompt},
		},
		Temperature: 0.3,
		MaxTokens:   3000,
	}

	ctx := context.Background()
	resp, err := m.GenerateText(ctx, req)
	if err != nil {
		return "", fmt.Errorf("代码分析失败: %w", err)
	}

	if len(resp.Choices) == 0 {
		return "", fmt.Errorf("AI响应中没有生成内容")
	}

	return resp.Choices[0].Message.Content, nil
}

// GenerateContent 生成内容
func (m *AIClientManager) GenerateContent(contentType, topic, requirements string) (string, error) {
	prompt := fmt.Sprintf(`
请生成%s内容：

主题：%s
要求：%s

请生成高质量的内容，符合要求。
`, contentType, topic, requirements)

	req := &AIRequest{
		Model: "gpt-3.5-turbo",
		Messages: []AIMessage{
			{Role: "system", Content: "你是一个专业的内容创作专家，擅长各种类型的内容创作。"},
			{Role: "user", Content: prompt},
		},
		Temperature: 0.8,
		MaxTokens:   2000,
	}

	ctx := context.Background()
	resp, err := m.GenerateText(ctx, req)
	if err != nil {
		return "", fmt.Errorf("内容生成失败: %w", err)
	}

	if len(resp.Choices) == 0 {
		return "", fmt.Errorf("AI响应中没有生成内容")
	}

	return resp.Choices[0].Message.Content, nil
}

// 基础HTTP客户端
type BaseAIClient struct {
	config     *config.Config
	httpClient *http.Client
	baseURL    string
	apiKey     string
	serviceType AIServiceType
}

// 创建基础HTTP客户端
func NewBaseAIClient(cfg *config.Config, baseURL, apiKey string, serviceType AIServiceType) *BaseAIClient {
	return &BaseAIClient{
		config:     cfg,
		httpClient: &http.Client{Timeout: 30 * time.Second},
		baseURL:    baseURL,
		apiKey:     apiKey,
		serviceType: serviceType,
	}
}

// 发送HTTP请求
func (c *BaseAIClient) sendRequest(ctx context.Context, endpoint string, req *AIRequest) (*AIResponse, error) {
	url := c.baseURL + endpoint
	
	// 构建请求体
	reqBody, err := json.Marshal(req)
	if err != nil {
		return nil, fmt.Errorf("序列化请求失败: %w", err)
	}
	
	// 创建HTTP请求
	httpReq, err := http.NewRequestWithContext(ctx, "POST", url, bytes.NewBuffer(reqBody))
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}
	
	// 设置请求头
	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", "Bearer "+c.apiKey)
	
	// 发送请求
	resp, err := c.httpClient.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("发送请求失败: %w", err)
	}
	defer resp.Body.Close()
	
	// 读取响应
	respBody, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	// 检查HTTP状态码
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("API请求失败: %d %s", resp.StatusCode, string(respBody))
	}
	
	// 解析响应
	var aiResp AIResponse
	if err := json.Unmarshal(respBody, &aiResp); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	return &aiResp, nil
}

// DeepSeek客户端
type DeepSeekClient struct {
	*BaseAIClient
}

func NewDeepSeekClient(cfg *config.Config) *DeepSeekClient {
	return &DeepSeekClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.DeepSeekBaseURL, cfg.DeepSeekAPIKey, AIServiceDeepSeek),
	}
}

func (c *DeepSeekClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *DeepSeekClient) GetServiceType() AIServiceType {
	return AIServiceDeepSeek
}

func (c *DeepSeekClient) IsAvailable() bool {
	return c.apiKey != ""
}

// AIMLAPI客户端
type AIMLAPIClient struct {
	*BaseAIClient
}

func NewAIMLAPIClient(cfg *config.Config) *AIMLAPIClient {
	return &AIMLAPIClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.AIMLAPIBaseURL, cfg.AIMLAPIKey, AIServiceAIMLAPI),
	}
}

func (c *AIMLAPIClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *AIMLAPIClient) GetServiceType() AIServiceType {
	return AIServiceAIMLAPI
}

func (c *AIMLAPIClient) IsAvailable() bool {
	return c.apiKey != ""
}

// Groq客户端
type GroqClient struct {
	*BaseAIClient
}

func NewGroqClient(cfg *config.Config) *GroqClient {
	return &GroqClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.GroqBaseURL, cfg.GroqAPIKey, AIServiceGroq),
	}
}

func (c *GroqClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *GroqClient) GetServiceType() AIServiceType {
	return AIServiceGroq
}

func (c *GroqClient) IsAvailable() bool {
	return c.apiKey != ""
}

// AI Tools客户端
type AIToolsClient struct {
	*BaseAIClient
}

func NewAIToolsClient(cfg *config.Config) *AIToolsClient {
	return &AIToolsClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.AIToolsBaseURL, cfg.AIToolsAPIKey, AIServiceAITools),
	}
}

func (c *AIToolsClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *AIToolsClient) GetServiceType() AIServiceType {
	return AIServiceAITools
}

func (c *AIToolsClient) IsAvailable() bool {
	return c.apiKey != ""
}

// Together AI客户端
type TogetherClient struct {
	*BaseAIClient
}

func NewTogetherClient(cfg *config.Config) *TogetherClient {
	return &TogetherClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.TogetherBaseURL, cfg.TogetherAPIKey, AIServiceTogether),
	}
}

func (c *TogetherClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *TogetherClient) GetServiceType() AIServiceType {
	return AIServiceTogether
}

func (c *TogetherClient) IsAvailable() bool {
	return c.apiKey != ""
}

// OpenRouter客户端
type OpenRouterClient struct {
	*BaseAIClient
}

func NewOpenRouterClient(cfg *config.Config) *OpenRouterClient {
	return &OpenRouterClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.OpenRouterBaseURL, cfg.OpenRouterAPIKey, AIServiceOpenRouter),
	}
}

func (c *OpenRouterClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *OpenRouterClient) GetServiceType() AIServiceType {
	return AIServiceOpenRouter
}

func (c *OpenRouterClient) IsAvailable() bool {
	return c.apiKey != ""
}

// 腾讯混元客户端
type TencentClient struct {
	*BaseAIClient
}

func NewTencentClient(cfg *config.Config) *TencentClient {
	return &TencentClient{
		BaseAIClient: NewBaseAIClient(cfg, "https://hunyuan.tencentcloudapi.com", cfg.TencentSecretKey, AIServiceTencent),
	}
}

func (c *TencentClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	// 腾讯混元API实现 - 使用OpenAI兼容接口
	apiKey := c.config.TencentSecretKey
	
	if apiKey == "" {
		return nil, fmt.Errorf("腾讯混元API密钥未配置")
	}
	
	// API配置 - 使用OpenAI兼容接口
	endpoint := "https://api.hunyuan.cloud.tencent.com/v1/chat/completions"
	
	// 构建请求体 - OpenAI兼容格式
	payload := map[string]interface{}{
		"model": "hunyuan-lite",
		"messages": req.Messages,
		"temperature": req.Temperature,
		"max_tokens": req.MaxTokens,
		"stream": false,
	}
	
	payloadJSON, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("序列化请求体失败: %w", err)
	}
	
	// 创建HTTP请求
	httpReq, err := http.NewRequestWithContext(ctx, "POST", endpoint, bytes.NewBuffer(payloadJSON))
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}
	
	// 设置请求头 - OpenAI兼容格式
	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Authorization", fmt.Sprintf("Bearer %s", apiKey))
	
	// 发送请求
	resp, err := c.httpClient.Do(httpReq)
	if err != nil {
		return nil, fmt.Errorf("请求失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	if resp.StatusCode != 200 {
		return nil, fmt.Errorf("API请求失败 (状态码: %d): %s", resp.StatusCode, string(body))
	}
	
	// 解析腾讯混元响应 - OpenAI兼容格式
	var tencentResp struct {
		Choices []struct {
			Message struct {
				Role    string `json:"role"`
				Content string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
		Usage struct {
			PromptTokens     int `json:"prompt_tokens"`
			CompletionTokens int `json:"completion_tokens"`
			TotalTokens      int `json:"total_tokens"`
		} `json:"usage"`
		Error struct {
			Message string `json:"message"`
		} `json:"error"`
	}
	
	if err := json.Unmarshal(body, &tencentResp); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	if tencentResp.Error.Message != "" {
		return nil, fmt.Errorf("API错误: %s", tencentResp.Error.Message)
	}
	
	if len(tencentResp.Choices) == 0 {
		return nil, fmt.Errorf("API返回空响应")
	}
	
	// 转换为标准响应格式
	choice := tencentResp.Choices[0]
	aiResp := &AIResponse{
		ID:      fmt.Sprintf("tencent-%d", time.Now().Unix()),
		Object:  "chat.completion",
		Created: time.Now().Unix(),
		Model:   "hunyuan-lite",
		Choices: []struct {
			Index   int `json:"index"`
			Message struct {
				Role    string `json:"role"`
				Content string `json:"content"`
			} `json:"message"`
			FinishReason string `json:"finish_reason"`
		}{
			{
				Index: 0,
				Message: struct {
					Role    string `json:"role"`
					Content string `json:"content"`
				}{
					Role:    choice.Message.Role,
					Content: choice.Message.Content,
				},
				FinishReason: "stop",
			},
		},
		Usage: tencentResp.Usage,
	}
	
	return aiResp, nil
}


func (c *TencentClient) GetServiceType() AIServiceType {
	return AIServiceTencent
}

func (c *TencentClient) IsAvailable() bool {
	return c.apiKey != "" && c.config.TencentSecretID != ""
}

// 讯飞星火客户端
type XunfeiClient struct {
	*BaseAIClient
}

func NewXunfeiClient(cfg *config.Config) *XunfeiClient {
	return &XunfeiClient{
		BaseAIClient: NewBaseAIClient(cfg, "https://spark-api.xf-yun.com", cfg.XunfeiAPIKey, AIServiceXunfei),
	}
}

func (c *XunfeiClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	// 讯飞星火需要特殊的认证方式
	return nil, fmt.Errorf("讯飞星火客户端暂未实现")
}

func (c *XunfeiClient) GetServiceType() AIServiceType {
	return AIServiceXunfei
}

func (c *XunfeiClient) IsAvailable() bool {
	return c.apiKey != "" && c.config.XunfeiAppID != ""
}

// 百度千帆客户端
type BaiduClient struct {
	*BaseAIClient
}

func NewBaiduClient(cfg *config.Config) *BaiduClient {
	return &BaiduClient{
		BaseAIClient: NewBaseAIClient(cfg, "https://aip.baidubce.com", cfg.BaiduAPIKey, AIServiceBaidu),
	}
}

func (c *BaiduClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	// 百度千帆需要特殊的认证方式
	return nil, fmt.Errorf("百度千帆客户端暂未实现")
}

func (c *BaiduClient) GetServiceType() AIServiceType {
	return AIServiceBaidu
}

func (c *BaiduClient) IsAvailable() bool {
	return c.apiKey != "" && c.config.BaiduSecretKey != ""
}

// 字节扣子客户端
type BytedanceClient struct {
	*BaseAIClient
}

func NewBytedanceClient(cfg *config.Config) *BytedanceClient {
	return &BytedanceClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.BytedanceBaseURL, cfg.BytedanceAPIKey, AIServiceBytedance),
	}
}

func (c *BytedanceClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *BytedanceClient) GetServiceType() AIServiceType {
	return AIServiceBytedance
}

func (c *BytedanceClient) IsAvailable() bool {
	return c.apiKey != ""
}

// 硅基流动客户端
type SiliconFlowClient struct {
	*BaseAIClient
}

func NewSiliconFlowClient(cfg *config.Config) *SiliconFlowClient {
	return &SiliconFlowClient{
		BaseAIClient: NewBaseAIClient(cfg, cfg.SiliconFlowBaseURL, cfg.SiliconFlowAPIKey, AIServiceSiliconFlow),
	}
}

func (c *SiliconFlowClient) GenerateText(ctx context.Context, req *AIRequest) (*AIResponse, error) {
	return c.sendRequest(ctx, "/chat/completions", req)
}

func (c *SiliconFlowClient) GetServiceType() AIServiceType {
	return AIServiceSiliconFlow
}

func (c *SiliconFlowClient) IsAvailable() bool {
	return c.apiKey != ""
}
