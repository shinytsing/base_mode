#!/bin/bash

# QAToolBox API 测试脚本

BASE_URL="http://localhost:8080/api/v1"

echo "🧪 开始测试 QAToolBox API..."

# 测试健康检查
echo "1. 测试健康检查..."
curl -s "$BASE_URL/health" | jq '.'

# 测试用户注册
echo -e "\n2. 测试用户注册..."
REGISTER_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "username": "testuser",
    "password": "password123",
    "first_name": "Test",
    "last_name": "User"
  }')

echo "$REGISTER_RESPONSE" | jq '.'

# 测试用户登录
echo -e "\n3. 测试用户登录..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }')

echo "$LOGIN_RESPONSE" | jq '.'

# 提取token
TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.token')
if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
    echo "❌ 登录失败，无法获取token"
    exit 1
fi

echo "✅ 获取到token: $TOKEN"

# 测试获取应用列表
echo -e "\n4. 测试获取应用列表..."
curl -s "$BASE_URL/apps" | jq '.'

# 测试AI服务 - 生成测试用例
echo -e "\n5. 测试AI服务 - 生成测试用例..."
curl -s -X POST "$BASE_URL/ai/generate-test-cases" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function add(a, b) { return a + b; }",
    "language": "javascript",
    "test_type": "unit"
  }' | jq '.'

# 测试第三方服务 - 获取天气
echo -e "\n6. 测试第三方服务 - 获取天气..."
curl -s "$BASE_URL/third-party/weather/Beijing" | jq '.'

# 测试需要认证的API - 获取用户资料
echo -e "\n7. 测试需要认证的API - 获取用户资料..."
curl -s "$BASE_URL/user/profile" \
  -H "Authorization: Bearer $TOKEN" | jq '.'

# 测试QA ToolBox功能
echo -e "\n8. 测试QA ToolBox功能 - 生成测试用例..."
curl -s -X POST "$BASE_URL/qa-toolbox/test-generation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function multiply(a, b) { return a * b; }",
    "language": "javascript",
    "test_type": "unit",
    "framework": "jest"
  }' | jq '.'

# 测试LifeMode功能
echo -e "\n9. 测试LifeMode功能 - 食物推荐..."
curl -s -X POST "$BASE_URL/life-mode/food-recommendation" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "cuisine": "川菜",
    "budget": "中等",
    "meal_time": "晚餐"
  }' | jq '.'

# 测试FitTracker功能
echo -e "\n10. 测试FitTracker功能 - 创建运动记录..."
curl -s -X POST "$BASE_URL/fit-tracker/workout" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "跑步",
    "duration": 30,
    "distance": 5.0,
    "calories": 300,
    "date": "2024-01-15"
  }' | jq '.'

# 测试SocialHub功能
echo -e "\n11. 测试SocialHub功能 - 查找匹配..."
curl -s -X POST "$BASE_URL/social-hub/match" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "interests": ["音乐", "电影"],
    "age_range": "20-30",
    "location": "北京",
    "gender": "男",
    "looking_for": "朋友"
  }' | jq '.'

# 测试CreativeStudio功能
echo -e "\n12. 测试CreativeStudio功能 - 生成内容..."
curl -s -X POST "$BASE_URL/creative-studio/ai-writing" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "春天的故事",
    "type": "散文",
    "topic": "春天",
    "requirements": "写一篇关于春天的散文，要求语言优美，情感真挚"
  }' | jq '.'

echo -e "\n✅ API测试完成！"
