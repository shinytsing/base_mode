package main

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/joho/godotenv"
	"qa-toolbox-backend/internal/config"
)

func main() {
	// 加载环境变量
	if err := godotenv.Load("env.local"); err != nil {
		fmt.Println("No env.local file found")
	}

	// 加载配置
	cfg := config.Load()
	fmt.Printf("Tencent Secret ID: %s\n", cfg.TencentSecretID)
	fmt.Printf("Tencent Secret Key: %s\n", cfg.TencentSecretKey)

	if cfg.TencentSecretID == "" || cfg.TencentSecretKey == "" {
		fmt.Println("腾讯云密钥未配置")
		return
	}

	// 测试修复后的腾讯混元API
	testFixedTencentAPI(cfg.TencentSecretID, cfg.TencentSecretKey)
}

func testFixedTencentAPI(secretID, secretKey string) {
	// API配置
	service := "hunyuan"
	host := "hunyuan.tencentcloudapi.com"
	endpoint := "https://hunyuan.tencentcloudapi.com"
	action := "ChatCompletions"
	region := "ap-beijing"
	version := "2023-09-01"
	timestamp := time.Now().Unix()
	date := time.Now().UTC().Format("2006-01-02")
	algorithm := "TC3-HMAC-SHA256"

	// 构建请求体 - 使用ChatCompletions格式
	payload := map[string]interface{}{
		"Model": "hunyuan-lite",
		"Messages": []map[string]interface{}{
			{"role": "user", "content": "你好，请用一句话介绍Go语言"},
		},
		"Temperature": 0.7,
		"MaxTokens": 100,
	}

	payloadJSON, err := json.Marshal(payload)
	if err != nil {
		fmt.Printf("序列化请求体失败: %v\n", err)
		return
	}

	fmt.Printf("请求体: %s\n", string(payloadJSON))

	// 计算请求体哈希
	hashedPayload := fmt.Sprintf("%x", sha256.Sum256(payloadJSON))

	// 构造规范请求串
	canonicalRequest := fmt.Sprintf(
		"POST\n/\n\ncontent-type:application/json\nhost:%s\nx-tc-action:%s\n\ncontent-type;host;x-tc-action\n%s",
		host, action, hashedPayload,
	)

	fmt.Printf("规范请求串:\n%s\n", canonicalRequest)

	// 构造待签名字符串
	credentialScope := fmt.Sprintf("%s/%s/tc3_request", date, service)
	hashedCanonicalRequest := fmt.Sprintf("%x", sha256.Sum256([]byte(canonicalRequest)))
	stringToSign := fmt.Sprintf("%s\n%d\n%s\n%s", algorithm, timestamp, credentialScope, hashedCanonicalRequest)

	fmt.Printf("待签名字符串:\n%s\n", stringToSign)

	// 计算签名
	signature := calculateSignature(secretKey, date, service, stringToSign)
	fmt.Printf("签名: %s\n", signature)

	// 构造Authorization头部
	authorization := fmt.Sprintf("%s Credential=%s/%s, SignedHeaders=content-type;host;x-tc-action, Signature=%s",
		algorithm, secretID, credentialScope, signature)

	fmt.Printf("Authorization: %s\n", authorization)

	// 创建HTTP请求
	httpReq, err := http.NewRequestWithContext(context.Background(), "POST", endpoint, bytes.NewBuffer(payloadJSON))
	if err != nil {
		fmt.Printf("创建请求失败: %v\n", err)
		return
	}

	// 设置请求头
	httpReq.Header.Set("Content-Type", "application/json")
	httpReq.Header.Set("Host", host)
	httpReq.Header.Set("X-TC-Action", action)
	httpReq.Header.Set("X-TC-Timestamp", fmt.Sprintf("%d", timestamp))
	httpReq.Header.Set("X-TC-Version", version)
	httpReq.Header.Set("X-TC-Region", region)
	httpReq.Header.Set("Authorization", authorization)

	// 发送请求
	client := &http.Client{Timeout: 30 * time.Second}
	resp, err := client.Do(httpReq)
	if err != nil {
		fmt.Printf("请求失败: %v\n", err)
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Printf("读取响应失败: %v\n", err)
		return
	}

	fmt.Printf("响应状态码: %d\n", resp.StatusCode)
	fmt.Printf("响应内容: %s\n", string(body))
}

// calculateSignature 计算TC3-HMAC-SHA256签名
func calculateSignature(secretKey, date, service, stringToSign string) string {
	// 计算签名密钥
	secretDate := hmacSHA256([]byte("TC3"+secretKey), date)
	secretService := hmacSHA256(secretDate, service)
	secretSigning := hmacSHA256(secretService, "tc3_request")

	// 计算最终签名
	signature := hmacSHA256(secretSigning, stringToSign)
	return fmt.Sprintf("%x", signature)
}

// hmacSHA256 计算HMAC-SHA256
func hmacSHA256(key []byte, data string) []byte {
	h := hmac.New(sha256.New, key)
	h.Write([]byte(data))
	return h.Sum(nil)
}
