#!/bin/bash

BASE_URL="http://localhost:8080/api/v1"

echo "🔐 JWT Token测试"
echo "=================="

# 1. 用户登录获取token
echo -e "\n=== 1. 用户登录 ==="
LOGIN_RESPONSE=$(curl -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@qatoolbox.com",
    "password": "password"
  }')
echo "${LOGIN_RESPONSE}"

# 提取token
AUTH_TOKEN=$(echo "${LOGIN_RESPONSE}" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
echo "Token: ${AUTH_TOKEN}"

# 2. 测试token验证
echo -e "\n=== 2. 测试token验证 ==="
curl -X GET "${BASE_URL}/user/profile" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .

echo -e "\nJWT测试完成！"
