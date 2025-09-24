-- QAToolBox 数据库初始化脚本
-- 创建数据库和基础表结构

-- 创建数据库
CREATE DATABASE IF NOT EXISTS qa_toolbox;
USE qa_toolbox;

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    avatar VARCHAR(500),
    phone VARCHAR(20),
    membership_level ENUM('free', 'basic', 'premium', 'vip') DEFAULT 'free',
    preferences JSON,
    statistics JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    INDEX idx_email (email),
    INDEX idx_membership (membership_level),
    INDEX idx_created_at (created_at)
);

-- 应用表
CREATE TABLE IF NOT EXISTS apps (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL,
    icon VARCHAR(100),
    color VARCHAR(20),
    version VARCHAR(20) DEFAULT '1.0.0',
    is_active BOOLEAN DEFAULT TRUE,
    features JSON,
    screenshots JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_category (category),
    INDEX idx_active (is_active)
);

-- 用户应用关系表
CREATE TABLE IF NOT EXISTS user_apps (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    app_id VARCHAR(36) NOT NULL,
    installed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_used_at TIMESTAMP,
    usage_count INT DEFAULT 0,
    settings JSON,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_app (user_id, app_id),
    INDEX idx_user_id (user_id),
    INDEX idx_app_id (app_id),
    INDEX idx_last_used (last_used_at)
);

-- 会员订阅表
CREATE TABLE IF NOT EXISTS subscriptions (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    membership_level ENUM('free', 'basic', 'premium', 'vip') NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    status ENUM('active', 'cancelled', 'expired', 'pending') DEFAULT 'pending',
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    cancelled_at TIMESTAMP NULL,
    payment_method VARCHAR(50),
    payment_id VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_expires_at (expires_at)
);

-- 支付记录表
CREATE TABLE IF NOT EXISTS payments (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    subscription_id VARCHAR(36),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'CNY',
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    payment_method VARCHAR(50),
    payment_id VARCHAR(100),
    transaction_id VARCHAR(100),
    gateway_response JSON,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_payment_id (payment_id),
    INDEX idx_created_at (created_at)
);

-- 应用使用统计表
CREATE TABLE IF NOT EXISTS app_usage_stats (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    app_id VARCHAR(36) NOT NULL,
    date DATE NOT NULL,
    usage_duration INT DEFAULT 0, -- 使用时长(秒)
    action_count INT DEFAULT 0,    -- 操作次数
    features_used JSON,            -- 使用的功能
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_app_date (user_id, app_id, date),
    INDEX idx_user_id (user_id),
    INDEX idx_app_id (app_id),
    INDEX idx_date (date)
);

-- 系统配置表
CREATE TABLE IF NOT EXISTS system_configs (
    id VARCHAR(36) PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE NOT NULL,
    config_value TEXT,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_config_key (config_key),
    INDEX idx_active (is_active)
);

-- 通知表
CREATE TABLE IF NOT EXISTS notifications (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    type ENUM('system', 'promotion', 'update', 'reminder') DEFAULT 'system',
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read),
    INDEX idx_type (type),
    INDEX idx_created_at (created_at)
);

-- 反馈表
CREATE TABLE IF NOT EXISTS feedbacks (
    id VARCHAR(36) PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    app_id VARCHAR(36),
    type ENUM('bug', 'feature', 'suggestion', 'complaint') DEFAULT 'suggestion',
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    status ENUM('pending', 'in_progress', 'resolved', 'closed') DEFAULT 'pending',
    priority ENUM('low', 'medium', 'high', 'urgent') DEFAULT 'medium',
    admin_response TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE SET NULL,
    INDEX idx_user_id (user_id),
    INDEX idx_app_id (app_id),
    INDEX idx_status (status),
    INDEX idx_type (type),
    INDEX idx_priority (priority)
);

-- 插入默认应用数据
INSERT INTO apps (id, name, description, category, icon, color, features, screenshots) VALUES
('qa_toolbox_pro', 'QAToolBox Pro', '专业的工作效率工具，包含测试用例生成、代码分析、API测试等功能', '工作效率', 'Icons.work_outline', '#6366F1', 
 '["AI智能测试用例生成", "多语言代码质量分析", "RESTful API自动化测试", "性能瓶颈检测", "安全漏洞扫描", "技术文档自动生成", "代码审查建议", "团队协作管理"]',
 '["assets/images/qa_toolbox_1.png", "assets/images/qa_toolbox_2.png", "assets/images/qa_toolbox_3.png"]'),

('life_mode', 'LifeMode', '智能生活助手，美食推荐、旅行规划、情绪管理一应俱全', '生活娱乐', 'Icons.home_outlined', '#10B981',
 '["AI美食推荐系统", "个性化旅行规划", "情绪智能分析", "冥想引导练习", "生活目标管理", "时间胶囊功能", "生活数据可视化", "社区分享互动"]',
 '["assets/images/life_mode_1.png", "assets/images/life_mode_2.png", "assets/images/life_mode_3.png"]'),

('fit_tracker', 'FitTracker', '全面的健康管理平台，健身计划、营养指导、运动追踪', '健康管理', 'Icons.fitness_center_outlined', '#F59E0B',
 '["AI训练计划生成", "实时运动指导", "营养计算分析", "健康数据监测", "习惯养成打卡", "社交健身挑战", "BMI健康评估", "睡眠质量分析"]',
 '["assets/images/fit_tracker_1.png", "assets/images/fit_tracker_2.png", "assets/images/fit_tracker_3.png"]'),

