package api

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type QAToolBoxHandler struct {
	qaToolBoxService *services.QAToolBoxService
}

func NewQAToolBoxHandler(qaToolBoxService *services.QAToolBoxService) *QAToolBoxHandler {
	return &QAToolBoxHandler{
		qaToolBoxService: qaToolBoxService,
	}
}

// GenerateTestCases 生成测试用例
func (h *QAToolBoxHandler) GenerateTestCases(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req models.TestGenerationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.qaToolBoxService.GenerateTestCases(userID.(string), &req)
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
		Data:    response,
	})
}

// GetTestCases 获取测试用例
func (h *QAToolBoxHandler) GetTestCases(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	testCases, total, err := h.qaToolBoxService.GetTestCases(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get test cases",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: testCases,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// ConvertPDF PDF转换
func (h *QAToolBoxHandler) ConvertPDF(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req models.PDFConversionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.qaToolBoxService.ConvertPDF(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to convert PDF",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "PDF converted successfully",
		Data:    response,
	})
}

// GetPDFConversions 获取PDF转换记录
func (h *QAToolBoxHandler) GetPDFConversions(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	conversions, total, err := h.qaToolBoxService.GetPDFConversions(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get PDF conversions",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: conversions,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// CreateCrawlerTask 创建爬虫任务
func (h *QAToolBoxHandler) CreateCrawlerTask(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req models.CrawlerTask
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	response, err := h.qaToolBoxService.CreateCrawlerTask(&req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to create crawler task",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "Crawler task created successfully",
		Data:    response,
	})
}

// GetCrawlerTasks 获取爬虫任务
func (h *QAToolBoxHandler) GetCrawlerTasks(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	tasks, total, err := h.qaToolBoxService.GetCrawlerTasks(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get crawler tasks",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: tasks,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}

// RunAPITest 运行API测试
func (h *QAToolBoxHandler) RunAPITest(c *gin.Context) {
	userID, _ := c.Get("user_id")

	var req models.APITestSuite
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "Invalid request format",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID.(string)

	// 从APITestSuite创建APITestCase
	testCase := &models.APITestCase{
		ID:             uuid.New().String(),
		SuiteID:        req.ID,
		Name:           req.Name,
		Method:         "GET", // 默认方法
		Endpoint:       req.BaseURL,
		Headers:        req.Headers,
		Params:         req.Variables,
		ExpectedStatus: 200,
		Timeout:        30,
	}

	response, err := h.qaToolBoxService.RunAPITest(userID.(string), testCase)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to run API test",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "API test completed successfully",
		Data:    response,
	})
}

// GetAPITests 获取API测试记录
func (h *QAToolBoxHandler) GetAPITests(c *gin.Context) {
	userID, _ := c.Get("user_id")
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	perPage, _ := strconv.Atoi(c.DefaultQuery("per_page", "10"))

	tests, total, err := h.qaToolBoxService.GetAPITests(userID.(string), page, perPage)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "Failed to get API tests",
			Error:   err.Error(),
		})
		return
	}

	totalPages := (total + perPage - 1) / perPage

	c.JSON(http.StatusOK, models.PaginatedResponse{
		Data: tests,
		Pagination: models.Pagination{
			Page:       page,
			PerPage:    perPage,
			Total:      total,
			TotalPages: totalPages,
		},
	})
}