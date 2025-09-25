package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"regexp"
	"strings"
	"time"

	"github.com/google/uuid"
	"qa-toolbox-backend/internal/database"
	"qa-toolbox-backend/internal/models"
)

type QAToolBoxService struct {
	db *database.DB
}

func NewQAToolBoxService(db *database.DB) *QAToolBoxService {
	return &QAToolBoxService{db: db}
}

// GenerateTestCases 生成测试用例
func (s *QAToolBoxService) GenerateTestCases(userID string, req *models.TestGenerationRequest) (*models.TestGenerationResponse, error) {
	generationID := uuid.New().String()
	
	// 分析代码并生成测试用例
	testCases, err := s.analyzeCodeAndGenerateTests(req.Code, req.Language, req.Framework, req.TestType)
	if err != nil {
		return nil, fmt.Errorf("分析代码失败: %w", err)
	}

	// 保存测试用例到数据库
	for _, testCase := range testCases {
		testCase.GenerationID = generationID
		testCase.CreatedAt = time.Now()
		
		// 将tags转换为JSON
		tagsJSON, err := json.Marshal(testCase.Tags)
		if err != nil {
			return nil, fmt.Errorf("转换tags为JSON失败: %w", err)
		}
		
		// 将metadata转换为JSON
		metadataJSON, err := json.Marshal(testCase.Metadata)
		if err != nil {
			return nil, fmt.Errorf("转换metadata为JSON失败: %w", err)
		}
		
		_, err = s.db.Exec(`
			INSERT INTO test_cases (id, generation_id, name, description, code, type, tags, priority, is_automated, metadata, created_at, user_id)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
		`, testCase.ID, testCase.GenerationID, testCase.Name, testCase.Description, 
			testCase.Code, testCase.Type, tagsJSON, testCase.Priority, 
			testCase.IsAutomated, metadataJSON, testCase.CreatedAt, userID)
		
		if err != nil {
			return nil, fmt.Errorf("保存测试用例失败: %w", err)
		}
	}

	// 计算测试指标
	metrics := s.calculateTestMetrics(testCases, req.Coverage)

	response := &models.TestGenerationResponse{
		ID:        generationID,
		TestCases: testCases,
		Status:    "completed",
		Metrics:   metrics,
		CreatedAt: time.Now(),
	}

	return response, nil
}

// analyzeCodeAndGenerateTests 分析代码并生成测试用例
func (s *QAToolBoxService) analyzeCodeAndGenerateTests(code, language, framework, testType string) ([]models.TestCase, error) {
	var testCases []models.TestCase
	
	// 根据语言和框架生成相应的测试用例
	switch language {
	case "javascript", "typescript":
		testCases = s.generateJavaScriptTests(code, framework, testType)
	case "python":
		testCases = s.generatePythonTests(code, framework, testType)
	case "java":
		testCases = s.generateJavaTests(code, framework, testType)
	case "go":
		testCases = s.generateGoTests(code, framework, testType)
	default:
		testCases = s.generateGenericTests(code, language, testType)
	}

	return testCases, nil
}

// generateJavaScriptTests 生成JavaScript测试用例
func (s *QAToolBoxService) generateJavaScriptTests(code, framework, testType string) []models.TestCase {
	var testCases []models.TestCase
	
	// 提取函数名
	functionNames := s.extractFunctionNames(code, "javascript")
	
	for i, funcName := range functionNames {
		testCase := models.TestCase{
			ID:          uuid.New().String(),
			Name:        fmt.Sprintf("测试 %s 函数", funcName),
			Description: fmt.Sprintf("验证 %s 函数的基本功能", funcName),
			Code:        s.generateJavaScriptTestCode(funcName, framework),
			Type:        testType,
			Tags:        []string{"javascript", "unit", "function"},
			Priority:    i + 1,
			IsAutomated: true,
			Metadata:    map[string]interface{}{"framework": framework, "function": funcName},
		}
		testCases = append(testCases, testCase)
	}

	// 添加边界测试
	testCases = append(testCases, models.TestCase{
		ID:          uuid.New().String(),
		Name:        "边界值测试",
		Description: "测试边界值和异常情况",
		Code:        s.generateBoundaryTestCode("javascript", framework),
		Type:        testType,
		Tags:        []string{"javascript", "boundary", "edge-case"},
		Priority:    len(testCases) + 1,
		IsAutomated: true,
		Metadata:    map[string]interface{}{"framework": framework, "type": "boundary"},
	})

	return testCases
}

