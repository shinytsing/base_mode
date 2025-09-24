-- QAToolBox PostgreSQL 数据库初始化脚本
-- 创建数据库和基础表结构

-- 创建扩展
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    avatar_url VARCHAR(500),
    is_active BOOLEAN DEFAULT TRUE,
    is_premium BOOLEAN DEFAULT FALSE,
    subscription_type VARCHAR(20) DEFAULT 'free',
    subscription_expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_subscription_type CHECK (subscription_type IN ('free', 'basic', 'premium', 'vip'))
);

-- 应用表
CREATE TABLE IF NOT EXISTS apps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL,
    icon VARCHAR(100),
    color VARCHAR(20),
    version VARCHAR(20) DEFAULT '1.0.0',
    is_active BOOLEAN DEFAULT TRUE,
    features JSONB DEFAULT '[]',
    screenshots JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 用户应用关系表
CREATE TABLE IF NOT EXISTS user_apps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    app_id UUID NOT NULL REFERENCES apps(id) ON DELETE CASCADE,
    installed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    last_used_at TIMESTAMP WITH TIME ZONE,
    usage_count INTEGER DEFAULT 0,
    settings JSONB DEFAULT '{}',
    UNIQUE(user_id, app_id)
);

-- 会员计划表
CREATE TABLE IF NOT EXISTS membership_plans (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    duration INTEGER NOT NULL, -- 天数
    max_apps INTEGER NOT NULL,
    features JSONB DEFAULT '[]',
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 订阅表
CREATE TABLE IF NOT EXISTS subscriptions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    plan_id UUID NOT NULL REFERENCES membership_plans(id),
    status VARCHAR(20) DEFAULT 'pending',
    start_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    auto_renew BOOLEAN DEFAULT TRUE,
    payment_method VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_subscription_status CHECK (status IN ('pending', 'active', 'cancelled', 'expired'))
);

-- 支付表
CREATE TABLE IF NOT EXISTS payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE SET NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    status VARCHAR(20) DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_id VARCHAR(100),
    transaction_id VARCHAR(100),
    gateway_response JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT valid_payment_status CHECK (status IN ('pending', 'completed', 'failed', 'refunded'))
);

-- 发票表
CREATE TABLE IF NOT EXISTS invoices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_id UUID NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(255) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    status VARCHAR(20) DEFAULT 'generated',
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_invoice_status CHECK (status IN ('generated', 'sent', 'paid', 'cancelled'))
);

-- 退款表
CREATE TABLE IF NOT EXISTS refunds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    payment_id UUID NOT NULL REFERENCES payments(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    status VARCHAR(20) DEFAULT 'pending',
    reason TEXT,
    stripe_refund_id VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_refund_status CHECK (status IN ('pending', 'succeeded', 'failed', 'cancelled'))
);

-- 测试用例表
CREATE TABLE IF NOT EXISTS test_cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    generation_id UUID NOT NULL,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    code TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,
    tags JSONB DEFAULT '[]',
    priority INTEGER DEFAULT 1,
    is_automated BOOLEAN DEFAULT FALSE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 项目表
CREATE TABLE IF NOT EXISTS projects (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'active',
    settings JSONB DEFAULT '{}',
    deadline TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_project_status CHECK (status IN ('active', 'completed', 'cancelled', 'archived'))
);

-- 任务表
CREATE TABLE IF NOT EXISTS tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',
    priority VARCHAR(20) DEFAULT 'medium',
    assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
    creator_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    tags JSONB DEFAULT '[]',
    metadata JSONB DEFAULT '{}',
    estimated_hours INTEGER DEFAULT 0,
    actual_hours INTEGER DEFAULT 0,
    due_date TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_task_status CHECK (status IN ('pending', 'in_progress', 'completed', 'cancelled')),
    CONSTRAINT valid_task_priority CHECK (priority IN ('low', 'medium', 'high', 'urgent'))
);

-- PDF转换记录表
CREATE TABLE IF NOT EXISTS pdf_conversions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    source_file_url VARCHAR(500) NOT NULL,
    target_file_url VARCHAR(500),
    source_format VARCHAR(20) NOT NULL,
    target_format VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    file_size INTEGER DEFAULT 0,
    page_count INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_conversion_status CHECK (status IN ('pending', 'processing', 'completed', 'failed'))
);

