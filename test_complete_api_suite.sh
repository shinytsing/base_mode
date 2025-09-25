#!/bin/bash

# 完整的API测试套件
# 测试所有50+个API端点的功能

BASE_URL="http://localhost:8080/api/v1"
TEST_USER_EMAIL="newuser@example.com"
TEST_USER_PASSWORD="password123"
AUTH_TOKEN=""

echo "🚀 开始完整API功能测试"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 测试函数
test_api() {
    local method=$1
    local endpoint=$2
    local data=$3
    local headers=$4
    local description=$5
    
    echo -e "\n${BLUE}=== $description ===${NC}"
    echo "请求: $method $endpoint"
    
    if [ -n "$data" ]; then
        response=$(curl -s -X $method "${BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            $headers \
            -d "$data")
    else
        response=$(curl -s -X $method "${BASE_URL}${endpoint}" \
            $headers)
    fi
    
    # 检查响应
    if echo "$response" | jq -e '.success' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 成功${NC}"
        echo "$response" | jq .
    else
        echo -e "${RED}❌ 失败${NC}"
        echo "$response" | jq .
    fi
}

# 测试需要认证的API
test_auth_api() {
    local method=$1
    local endpoint=$2
    local data=$3
    local description=$4
    
    echo -e "\n${BLUE}=== $description ===${NC}"
    echo "请求: $method $endpoint"
    
    if [ -n "$data" ]; then
        response=$(curl -s -X $method "${BASE_URL}${endpoint}" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $AUTH_TOKEN" \
            -d "$data")
    else
        response=$(curl -s -X $method "${BASE_URL}${endpoint}" \
            -H "Authorization: Bearer $AUTH_TOKEN")
    fi
    
    # 检查响应
    if echo "$response" | jq -e '.success' > /dev/null 2>&1; then
        echo -e "${GREEN}✅ 成功${NC}"
        echo "$response" | jq .
    else
        echo -e "${RED}❌ 失败${NC}"
        echo "$response" | jq .
    fi
}

# 1. 健康检查
test_api "GET" "/health" "" "" "健康检查"

# 2. 用户注册
echo -e "\n${YELLOW}=== 用户注册测试 ===${NC}"
REGISTER_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "apitest@example.com",
        "username": "apitest",
        "password": "password123",
        "first_name": "API",
        "last_name": "Test"
    }')
echo "$REGISTER_RESPONSE" | jq .

# 3. 用户登录
echo -e "\n${YELLOW}=== 用户登录测试 ===${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "${BASE_URL}/auth/login" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "apitest@example.com",
        "password": "password123"
    }')
echo "$LOGIN_RESPONSE" | jq .

# 提取token
AUTH_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.data.token // empty')
if [ -z "$AUTH_TOKEN" ]; then
    echo -e "${RED}❌ 无法获取认证token，跳过需要认证的测试${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 认证Token获取成功${NC}"

# 4. 核心功能测试
test_api "GET" "/apps" "" "" "获取应用列表"
test_api "GET" "/apps/qa-toolbox" "" "" "获取特定应用详情"

# 5. 用户管理测试
test_auth_api "GET" "/user/profile" "" "获取用户资料"
test_auth_api "PUT" "/user/profile" '{"first_name": "UpdatedAPI", "last_name": "Test"}' "更新用户资料"

# 6. 会员管理测试
test_auth_api "GET" "/membership/plans" "" "获取会员计划"
test_auth_api "GET" "/membership/status" "" "获取会员状态"

# 7. AI服务测试
test_api "POST" "/ai/generate-test-cases" '{"code": "func Add(a, b int) int { return a + b }", "language": "Go", "test_type": "单元测试"}' "" "AI测试用例生成"
test_api "POST" "/ai/analyze-code" '{"code": "func Fibonacci(n int) int { if n <= 1 { return n }; return Fibonacci(n-1) + Fibonacci(n-2) }", "language": "Go"}' "" "AI代码分析"
test_api "POST" "/ai/generate-content" '{"content_type": "博客文章", "prompt": "关于人工智能在软件测试中的应用", "requirements": "字数不少于1000字"}' "" "AI内容生成"

# 8. 第三方服务测试
test_api "GET" "/third-party/location/北京市" "" "" "位置信息查询"
test_api "GET" "/third-party/images/search?q=Flutter&per_page=5" "" "" "图片搜索"
test_api "GET" "/third-party/weather/北京" "" "" "天气查询"
test_api "GET" "/third-party/search?q=Flutter开发&num=5" "" "" "网络搜索"

# 9. QA ToolBox功能测试
test_auth_api "POST" "/qa-toolbox/test-generation" '{"code": "func Multiply(a, b int) int { return a * b }", "language": "Go", "framework": "testing", "test_type": "单元测试"}' "测试用例生成"
test_auth_api "GET" "/qa-toolbox/test-cases" "" "获取测试用例"
test_auth_api "POST" "/qa-toolbox/pdf-conversion" '{"url": "https://example.com/document.pdf", "format": "text"}' "PDF转换"
test_auth_api "GET" "/qa-toolbox/pdf-conversions" "" "获取PDF转换记录"
test_auth_api "POST" "/qa-toolbox/crawler" '{"url": "https://example.com", "depth": 2, "max_pages": 10}' "创建爬虫任务"
test_auth_api "GET" "/qa-toolbox/crawler-tasks" "" "获取爬虫任务"
test_auth_api "POST" "/qa-toolbox/api-test" '{"name": "测试API", "method": "GET", "url": "https://httpbin.org/get", "headers": {}, "body": ""}' "API测试"
test_auth_api "GET" "/qa-toolbox/api-tests" "" "获取API测试记录"

