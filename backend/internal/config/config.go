package config

import (
	"os"
	"strconv"
	"strings"
	"github.com/joho/godotenv"
)

type Config struct {
	// 基础配置
	Environment string
	Port        string
	Version     string
	Host        string
	Debug       bool
	
	// 数据库配置
	DatabaseURL string
	DBHost      string
	DBPort      string
	DBName      string
	DBUser      string
	DBPassword  string
	DBSSLMode   string
	
	// Redis配置
	RedisURL    string
	RedisHost   string
	RedisPort   string
	RedisPassword string
	RedisDB     int
	
	// JWT配置
	JWTSecret     string
	JWTExpireHours int
	
	// AI服务配置
	DeepSeekAPIKey    string
	DeepSeekBaseURL   string
	AIMLAPIKey        string
	AIMLAPIBaseURL    string
	TencentSecretID   string
	TencentSecretKey  string
	TencentRegion     string
	GroqAPIKey        string
	GroqBaseURL       string
	AIToolsAPIKey     string
	AIToolsBaseURL    string
	TogetherAPIKey    string
	TogetherBaseURL   string
	OpenRouterAPIKey  string
	OpenRouterBaseURL string
	XunfeiAPIKey      string
	XunfeiAppID       string
	BaiduAPIKey       string
	BaiduSecretKey    string
	BytedanceAPIKey   string
	BytedanceBaseURL  string
	SiliconFlowAPIKey string
	SiliconFlowBaseURL string
	
	// 地图和位置服务
	AmapAPIKey  string
	AmapBaseURL string
	
	// 图片和媒体服务
	PixabayAPIKey  string
	PixabayBaseURL string
	
	// 天气服务
	OpenWeatherAPIKey  string
	OpenWeatherBaseURL string
	
	// 搜索引擎服务
	GoogleAPIKey  string
	GoogleCSEID   string
	GoogleBaseURL string
	
	// OAuth认证服务
	GoogleOAuthClientID     string
	GoogleOAuthClientSecret string
	GoogleOAuthRedirectURL  string
	
	// 邮件服务
	EmailHost     string
	EmailPort     int
	EmailUser     string
	EmailPassword string
	EmailUseTLS   bool
	EmailFromName string
	
	// 支付服务
	StripeSecretKey      string
	StripePublishableKey string
	StripeWebhookSecret  string
	
	// 文件存储
	UploadDir         string
	MaxFileSize       int64
	AllowedFileTypes  []string
	
	// 日志配置
	LogLevel      string
	LogFormat     string
	LogFile       string
	LogMaxSize    int
	LogMaxBackups int
	LogMaxAge     int
	
	// 监控配置
	PrometheusEnabled bool
	PrometheusPort    string
	
	// 安全配置
	CORSAllowedOrigins []string
	CORSAllowedMethods []string
	CORSAllowedHeaders []string
	
	// 限流配置
	RateLimitEnabled         bool
	RateLimitRequestsPerMinute int
	RateLimitBurst          int
}

