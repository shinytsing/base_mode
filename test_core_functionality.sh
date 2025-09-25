#!/bin/bash

BASE_URL="http://localhost:8080/api/v1"
TEST_USER_EMAIL="test@qatoolbox.com"
TEST_USER_PASSWORD="password"

echo "🚀 核心功能测试"
echo "=================="

# 1. 健康检查
echo -e "\n=== 1. 健康检查 ==="
curl -X GET "${BASE_URL}/health" | jq .

# 2. 用户注册
echo -e "\n=== 2. 用户注册 ==="
REGISTER_RESPONSE=$(curl -X POST "${BASE_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"${TEST_USER_EMAIL}"'",
    "username": "testuser",
    "password": "'"${TEST_USER_PASSWORD}"'",
    "first_name": "Test",
    "last_name": "User"
  }')
echo "${REGISTER_RESPONSE}"

# 3. 用户登录
echo -e "\n=== 3. 用户登录 ==="
LOGIN_RESPONSE=$(curl -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'"${TEST_USER_EMAIL}"'",
    "password": "'"${TEST_USER_PASSWORD}"'"
  }')
echo "${LOGIN_RESPONSE}"
AUTH_TOKEN=$(echo "${LOGIN_RESPONSE}" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)

if [ -z "$AUTH_TOKEN" ]; then
  echo "❌ 无法获取认证token，跳过需要认证的接口测试"
  exit 1
fi
echo "✅ 认证Token: ${AUTH_TOKEN}"

# 4. 获取用户资料
echo -e "\n=== 4. 获取用户资料 ==="
curl -X GET "${BASE_URL}/user/profile" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 5. 获取应用列表
echo -e "\n=== 5. 获取应用列表 ==="
curl -X GET "${BASE_URL}/apps" | jq .

# 6. 安装应用
echo -e "\n=== 6. 安装应用 ==="
APP_ID="550e8400-e29b-41d4-a716-446655440101" # QA ToolBox Pro
curl -X POST "${BASE_URL}/apps/${APP_ID}/install" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{}' | jq .

# 7. 获取已安装应用
echo -e "\n=== 7. 获取已安装应用 ==="
curl -X GET "${BASE_URL}/apps/installed" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 8. 获取会员计划
echo -e "\n=== 8. 获取会员计划 ==="
curl -X GET "${BASE_URL}/membership/plans" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 9. QA ToolBox - 获取测试用例
echo -e "\n=== 9. QA ToolBox - 获取测试用例 ==="
curl -X GET "${BASE_URL}/qa-toolbox/test-cases" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 10. QA ToolBox - 生成测试用例
echo -e "\n=== 10. QA ToolBox - 生成测试用例 ==="
curl -X POST "${BASE_URL}/qa-toolbox/test-generation" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "func Add(a, b int) int { return a + b }",
    "language": "Go",
    "test_type": "单元测试"
  }' | jq .

# 11. LifeMode - 获取心情历史
echo -e "\n=== 11. LifeMode - 获取心情历史 ==="
curl -X GET "${BASE_URL}/life-mode/mood-history" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 12. FitTracker - 获取运动记录
echo -e "\n=== 12. FitTracker - 获取运动记录 ==="
curl -X GET "${BASE_URL}/fit-tracker/workouts" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 13. SocialHub - 获取匹配
echo -e "\n=== 13. SocialHub - 获取匹配 ==="
curl -X GET "${BASE_URL}/social-hub/matches" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 14. CreativeStudio - 获取写作历史
echo -e "\n=== 14. CreativeStudio - 获取写作历史 ==="
curl -X GET "${BASE_URL}/creative-studio/writing-history" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

# 15. 用户登出
echo -e "\n=== 15. 用户登出 ==="
curl -X POST "${BASE_URL}/user/logout" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

echo -e "\n✅ 核心功能测试完成！"
