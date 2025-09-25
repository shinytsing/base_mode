package api

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type ThirdPartyHandler struct {
	services *services.Services
}

func NewThirdPartyHandler(services *services.Services) *ThirdPartyHandler {
	return &ThirdPartyHandler{
		services: services,
	}
}

// RegisterRoutes 注册第三方服务路由
func (h *ThirdPartyHandler) RegisterRoutes(router *gin.RouterGroup) {
	thirdParty := router.Group("/third-party")
	{
		thirdParty.GET("/location/:address", h.GetLocationInfo)
		thirdParty.GET("/images/search", h.SearchImages)
		thirdParty.GET("/weather/:city", h.GetWeather)
		thirdParty.GET("/search", h.SearchWeb)
	}
}

// GetLocationInfo 获取位置信息
func (h *ThirdPartyHandler) GetLocationInfo(c *gin.Context) {
	address := c.Param("address")
	if address == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Address is required",
		})
		return
	}

	response, err := h.services.ThirdPartyClientManager.GetLocationInfo(address)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get location info",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Location info retrieved successfully",
		Data:    response,
	})
}

// SearchImages 搜索图片
func (h *ThirdPartyHandler) SearchImages(c *gin.Context) {
	query := c.Query("q")
	if query == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Query parameter 'q' is required",
		})
		return
	}

	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "20"))
	if perPage > 200 {
		perPage = 200
	}

	response, err := h.services.ThirdPartyClientManager.SearchImages(query, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to search images",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Images searched successfully",
		Data:    response,
	})
}

// GetWeather 获取天气信息
func (h *ThirdPartyHandler) GetWeather(c *gin.Context) {
	city := c.Param("city")
	if city == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "City is required",
		})
		return
	}

	response, err := h.services.ThirdPartyClientManager.GetWeather(city)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get weather",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Weather retrieved successfully",
		Data:    response,
	})
}

// SearchWeb 搜索网页
func (h *ThirdPartyHandler) SearchWeb(c *gin.Context) {
	query := c.Query("q")
	if query == "" {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Query parameter 'q' is required",
		})
		return
	}

	num, _ := strconv.Atoi(c.DefaultQuery("num", "10"))
	if num > 100 {
		num = 100
	}

	response, err := h.services.ThirdPartyClientManager.SearchWeb(query, num)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to search web",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Web search completed successfully",
		Data:    response,
	})
}