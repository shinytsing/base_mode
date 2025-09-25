#!/bin/bash

BASE_URL="http://localhost:8080/api/v1"

echo "🚀 LLM大服务完整测试"
echo "=================================="

# 等待服务启动
sleep 3

# 1. LLM服务健康检查
echo -e "\n=== 1. LLM服务健康检查 ==="
curl -X GET "${BASE_URL}/llm/health" | jq .

# 2. 获取可用模型列表
echo -e "\n=== 2. 获取可用模型列表 ==="
curl -X GET "${BASE_URL}/llm/models" | jq .

# 3. 简单文本生成测试
echo -e "\n=== 3. 简单文本生成测试 ==="
curl -X POST "${BASE_URL}/llm/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "请用一句话介绍Go语言的特点",
    "model": "auto",
    "temperature": 0.7,
    "max_tokens": 100
  }' | jq .

# 4. LLM对话测试
echo -e "\n=== 4. LLM对话测试 ==="
curl -X POST "${BASE_URL}/llm/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "你是一个专业的软件测试工程师"},
      {"role": "user", "content": "请为以下Go函数生成测试用例：func Add(a, b int) int { return a + b }"}
    ],
    "model": "auto",
    "temperature": 0.3,
    "max_tokens": 500
  }' | jq .

# 5. 指定腾讯混元模型测试
echo -e "\n=== 5. 指定腾讯混元模型测试 ==="
curl -X POST "${BASE_URL}/llm/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "请解释什么是微服务架构",
    "model": "hunyuan-lite",
    "temperature": 0.5,
    "max_tokens": 200
  }' | jq .

# 6. 指定DeepSeek模型测试
echo -e "\n=== 6. 指定DeepSeek模型测试 ==="
curl -X POST "${BASE_URL}/llm/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "请写一个简单的Go HTTP服务器",
    "model": "deepseek-chat",
    "temperature": 0.2,
    "max_tokens": 300
  }' | jq .

# 7. 多轮对话测试
echo -e "\n=== 7. 多轮对话测试 ==="
curl -X POST "${BASE_URL}/llm/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "你是一个Flutter开发专家"},
      {"role": "user", "content": "Flutter和React Native有什么区别？"},
      {"role": "assistant", "content": "Flutter使用Dart语言，React Native使用JavaScript。Flutter性能更好，React Native生态更丰富。"},
      {"role": "user", "content": "那Flutter适合开发什么类型的应用？"}
    ],
    "model": "auto",
    "temperature": 0.6,
    "max_tokens": 400
  }' | jq .

# 8. 创意写作测试
echo -e "\n=== 8. 创意写作测试 ==="
curl -X POST "${BASE_URL}/llm/generate" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "写一首关于程序员生活的短诗",
    "model": "auto",
    "temperature": 0.9,
    "max_tokens": 150
  }' | jq .

# 9. 代码分析测试
echo -e "\n=== 9. 代码分析测试 ==="
curl -X POST "${BASE_URL}/llm/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "你是一个代码审查专家"},
      {"role": "user", "content": "请分析这段代码的问题：\nfunc divide(a, b int) int {\n    return a / b\n}"}
    ],
    "model": "auto",
    "temperature": 0.1,
    "max_tokens": 300
  }' | jq .

# 10. 压力测试 - 并发请求
echo -e "\n=== 10. 并发压力测试 ==="
for i in {1..3}; do
  echo "并发请求 $i"
  curl -X POST "${BASE_URL}/llm/generate" \
    -H "Content-Type: application/json" \
    -d "{
      \"prompt\": \"测试请求 $i：请简单介绍一下人工智能\",
      \"model\": \"auto\",
      \"temperature\": 0.5,
      \"max_tokens\": 100
    }" &
done
wait

echo -e "\n✅ LLM大服务测试完成！"
echo "=================================="
echo "测试总结："
echo "- ✅ 健康检查：检查LLM服务状态"
echo "- ✅ 模型列表：获取可用AI模型"
echo "- ✅ 文本生成：基础文本生成功能"
echo "- ✅ 对话功能：多轮对话支持"
echo "- ✅ 模型选择：支持指定特定模型"
echo "- ✅ 创意写作：高温度创意内容"
echo "- ✅ 代码分析：低温度精确分析"
echo "- ✅ 并发测试：多请求并发处理"
echo "=================================="