// generatePythonTests 生成Python测试用例
func (s *QAToolBoxService) generatePythonTests(code, framework, testType string) []models.TestCase {
	var testCases []models.TestCase
	
	functionNames := s.extractFunctionNames(code, "python")
	
	for i, funcName := range functionNames {
		testCase := models.TestCase{
			ID:          uuid.New().String(),
			Name:        fmt.Sprintf("测试 %s 函数", funcName),
			Description: fmt.Sprintf("验证 %s 函数的基本功能", funcName),
			Code:        s.generatePythonTestCode(funcName, framework),
			Type:        testType,
			Tags:        []string{"python", "unit", "function"},
			Priority:    i + 1,
			IsAutomated: true,
			Metadata:    map[string]interface{}{"framework": framework, "function": funcName},
		}
		testCases = append(testCases, testCase)
	}

	return testCases
}

// generateJavaTests 生成Java测试用例
func (s *QAToolBoxService) generateJavaTests(code, framework, testType string) []models.TestCase {
	var testCases []models.TestCase
	
	methodNames := s.extractMethodNames(code, "java")
	
	for i, methodName := range methodNames {
		testCase := models.TestCase{
			ID:          uuid.New().String(),
			Name:        fmt.Sprintf("测试 %s 方法", methodName),
			Description: fmt.Sprintf("验证 %s 方法的基本功能", methodName),
			Code:        s.generateJavaTestCode(methodName, framework),
			Type:        testType,
			Tags:        []string{"java", "unit", "method"},
			Priority:    i + 1,
			IsAutomated: true,
			Metadata:    map[string]interface{}{"framework": framework, "method": methodName},
		}
		testCases = append(testCases, testCase)
	}

	return testCases
}

// generateGoTests 生成Go测试用例
func (s *QAToolBoxService) generateGoTests(code, framework, testType string) []models.TestCase {
	var testCases []models.TestCase
	
	functionNames := s.extractFunctionNames(code, "go")
	
	for i, funcName := range functionNames {
		testCase := models.TestCase{
			ID:          uuid.New().String(),
			Name:        fmt.Sprintf("测试 %s 函数", funcName),
			Description: fmt.Sprintf("验证 %s 函数的基本功能", funcName),
			Code:        s.generateGoTestCode(funcName),
			Type:        testType,
			Tags:        []string{"go", "unit", "function"},
			Priority:    i + 1,
			IsAutomated: true,
			Metadata:    map[string]interface{}{"function": funcName},
		}
		testCases = append(testCases, testCase)
	}

	return testCases
}

// generateGenericTests 生成通用测试用例
func (s *QAToolBoxService) generateGenericTests(code, language, testType string) []models.TestCase {
	return []models.TestCase{
		{
			ID:          uuid.New().String(),
			Name:        "基本功能测试",
			Description: "测试基本功能是否正常工作",
			Code:        fmt.Sprintf("// %s 基本功能测试\n// 请根据实际代码编写测试", language),
			Type:        testType,
			Tags:        []string{language, "basic", "functional"},
			Priority:    1,
			IsAutomated: false,
			Metadata:    map[string]interface{}{"language": language},
		},
	}
}

// extractFunctionNames 提取函数名
func (s *QAToolBoxService) extractFunctionNames(code, language string) []string {
	var functionNames []string
	
	switch language {
	case "javascript", "typescript":
		// 匹配 function name() 或 const name = () => 或 name() 等
		re := regexp.MustCompile(`(?:function\s+(\w+)|const\s+(\w+)\s*=\s*(?:async\s+)?\(|(\w+)\s*\(`)
		matches := re.FindAllStringSubmatch(code, -1)
		for _, match := range matches {
			for i := 1; i < len(match); i++ {
				if match[i] != "" {
					functionNames = append(functionNames, match[i])
					break
				}
			}
		}
	case "python":
		// 匹配 def function_name():
		re := regexp.MustCompile(`def\s+(\w+)\s*\(`)
		matches := re.FindAllStringSubmatch(code, -1)
		for _, match := range matches {
			if len(match) > 1 {
				functionNames = append(functionNames, match[1])
			}
		}
	case "java":
		// 匹配 public/private/protected returnType methodName()
		re := regexp.MustCompile(`(?:public|private|protected)\s+\w+\s+(\w+)\s*\(`)
		matches := re.FindAllStringSubmatch(code, -1)
		for _, match := range matches {
			if len(match) > 1 {
				functionNames = append(functionNames, match[1])
			}
		}
	case "go":
		// 匹配 func FunctionName()
		re := regexp.MustCompile(`func\s+(\w+)\s*\(`)
		matches := re.FindAllStringSubmatch(code, -1)
		for _, match := range matches {
			if len(match) > 1 {
				functionNames = append(functionNames, match[1])
			}
		}
	}
	
	// 去重
	uniqueNames := make(map[string]bool)
	var result []string
	for _, name := range functionNames {
		if !uniqueNames[name] {
			uniqueNames[name] = true
			result = append(result, name)
		}
	}
	
	return result
}

// extractMethodNames 提取方法名（主要用于Java）
func (s *QAToolBoxService) extractMethodNames(code, language string) []string {
	return s.extractFunctionNames(code, language)
}

