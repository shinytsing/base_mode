package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
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
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req models.TestGenerationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID

	result, err := h.qaToolBoxService.GenerateTestCases(&req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "生成测试用例失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "生成测试用例成功",
		Data:    result,
	})
}

// GetTestCases 获取测试用例
func (h *QAToolBoxHandler) GetTestCases(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	testCases, err := h.qaToolBoxService.GetTestCases(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取测试用例失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取测试用例成功",
		Data:    testCases,
	})
}

// ConvertPDF PDF转换
func (h *QAToolBoxHandler) ConvertPDF(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req models.PDFConversionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID

	result, err := h.qaToolBoxService.ConvertPDF(&req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "PDF转换失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "PDF转换成功",
		Data:    result,
	})
}

// GetPDFConversions 获取PDF转换历史
func (h *QAToolBoxHandler) GetPDFConversions(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	conversions, err := h.qaToolBoxService.GetPDFConversions(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取PDF转换历史失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取PDF转换历史成功",
		Data:    conversions,
	})
}

// CreateCrawlerTask 创建爬虫任务
func (h *QAToolBoxHandler) CreateCrawlerTask(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req models.CrawlerTask
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	req.UserID = userID

	task, err := h.qaToolBoxService.CreateCrawlerTask(&req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "创建爬虫任务失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "创建爬虫任务成功",
		Data:    task,
	})
}

// GetCrawlerTasks 获取爬虫任务
func (h *QAToolBoxHandler) GetCrawlerTasks(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	tasks, err := h.qaToolBoxService.GetCrawlerTasks(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取爬虫任务失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取爬虫任务成功",
		Data:    tasks,
	})
}

// RunAPITest 运行API测试
func (h *QAToolBoxHandler) RunAPITest(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	var req models.APITestCase
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "请求参数错误",
			Error:   err.Error(),
		})
		return
	}

	result, err := h.qaToolBoxService.RunAPITest(userID, &req)
	if err != nil {
		c.JSON(http.StatusBadRequest, models.APIResponse{
			Success: false,
			Message: "运行API测试失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "运行API测试成功",
		Data:    result,
	})
}

// GetAPITests 获取API测试历史
func (h *QAToolBoxHandler) GetAPITests(c *gin.Context) {
	userID := c.GetString("user_id")
	if userID == "" {
		c.JSON(http.StatusUnauthorized, models.APIResponse{
			Success: false,
			Message: "用户未认证",
		})
		return
	}

	tests, err := h.qaToolBoxService.GetAPITests(userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, models.APIResponse{
			Success: false,
			Message: "获取API测试历史失败",
			Error:   err.Error(),
		})
		return
	}

	c.JSON(http.StatusOK, models.APIResponse{
		Success: true,
		Message: "获取API测试历史成功",
		Data:    tests,
	})
}
