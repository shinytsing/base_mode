package models

import (
	"time"
)

// ==================== 用户相关模型 ====================

// User 用户模型
type User struct {
	ID                   string     `json:"id" db:"id"`
	Email                string     `json:"email" db:"email"`
	Username             string     `json:"username" db:"username"`
	PasswordHash         string     `json:"-" db:"password_hash"`
	FirstName            string     `json:"first_name" db:"first_name"`
	LastName             string     `json:"last_name" db:"last_name"`
	AvatarURL            string     `json:"avatar_url" db:"avatar_url"`
	IsActive             bool       `json:"is_active" db:"is_active"`
	IsPremium            bool       `json:"is_premium" db:"is_premium"`
	SubscriptionType     string     `json:"subscription_type" db:"subscription_type"`
	SubscriptionExpiresAt *time.Time `json:"subscription_expires_at" db:"subscription_expires_at"`
	CreatedAt            time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt            time.Time  `json:"updated_at" db:"updated_at"`
}

// UserRegistrationRequest 用户注册请求
type UserRegistrationRequest struct {
	Email     string `json:"email" validate:"required,email"`
	Username  string `json:"username" validate:"required,min=3,max=20"`
	Password  string `json:"password" validate:"required,min=6"`
	FirstName string `json:"first_name" validate:"required"`
	LastName  string `json:"last_name" validate:"required"`
}

// UserLoginRequest 用户登录请求
type UserLoginRequest struct {
	Email    string `json:"email" validate:"required,email"`
	Password string `json:"password" validate:"required"`
}

// UserResponse 用户响应
type UserResponse struct {
	ID                   string     `json:"id"`
	Email                string     `json:"email"`
	Username             string     `json:"username"`
	FirstName            string     `json:"first_name"`
	LastName             string     `json:"last_name"`
	AvatarURL            string     `json:"avatar_url"`
	IsActive             bool       `json:"is_active"`
	IsPremium            bool       `json:"is_premium"`
	SubscriptionType     string     `json:"subscription_type"`
	SubscriptionExpiresAt *time.Time `json:"subscription_expires_at"`
	CreatedAt            time.Time  `json:"created_at"`
}

// ==================== 测试相关模型 ====================

// TestGenerationRequest 测试生成请求
type TestGenerationRequest struct {
	UserID                   string                 `json:"user_id"`
	Code                     string                 `json:"code" validate:"required"`
	Language                 string                 `json:"language" validate:"required"`
	Framework                string                 `json:"framework"`
	TestType                 string                 `json:"test_type" validate:"required"`
	Coverage                 int                    `json:"coverage"`
	Options                  map[string]interface{} `json:"options"`
	Description              string                 `json:"description"`
	IncludeEdgeCases         bool                   `json:"includeEdgeCases"`
	IncludePerformanceTests  bool                   `json:"includePerformanceTests"`
	IncludeSecurityTests     bool                   `json:"includeSecurityTests"`
}

// TestCase 测试用例
type TestCase struct {
	ID          string                 `json:"id" db:"id"`
	GenerationID string                `json:"generation_id" db:"generation_id"`
	Name        string                 `json:"name" db:"name"`
	Description string                 `json:"description" db:"description"`
	Code        string                 `json:"code" db:"code"`
	Type        string                 `json:"type" db:"type"`
	Tags        []string               `json:"tags" db:"tags"`
	Priority    int                    `json:"priority" db:"priority"`
	IsAutomated bool                   `json:"is_automated" db:"is_automated"`
	Metadata    map[string]interface{} `json:"metadata" db:"metadata"`
	CreatedAt   time.Time              `json:"created_at" db:"created_at"`
}

// TestGenerationResponse 测试生成响应
type TestGenerationResponse struct {
	ID        string                 `json:"id"`
	TestCases []TestCase             `json:"test_cases"`
	Status    string                 `json:"status"`
	Metrics   TestMetrics            `json:"metrics"`
	CreatedAt time.Time              `json:"created_at"`
}

// TestMetrics 测试指标
type TestMetrics struct {
	TotalCases        int     `json:"total_cases"`
	TotalTests        int     `json:"totalTests"`
	UnitTests         int     `json:"unitTests"`
	IntegrationTests  int     `json:"integrationTests"`
	PerformanceTests  int     `json:"performanceTests"`
	SecurityTests     int     `json:"securityTests"`
	Coverage          float64 `json:"coverage"`
	Complexity        string  `json:"complexity"`
	EstimatedTime     int     `json:"estimated_time"`
	QualityScore      float64 `json:"quality_score"`
}

// ==================== 项目相关模型 ====================