-- 爬虫任务表
CREATE TABLE IF NOT EXISTS crawler_tasks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    url VARCHAR(500) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    config JSONB DEFAULT '{}',
    selectors JSONB DEFAULT '[]',
    max_pages INTEGER DEFAULT 10,
    delay_ms INTEGER DEFAULT 1000,
    follow_links BOOLEAN DEFAULT FALSE,
    respect_robots BOOLEAN DEFAULT TRUE,
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_crawler_status CHECK (status IN ('pending', 'running', 'completed', 'failed', 'cancelled'))
);

-- 爬虫结果表
CREATE TABLE IF NOT EXISTS crawler_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    task_id UUID NOT NULL REFERENCES crawler_tasks(id) ON DELETE CASCADE,
    url VARCHAR(500) NOT NULL,
    data JSONB DEFAULT '{}',
    status_code INTEGER DEFAULT 0,
    response_time INTEGER DEFAULT 0,
    headers JSONB DEFAULT '{}',
    crawled_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- API测试套件表
CREATE TABLE IF NOT EXISTS api_test_suites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    base_url VARCHAR(500) NOT NULL,
    headers JSONB DEFAULT '{}',
    variables JSONB DEFAULT '{}',
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_suite_status CHECK (status IN ('active', 'inactive', 'archived'))
);

-- API测试用例表
CREATE TABLE IF NOT EXISTS api_test_cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    suite_id UUID NOT NULL REFERENCES api_test_suites(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    method VARCHAR(10) NOT NULL,
    endpoint VARCHAR(500) NOT NULL,
    headers JSONB DEFAULT '{}',
    params JSONB DEFAULT '{}',
    body JSONB DEFAULT '{}',
    assertions JSONB DEFAULT '{}',
    expected_status INTEGER DEFAULT 200,
    timeout INTEGER DEFAULT 30,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_http_method CHECK (method IN ('GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'HEAD', 'OPTIONS'))
);

-- API测试结果表
CREATE TABLE IF NOT EXISTS api_test_results (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    test_case_id UUID NOT NULL REFERENCES api_test_cases(id) ON DELETE CASCADE,
    status VARCHAR(20) NOT NULL,
    response_status INTEGER DEFAULT 0,
    response_time INTEGER DEFAULT 0,
    response_body JSONB DEFAULT '{}',
    response_headers JSONB DEFAULT '{}',
    errors JSONB DEFAULT '[]',
    warnings JSONB DEFAULT '[]',
    executed_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_test_status CHECK (status IN ('passed', 'failed', 'error', 'skipped'))
);

-- 代码审查表
CREATE TABLE IF NOT EXISTS code_reviews (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    repository VARCHAR(500) NOT NULL,
    branch VARCHAR(100) NOT NULL,
    commit_hash VARCHAR(40) NOT NULL,
    author_id UUID REFERENCES users(id) ON DELETE SET NULL,
    reviewer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    status VARCHAR(20) DEFAULT 'pending',
    files JSONB DEFAULT '[]',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT valid_review_status CHECK (status IN ('pending', 'in_progress', 'approved', 'rejected', 'merged'))
);

-- 代码审查评论表
CREATE TABLE IF NOT EXISTS code_review_comments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    review_id UUID NOT NULL REFERENCES code_reviews(id) ON DELETE CASCADE,
    author_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    file VARCHAR(500),
    line INTEGER DEFAULT 0,
    type VARCHAR(20) DEFAULT 'comment',
    resolved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_comment_type CHECK (type IN ('comment', 'suggestion', 'question', 'approval', 'rejection'))
);

-- 通知表
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    type VARCHAR(20) DEFAULT 'system',
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_notification_type CHECK (type IN ('system', 'promotion', 'update', 'reminder', 'payment'))
);

-- 反馈表
CREATE TABLE IF NOT EXISTS feedbacks (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    app_id UUID REFERENCES apps(id) ON DELETE SET NULL,
    type VARCHAR(20) DEFAULT 'suggestion',
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    priority VARCHAR(20) DEFAULT 'medium',
    admin_response TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_feedback_type CHECK (type IN ('bug', 'feature', 'suggestion', 'complaint')),
    CONSTRAINT valid_feedback_status CHECK (status IN ('pending', 'in_progress', 'resolved', 'closed')),
    CONSTRAINT valid_feedback_priority CHECK (priority IN ('low', 'medium', 'high', 'urgent'))
);

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_configs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_subscription_type ON users(subscription_type);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON users(created_at);

