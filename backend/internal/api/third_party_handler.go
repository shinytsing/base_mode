package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/services"
)

// 第三方服务处理器
type ThirdPartyHandler struct {
	services *services.Services
}

// 创建第三方服务处理器
func NewThirdPartyHandler(services *services.Services) *ThirdPartyHandler {
	return &ThirdPartyHandler{
		services: services,
	}
}

// ==================== 高德地图服务 ====================

// 地理编码请求
type AmapGeocodeRequest struct {
	Address string `json:"address" binding:"required"`
}

// 地理编码响应
type AmapGeocodeResponse struct {
	Status   string `json:"status"`
	Info     string `json:"info"`
	Infocode string `json:"infocode"`
	Count    string `json:"count"`
	Geocodes []struct {
		FormattedAddress string `json:"formatted_address"`
		Province         string `json:"province"`
		City             string `json:"city"`
		District         string `json:"district"`
		Township         string `json:"township"`
		Neighborhood     struct {
			Name string `json:"name"`
		} `json:"neighborhood"`
		Building struct {
			Name string `json:"name"`
		} `json:"building"`
		Adcode   string `json:"adcode"`
		Location string `json:"location"`
		Level    string `json:"level"`
	} `json:"geocodes"`
}

// 逆地理编码请求
type AmapRegeocodeRequest struct {
	Longitude float64 `json:"longitude" binding:"required"`
	Latitude  float64 `json:"latitude" binding:"required"`
}

// 逆地理编码响应
type AmapRegeocodeResponse struct {
	Status   string `json:"status"`
	Info     string `json:"info"`
	Infocode string `json:"infocode"`
	Regeocode struct {
		FormattedAddress string `json:"formatted_address"`
		AddressComponent struct {
			Province string `json:"province"`
			City     string `json:"city"`
			District string `json:"district"`
			Township string `json:"township"`
		} `json:"addressComponent"`
		Location string `json:"location"`
	} `json:"regeocode"`
}