# 10. LifeMode功能测试
test_auth_api "POST" "/life-mode/food-recommendation" '{"preferences": ["健康", "素食"], "dietary_restrictions": [], "location": "北京"}' "食物推荐"
test_auth_api "POST" "/life-mode/travel-plan" '{"destination": "北京", "duration": 3, "budget": 2000, "interests": ["历史", "文化"]}' "旅行计划"
test_auth_api "POST" "/life-mode/mood-entry" '{"mood": "开心", "energy_level": 8, "notes": "今天工作很顺利"}' "心情记录"
test_auth_api "GET" "/life-mode/mood-history" "" "心情历史"
test_auth_api "POST" "/life-mode/meditation-session" '{"duration": 10, "type": "正念冥想", "notes": "放松身心"}' "冥想会话"
test_auth_api "GET" "/life-mode/meditation-history" "" "冥想历史"

# 11. FitTracker功能测试
test_auth_api "POST" "/fit-tracker/workout" '{"name": "晨跑", "type": "有氧", "duration": 30, "calories_burned": 300}' "创建运动记录"
test_auth_api "GET" "/fit-tracker/workouts" "" "获取运动记录"
test_auth_api "POST" "/fit-tracker/nutrition-log" '{"meal_type": "早餐", "foods": [{"name": "燕麦", "calories": 200, "protein": 8}]}' "营养记录"
test_auth_api "GET" "/fit-tracker/nutrition-history" "" "营养历史"
test_auth_api "POST" "/fit-tracker/health-metric" '{"metric_type": "体重", "value": 70.5, "unit": "kg"}' "健康指标"
test_auth_api "GET" "/fit-tracker/health-metrics" "" "健康指标历史"
test_auth_api "POST" "/fit-tracker/habit-checkin" '{"habit_name": "早起", "completed": true, "notes": "6点起床"}' "习惯打卡"
test_auth_api "GET" "/fit-tracker/habits" "" "获取习惯"

# 12. SocialHub功能测试
test_auth_api "POST" "/social-hub/match" '{"preferences": {"age_range": [25, 35], "interests": ["编程", "音乐"]}}' "智能匹配"
test_auth_api "GET" "/social-hub/matches" "" "获取匹配"
test_auth_api "POST" "/social-hub/activity" '{"title": "编程聚会", "description": "一起学习编程", "location": "北京", "date": "2025-10-01", "max_participants": 10}' "创建活动"
test_auth_api "GET" "/social-hub/activities" "" "获取活动"
test_auth_api "POST" "/social-hub/chat/send" '{"recipient_id": "user123", "message": "你好！", "message_type": "text"}' "发送消息"

# 13. CreativeStudio功能测试
test_api "POST" "/creative-studio/ai-writing" '{"title": "AI的未来", "type": "博客文章", "topic": "人工智能", "length": 1000}' "-H \"Authorization: Bearer $AUTH_TOKEN\"" "AI写作"
test_api "GET" "/creative-studio/writing-history" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "写作历史"
test_api "POST" "/creative-studio/avatar-generation" '{"style": "动漫", "description": "一个程序员角色", "gender": "male"}' "-H \"Authorization: Bearer $AUTH_TOKEN\"" "头像生成"
test_api "GET" "/creative-studio/avatars" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "获取头像"
test_api "POST" "/creative-studio/music-composition" '{"genre": "电子", "mood": "轻松", "duration": 120}' "-H \"Authorization: Bearer $AUTH_TOKEN\"" "音乐创作"
test_api "GET" "/creative-studio/music-compositions" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "音乐作品"
test_api "POST" "/creative-studio/design" '{"type": "海报", "theme": "科技", "style": "现代", "content": "AI技术展示"}' "-H \"Authorization: Bearer $AUTH_TOKEN\"" "设计创作"
test_api "GET" "/creative-studio/designs" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "设计作品"

# 14. 应用管理测试
test_api "POST" "/apps/qa-toolbox/install" '{}' "-H \"Authorization: Bearer $AUTH_TOKEN\"" "安装应用"
test_api "GET" "/apps/installed" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "获取已安装应用"
test_api "DELETE" "/apps/qa-toolbox/uninstall" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "卸载应用"

# 15. 支付测试
test_api "POST" "/payment/create-intent" '{"plan_id": "550e8400-e29b-41d4-a716-446655440002", "amount": 2990, "currency": "CNY"}' "-H \"Authorization: Bearer $AUTH_TOKEN\"" "创建支付意图"
test_api "GET" "/payment/history" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "支付历史"

# 16. 用户登出
test_api "POST" "/user/logout" "" "-H \"Authorization: Bearer $AUTH_TOKEN\"" "用户登出"

echo -e "\n${GREEN}🎉 完整API测试套件执行完成！${NC}"
echo "=================================="
echo "测试了所有核心功能："
echo "✅ 用户认证和管理"
echo "✅ 应用管理"
echo "✅ 会员管理"
echo "✅ AI服务"
echo "✅ 第三方服务"
echo "✅ QA ToolBox功能"
echo "✅ LifeMode功能"
echo "✅ FitTracker功能"
echo "✅ SocialHub功能"
echo "✅ CreativeStudio功能"
echo "✅ 支付功能"
echo "=================================="