func Load() *Config {
	// 加载环境变量文件
	godotenv.Load("env.local")
	
	return &Config{
		// 基础配置
		Environment: getEnv("APP_ENV", "development"),
		Port:        getEnv("APP_PORT", "8080"),
		Version:     getEnv("APP_VERSION", "1.0.0"),
		Host:        getEnv("APP_HOST", "0.0.0.0"),
		Debug:       getEnvAsBool("DEBUG", true),
		
		// 数据库配置
		DatabaseURL: getEnv("DATABASE_URL", "postgres://gaojie@localhost/qatoolbox_local?sslmode=disable"),
		DBHost:      getEnv("DB_HOST", "localhost"),
		DBPort:      getEnv("DB_PORT", "5432"),
		DBName:      getEnv("DB_NAME", "qatoolbox_local"),
		DBUser:      getEnv("DB_USER", "gaojie"),
		DBPassword:  getEnv("DB_PASSWORD", ""),
		DBSSLMode:   getEnv("DB_SSLMODE", "disable"),
		
		// Redis配置
		RedisURL:      getEnv("REDIS_URL", "redis://localhost:6379/0"),
		RedisHost:     getEnv("REDIS_HOST", "localhost"),
		RedisPort:     getEnv("REDIS_PORT", "6379"),
		RedisPassword: getEnv("REDIS_PASSWORD", ""),
		RedisDB:       getEnvAsInt("REDIS_DB", 0),
		
		// JWT配置
		JWTSecret:      getEnv("JWT_SECRET", "your-jwt-secret-key-here"),
		JWTExpireHours: getEnvAsInt("JWT_EXPIRE_HOURS", 24),
		
		// AI服务配置
		DeepSeekAPIKey:    getEnv("DEEPSEEK_API_KEY", ""),
		DeepSeekBaseURL:   getEnv("DEEPSEEK_BASE_URL", "https://api.deepseek.com/v1"),
		AIMLAPIKey:        getEnv("AIMLAPI_API_KEY", ""),
		AIMLAPIBaseURL:    getEnv("AIMLAPI_BASE_URL", "https://api.aimlapi.com/v1"),
		TencentSecretID:   getEnv("TENCENT_SECRET_ID", ""),
		TencentSecretKey:  getEnv("TENCENT_SECRET_KEY", ""),
		TencentRegion:     getEnv("TENCENT_REGION", "ap-beijing"),
		GroqAPIKey:        getEnv("GROQ_API_KEY", ""),
		GroqBaseURL:       getEnv("GROQ_BASE_URL", "https://api.groq.com/openai/v1"),
		AIToolsAPIKey:     getEnv("AITOOLS_API_KEY", ""),
		AIToolsBaseURL:    getEnv("AITOOLS_BASE_URL", "https://api.aitools.cfd/v1"),
		TogetherAPIKey:    getEnv("TOGETHER_API_KEY", ""),
		TogetherBaseURL:   getEnv("TOGETHER_BASE_URL", "https://api.together.xyz/v1"),
		OpenRouterAPIKey:  getEnv("OPENROUTER_API_KEY", ""),
		OpenRouterBaseURL: getEnv("OPENROUTER_BASE_URL", "https://openrouter.ai/api/v1"),
		XunfeiAPIKey:     getEnv("XUNFEI_API_KEY", ""),
		XunfeiAppID:      getEnv("XUNFEI_APP_ID", ""),
		BaiduAPIKey:      getEnv("BAIDU_API_KEY", ""),
		BaiduSecretKey:   getEnv("BAIDU_SECRET_KEY", ""),
		BytedanceAPIKey:  getEnv("BYTEDANCE_API_KEY", ""),
		BytedanceBaseURL: getEnv("BYTEDANCE_BASE_URL", "https://ark.cn-beijing.volces.com/api/v3"),
		SiliconFlowAPIKey: getEnv("SILICONFLOW_API_KEY", ""),
		SiliconFlowBaseURL: getEnv("SILICONFLOW_BASE_URL", "https://api.siliconflow.cn/v1"),
		
		// 地图和位置服务
		AmapAPIKey:  getEnv("AMAP_API_KEY", ""),
		AmapBaseURL: getEnv("AMAP_BASE_URL", "https://restapi.amap.com/v3"),
		
		// 图片和媒体服务
		PixabayAPIKey:  getEnv("PIXABAY_API_KEY", ""),
		PixabayBaseURL: getEnv("PIXABAY_BASE_URL", "https://pixabay.com/api"),
		
		// 天气服务
		OpenWeatherAPIKey:  getEnv("OPENWEATHER_API_KEY", ""),
		OpenWeatherBaseURL: getEnv("OPENWEATHER_BASE_URL", "https://api.openweathermap.org/data/2.5"),
		
		// 搜索引擎服务
		GoogleAPIKey:  getEnv("GOOGLE_API_KEY", ""),
		GoogleCSEID:   getEnv("GOOGLE_CSE_ID", ""),
		GoogleBaseURL: getEnv("GOOGLE_BASE_URL", "https://www.googleapis.com/customsearch/v1"),
		
		// OAuth认证服务
		GoogleOAuthClientID:     getEnv("GOOGLE_OAUTH_CLIENT_ID", ""),
		GoogleOAuthClientSecret: getEnv("GOOGLE_OAUTH_CLIENT_SECRET", ""),
		GoogleOAuthRedirectURL:  getEnv("GOOGLE_OAUTH_REDIRECT_URL", "http://localhost:8080/auth/google/callback"),
		
		// 邮件服务
		EmailHost:     getEnv("EMAIL_HOST", "smtp.qq.com"),
		EmailPort:     getEnvAsInt("EMAIL_PORT", 587),
		EmailUser:     getEnv("EMAIL_HOST_USER", ""),
		EmailPassword: getEnv("EMAIL_HOST_PASSWORD", ""),
		EmailUseTLS:   getEnvAsBool("EMAIL_USE_TLS", true),
		EmailFromName: getEnv("EMAIL_FROM_NAME", "QAToolBox"),
		
		// 支付服务
		StripeSecretKey:      getEnv("STRIPE_SECRET_KEY", ""),
		StripePublishableKey: getEnv("STRIPE_PUBLISHABLE_KEY", ""),
		StripeWebhookSecret:  getEnv("STRIPE_WEBHOOK_SECRET", ""),
		
		// 文件存储
		UploadDir:        getEnv("UPLOAD_DIR", "./uploads"),
		MaxFileSize:      getEnvAsInt64("MAX_FILE_SIZE", 10485760), // 10MB
		AllowedFileTypes: getEnvStringSlice("ALLOWED_FILE_TYPES", []string{"jpg", "jpeg", "png", "gif", "pdf", "doc", "docx", "xls", "xlsx", "ppt", "pptx"}),
		
		// 日志配置
		LogLevel:      getEnv("LOG_LEVEL", "info"),
		LogFormat:     getEnv("LOG_FORMAT", "json"),
		LogFile:       getEnv("LOG_FILE", "./logs/app.log"),
		LogMaxSize:    getEnvAsInt("LOG_MAX_SIZE", 100),
		LogMaxBackups: getEnvAsInt("LOG_MAX_BACKUPS", 3),
		LogMaxAge:     getEnvAsInt("LOG_MAX_AGE", 28),
		
		// 监控配置
		PrometheusEnabled: getEnvAsBool("PROMETHEUS_ENABLED", true),
		PrometheusPort:    getEnv("PROMETHEUS_PORT", "9090"),
		
		// 安全配置
		CORSAllowedOrigins: getEnvStringSlice("CORS_ALLOWED_ORIGINS", []string{"http://localhost:3000", "http://localhost:8080"}),
		CORSAllowedMethods: getEnvStringSlice("CORS_ALLOWED_METHODS", []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"}),
		CORSAllowedHeaders: getEnvStringSlice("CORS_ALLOWED_HEADERS", []string{"Content-Type", "Authorization", "X-Requested-With"}),
		
		// 限流配置
		RateLimitEnabled:         getEnvAsBool("RATE_LIMIT_ENABLED", true),
		RateLimitRequestsPerMinute: getEnvAsInt("RATE_LIMIT_REQUESTS_PER_MINUTE", 60),
		RateLimitBurst:          getEnvAsInt("RATE_LIMIT_BURST", 10),
	}
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

func getEnvAsInt(key string, defaultValue int) int {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.Atoi(value); err == nil {
			return intValue
		}
	}
	return defaultValue
}

func getEnvAsInt64(key string, defaultValue int64) int64 {
	if value := os.Getenv(key); value != "" {
		if intValue, err := strconv.ParseInt(value, 10, 64); err == nil {
			return intValue
		}
	}
	return defaultValue
}

func getEnvAsBool(key string, defaultValue bool) bool {
	if value := os.Getenv(key); value != "" {
		if boolValue, err := strconv.ParseBool(value); err == nil {
			return boolValue
		}
	}
	return defaultValue
}

func getEnvStringSlice(key string, defaultValue []string) []string {
	if value := os.Getenv(key); value != "" {
		return strings.Split(value, ",")
	}
	return defaultValue
}