// generateJavaScriptTestCode 生成JavaScript测试代码
func (s *QAToolBoxService) generateJavaScriptTestCode(funcName, framework string) string {
	switch framework {
	case "jest":
		return fmt.Sprintf(`describe('%s', () => {
  test('应该正确执行基本功能', () => {
    // Arrange
    const input = 'test input';
    
    // Act
    const result = %s(input);
    
    // Assert
    expect(result).toBeDefined();
    expect(typeof result).toBe('string');
  });
  
  test('应该处理边界情况', () => {
    // 测试空值
    expect(() => %s(null)).not.toThrow();
    expect(() => %s(undefined)).not.toThrow();
  });
});`, funcName, funcName, funcName, funcName)
	case "mocha":
		return fmt.Sprintf(`describe('%s', function() {
  it('应该正确执行基本功能', function() {
    const input = 'test input';
    const result = %s(input);
    
    assert.isDefined(result);
    assert.isString(result);
  });
  
  it('应该处理边界情况', function() {
    assert.doesNotThrow(() => %s(null));
    assert.doesNotThrow(() => %s(undefined));
  });
});`, funcName, funcName, funcName, funcName)
	default:
		return fmt.Sprintf(`// %s 函数测试
function test%s() {
  // 基本功能测试
  const input = 'test input';
  const result = %s(input);
  
  if (result === undefined) {
    throw new Error('函数返回值为undefined');
  }
  
  console.log('测试通过:', result);
}

// 运行测试
test%s();`, funcName, funcName, funcName, funcName)
	}
}

// generatePythonTestCode 生成Python测试代码
func (s *QAToolBoxService) generatePythonTestCode(funcName, framework string) string {
	switch framework {
	case "pytest":
		return fmt.Sprintf(`import pytest

def test_%s_basic():
    """测试 %s 函数的基本功能"""
    input_data = "test input"
    result = %s(input_data)
    
    assert result is not None
    assert isinstance(result, str)

def test_%s_edge_cases():
    """测试 %s 函数的边界情况"""
    # 测试空值
    assert %s(None) is not None
    assert %s("") is not None
`, funcName, funcName, funcName, funcName, funcName, funcName, funcName)
	case "unittest":
		return fmt.Sprintf(`import unittest

class Test%s(unittest.TestCase):
    def test_basic_functionality(self):
        """测试基本功能"""
        input_data = "test input"
        result = %s(input_data)
        
        self.assertIsNotNone(result)
        self.assertIsInstance(result, str)
    
    def test_edge_cases(self):
        """测试边界情况"""
        self.assertIsNotNone(%s(None))
        self.assertIsNotNone(%s(""))

if __name__ == '__main__':
    unittest.main()
`, funcName, funcName, funcName, funcName)
	default:
		return fmt.Sprintf(`# %s 函数测试
def test_%s():
    """测试 %s 函数"""
    input_data = "test input"
    result = %s(input_data)
    
    if result is None:
        raise AssertionError("函数返回值为None")
    
    print(f"测试通过: {result}")

# 运行测试
if __name__ == "__main__":
    test_%s()
`, funcName, funcName, funcName, funcName, funcName)
	}
}

// generateJavaTestCode 生成Java测试代码
func (s *QAToolBoxService) generateJavaTestCode(methodName, framework string) string {
	switch framework {
	case "junit":
		return fmt.Sprintf(`import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

public class %sTest {
    
    @BeforeEach
    void setUp() {
        // 初始化测试数据
    }
    
    @Test
    void test%sBasic() {
        // Arrange
        String input = "test input";
        
        // Act
        String result = %s(input);
        
        // Assert
        assertNotNull(result);
        assertTrue(result.length() > 0);
    }
    
    @Test
    void test%sEdgeCases() {
        // 测试边界情况
        assertDoesNotThrow(() -> %s(null));
        assertDoesNotThrow(() -> %s(""));
    }
}`, strings.Title(methodName), strings.Title(methodName), methodName, strings.Title(methodName), methodName, methodName)
	default:
		return fmt.Sprintf(`// %s 方法测试
public class %sTest {
    public static void test%s() {
        String input = "test input";
        String result = %s(input);
        
        if (result == null) {
            throw new AssertionError("方法返回值为null");
        }
        
        System.out.println("测试通过: " + result);
    }
    
    public static void main(String[] args) {
        test%s();
    }
}`, methodName, strings.Title(methodName), strings.Title(methodName), methodName, strings.Title(methodName))
	}
}

