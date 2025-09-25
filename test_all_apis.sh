#!/bin/bash

BASE_URL="http://localhost:8080/api/v1"
echo "🚀 开始完整API接口联调测试"
echo "=================================="

# 1. 健康检查
echo "=== 1. 健康检查 ==="
curl -X GET "${BASE_URL}/health" | jq .
echo ""

# 2. 测试AI接口（不需要认证）
echo "=== 2. AI测试用例生成 ==="
curl -X POST "${BASE_URL}/ai/generate-test-cases" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function add(a, b) { return a + b; }",
    "language": "JavaScript",
    "test_type": "unit"
  }' | jq .
echo ""

# 3. AI代码分析
echo "=== 3. AI代码分析 ==="
curl -X POST "${BASE_URL}/ai/analyze-code" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function add(a, b) { return a + b; }",
    "language": "JavaScript"
  }' | jq .
echo ""

# 4. AI内容生成
echo "=== 4. AI内容生成 ==="
curl -X POST "${BASE_URL}/ai/generate-content" \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "写一篇关于Flutter开发的博客文章",
    "content_type": "blog",
    "requirements": "1000字左右，包含代码示例"
  }' | jq .
echo ""

# 5. 第三方服务 - 位置信息
echo "=== 5. 位置信息查询 ==="
curl -X GET "${BASE_URL}/third-party/location/北京市" | jq .
echo ""

# 6. 第三方服务 - 图片搜索
echo "=== 6. 图片搜索 ==="
curl -X GET "${BASE_URL}/third-party/images/search?q=Flutter&per_page=5" | jq .
echo ""

# 7. 第三方服务 - 天气查询
echo "=== 7. 天气查询 ==="
curl -X GET "${BASE_URL}/third-party/weather/北京" | jq .
echo ""

# 8. 第三方服务 - 网络搜索
echo "=== 8. 网络搜索 ==="
curl -X GET "${BASE_URL}/third-party/search?q=Flutter开发&num=5" | jq .
echo ""

# 9. 用户注册
echo "=== 9. 用户注册 ==="
REGISTER_RESPONSE=$(curl -X POST "${BASE_URL}/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "apitest@qatoolbox.com",
    "username": "apitest",
    "password": "password123",
    "first_name": "API",
    "last_name": "Test"
  }')
echo "${REGISTER_RESPONSE}" | jq .
echo ""

# 10. 用户登录
echo "=== 10. 用户登录 ==="
LOGIN_RESPONSE=$(curl -X POST "${BASE_URL}/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "apitest@qatoolbox.com",
    "password": "password123"
  }')
echo "${LOGIN_RESPONSE}" | jq .

# 提取token
AUTH_TOKEN=$(echo "${LOGIN_RESPONSE}" | jq -r '.data.token // empty')
if [ -z "$AUTH_TOKEN" ]; then
    echo "❌ 无法获取认证token，跳过需要认证的接口测试"
    exit 1
fi
echo "✅ 获取到认证token: ${AUTH_TOKEN:0:20}..."
echo ""

# 11. 用户资料
echo "=== 11. 获取用户资料 ==="
curl -X GET "${BASE_URL}/user/profile" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .
echo ""

# 12. QA ToolBox - 测试用例生成
echo "=== 12. QA ToolBox - 测试用例生成 ==="
curl -X POST "${BASE_URL}/qa-toolbox/test-generation" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "code": "function calculate(a, b, operation) { return operation(a, b); }",
    "language": "JavaScript",
    "framework": "Jest",
    "test_type": "unit"
  }' | jq .
echo ""

# 13. QA ToolBox - PDF转换
echo "=== 13. QA ToolBox - PDF转换 ==="
curl -X POST "${BASE_URL}/qa-toolbox/pdf-conversion" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "source_file_url": "https://example.com/document.pdf",
    "source_format": "pdf",
    "target_format": "docx"
  }' | jq .
echo ""

# 14. QA ToolBox - 爬虫任务
echo "=== 14. QA ToolBox - 创建爬虫任务 ==="
curl -X POST "${BASE_URL}/qa-toolbox/crawler" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "测试爬虫",
    "url": "https://example.com",
    "type": "web"
  }' | jq .
echo ""

# 15. QA ToolBox - API测试
echo "=== 15. QA ToolBox - API测试 ==="
curl -X POST "${BASE_URL}/qa-toolbox/api-test" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "测试API",
    "base_url": "https://api.example.com",
    "headers": {"Content-Type": "application/json"},
    "variables": {"api_key": "test123"}
  }' | jq .
echo ""

# 16. LifeMode - 美食推荐
echo "=== 16. LifeMode - 美食推荐 ==="
curl -X POST "${BASE_URL}/life-mode/food-recommendation" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "preferences": ["川菜", "辣"],
    "location": "北京",
    "budget": 100
  }' | jq .
echo ""