('social_hub', 'SocialHub', '新一代社交平台，通过智能匹配算法帮助您找到志同道合的朋友', '社交互动', 'Icons.people_outline', '#8B5CF6',
 '["智能匹配算法", "活动发布参与", "深度交流系统", "人际关系管理", "社交行为分析", "兴趣标签匹配", "群组讨论功能", "隐私安全保护"]',
 '["assets/images/social_hub_1.png", "assets/images/social_hub_2.png", "assets/images/social_hub_3.png"]'),

('creative_studio', 'CreativeStudio', '创作者的梦想工坊，集成了AI写作助手、设计工具、音乐制作等多种创作功能', '创作工具', 'Icons.palette_outlined', '#06B6D4',
 '["AI写作助手", "智能设计工具", "音乐制作平台", "视频剪辑功能", "创意灵感激发", "作品分享社区", "协作创作支持", "版权保护机制"]',
 '["assets/images/creative_studio_1.png", "assets/images/creative_studio_2.png", "assets/images/creative_studio_3.png"]');

-- 插入系统配置
INSERT INTO system_configs (id, config_key, config_value, description) VALUES
('app_version', '1.0.0', '1.0.0', '应用版本号'),
('maintenance_mode', 'false', 'false', '维护模式开关'),
('max_free_apps', '1', '1', '免费用户最大应用数量'),
('max_basic_apps', '2', '2', '基础会员最大应用数量'),
('max_premium_apps', '4', '4', '高级会员最大应用数量'),
('max_vip_apps', '5', '5', 'VIP会员最大应用数量'),
('free_daily_limit', '10', '10', '免费用户每日使用限制'),
('basic_daily_limit', '100', '100', '基础会员每日使用限制'),
('premium_daily_limit', '500', '500', '高级会员每日使用限制'),
('vip_daily_limit', '-1', '-1', 'VIP会员每日使用限制(-1表示无限制)');

-- 创建视图：用户应用统计
CREATE VIEW user_app_statistics AS
SELECT 
    u.id as user_id,
    u.name as user_name,
    u.membership_level,
    COUNT(ua.app_id) as installed_apps_count,
    SUM(ua.usage_count) as total_usage_count,
    MAX(ua.last_used_at) as last_app_used_at
FROM users u
LEFT JOIN user_apps ua ON u.id = ua.user_id
WHERE u.deleted_at IS NULL
GROUP BY u.id, u.name, u.membership_level;

-- 创建视图：应用使用排行
CREATE VIEW app_usage_ranking AS
SELECT 
    a.id as app_id,
    a.name as app_name,
    a.category,
    COUNT(ua.user_id) as install_count,
    SUM(ua.usage_count) as total_usage,
    AVG(ua.usage_count) as avg_usage_per_user
FROM apps a
LEFT JOIN user_apps ua ON a.id = ua.app_id
WHERE a.is_active = TRUE
GROUP BY a.id, a.name, a.category
ORDER BY install_count DESC, total_usage DESC;

-- 创建存储过程：更新用户统计
DELIMITER //
CREATE PROCEDURE UpdateUserStatistics(IN user_id VARCHAR(36))
BEGIN
    DECLARE total_apps INT DEFAULT 0;
    DECLARE total_usage INT DEFAULT 0;
    DECLARE membership_level VARCHAR(20);
    
    -- 获取用户会员等级
    SELECT u.membership_level INTO membership_level
    FROM users u WHERE u.id = user_id;
    
    -- 计算已安装应用数量
    SELECT COUNT(*) INTO total_apps
    FROM user_apps ua WHERE ua.user_id = user_id;
    
    -- 计算总使用次数
    SELECT COALESCE(SUM(usage_count), 0) INTO total_usage
    FROM user_apps ua WHERE ua.user_id = user_id;
    
    -- 更新用户统计信息
    UPDATE users 
    SET statistics = JSON_OBJECT(
        'total_apps', total_apps,
        'total_usage', total_usage,
        'last_updated', NOW()
    )
    WHERE id = user_id;
END //
DELIMITER ;

-- 创建触发器：用户注册后自动创建统计记录
DELIMITER //
CREATE TRIGGER after_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    -- 初始化用户统计
    UPDATE users 
    SET statistics = JSON_OBJECT(
        'total_apps', 0,
        'total_usage', 0,
        'created_at', NOW()
    )
    WHERE id = NEW.id;
END //
DELIMITER ;

-- 创建触发器：应用安装后更新统计
DELIMITER //
CREATE TRIGGER after_user_app_insert
AFTER INSERT ON user_apps
FOR EACH ROW
BEGIN
    -- 调用存储过程更新用户统计
    CALL UpdateUserStatistics(NEW.user_id);
END //
DELIMITER ;

-- 创建触发器：应用使用后更新统计
DELIMITER //
CREATE TRIGGER after_user_app_update
AFTER UPDATE ON user_apps
FOR EACH ROW
BEGIN
    -- 如果使用次数发生变化，更新统计
    IF OLD.usage_count != NEW.usage_count THEN
        CALL UpdateUserStatistics(NEW.user_id);
    END IF;
END //
DELIMITER ;

-- 创建索引优化查询性能
CREATE INDEX idx_users_membership_created ON users(membership_level, created_at);
CREATE INDEX idx_user_apps_usage ON user_apps(user_id, usage_count DESC);
CREATE INDEX idx_subscriptions_user_status ON subscriptions(user_id, status);
CREATE INDEX idx_payments_user_status ON payments(user_id, status);
CREATE INDEX idx_notifications_user_read ON notifications(user_id, is_read, created_at DESC);
CREATE INDEX idx_feedbacks_status_priority ON feedbacks(status, priority, created_at DESC);

-- 设置字符集
ALTER DATABASE qa_toolbox CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE users CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE apps CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE user_apps CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE subscriptions CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE payments CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE app_usage_stats CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE system_configs CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE notifications CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE feedbacks CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