// 地理编码（地址转坐标）
func (h *ThirdPartyHandler) AmapGeocode(c *gin.Context) {
	var req AmapGeocodeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	resp, err := h.services.ThirdPartyClientManager.AmapGeocode(c.Request.Context(), req.Address)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "地理编码失败: " + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// 逆地理编码（坐标转地址）
func (h *ThirdPartyHandler) AmapRegeocode(c *gin.Context) {
	var req AmapRegeocodeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	resp, err := h.services.ThirdPartyClientManager.AmapRegeocode(c.Request.Context(), req.Longitude, req.Latitude)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "逆地理编码失败: " + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// ==================== Pixabay图片服务 ====================

// Pixabay搜索请求
type PixabaySearchRequest struct {
	Query      string `json:"query" binding:"required"`
	Category   string `json:"category,omitempty"`
	MinWidth   int    `json:"min_width,omitempty"`
	MinHeight  int    `json:"min_height,omitempty"`
	PerPage    int    `json:"per_page,omitempty"`
}

// Pixabay搜索响应
type PixabaySearchResponse struct {
	Total     int `json:"total"`
	TotalHits int `json:"totalHits"`
	Hits      []struct {
		ID         int    `json:"id"`
		PageURL    string `json:"pageURL"`
		Type       string `json:"type"`
		Tags       string `json:"tags"`
		PreviewURL string `json:"previewURL"`
		PreviewWidth int `json:"previewWidth"`
		PreviewHeight int `json:"previewHeight"`
		WebformatURL string `json:"webformatURL"`
		WebformatWidth int `json:"webformatWidth"`
		WebformatHeight int `json:"webformatHeight"`
		LargeImageURL string `json:"largeImageURL"`
		ImageWidth int `json:"imageWidth"`
		ImageHeight int `json:"imageHeight"`
		ImageSize int `json:"imageSize"`
		Views int `json:"views"`
		Downloads int `json:"downloads"`
		Collections int `json:"collections"`
		Likes int `json:"likes"`
		Comments int `json:"comments"`
		UserID int `json:"user_id"`
		User string `json:"user"`
		UserImageURL string `json:"userImageURL"`
	} `json:"hits"`
}

// 搜索图片
func (h *ThirdPartyHandler) PixabaySearchImages(c *gin.Context) {
	var req PixabaySearchRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	// 设置默认值
	if req.Category == "" {
		req.Category = "all"
	}
	if req.MinWidth == 0 {
		req.MinWidth = 100
	}
	if req.MinHeight == 0 {
		req.MinHeight = 100
	}
	if req.PerPage == 0 {
		req.PerPage = 20
	}

	resp, err := h.services.ThirdPartyClientManager.PixabaySearchImages(
		c.Request.Context(),
		req.Query,
		req.Category,
		req.MinWidth,
		req.MinHeight,
		req.PerPage,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "搜索图片失败: " + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// ==================== OpenWeather天气服务 ====================

// 天气查询请求
type OpenWeatherRequest struct {
	City        string `json:"city" binding:"required"`
	CountryCode string `json:"country_code,omitempty"`
}

// 天气查询响应
type OpenWeatherResponse struct {
	Coord struct {
		Lon float64 `json:"lon"`
		Lat float64 `json:"lat"`
	} `json:"coord"`
	Weather []struct {
		ID          int    `json:"id"`
		Main        string `json:"main"`
		Description string `json:"description"`
		Icon        string `json:"icon"`
	} `json:"weather"`
	Base string `json:"base"`
	Main struct {
		Temp      float64 `json:"temp"`
		FeelsLike float64 `json:"feels_like"`
		TempMin   float64 `json:"temp_min"`
		TempMax   float64 `json:"temp_max"`
		Pressure  int     `json:"pressure"`
		Humidity  int     `json:"humidity"`
	} `json:"main"`
	Visibility int `json:"visibility"`
	Wind struct {
		Speed float64 `json:"speed"`
		Deg   int     `json:"deg"`
	} `json:"wind"`
	Clouds struct {
		All int `json:"all"`
	} `json:"clouds"`
	Dt  int `json:"dt"`
	Sys struct {
		Type    int    `json:"type"`
		ID      int    `json:"id"`
		Country string `json:"country"`
		Sunrise int    `json:"sunrise"`
		Sunset  int    `json:"sunset"`
	} `json:"sys"`
	Timezone int    `json:"timezone"`
	ID       int    `json:"id"`
	Name     string `json:"name"`
	Cod      int    `json:"cod"`
}

// 获取天气信息
func (h *ThirdPartyHandler) OpenWeatherGetWeather(c *gin.Context) {
	var req OpenWeatherRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	// 设置默认国家代码
	if req.CountryCode == "" {
		req.CountryCode = "CN"
	}

	resp, err := h.services.ThirdPartyClientManager.OpenWeatherGetWeather(
		c.Request.Context(),
		req.City,
		req.CountryCode,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "获取天气信息失败: " + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// ==================== Google搜索服务 ====================

// Google搜索请求
type GoogleSearchRequest struct {
	Query string `json:"query" binding:"required"`
	Num   int    `json:"num,omitempty"`
}

// Google搜索响应
type GoogleSearchResponse struct {
	Kind string `json:"kind"`
	URL struct {
		Type     string `json:"type"`
		Template string `json:"template"`
	} `json:"url"`
	Queries struct {
		Request []struct {
			Title          string `json:"title"`
			TotalResults   string `json:"totalResults"`
			SearchTerms    string `json:"searchTerms"`
			Count          int    `json:"count"`
			StartIndex     int    `json:"startIndex"`
			InputEncoding  string `json:"inputEncoding"`
			OutputEncoding string `json:"outputEncoding"`
			Safe           string `json:"safe"`
			Cx             string `json:"cx"`
		} `json:"request"`
	} `json:"queries"`
	Context struct {
		Title string `json:"title"`
	} `json:"context"`
	SearchInformation struct {
		SearchTime            float64 `json:"searchTime"`
		FormattedSearchTime   string  `json:"formattedSearchTime"`
		TotalResults          string  `json:"totalResults"`
		FormattedTotalResults string  `json:"formattedTotalResults"`
	} `json:"searchInformation"`
	Items []struct {
		Kind        string `json:"kind"`
		Title       string `json:"title"`
		HTMLTitle   string `json:"htmlTitle"`
		Link        string `json:"link"`
		DisplayLink string `json:"displayLink"`
		Snippet     string `json:"snippet"`
		HTMLSnippet string `json:"htmlSnippet"`
		FormattedURL string `json:"formattedUrl"`
		Pagemap     struct {
			Metatags []struct {
				Title       string `json:"title"`
				Description string `json:"description"`
			} `json:"metatags"`
		} `json:"pagemap"`
	} `json:"items"`
}

// Google搜索
func (h *ThirdPartyHandler) GoogleSearch(c *gin.Context) {
	var req GoogleSearchRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	// 设置默认搜索结果数量
	if req.Num == 0 {
		req.Num = 10
	}

	resp, err := h.services.ThirdPartyClientManager.GoogleSearch(
		c.Request.Context(),
		req.Query,
		req.Num,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "Google搜索失败: " + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// ==================== 邮件服务 ====================

// 邮件发送请求
type EmailSendRequest struct {
	To      []string `json:"to" binding:"required"`
	Subject string   `json:"subject" binding:"required"`
	Body    string   `json:"body" binding:"required"`
	IsHTML  bool     `json:"is_html,omitempty"`
}

// 邮件发送响应
type EmailSendResponse struct {
	Success bool   `json:"success"`
	Message string `json:"message"`
}

// 发送邮件
func (h *ThirdPartyHandler) SendEmail(c *gin.Context) {
	var req EmailSendRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error": "请求参数错误: " + err.Error(),
		})
		return
	}

	emailContent := &services.EmailContent{
		To:      req.To,
		Subject: req.Subject,
		Body:    req.Body,
		IsHTML:  req.IsHTML,
	}

	err := h.services.ThirdPartyClientManager.SendEmail(c.Request.Context(), emailContent)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"error": "发送邮件失败: " + err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, EmailSendResponse{
		Success: true,
		Message: "邮件发送成功",
	})
}

// ==================== 服务状态检查 ====================

// 服务状态响应
type ServiceStatusResponse struct {
	Service string `json:"service"`
	Status  string `json:"status"`
	Message string `json:"message"`
}

// 检查服务状态
func (h *ThirdPartyHandler) CheckServiceStatus(c *gin.Context) {
	service := c.Param("service")
	
	var status string
	var message string
	
	switch service {
	case "amap":
		if h.services.Config.AmapAPIKey != "" {
			status = "available"
			message = "高德地图服务可用"
		} else {
			status = "unavailable"
			message = "高德地图API密钥未配置"
		}
	case "pixabay":
		if h.services.Config.PixabayAPIKey != "" {
			status = "available"
			message = "Pixabay服务可用"
		} else {
			status = "unavailable"
			message = "Pixabay API密钥未配置"
		}
	case "openweather":
		if h.services.Config.OpenWeatherAPIKey != "" {
			status = "available"
			message = "OpenWeather服务可用"
		} else {
			status = "unavailable"
			message = "OpenWeather API密钥未配置"
		}
	case "google":
		if h.services.Config.GoogleAPIKey != "" && h.services.Config.GoogleCSEID != "" {
			status = "available"
			message = "Google搜索服务可用"
		} else {
			status = "unavailable"
			message = "Google API密钥或自定义搜索引擎ID未配置"
		}
	case "email":
		if h.services.Config.EmailHost != "" && h.services.Config.EmailUser != "" && h.services.Config.EmailPassword != "" {
			status = "available"
			message = "邮件服务可用"
		} else {
			status = "unavailable"
			message = "邮件服务配置不完整"
		}
	default:
		c.JSON(http.StatusNotFound, gin.H{
			"error": "未知服务: " + service,
		})
		return
	}

	c.JSON(http.StatusOK, ServiceStatusResponse{
		Service: service,
		Status:  status,
		Message: message,
	})
}

// 获取所有服务状态
func (h *ThirdPartyHandler) GetAllServiceStatus(c *gin.Context) {
	services := []string{"amap", "pixabay", "openweather", "google", "email"}
	var statuses []ServiceStatusResponse
	
	for _, service := range services {
		var status string
		var message string
		
		switch service {
		case "amap":
			if h.services.Config.AmapAPIKey != "" {
				status = "available"
				message = "高德地图服务可用"
			} else {
				status = "unavailable"
				message = "高德地图API密钥未配置"
			}
		case "pixabay":
			if h.services.Config.PixabayAPIKey != "" {
				status = "available"
				message = "Pixabay服务可用"
			} else {
				status = "unavailable"
				message = "Pixabay API密钥未配置"
			}
		case "openweather":
			if h.services.Config.OpenWeatherAPIKey != "" {
				status = "available"
				message = "OpenWeather服务可用"
			} else {
				status = "unavailable"
				message = "OpenWeather API密钥未配置"
			}
		case "google":
			if h.services.Config.GoogleAPIKey != "" && h.services.Config.GoogleCSEID != "" {
				status = "available"
				message = "Google搜索服务可用"
			} else {
				status = "unavailable"
				message = "Google API密钥或自定义搜索引擎ID未配置"
			}
		case "email":
			if h.services.Config.EmailHost != "" && h.services.Config.EmailUser != "" && h.services.Config.EmailPassword != "" {
				status = "available"
				message = "邮件服务可用"
			} else {
				status = "unavailable"
				message = "邮件服务配置不完整"
			}
		}
		
		statuses = append(statuses, ServiceStatusResponse{
			Service: service,
			Status:  status,
			Message: message,
		})
	}

	c.JSON(http.StatusOK, gin.H{
		"services": statuses,
		"count":    len(statuses),
	})
}

// 注册第三方服务路由
func (h *ThirdPartyHandler) RegisterRoutes(router *gin.RouterGroup) {
	thirdParty := router.Group("/third-party")
	{
		// 高德地图服务
		amap := thirdParty.Group("/amap")
		{
			amap.POST("/geocode", h.AmapGeocode)
			amap.POST("/regeocode", h.AmapRegeocode)
		}
		
		// Pixabay图片服务
		thirdParty.POST("/pixabay/search", h.PixabaySearchImages)
		
		// OpenWeather天气服务
		thirdParty.POST("/weather", h.OpenWeatherGetWeather)
		
		// Google搜索服务
		thirdParty.POST("/google/search", h.GoogleSearch)
		
		// 邮件服务
		thirdParty.POST("/email/send", h.SendEmail)
		
		// 服务状态检查
		thirdParty.GET("/status/:service", h.CheckServiceStatus)
		thirdParty.GET("/status", h.GetAllServiceStatus)
	}
}