// Project 项目模型
type Project struct {
	ID          string                 `json:"id" db:"id"`
	UserID      string                 `json:"user_id" db:"user_id"`
	Name        string                 `json:"name" db:"name"`
	Description string                 `json:"description" db:"description"`
	Status      string                 `json:"status" db:"status"`
	Settings    map[string]interface{} `json:"settings" db:"settings"`
	Deadline    *time.Time             `json:"deadline" db:"deadline"`
	CreatedAt   time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time              `json:"updated_at" db:"updated_at"`
}

// ProjectMember 项目成员
type ProjectMember struct {
	ID        string    `json:"id" db:"id"`
	ProjectID string    `json:"project_id" db:"project_id"`
	UserID    string    `json:"user_id" db:"user_id"`
	Role      string    `json:"role" db:"role"`
	Status    string    `json:"status" db:"status"`
	JoinedAt  time.Time `json:"joined_at" db:"joined_at"`
}

// ==================== 任务相关模型 ====================

// Task 任务模型
type Task struct {
	ID            string                 `json:"id" db:"id"`
	ProjectID     string                 `json:"project_id" db:"project_id"`
	Title         string                 `json:"title" db:"title"`
	Description   string                 `json:"description" db:"description"`
	Status        string                 `json:"status" db:"status"`
	Priority      string                 `json:"priority" db:"priority"`
	AssigneeID    *string                `json:"assignee_id" db:"assignee_id"`
	CreatorID     string                 `json:"creator_id" db:"creator_id"`
	Tags          []string               `json:"tags" db:"tags"`
	Metadata      map[string]interface{} `json:"metadata" db:"metadata"`
	EstimatedHours int                   `json:"estimated_hours" db:"estimated_hours"`
	ActualHours   int                   `json:"actual_hours" db:"actual_hours"`
	DueDate       *time.Time             `json:"due_date" db:"due_date"`
	CompletedAt   *time.Time             `json:"completed_at" db:"completed_at"`
	CreatedAt     time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time              `json:"updated_at" db:"updated_at"`
}