// generateGoTestCode 生成Go测试代码
func (s *QAToolBoxService) generateGoTestCode(funcName string) string {
	return fmt.Sprintf(`package main

import (
    "testing"
    "reflect"
)

func Test%s(t *testing.T) {
    tests := []struct {
        name     string
        input    string
        expected string
    }{
        {
            name:     "基本功能测试",
            input:    "test input",
            expected: "expected output",
        },
        {
            name:     "空值测试",
            input:    "",
            expected: "",
        },
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := %s(tt.input)
            
            if result == "" && tt.expected != "" {
                t.Errorf("函数返回空值")
            }
            
            // 根据实际需求调整断言
            t.Logf("输入: %s, 输出: %s", tt.input, result)
        })
    }
}

func Test%sEdgeCases(t *testing.T) {
    // 测试边界情况
    t.Run("空值测试", func(t *testing.T) {
        result := %s("")
        t.Logf("空值测试结果: %s", result)
    })
    
    t.Run("nil测试", func(t *testing.T) {
        // 如果函数接受指针，测试nil情况
        // result := %s(nil)
        t.Log("nil测试完成")
    })
}`, strings.Title(funcName), funcName, strings.Title(funcName), funcName)
}

// generateBoundaryTestCode 生成边界测试代码
func (s *QAToolBoxService) generateBoundaryTestCode(language, framework string) string {
	switch language {
	case "javascript":
		return `// 边界值测试
describe('边界值测试', () => {
  test('空值测试', () => {
    expect(() => functionUnderTest(null)).not.toThrow();
    expect(() => functionUnderTest(undefined)).not.toThrow();
    expect(() => functionUnderTest('')).not.toThrow();
  });
  
  test('极值测试', () => {
    expect(() => functionUnderTest(Number.MAX_VALUE)).not.toThrow();
    expect(() => functionUnderTest(Number.MIN_VALUE)).not.toThrow();
  });
  
  test('特殊字符测试', () => {
    expect(() => functionUnderTest('!@#$%^&*()')).not.toThrow();
    expect(() => functionUnderTest('中文测试')).not.toThrow();
  });
});`
	case "python":
		return `# 边界值测试
def test_boundary_cases():
    """测试边界情况"""
    # 空值测试
    assert function_under_test(None) is not None
    assert function_under_test("") is not None
    assert function_under_test([]) is not None
    
    # 极值测试
    assert function_under_test(float('inf')) is not None
    assert function_under_test(float('-inf')) is not None
    
    # 特殊字符测试
    assert function_under_test("!@#$%^&*()") is not None
    assert function_under_test("中文测试") is not None`
	default:
		return fmt.Sprintf(`// %s 边界值测试
// 请根据实际函数编写边界测试用例`, language)
	}
}

// calculateTestMetrics 计算测试指标
func (s *QAToolBoxService) calculateTestMetrics(testCases []models.TestCase, targetCoverage int) models.TestMetrics {
	totalCases := len(testCases)
	
	// 计算覆盖率（简化计算）
	coverage := float64(targetCoverage)
	if coverage == 0 {
		coverage = 80.0 // 默认覆盖率
	}
	
	// 计算复杂度
	complexity := "low"
	if totalCases > 10 {
		complexity = "high"
	} else if totalCases > 5 {
		complexity = "medium"
	}
	
	// 估算时间（每个测试用例平均2分钟）
	estimatedTime := totalCases * 2
	
	// 计算质量分数
	qualityScore := 70.0
	if totalCases > 0 {
		qualityScore = 70.0 + float64(totalCases)*2
		if qualityScore > 100 {
			qualityScore = 100
		}
	}
	
	return models.TestMetrics{
		TotalCases:    totalCases,
		Coverage:      coverage,
		Complexity:    complexity,
		EstimatedTime: estimatedTime,
		QualityScore:  qualityScore,
	}
}

// GetTestCases 获取测试用例
func (s *QAToolBoxService) GetTestCases(userID string, page, perPage int) ([]models.TestCase, int, error) {
	// 计算偏移量
	offset := (page - 1) * perPage
	
	// 查询测试用例
	rows, err := s.db.Query(`
		SELECT id, generation_id, name, description, code, type, tags, priority, is_automated, metadata, created_at
		FROM test_cases 
		WHERE user_id = $1 
		ORDER BY created_at DESC 
		LIMIT $2 OFFSET $3
	`, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("查询测试用例失败: %w", err)
	}
	defer rows.Close()
	
	var testCases []models.TestCase
	for rows.Next() {
		var testCase models.TestCase
		err := rows.Scan(
			&testCase.ID, &testCase.GenerationID, &testCase.Name, &testCase.Description,
			&testCase.Code, &testCase.Type, &testCase.Tags, &testCase.Priority,
			&testCase.IsAutomated, &testCase.Metadata, &testCase.CreatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("扫描测试用例失败: %w", err)
		}
		testCases = append(testCases, testCase)
	}
	
	// 查询总数
	var total int
	err = s.db.QueryRow("SELECT COUNT(*) FROM test_cases WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("查询总数失败: %w", err)
	}
	
	return testCases, total, nil
}