CREATE INDEX IF NOT EXISTS idx_apps_category ON apps(category);
CREATE INDEX IF NOT EXISTS idx_apps_is_active ON apps(is_active);

CREATE INDEX IF NOT EXISTS idx_user_apps_user_id ON user_apps(user_id);
CREATE INDEX IF NOT EXISTS idx_user_apps_app_id ON user_apps(app_id);
CREATE INDEX IF NOT EXISTS idx_user_apps_last_used ON user_apps(last_used_at);

CREATE INDEX IF NOT EXISTS idx_subscriptions_user_id ON subscriptions(user_id);
CREATE INDEX IF NOT EXISTS idx_subscriptions_status ON subscriptions(status);
CREATE INDEX IF NOT EXISTS idx_subscriptions_end_date ON subscriptions(end_date);

CREATE INDEX IF NOT EXISTS idx_payments_user_id ON payments(user_id);
CREATE INDEX IF NOT EXISTS idx_payments_status ON payments(status);
CREATE INDEX IF NOT EXISTS idx_payments_payment_id ON payments(payment_id);

CREATE INDEX IF NOT EXISTS idx_tasks_project_id ON tasks(project_id);
CREATE INDEX IF NOT EXISTS idx_tasks_assignee_id ON tasks(assignee_id);
CREATE INDEX IF NOT EXISTS idx_tasks_status ON tasks(status);
CREATE INDEX IF NOT EXISTS idx_tasks_priority ON tasks(priority);

CREATE INDEX IF NOT EXISTS idx_pdf_conversions_user_id ON pdf_conversions(user_id);
CREATE INDEX IF NOT EXISTS idx_pdf_conversions_status ON pdf_conversions(status);

CREATE INDEX IF NOT EXISTS idx_crawler_tasks_user_id ON crawler_tasks(user_id);
CREATE INDEX IF NOT EXISTS idx_crawler_tasks_status ON crawler_tasks(status);

CREATE INDEX IF NOT EXISTS idx_crawler_results_task_id ON crawler_results(task_id);

CREATE INDEX IF NOT EXISTS idx_api_test_suites_user_id ON api_test_suites(user_id);
CREATE INDEX IF NOT EXISTS idx_api_test_cases_suite_id ON api_test_cases(suite_id);
CREATE INDEX IF NOT EXISTS idx_api_test_results_test_case_id ON api_test_results(test_case_id);