// TaskComment 任务评论
type TaskComment struct {
	ID          string    `json:"id" db:"id"`
	TaskID      string    `json:"task_id" db:"task_id"`
	UserID      string    `json:"user_id" db:"user_id"`
	Content     string    `json:"content" db:"content"`
	Attachments []string  `json:"attachments" db:"attachments"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}

// ==================== PDF转换相关模型 ====================

// PDFConversionRequest PDF转换请求
type PDFConversionRequest struct {
	UserID       string `json:"user_id"`
	SourceFileURL string `json:"source_file_url" validate:"required"`
	SourceFormat string `json:"source_format" validate:"required"`
	TargetFormat string `json:"target_format" validate:"required"`
	Options      map[string]interface{} `json:"options"`
}

// PDFConversionResponse PDF转换响应
type PDFConversionResponse struct {
	ID            string     `json:"id" db:"id"`
	UserID        string     `json:"user_id" db:"user_id"`
	SourceFileURL string     `json:"source_file_url" db:"source_file_url"`
	TargetFileURL string     `json:"target_file_url" db:"target_file_url"`
	SourceFormat  string     `json:"source_format" db:"source_format"`
	TargetFormat  string     `json:"target_format" db:"target_format"`
	Status        string     `json:"status" db:"status"`
	FileSize      int        `json:"file_size" db:"file_size"`
	PageCount     int        `json:"page_count" db:"page_count"`
	ErrorMessage  string     `json:"error_message" db:"error_message"`
	CreatedAt     time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time  `json:"updated_at" db:"updated_at"`
}

// ==================== 爬虫相关模型 ====================

// CrawlerTask 爬虫任务
type CrawlerTask struct {
	ID           string                 `json:"id" db:"id"`
	UserID       string                 `json:"user_id" db:"user_id"`
	Name         string                 `json:"name" db:"name"`
	URL          string                 `json:"url" db:"url"`
	Status       string                 `json:"status" db:"status"`
	Config       map[string]interface{} `json:"config" db:"config"`
	Selectors    []string               `json:"selectors" db:"selectors"`
	MaxPages     int                    `json:"max_pages" db:"max_pages"`
	DelayMs      int                    `json:"delay_ms" db:"delay_ms"`
	FollowLinks  bool                   `json:"follow_links" db:"follow_links"`
	RespectRobots bool                  `json:"respect_robots" db:"respect_robots"`
	StartedAt    *time.Time             `json:"started_at" db:"started_at"`
	CompletedAt  *time.Time             `json:"completed_at" db:"completed_at"`
	CreatedAt    time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time              `json:"updated_at" db:"updated_at"`
}

// CrawlerResult 爬虫结果
type CrawlerResult struct {
	ID           string                 `json:"id" db:"id"`
	TaskID       string                 `json:"task_id" db:"task_id"`
	URL          string                 `json:"url" db:"url"`
	Data         map[string]interface{} `json:"data" db:"data"`
	StatusCode   int                    `json:"status_code" db:"status_code"`
	ResponseTime int                    `json:"response_time" db:"response_time"`
	Headers      map[string]interface{} `json:"headers" db:"headers"`
	CrawledAt    time.Time              `json:"crawled_at" db:"crawled_at"`
}

// ==================== API测试相关模型 ====================

// APITestSuite API测试套件
type APITestSuite struct {
	ID          string                 `json:"id" db:"id"`
	UserID      string                 `json:"user_id" db:"user_id"`
	Name        string                 `json:"name" db:"name"`
	Description string                 `json:"description" db:"description"`
	BaseURL     string                 `json:"base_url" db:"base_url"`
	Headers     map[string]interface{} `json:"headers" db:"headers"`
	Variables   map[string]interface{} `json:"variables" db:"variables"`
	Status      string                 `json:"status" db:"status"`
	CreatedAt   time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time              `json:"updated_at" db:"updated_at"`
}

// APITestCase API测试用例
type APITestCase struct {
	ID              string                 `json:"id" db:"id"`
	SuiteID         string                 `json:"suite_id" db:"suite_id"`
	Name            string                 `json:"name" db:"name"`
	Method          string                 `json:"method" db:"method"`
	Endpoint        string                 `json:"endpoint" db:"endpoint"`
	Headers         map[string]interface{} `json:"headers" db:"headers"`
	Params          map[string]interface{} `json:"params" db:"params"`
	Body            map[string]interface{} `json:"body" db:"body"`
	Assertions      map[string]interface{} `json:"assertions" db:"assertions"`
	ExpectedStatus  int                    `json:"expected_status" db:"expected_status"`
	Timeout         int                    `json:"timeout" db:"timeout"`
	Enabled         bool                   `json:"enabled" db:"enabled"`
	CreatedAt       time.Time              `json:"created_at" db:"created_at"`
}

// APITestResult API测试结果
type APITestResult struct {
	ID              string                 `json:"id" db:"id"`
	TestCaseID      string                 `json:"test_case_id" db:"test_case_id"`
	Status          string                 `json:"status" db:"status"`
	ResponseStatus  int                    `json:"response_status" db:"response_status"`
	ResponseTime    int                    `json:"response_time" db:"response_time"`
	ResponseBody    map[string]interface{} `json:"response_body" db:"response_body"`
	ResponseHeaders map[string]interface{} `json:"response_headers" db:"response_headers"`
	Errors          []string               `json:"errors" db:"errors"`
	Warnings        []string               `json:"warnings" db:"warnings"`
	ExecutedAt      time.Time              `json:"executed_at" db:"executed_at"`
}

// ==================== 代码审查相关模型 ====================

// CodeReview 代码审查
type CodeReview struct {
	ID          string     `json:"id" db:"id"`
	Title       string     `json:"title" db:"title"`
	Description string     `json:"description" db:"description"`
	Repository  string     `json:"repository" db:"repository"`
	Branch      string     `json:"branch" db:"branch"`
	CommitHash  string     `json:"commit_hash" db:"commit_hash"`
	AuthorID    *string    `json:"author_id" db:"author_id"`
	ReviewerID  *string    `json:"reviewer_id" db:"reviewer_id"`
	Status      string     `json:"status" db:"status"`
	Files       []string   `json:"files" db:"files"`
	CreatedAt   time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time  `json:"updated_at" db:"updated_at"`
	ReviewedAt  *time.Time `json:"reviewed_at" db:"reviewed_at"`
}

// CodeReviewComment 代码审查评论
type CodeReviewComment struct {
	ID        string    `json:"id" db:"id"`
	ReviewID  string    `json:"review_id" db:"review_id"`
	AuthorID  string    `json:"author_id" db:"author_id"`
	Content   string    `json:"content" db:"content"`
	File      string    `json:"file" db:"file"`
	Line      int       `json:"line" db:"line"`
	Type      string    `json:"type" db:"type"`
	Resolved  bool      `json:"resolved" db:"resolved"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// ==================== 应用相关模型 ====================

// App 应用模型
type App struct {
	ID          string                 `json:"id" db:"id"`
	Name        string                 `json:"name" db:"name"`
	Description string                 `json:"description" db:"description"`
	Category    string                 `json:"category" db:"category"`
	Icon        string                 `json:"icon" db:"icon"`
	Color       string                 `json:"color" db:"color"`
	Version     string                 `json:"version" db:"version"`
	IsPremium   bool                   `json:"is_premium" db:"is_premium"`
	IsActive    bool                   `json:"is_active" db:"is_active"`
	Features    []string               `json:"features" db:"features"`
	Screenshots []string               `json:"screenshots" db:"screenshots"`
	CreatedAt   time.Time              `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time              `json:"updated_at" db:"updated_at"`
}

// ==================== 通用响应模型 ====================

// APIResponse 通用API响应
type APIResponse struct {
	Success bool        `json:"success"`
	Message string      `json:"message"`
	Data    interface{} `json:"data,omitempty"`
	Error   string      `json:"error,omitempty"`
}

// PaginatedResponse 分页响应
type PaginatedResponse struct {
	Data       interface{} `json:"data"`
	Pagination Pagination  `json:"pagination"`
}

// Pagination 分页信息
type Pagination struct {
	Page       int `json:"page"`
	PerPage    int `json:"per_page"`
	Total      int `json:"total"`
	TotalPages int `json:"total_pages"`
}

// ==================== 会员相关模型 ====================

// MembershipPlan 会员计划
type MembershipPlan struct {
	ID          string  `json:"id"`
	Name        string  `json:"name"`
	Description string  `json:"description"`
	Price       float64 `json:"price"`
	Currency    string  `json:"currency"`
	Duration    int     `json:"duration"` // 天数
	MaxApps     int     `json:"max_apps"`
	Features    []string `json:"features"`
	IsActive    bool    `json:"is_active"`
}

// Subscription 订阅
type Subscription struct {
	ID           string     `json:"id" db:"id"`
	UserID       string     `json:"user_id" db:"user_id"`
	PlanID       string     `json:"plan_id" db:"plan_id"`
	Status       string     `json:"status" db:"status"`
	StartDate    time.Time  `json:"start_date" db:"start_date"`
	EndDate      time.Time  `json:"end_date" db:"end_date"`
	AutoRenew    bool       `json:"auto_renew" db:"auto_renew"`
	PaymentMethod string    `json:"payment_method" db:"payment_method"`
	CreatedAt    time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time  `json:"updated_at" db:"updated_at"`
}

// ==================== 支付相关模型 ====================

// PaymentRequest 支付请求
type PaymentRequest struct {
	UserID      string  `json:"user_id" validate:"required"`
	PlanID      string  `json:"plan_id" validate:"required"`
	Amount      float64 `json:"amount" validate:"required,min=0"`
	Currency    string  `json:"currency" validate:"required"`
	PaymentMethod string `json:"payment_method" validate:"required"`
	ReturnURL   string  `json:"return_url"`
	CancelURL   string  `json:"cancel_url"`
}

// PaymentResponse 支付响应
type PaymentResponse struct {
	ID            string `json:"id"`
	UserID        string `json:"user_id"`
	Status        string `json:"status"`
	PaymentURL    string `json:"payment_url"`
	ClientSecret  string `json:"client_secret"`
	Amount        float64 `json:"amount"`
	Currency      string `json:"currency"`
	CreatedAt     time.Time `json:"created_at"`
	CompletedAt   *time.Time `json:"completed_at"`
}

// Invoice 发票
type Invoice struct {
	ID            string `json:"id"`
	PaymentID      string `json:"payment_id"`
	UserID         string `json:"user_id"`
	UserName       string `json:"user_name"`
	UserEmail      string `json:"user_email"`
	Amount         float64 `json:"amount"`
	Currency       string `json:"currency"`
	Status         string `json:"status"`
	InvoiceNumber  string `json:"invoice_number"`
	CreatedAt      time.Time `json:"created_at"`
}

// Refund 退款
type Refund struct {
	ID              string `json:"id"`
	PaymentID       string `json:"payment_id"`
	Amount          float64 `json:"amount"`
	Currency        string `json:"currency"`
	Status          string `json:"status"`
	Reason          string `json:"reason"`
	StripeRefundID  string `json:"stripe_refund_id"`
	CreatedAt       time.Time `json:"created_at"`
}

// ==================== 扩展测试相关模型 ====================

// BatchTestGenerationRequest 批量测试生成请求
type BatchTestGenerationRequest struct {
	CodeFiles []string               `json:"codeFiles"`
	Language  string                 `json:"language"`
	Framework string                 `json:"framework"`
	Options   map[string]interface{} `json:"options"`
}

// BatchTestGenerationResponse 批量测试生成响应
type BatchTestGenerationResponse struct {
	BatchID        string                   `json:"batchId"`
	Results        []TestGenerationResponse `json:"results"`
	Status         string                   `json:"status"`
	TotalFiles     int                      `json:"totalFiles"`
	CompletedFiles int                      `json:"completedFiles"`
	CreatedAt      time.Time                `json:"createdAt"`
}

// UnitTestRequest 单元测试请求
type UnitTestRequest struct {
	FunctionCode string                 `json:"functionCode"`
	Language     string                 `json:"language"`
	Options      map[string]interface{} `json:"options"`
}

// UnitTestResponse 单元测试响应
type UnitTestResponse struct {
	ID          string     `json:"id"`
	UnitTests   []TestCase `json:"unitTests"`
	Status      string     `json:"status"`
	GeneratedAt time.Time  `json:"generatedAt"`
}

// IntegrationTestRequest 集成测试请求
type IntegrationTestRequest struct {
	ServiceCode  string                 `json:"serviceCode"`
	Language     string                 `json:"language"`
	Dependencies []string               `json:"dependencies"`
	Options      map[string]interface{} `json:"options"`
}

// IntegrationTestResponse 集成测试响应
type IntegrationTestResponse struct {
	ID               string     `json:"id"`
	IntegrationTests []TestCase `json:"integrationTests"`
	Status           string     `json:"status"`
	GeneratedAt      time.Time  `json:"generatedAt"`
}

// PerformanceTestRequest 性能测试请求
type PerformanceTestRequest struct {
	Code            string                 `json:"code"`
	Language        string                 `json:"language"`
	BenchmarkOptions map[string]interface{} `json:"benchmarkOptions"`
}

// PerformanceTestResponse 性能测试响应
type PerformanceTestResponse struct {
	ID               string     `json:"id"`
	PerformanceTests []TestCase `json:"performanceTests"`
	Status           string     `json:"status"`
	GeneratedAt      time.Time  `json:"generatedAt"`
}

// SecurityTestRequest 安全测试请求
type SecurityTestRequest struct {
	Code               string                 `json:"code"`
	Language           string                 `json:"language"`
	VulnerabilityTypes []string               `json:"vulnerabilityTypes"`
	Options            map[string]interface{} `json:"options"`
}

// SecurityTestResponse 安全测试响应
type SecurityTestResponse struct {
	ID            string     `json:"id"`
	SecurityTests []TestCase `json:"securityTests"`
	Status        string     `json:"status"`
	GeneratedAt   time.Time  `json:"generatedAt"`
}

// TestQualityAnalysisRequest 测试质量分析请求
type TestQualityAnalysisRequest struct {
	TestCases []TestCase               `json:"testCases"`
	CodeBase  string                   `json:"codeBase"`
	Options   map[string]interface{}   `json:"options"`
}

// TestQualityAnalysisResponse 测试质量分析响应
type TestQualityAnalysisResponse struct {
	ID         string            `json:"id"`
	Report     TestQualityReport `json:"report"`
	Status     string            `json:"status"`
	AnalyzedAt time.Time         `json:"analyzedAt"`
}

// TestQualityReport 测试质量报告
type TestQualityReport struct {
	CoverageScore    float64  `json:"coverageScore"`
	QualityScore     float64  `json:"qualityScore"`
	DuplicateTests   int      `json:"duplicateTests"`
	MissingTests     int      `json:"missingTests"`
	Recommendations  []string `json:"recommendations"`
}

// CoverageAnalysisRequest 覆盖率分析请求
type CoverageAnalysisRequest struct {
	CodeBase  string                 `json:"codeBase"`
	TestCases []TestCase             `json:"testCases"`
	Options   map[string]interface{} `json:"options"`
}

// CoverageAnalysisResponse 覆盖率分析响应
type CoverageAnalysisResponse struct {
	ID         string         `json:"id"`
	Report     CoverageReport `json:"report"`
	Status     string         `json:"status"`
	AnalyzedAt time.Time      `json:"analyzedAt"`
}

// CoverageReport 覆盖率报告
type CoverageReport struct {
	LineCoverage        float64  `json:"lineCoverage"`
	FunctionCoverage    float64  `json:"functionCoverage"`
	BranchCoverage      float64  `json:"branchCoverage"`
	UncoveredLines      []string `json:"uncoveredLines"`
	UncoveredFunctions  []string `json:"uncoveredFunctions"`
}

// ==================== 工具函数 ====================

// generateID 生成唯一ID
func generateID() string {
	// 这里应该使用UUID生成器
	// 为了简化，使用时间戳
	return "id_" + string(rune(time.Now().UnixNano()))
}