// ConvertPDF PDF转换
func (s *QAToolBoxService) ConvertPDF(req *models.PDFConversionRequest) (*models.PDFConversionResponse, error) {
	conversionID := uuid.New().String()
	
	// 创建转换记录
	_, err := s.db.Exec(`
		INSERT INTO pdf_conversions (id, user_id, source_file_url, source_format, target_format, status, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`, conversionID, req.UserID, req.SourceFileURL, req.SourceFormat, req.TargetFormat, "pending", time.Now(), time.Now())
	
	if err != nil {
		return nil, fmt.Errorf("创建转换记录失败: %w", err)
	}

	// 执行转换
	targetFileURL, fileSize, pageCount, err := s.performPDFConversion(req.SourceFileURL, req.SourceFormat, req.TargetFormat)
	if err != nil {
		// 更新状态为失败
		s.db.Exec(`
			UPDATE pdf_conversions 
			SET status = 'failed', error_message = $1, updated_at = $2
			WHERE id = $3
		`, err.Error(), time.Now(), conversionID)
		
		return nil, fmt.Errorf("PDF转换失败: %w", err)
	}

	// 更新转换记录
	_, err = s.db.Exec(`
		UPDATE pdf_conversions 
		SET target_file_url = $1, status = 'completed', file_size = $2, page_count = $3, updated_at = $4
		WHERE id = $5
	`, targetFileURL, fileSize, pageCount, time.Now(), conversionID)
	
	if err != nil {
		return nil, fmt.Errorf("更新转换记录失败: %w", err)
	}

	response := &models.PDFConversionResponse{
		ID:            conversionID,
		UserID:        req.UserID,
		SourceFileURL: req.SourceFileURL,
		TargetFileURL: targetFileURL,
		SourceFormat:  req.SourceFormat,
		TargetFormat:  req.TargetFormat,
		Status:        "completed",
		FileSize:      fileSize,
		PageCount:     pageCount,
		CreatedAt:     time.Now(),
		UpdatedAt:     time.Now(),
	}

	return response, nil
}

// performPDFConversion 执行PDF转换
func (s *QAToolBoxService) performPDFConversion(sourceURL, sourceFormat, targetFormat string) (string, int, int, error) {
	// 这里应该实现实际的PDF转换逻辑
	// 可以使用第三方服务如CloudConvert、PDFShift等
	// 或者使用本地库如LibreOffice、Pandoc等
	
	// 模拟转换过程
	time.Sleep(2 * time.Second) // 模拟转换时间
	
	// 生成目标文件URL（实际应该上传到云存储）
	targetFileURL := fmt.Sprintf("https://storage.qatoolbox.com/converted/%s.%s", uuid.New().String(), targetFormat)
	
	// 模拟文件大小和页数
	fileSize := 1024 * 1024 // 1MB
	pageCount := 5
	
	return targetFileURL, fileSize, pageCount, nil
}

// GetPDFConversions 获取PDF转换历史
func (s *QAToolBoxService) GetPDFConversions(userID string, page, perPage int) ([]models.PDFConversionResponse, int, error) {
	// 计算偏移量
	offset := (page - 1) * perPage
	
	// 查询PDF转换历史
	rows, err := s.db.Query(`
		SELECT id, user_id, source_file_url, source_format, target_format, status, created_at, updated_at
		FROM pdf_conversions 
		WHERE user_id = $1 
		ORDER BY created_at DESC 
		LIMIT $2 OFFSET $3
	`, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("查询PDF转换历史失败: %w", err)
	}
	defer rows.Close()
	
	var conversions []models.PDFConversionResponse
	for rows.Next() {
		var conversion models.PDFConversionResponse
		err := rows.Scan(
			&conversion.ID, &conversion.UserID, &conversion.SourceFileURL, 
			&conversion.SourceFormat, &conversion.TargetFormat, &conversion.Status,
			&conversion.CreatedAt, &conversion.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("扫描PDF转换记录失败: %w", err)
		}
		conversions = append(conversions, conversion)
	}
	
	// 查询总数
	var total int
	err = s.db.QueryRow("SELECT COUNT(*) FROM pdf_conversions WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("查询总数失败: %w", err)
	}
	
	return conversions, total, nil
}

// CreateCrawlerTask 创建爬虫任务
func (s *QAToolBoxService) CreateCrawlerTask(req *models.CrawlerTask) (*models.CrawlerTask, error) {
	req.ID = uuid.New().String()
	req.Status = "pending"
	req.CreatedAt = time.Now()
	req.UpdatedAt = time.Now()

	// 保存到数据库
	_, err := s.db.Exec(`
		INSERT INTO crawler_tasks (id, user_id, name, url, status, config, selectors, max_pages, delay_ms, follow_links, respect_robots, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
	`, req.ID, req.UserID, req.Name, req.URL, req.Status, req.Config, req.Selectors, 
		req.MaxPages, req.DelayMs, req.FollowLinks, req.RespectRobots, req.CreatedAt, req.UpdatedAt)
	
	if err != nil {
		return nil, fmt.Errorf("创建爬虫任务失败: %w", err)
	}

	// 异步执行爬虫任务
	go s.executeCrawlerTask(req)

	return req, nil
}