CREATE INDEX IF NOT EXISTS idx_code_reviews_author_id ON code_reviews(author_id);
CREATE INDEX IF NOT EXISTS idx_code_reviews_reviewer_id ON code_reviews(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_code_reviews_status ON code_reviews(status);

CREATE INDEX IF NOT EXISTS idx_code_review_comments_review_id ON code_review_comments(review_id);
CREATE INDEX IF NOT EXISTS idx_code_review_comments_author_id ON code_review_comments(author_id);

CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_is_read ON notifications(is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_type ON notifications(type);

CREATE INDEX IF NOT EXISTS idx_feedbacks_user_id ON feedbacks(user_id);
CREATE INDEX IF NOT EXISTS idx_feedbacks_app_id ON feedbacks(app_id);
CREATE INDEX IF NOT EXISTS idx_feedbacks_status ON feedbacks(status);
CREATE INDEX IF NOT EXISTS idx_feedbacks_type ON feedbacks(type);

CREATE INDEX IF NOT EXISTS idx_system_configs_config_key ON system_configs(config_key);
CREATE INDEX IF NOT EXISTS idx_system_configs_is_active ON system_configs(is_active);

-- 创建更新时间触发器函数
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- 为需要的表创建更新时间触发器
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_apps_updated_at BEFORE UPDATE ON apps FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_apps_updated_at BEFORE UPDATE ON user_apps FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_membership_plans_updated_at BEFORE UPDATE ON membership_plans FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_subscriptions_updated_at BEFORE UPDATE ON subscriptions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_projects_updated_at BEFORE UPDATE ON projects FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_pdf_conversions_updated_at BEFORE UPDATE ON pdf_conversions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_crawler_tasks_updated_at BEFORE UPDATE ON crawler_tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_api_test_suites_updated_at BEFORE UPDATE ON api_test_suites FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_code_reviews_updated_at BEFORE UPDATE ON code_reviews FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_code_review_comments_updated_at BEFORE UPDATE ON code_review_comments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_feedbacks_updated_at BEFORE UPDATE ON feedbacks FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_configs_updated_at BEFORE UPDATE ON system_configs FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 插入默认会员计划
INSERT INTO membership_plans (id, name, description, price, currency, duration, max_apps, features) VALUES
('550e8400-e29b-41d4-a716-446655440001', '免费版', '基础功能，适合个人用户', 0.00, 'CNY', 365, 1, '["基础功能", "每日10次使用限制", "社区支持"]'),
('550e8400-e29b-41d4-a716-446655440002', '基础会员', '适合个人用户和小团队', 29.90, 'CNY', 30, 2, '["2个应用", "每日100次使用", "优先支持", "高级功能"]'),
('550e8400-e29b-41d4-a716-446655440003', '高级会员', '适合中小型团队', 59.90, 'CNY', 30, 4, '["4个应用", "每日500次使用", "专属客服", "所有高级功能", "API访问"]'),
('550e8400-e29b-41d4-a716-446655440004', 'VIP会员', '适合大型团队和企业', 99.90, 'CNY', 30, 5, '["全部应用", "无使用限制", "专属客户经理", "定制功能", "企业级支持", "私有部署"]');

-- 插入默认应用数据
INSERT INTO apps (id, name, description, category, icon, color, features, screenshots) VALUES
('550e8400-e29b-41d4-a716-446655440101', 'QAToolBox Pro', '专业的工作效率工具，包含测试用例生成、代码分析、API测试等功能', '工作效率', 'Icons.work_outline', '#6366F1', 
 '["AI智能测试用例生成", "多语言代码质量分析", "RESTful API自动化测试", "性能瓶颈检测", "安全漏洞扫描", "技术文档自动生成", "代码审查建议", "团队协作管理"]',
 '["assets/images/qa_toolbox_1.png", "assets/images/qa_toolbox_2.png", "assets/images/qa_toolbox_3.png"]'),

('550e8400-e29b-41d4-a716-446655440102', 'LifeMode', '智能生活助手，美食推荐、旅行规划、情绪管理一应俱全', '生活娱乐', 'Icons.home_outlined', '#10B981',
 '["AI美食推荐系统", "个性化旅行规划", "情绪智能分析", "冥想引导练习", "生活目标管理", "时间胶囊功能", "生活数据可视化", "社区分享互动"]',
 '["assets/images/life_mode_1.png", "assets/images/life_mode_2.png", "assets/images/life_mode_3.png"]'),

('550e8400-e29b-41d4-a716-446655440103', 'FitTracker', '全面的健康管理平台，健身计划、营养指导、运动追踪', '健康管理', 'Icons.fitness_center_outlined', '#F59E0B',
 '["AI训练计划生成", "实时运动指导", "营养计算分析", "健康数据监测", "习惯养成打卡", "社交健身挑战", "BMI健康评估", "睡眠质量分析"]',
 '["assets/images/fit_tracker_1.png", "assets/images/fit_tracker_2.png", "assets/images/fit_tracker_3.png"]'),

('550e8400-e29b-41d4-a716-446655440104', 'SocialHub', '新一代社交平台，通过智能匹配算法帮助您找到志同道合的朋友', '社交互动', 'Icons.people_outline', '#8B5CF6',
 '["智能匹配算法", "活动发布参与", "深度交流系统", "人际关系管理", "社交行为分析", "兴趣标签匹配", "群组讨论功能", "隐私安全保护"]',
 '["assets/images/social_hub_1.png", "assets/images/social_hub_2.png", "assets/images/social_hub_3.png"]'),

('550e8400-e29b-41d4-a716-446655440105', 'CreativeStudio', '创作者的梦想工坊，集成了AI写作助手、设计工具、音乐制作等多种创作功能', '创作工具', 'Icons.palette_outlined', '#06B6D4',
 '["AI写作助手", "智能设计工具", "音乐制作平台", "视频剪辑功能", "创意灵感激发", "作品分享社区", "协作创作支持", "版权保护机制"]',
 '["assets/images/creative_studio_1.png", "assets/images/creative_studio_2.png", "assets/images/creative_studio_3.png"]');

-- 插入系统配置
INSERT INTO system_configs (id, config_key, config_value, description) VALUES
('550e8400-e29b-41d4-a716-446655440201', 'app_version', '1.0.0', '应用版本号'),
('550e8400-e29b-41d4-a716-446655440202', 'maintenance_mode', 'false', '维护模式开关'),
('550e8400-e29b-41d4-a716-446655440203', 'max_free_apps', '1', '免费用户最大应用数量'),
('550e8400-e29b-41d4-a716-446655440204', 'max_basic_apps', '2', '基础会员最大应用数量'),
('550e8400-e29b-41d4-a716-446655440205', 'max_premium_apps', '4', '高级会员最大应用数量'),
('550e8400-e29b-41d4-a716-446655440206', 'max_vip_apps', '5', 'VIP会员最大应用数量'),
('550e8400-e29b-41d4-a716-446655440207', 'free_daily_limit', '10', '免费用户每日使用限制'),
('550e8400-e29b-41d4-a716-446655440208', 'basic_daily_limit', '100', '基础会员每日使用限制'),
('550e8400-e29b-41d4-a716-446655440209', 'premium_daily_limit', '500', '高级会员每日使用限制'),
('550e8400-e29b-41d4-a716-446655440210', 'vip_daily_limit', '-1', 'VIP会员每日使用限制(-1表示无限制)');

-- 创建视图：用户应用统计
CREATE OR REPLACE VIEW user_app_statistics AS
SELECT 
    u.id as user_id,
    u.username,
    u.email,
    u.subscription_type,
    COUNT(ua.app_id) as installed_apps_count,
    COALESCE(SUM(ua.usage_count), 0) as total_usage_count,
    MAX(ua.last_used_at) as last_app_used_at
FROM users u
LEFT JOIN user_apps ua ON u.id = ua.user_id
WHERE u.is_active = TRUE
GROUP BY u.id, u.username, u.email, u.subscription_type;

-- 创建视图：应用使用排行
CREATE OR REPLACE VIEW app_usage_ranking AS
SELECT 
    a.id as app_id,
    a.name as app_name,
    a.category,
    COUNT(ua.user_id) as install_count,
    COALESCE(SUM(ua.usage_count), 0) as total_usage,
    COALESCE(AVG(ua.usage_count), 0) as avg_usage_per_user
FROM apps a
LEFT JOIN user_apps ua ON a.id = ua.app_id
WHERE a.is_active = TRUE
GROUP BY a.id, a.name, a.category
ORDER BY install_count DESC, total_usage DESC;

-- 创建函数：更新用户统计
CREATE OR REPLACE FUNCTION update_user_statistics(user_uuid UUID)
RETURNS VOID AS $$
DECLARE
    total_apps INTEGER := 0;
    total_usage INTEGER := 0;
BEGIN
    -- 计算已安装应用数量
    SELECT COUNT(*) INTO total_apps
    FROM user_apps ua WHERE ua.user_id = user_uuid;
    
    -- 计算总使用次数
    SELECT COALESCE(SUM(usage_count), 0) INTO total_usage
    FROM user_apps ua WHERE ua.user_id = user_uuid;
    
    -- 这里可以更新用户统计信息到用户表的某个JSON字段
    -- 由于当前用户表没有statistics字段，这里只是示例
END;
$$ LANGUAGE plpgsql;

-- 创建函数：检查用户应用限制
CREATE OR REPLACE FUNCTION check_user_app_limit(user_uuid UUID, app_uuid UUID)
RETURNS BOOLEAN AS $$
DECLARE
    user_subscription VARCHAR(20);
    current_app_count INTEGER;
    max_apps INTEGER;
BEGIN
    -- 获取用户订阅类型
    SELECT subscription_type INTO user_subscription
    FROM users WHERE id = user_uuid;
    
    -- 获取当前已安装应用数量
    SELECT COUNT(*) INTO current_app_count
    FROM user_apps WHERE user_id = user_uuid;
    
    -- 根据订阅类型确定最大应用数量
    CASE user_subscription
        WHEN 'free' THEN max_apps := 1;
        WHEN 'basic' THEN max_apps := 2;
        WHEN 'premium' THEN max_apps := 4;
        WHEN 'vip' THEN max_apps := 5;
        ELSE max_apps := 1;
    END CASE;
    
    -- 检查是否已安装该应用
    IF EXISTS (SELECT 1 FROM user_apps WHERE user_id = user_uuid AND app_id = app_uuid) THEN
        RETURN TRUE; -- 已安装，允许使用
    END IF;
    
    -- 检查是否超过限制
    RETURN current_app_count < max_apps;
END;
$$ LANGUAGE plpgsql;

-- 创建函数：检查用户每日使用限制
CREATE OR REPLACE FUNCTION check_daily_usage_limit(user_uuid UUID, app_uuid UUID)
RETURNS BOOLEAN AS $$
DECLARE
    user_subscription VARCHAR(20);
    daily_limit INTEGER;
    today_usage INTEGER;
BEGIN
    -- 获取用户订阅类型
    SELECT subscription_type INTO user_subscription
    FROM users WHERE id = user_uuid;
    
    -- 根据订阅类型确定每日限制
    CASE user_subscription
        WHEN 'free' THEN daily_limit := 10;
        WHEN 'basic' THEN daily_limit := 100;
        WHEN 'premium' THEN daily_limit := 500;
        WHEN 'vip' THEN RETURN TRUE; -- VIP无限制
        ELSE daily_limit := 10;
    END CASE;
    
    -- 获取今日使用次数（这里简化处理，实际应该按应用分别统计）
    SELECT COALESCE(SUM(usage_count), 0) INTO today_usage
    FROM user_apps 
    WHERE user_id = user_uuid 
    AND DATE(last_used_at) = CURRENT_DATE;
    
    RETURN today_usage < daily_limit;
END;
$$ LANGUAGE plpgsql;

-- 创建触发器：用户注册后自动创建统计记录
CREATE OR REPLACE FUNCTION after_user_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- 这里可以添加用户注册后的初始化逻辑
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_after_user_insert
    AFTER INSERT ON users
    FOR EACH ROW
    EXECUTE FUNCTION after_user_insert();

-- 创建触发器：应用安装后更新统计
CREATE OR REPLACE FUNCTION after_user_app_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- 调用函数更新用户统计
    PERFORM update_user_statistics(NEW.user_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_after_user_app_insert
    AFTER INSERT ON user_apps
    FOR EACH ROW
    EXECUTE FUNCTION after_user_app_insert();

-- 创建触发器：应用使用后更新统计
CREATE OR REPLACE FUNCTION after_user_app_update()
RETURNS TRIGGER AS $$
BEGIN
    -- 如果使用次数发生变化，更新统计
    IF OLD.usage_count != NEW.usage_count THEN
        PERFORM update_user_statistics(NEW.user_id);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_after_user_app_update
    AFTER UPDATE ON user_apps
    FOR EACH ROW
    EXECUTE FUNCTION after_user_app_update();

-- 创建复合索引优化查询性能
CREATE INDEX IF NOT EXISTS idx_users_membership_created ON users(subscription_type, created_at);
CREATE INDEX IF NOT EXISTS idx_user_apps_usage ON user_apps(user_id, usage_count DESC);
CREATE INDEX IF NOT EXISTS idx_subscriptions_user_status ON subscriptions(user_id, status);
CREATE INDEX IF NOT EXISTS idx_payments_user_status ON payments(user_id, status);
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_feedbacks_status_priority ON feedbacks(status, priority, created_at DESC);

-- 设置数据库参数
ALTER DATABASE postgres SET timezone TO 'Asia/Shanghai';

-- 创建示例用户（用于测试）
INSERT INTO users (id, email, username, password_hash, first_name, last_name, subscription_type) VALUES
('550e8400-e29b-41d4-a716-446655440301', 'admin@qatoolbox.com', 'admin', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', 'vip'),
('550e8400-e29b-41d4-a716-446655440302', 'test@qatoolbox.com', 'testuser', '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Test', 'User', 'free');

-- 为测试用户安装应用
INSERT INTO user_apps (user_id, app_id, usage_count) VALUES
('550e8400-e29b-41d4-a716-446655440301', '550e8400-e29b-41d4-a716-446655440101', 50),
('550e8400-e29b-41d4-a716-446655440301', '550e8400-e29b-41d4-a716-446655440102', 30),
('550e8400-e29b-41d4-a716-446655440302', '550e8400-e29b-41d4-a716-446655440101', 5);

COMMIT;