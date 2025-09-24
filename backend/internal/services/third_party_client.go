package services

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strconv"
	"time"

	"qa-toolbox-backend/internal/config"
)

// 第三方服务客户端管理器
type ThirdPartyClientManager struct {
	config *config.Config
	httpClient *http.Client
}

// 创建第三方服务客户端管理器
func NewThirdPartyClientManager(cfg *config.Config) *ThirdPartyClientManager {
	return &ThirdPartyClientManager{
		config: cfg,
		httpClient: &http.Client{Timeout: 30 * time.Second},
	}
}

// ==================== 高德地图服务 ====================

// 高德地图地理编码响应
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
		Adcode string `json:"adcode"`
		Location string `json:"location"`
		Level   string `json:"level"`
	} `json:"geocodes"`
}

// 高德地图逆地理编码响应
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
func (m *ThirdPartyClientManager) AmapGeocode(ctx context.Context, address string) (*AmapGeocodeResponse, error) {
	if m.config.AmapAPIKey == "" {
		return nil, fmt.Errorf("高德地图API密钥未配置")
	}
	
	params := url.Values{}
	params.Set("key", m.config.AmapAPIKey)
	params.Set("address", address)
	params.Set("output", "json")
	
	url := m.config.AmapBaseURL + "/geocode/geo?" + params.Encode()
	
	resp, err := m.httpClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("请求高德地图API失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	var result AmapGeocodeResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	if result.Status != "1" {
		return nil, fmt.Errorf("高德地图API错误: %s", result.Info)
	}
	
	return &result, nil
}

// 逆地理编码（坐标转地址）
func (m *ThirdPartyClientManager) AmapRegeocode(ctx context.Context, longitude, latitude float64) (*AmapRegeocodeResponse, error) {
	if m.config.AmapAPIKey == "" {
		return nil, fmt.Errorf("高德地图API密钥未配置")
	}
	
	params := url.Values{}
	params.Set("key", m.config.AmapAPIKey)
	params.Set("location", fmt.Sprintf("%.6f,%.6f", longitude, latitude))
	params.Set("output", "json")
	params.Set("extensions", "base")
	
	url := m.config.AmapBaseURL + "/geocode/regeo?" + params.Encode()
	
	resp, err := m.httpClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("请求高德地图API失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	var result AmapRegeocodeResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	if result.Status != "1" {
		return nil, fmt.Errorf("高德地图API错误: %s", result.Info)
	}
	
	return &result, nil
}

// ==================== Pixabay图片服务 ====================

// Pixabay图片响应
type PixabayImageResponse struct {
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
func (m *ThirdPartyClientManager) PixabaySearchImages(ctx context.Context, query string, category string, minWidth, minHeight int, perPage int) (*PixabayImageResponse, error) {
	if m.config.PixabayAPIKey == "" {
		return nil, fmt.Errorf("Pixabay API密钥未配置")
	}
	
	params := url.Values{}
	params.Set("key", m.config.PixabayAPIKey)
	params.Set("q", query)
	params.Set("image_type", "photo")
	params.Set("orientation", "all")
	params.Set("category", category)
	params.Set("min_width", strconv.Itoa(minWidth))
	params.Set("min_height", strconv.Itoa(minHeight))
	params.Set("per_page", strconv.Itoa(perPage))
	params.Set("safesearch", "true")
	
	url := m.config.PixabayBaseURL + "/?" + params.Encode()
	
	resp, err := m.httpClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("请求Pixabay API失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	var result PixabayImageResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	return &result, nil
}

// ==================== OpenWeather天气服务 ====================

// OpenWeather天气响应
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
func (m *ThirdPartyClientManager) OpenWeatherGetWeather(ctx context.Context, city string, countryCode string) (*OpenWeatherResponse, error) {
	if m.config.OpenWeatherAPIKey == "" {
		return nil, fmt.Errorf("OpenWeather API密钥未配置")
	}
	
	params := url.Values{}
	params.Set("q", city+","+countryCode)
	params.Set("appid", m.config.OpenWeatherAPIKey)
	params.Set("units", "metric")
	params.Set("lang", "zh_cn")
	
	url := m.config.OpenWeatherBaseURL + "/weather?" + params.Encode()
	
	resp, err := m.httpClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("请求OpenWeather API失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	var result OpenWeatherResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	if result.Cod != 200 {
		return nil, fmt.Errorf("OpenWeather API错误: %d", result.Cod)
	}
	
	return &result, nil
}

// ==================== Google搜索服务 ====================

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
func (m *ThirdPartyClientManager) GoogleSearch(ctx context.Context, query string, num int) (*GoogleSearchResponse, error) {
	if m.config.GoogleAPIKey == "" || m.config.GoogleCSEID == "" {
		return nil, fmt.Errorf("Google API密钥或自定义搜索引擎ID未配置")
	}
	
	params := url.Values{}
	params.Set("key", m.config.GoogleAPIKey)
	params.Set("cx", m.config.GoogleCSEID)
	params.Set("q", query)
	params.Set("num", strconv.Itoa(num))
	params.Set("safe", "medium")
	
	url := m.config.GoogleBaseURL + "?" + params.Encode()
	
	resp, err := m.httpClient.Get(url)
	if err != nil {
		return nil, fmt.Errorf("请求Google API失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	var result GoogleSearchResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("解析响应失败: %w", err)
	}
	
	return &result, nil
}

// ==================== 邮件服务 ====================

// 邮件内容
type EmailContent struct {
	To      []string `json:"to"`
	Subject string   `json:"subject"`
	Body    string   `json:"body"`
	IsHTML  bool     `json:"is_html"`
}

// 发送邮件
func (m *ThirdPartyClientManager) SendEmail(ctx context.Context, content *EmailContent) error {
	if m.config.EmailHost == "" || m.config.EmailUser == "" || m.config.EmailPassword == "" {
		return fmt.Errorf("邮件服务配置不完整")
	}
	
	// 这里应该使用SMTP客户端发送邮件
	// 为了简化，这里只是示例
	return fmt.Errorf("邮件发送功能需要实现SMTP客户端")
}

// ==================== 工具方法 ====================

// 发送HTTP GET请求
func (m *ThirdPartyClientManager) sendGetRequest(ctx context.Context, url string) ([]byte, error) {
	req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}
	
	resp, err := m.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("发送请求失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("HTTP请求失败: %d %s", resp.StatusCode, string(body))
	}
	
	return body, nil
}

// 发送HTTP POST请求
func (m *ThirdPartyClientManager) sendPostRequest(ctx context.Context, url string, data interface{}) ([]byte, error) {
	jsonData, err := json.Marshal(data)
	if err != nil {
		return nil, fmt.Errorf("序列化数据失败: %w", err)
	}
	
	req, err := http.NewRequestWithContext(ctx, "POST", url, bytes.NewBuffer(jsonData))
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}
	
	req.Header.Set("Content-Type", "application/json")
	
	resp, err := m.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("发送请求失败: %w", err)
	}
	defer resp.Body.Close()
	
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}
	
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("HTTP请求失败: %d %s", resp.StatusCode, string(body))
	}
	
	return body, nil
}