// executeCrawlerTask 执行爬虫任务
func (s *QAToolBoxService) executeCrawlerTask(task *models.CrawlerTask) {
	// 更新状态为运行中
	s.db.Exec(`
		UPDATE crawler_tasks 
		SET status = 'running', started_at = $1, updated_at = $2
		WHERE id = $3
	`, time.Now(), time.Now(), task.ID)

	// 执行爬虫逻辑
	results, err := s.performWebCrawling(task)
	if err != nil {
		// 更新状态为失败
		s.db.Exec(`
			UPDATE crawler_tasks 
			SET status = 'failed', completed_at = $1, updated_at = $2
			WHERE id = $3
		`, time.Now(), time.Now(), task.ID)
		return
	}

	// 保存爬虫结果
	for _, result := range results {
		s.db.Exec(`
			INSERT INTO crawler_results (id, task_id, url, data, status_code, response_time, headers, crawled_at)
			VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		`, uuid.New().String(), task.ID, result.URL, result.Data, result.StatusCode, 
			result.ResponseTime, result.Headers, result.CrawledAt)
	}

	// 更新状态为完成
	s.db.Exec(`
		UPDATE crawler_tasks 
		SET status = 'completed', completed_at = $1, updated_at = $2
		WHERE id = $3
	`, time.Now(), time.Now(), task.ID)
}

// performWebCrawling 执行网页爬取
func (s *QAToolBoxService) performWebCrawling(task *models.CrawlerTask) ([]models.CrawlerResult, error) {
	var results []models.CrawlerResult
	
	// 创建HTTP客户端
	client := &http.Client{
		Timeout: 30 * time.Second,
	}

	// 发送请求
	req, err := http.NewRequest("GET", task.URL, nil)
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}

	// 设置User-Agent
	req.Header.Set("User-Agent", "QAToolBox-Crawler/1.0")

	// 执行请求
	startTime := time.Now()
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("请求失败: %w", err)
	}
	defer resp.Body.Close()

	responseTime := int(time.Since(startTime).Milliseconds())

	// 读取响应内容
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("读取响应失败: %w", err)
	}

	// 解析HTML内容
	extractedData, err := s.extractDataFromHTML(string(body), task.Selectors)
	if err != nil {
		return nil, fmt.Errorf("解析HTML失败: %w", err)
	}

	// 构建结果
	result := models.CrawlerResult{
		ID:           uuid.New().String(),
		TaskID:       task.ID,
		URL:          task.URL,
		Data:         extractedData,
		StatusCode:   resp.StatusCode,
		ResponseTime: responseTime,
		Headers:      s.convertHeadersToMap(resp.Header),
		CrawledAt:    time.Now(),
	}

	results = append(results, result)

	return results, nil
}

// extractDataFromHTML 从HTML中提取数据
func (s *QAToolBoxService) extractDataFromHTML(html string, selectors []string) (map[string]interface{}, error) {
	data := make(map[string]interface{})
	
	// 简单的HTML解析（实际应该使用专业的HTML解析库如goquery）
	for _, selector := range selectors {
		switch selector {
		case "title":
			// 提取标题
			titleRegex := regexp.MustCompile(`<title[^>]*>(.*?)</title>`)
			matches := titleRegex.FindStringSubmatch(html)
			if len(matches) > 1 {
				data["title"] = strings.TrimSpace(matches[1])
			}
		case "meta_description":
			// 提取meta描述
			descRegex := regexp.MustCompile(`<meta[^>]*name=["']description["'][^>]*content=["']([^"']*)["']`)
			matches := descRegex.FindStringSubmatch(html)
			if len(matches) > 1 {
				data["meta_description"] = strings.TrimSpace(matches[1])
			}
		case "links":
			// 提取链接
			linkRegex := regexp.MustCompile(`<a[^>]*href=["']([^"']*)["'][^>]*>([^<]*)</a>`)
			matches := linkRegex.FindAllStringSubmatch(html, -1)
			var links []map[string]string
			for _, match := range matches {
				if len(match) > 2 {
					links = append(links, map[string]string{
						"url":   strings.TrimSpace(match[1]),
						"text":  strings.TrimSpace(match[2]),
					})
				}
			}
			data["links"] = links
		case "images":
			// 提取图片
			imgRegex := regexp.MustCompile(`<img[^>]*src=["']([^"']*)["'][^>]*alt=["']([^"']*)["']`)
			matches := imgRegex.FindAllStringSubmatch(html, -1)
			var images []map[string]string
			for _, match := range matches {
				if len(match) > 2 {
					images = append(images, map[string]string{
						"src": strings.TrimSpace(match[1]),
						"alt": strings.TrimSpace(match[2]),
					})
				}
			}
			data["images"] = images
		case "text_content":
			// 提取文本内容（去除HTML标签）
			textRegex := regexp.MustCompile(`<[^>]*>`)
			cleanText := textRegex.ReplaceAllString(html, " ")
			cleanText = regexp.MustCompile(`\s+`).ReplaceAllString(cleanText, " ")
			data["text_content"] = strings.TrimSpace(cleanText)
		default:
			// 自定义选择器（简化实现）
			data[selector] = fmt.Sprintf("提取的数据: %s", selector)
		}
	}

	return data, nil
}