# 17. LifeMode - 旅行规划
echo "=== 17. LifeMode - 旅行规划 ==="
curl -X POST "${BASE_URL}/life-mode/travel-plan" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "destination": "上海",
    "duration": 3,
    "budget": 2000,
    "interests": ["美食", "文化"]
  }' | jq .
echo ""

# 18. LifeMode - 情绪记录
echo "=== 18. LifeMode - 情绪记录 ==="
curl -X POST "${BASE_URL}/life-mode/mood-entry" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "mood": "happy",
    "energy_level": 8,
    "notes": "今天工作很顺利"
  }' | jq .
echo ""

# 19. LifeMode - 冥想会话
echo "=== 19. LifeMode - 冥想会话 ==="
curl -X POST "${BASE_URL}/life-mode/meditation-session" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "breathing",
    "duration": 10,
    "background_music": "nature"
  }' | jq .
echo ""

# 20. FitTracker - 运动记录
echo "=== 20. FitTracker - 运动记录 ==="
curl -X POST "${BASE_URL}/fit-tracker/workout" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "晨跑",
    "type": "running",
    "duration": 30,
    "calories_burned": 300,
    "distance": 5.0
  }' | jq .
echo ""

# 21. FitTracker - 营养记录
echo "=== 21. FitTracker - 营养记录 ==="
curl -X POST "${BASE_URL}/fit-tracker/nutrition-log" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "meal_type": "breakfast",
    "foods": [{"name": "燕麦", "calories": 200, "protein": 8}],
    "total_calories": 200
  }' | jq .
echo ""

# 22. FitTracker - 健康指标
echo "=== 22. FitTracker - 健康指标 ==="
curl -X POST "${BASE_URL}/fit-tracker/health-metric" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "weight",
    "value": 70.5,
    "unit": "kg"
  }' | jq .
echo ""

# 23. FitTracker - 习惯打卡
echo "=== 23. FitTracker - 习惯打卡 ==="
curl -X POST "${BASE_URL}/fit-tracker/habit-checkin" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "habit_id": "drink_water",
    "completed": true,
    "notes": "今天喝了8杯水"
  }' | jq .
echo ""

# 24. SocialHub - 智能匹配
echo "=== 24. SocialHub - 智能匹配 ==="
curl -X POST "${BASE_URL}/social-hub/match" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "interests": ["编程", "音乐"],
    "location": "北京",
    "age_range": [25, 35]
  }' | jq .
echo ""

# 25. SocialHub - 创建活动
echo "=== 25. SocialHub - 创建活动 ==="
curl -X POST "${BASE_URL}/social-hub/activity" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Flutter技术分享会",
    "description": "分享Flutter开发经验",
    "location": "北京",
    "date": "2025-10-01",
    "max_participants": 20
  }' | jq .
echo ""

# 26. SocialHub - 发送消息
echo "=== 26. SocialHub - 发送消息 ==="
curl -X POST "${BASE_URL}/social-hub/chat/send" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "chat_id": "test_chat_123",
    "message": "你好，很高兴认识你！",
    "type": "text"
  }' | jq .
echo ""

# 27. CreativeStudio - AI写作
echo "=== 27. CreativeStudio - AI写作 ==="
curl -X POST "${BASE_URL}/creative-studio/ai-writing" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Flutter开发指南",
    "type": "tutorial",
    "topic": "Flutter基础",
    "length": 1000
  }' | jq .
echo ""

# 28. CreativeStudio - 头像生成
echo "=== 28. CreativeStudio - 头像生成 ==="
curl -X POST "${BASE_URL}/creative-studio/avatar-generation" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "style": "cartoon",
    "gender": "male",
    "age": 25,
    "features": ["glasses", "beard"]
  }' | jq .
echo ""

# 29. CreativeStudio - 音乐创作
echo "=== 29. CreativeStudio - 音乐创作 ==="
curl -X POST "${BASE_URL}/creative-studio/music-composition" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "genre": "electronic",
    "mood": "energetic",
    "duration": 180,
    "instruments": ["synthesizer", "drums"]
  }' | jq .
echo ""

# 30. CreativeStudio - 设计创作
echo "=== 30. CreativeStudio - 设计创作 ==="
curl -X POST "${BASE_URL}/creative-studio/design" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{
    "type": "logo",
    "style": "modern",
    "colors": ["#6366F1", "#10B981"],
    "text": "QAToolBox"
  }' | jq .
echo ""

# 31. 会员计划
echo "=== 31. 获取会员计划 ==="
curl -X GET "${BASE_URL}/membership/plans" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .
echo ""

# 32. 支付历史
echo "=== 32. 获取支付历史 ==="
curl -X GET "${BASE_URL}/payment/history" \
  -H "Authorization: Bearer ${AUTH_TOKEN}" | jq .
echo ""

echo "🎉 完整API接口联调测试完成！"
echo "=================================="
