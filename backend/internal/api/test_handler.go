package api

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"qa-toolbox-backend/internal/models"
	"qa-toolbox-backend/internal/services"
)

type TestHandler struct {
	testService *services.TestService
}

func NewTestHandler(testService *services.TestService) *TestHandler {
	return &TestHandler{
		testService: testService,
	}
}

// GenerateTestCases - AI驱动的测试用例生成
func (h *TestHandler) GenerateTestCases(c *gin.Context) {
	var req models.TestGenerationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.GenerateTestCases(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GenerateBatchTestCases - 批量生成测试用例
func (h *TestHandler) GenerateBatchTestCases(c *gin.Context) {
	var req models.BatchTestGenerationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.BatchGenerateTestCases(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GenerateUnitTests - 生成单元测试
func (h *TestHandler) GenerateUnitTests(c *gin.Context) {
	var req models.UnitTestRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.GenerateUnitTests(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GenerateIntegrationTests - 生成集成测试
func (h *TestHandler) GenerateIntegrationTests(c *gin.Context) {
	var req models.IntegrationTestRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.GenerateIntegrationTests(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GeneratePerformanceTests - 生成性能测试
func (h *TestHandler) GeneratePerformanceTests(c *gin.Context) {
	var req models.PerformanceTestRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.GeneratePerformanceTests(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// GenerateSecurityTests - 生成安全测试
func (h *TestHandler) GenerateSecurityTests(c *gin.Context) {
	var req models.SecurityTestRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.GenerateSecurityTests(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// AnalyzeTestQuality - 测试用例质量分析
func (h *TestHandler) AnalyzeTestQuality(c *gin.Context) {
	var req models.TestQualityAnalysisRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.AnalyzeTestQuality(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}

// AnalyzeCoverage - 测试覆盖率分析
func (h *TestHandler) AnalyzeCoverage(c *gin.Context) {
	var req models.CoverageAnalysisRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	response, err := h.testService.AnalyzeCoverage(c.Request.Context(), &req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, response)
}