// convertHeadersToMap 将HTTP头转换为map
func (s *QAToolBoxService) convertHeadersToMap(headers http.Header) map[string]interface{} {
	result := make(map[string]interface{})
	for key, values := range headers {
		if len(values) == 1 {
			result[key] = values[0]
		} else {
			result[key] = values
		}
	}
	return result
}

// GetCrawlerTasks 获取爬虫任务
func (s *QAToolBoxService) GetCrawlerTasks(userID string, page, perPage int) ([]models.CrawlerTask, int, error) {
	// 计算偏移量
	offset := (page - 1) * perPage
	
	// 查询爬虫任务
	rows, err := s.db.Query(`
		SELECT id, user_id, name, url, status, created_at, updated_at
		FROM crawler_tasks 
		WHERE user_id = $1 
		ORDER BY created_at DESC 
		LIMIT $2 OFFSET $3
	`, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("查询爬虫任务失败: %w", err)
	}
	defer rows.Close()
	
	var tasks []models.CrawlerTask
	for rows.Next() {
		var task models.CrawlerTask
		err := rows.Scan(
			&task.ID, &task.UserID, &task.Name, &task.URL, 
			&task.Status, &task.CreatedAt, &task.UpdatedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("扫描爬虫任务失败: %w", err)
		}
		tasks = append(tasks, task)
	}
	
	// 查询总数
	var total int
	err = s.db.QueryRow("SELECT COUNT(*) FROM crawler_tasks WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("查询总数失败: %w", err)
	}
	
	return tasks, total, nil
}

// RunAPITest 运行API测试
func (s *QAToolBoxService) RunAPITest(userID string, testCase *models.APITestCase) (*models.APITestResult, error) {
	resultID := uuid.New().String()
	
	// 创建HTTP客户端
	client := &http.Client{
		Timeout: time.Duration(testCase.Timeout) * time.Second,
	}

	// 构建请求URL
	url := testCase.Endpoint
	if !strings.HasPrefix(url, "http") {
		// 从测试套件获取base URL
		var baseURL string
		err := s.db.QueryRow("SELECT base_url FROM api_test_suites WHERE id = $1", testCase.SuiteID).Scan(&baseURL)
		if err != nil {
			return nil, fmt.Errorf("获取测试套件信息失败: %w", err)
		}
		url = baseURL + url
	}

	// 创建请求
	var reqBody io.Reader
	if testCase.Body != nil && len(testCase.Body) > 0 {
		bodyBytes, err := json.Marshal(testCase.Body)
		if err != nil {
			return nil, fmt.Errorf("序列化请求体失败: %w", err)
		}
		reqBody = bytes.NewBuffer(bodyBytes)
	}

	req, err := http.NewRequest(testCase.Method, url, reqBody)
	if err != nil {
		return nil, fmt.Errorf("创建请求失败: %w", err)
	}

	// 设置请求头
	for key, value := range testCase.Headers {
		if strValue, ok := value.(string); ok {
			req.Header.Set(key, strValue)
		}
	}

	// 设置默认Content-Type
	if req.Header.Get("Content-Type") == "" && reqBody != nil {
		req.Header.Set("Content-Type", "application/json")
	}

	// 执行请求
	startTime := time.Now()
	resp, err := client.Do(req)
	responseTime := int(time.Since(startTime).Milliseconds())

	var result models.APITestResult
	result.ID = resultID
	result.TestCaseID = testCase.ID
	result.ExecutedAt = time.Now()
	result.ResponseTime = responseTime

	if err != nil {
		result.Status = "error"
		result.Errors = []string{err.Error()}
		return &result, nil
	}
	defer resp.Body.Close()

	// 读取响应体
	bodyBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		result.Status = "error"
		result.Errors = []string{fmt.Sprintf("读取响应体失败: %v", err)}
		return &result, nil
	}

	// 解析响应体
	var responseBody map[string]interface{}
	if len(bodyBytes) > 0 {
		err = json.Unmarshal(bodyBytes, &responseBody)
		if err != nil {
			// 如果不是JSON，存储为字符串
			responseBody = map[string]interface{}{
				"raw": string(bodyBytes),
			}
		}
	}

	result.ResponseStatus = resp.StatusCode
	result.ResponseBody = responseBody
	result.ResponseHeaders = s.convertHeadersToMap(resp.Header)

	// 执行断言
	result.Status, result.Errors, result.Warnings = s.executeAssertions(testCase, resp.StatusCode, responseBody, resp.Header)

	// 保存测试结果到数据库
	_, err = s.db.Exec(`
		INSERT INTO api_test_results (id, test_case_id, status, response_status, response_time, response_body, response_headers, errors, warnings, executed_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
	`, result.ID, result.TestCaseID, result.Status, result.ResponseStatus, result.ResponseTime, 
		result.ResponseBody, result.ResponseHeaders, result.Errors, result.Warnings, result.ExecutedAt)
	
	if err != nil {
		return nil, fmt.Errorf("保存测试结果失败: %w", err)
	}

	return &result, nil
}

// executeAssertions 执行断言
func (s *QAToolBoxService) executeAssertions(testCase *models.APITestCase, statusCode int, responseBody map[string]interface{}, headers http.Header) (string, []string, []string) {
	var errors []string
	var warnings []string

	// 检查状态码
	if testCase.ExpectedStatus != 0 && statusCode != testCase.ExpectedStatus {
		errors = append(errors, fmt.Sprintf("期望状态码 %d，实际状态码 %d", testCase.ExpectedStatus, statusCode))
	}

	// 执行自定义断言
	for assertionType, assertionValue := range testCase.Assertions {
		switch assertionType {
		case "status_code":
			if expectedStatus, ok := assertionValue.(float64); ok {
				if statusCode != int(expectedStatus) {
					errors = append(errors, fmt.Sprintf("状态码断言失败: 期望 %d，实际 %d", int(expectedStatus), statusCode))
				}
			}
		case "response_time":
			if maxTime, ok := assertionValue.(float64); ok {
				// 这里需要从测试结果中获取响应时间，简化处理
				if maxTime < 1000 { // 假设响应时间小于1秒
					warnings = append(warnings, "响应时间较长")
				}
			}
		case "response_contains":
			if expectedText, ok := assertionValue.(string); ok {
				responseStr := fmt.Sprintf("%v", responseBody)
				if !strings.Contains(responseStr, expectedText) {
					errors = append(errors, fmt.Sprintf("响应内容不包含期望文本: %s", expectedText))
				}
			}
		case "response_field":
			if fieldAssertion, ok := assertionValue.(map[string]interface{}); ok {
				for field, expectedValue := range fieldAssertion {
					if actualValue, exists := responseBody[field]; exists {
						if actualValue != expectedValue {
							errors = append(errors, fmt.Sprintf("字段 %s 值不匹配: 期望 %v，实际 %v", field, expectedValue, actualValue))
						}
					} else {
						errors = append(errors, fmt.Sprintf("响应中缺少字段: %s", field))
					}
				}
			}
		case "header_contains":
			if headerAssertion, ok := assertionValue.(map[string]interface{}); ok {
				for headerName, expectedValue := range headerAssertion {
					if actualValue := headers.Get(headerName); actualValue != "" {
						if !strings.Contains(actualValue, fmt.Sprintf("%v", expectedValue)) {
							warnings = append(warnings, fmt.Sprintf("响应头 %s 值不匹配: 期望包含 %v，实际 %s", headerName, expectedValue, actualValue))
						}
					} else {
						errors = append(errors, fmt.Sprintf("响应中缺少头: %s", headerName))
					}
				}
			}
		}
	}

	// 确定测试状态
	status := "passed"
	if len(errors) > 0 {
		status = "failed"
	} else if len(warnings) > 0 {
		status = "passed" // 有警告但通过
	}

	return status, errors, warnings
}

// GetAPITests 获取API测试历史
func (s *QAToolBoxService) GetAPITests(userID string, page, perPage int) ([]models.APITestResult, int, error) {
	// 计算偏移量
	offset := (page - 1) * perPage
	
	// 查询API测试结果
	rows, err := s.db.Query(`
		SELECT id, test_case_id, status, response_status, response_time, executed_at
		FROM api_test_results 
		WHERE test_case_id IN (SELECT id FROM api_test_cases WHERE user_id = $1)
		ORDER BY executed_at DESC 
		LIMIT $2 OFFSET $3
	`, userID, perPage, offset)
	if err != nil {
		return nil, 0, fmt.Errorf("查询API测试结果失败: %w", err)
	}
	defer rows.Close()
	
	var results []models.APITestResult
	for rows.Next() {
		var result models.APITestResult
		err := rows.Scan(
			&result.ID, &result.TestCaseID, &result.Status, &result.ResponseStatus,
			&result.ResponseTime, &result.ExecutedAt,
		)
		if err != nil {
			return nil, 0, fmt.Errorf("扫描API测试结果失败: %w", err)
		}
		results = append(results, result)
	}
	
	// 查询总数
	var total int
	err = s.db.QueryRow("SELECT COUNT(*) FROM api_test_results WHERE user_id = $1", userID).Scan(&total)
	if err != nil {
		return nil, 0, fmt.Errorf("查询总数失败: %w", err)
	}
	
	return results, total, nil
}
