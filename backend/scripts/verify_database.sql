-- 完整的数据库验证脚本

-- 1. 检查数据库连接
SELECT current_database(), current_user, version();

-- 2. 列出所有表
SELECT table_name, table_schema 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;

-- 3. 检查apps表结构
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'apps' AND table_schema = 'public'
ORDER BY ordinal_position;

-- 4. 检查apps表数据
SELECT COUNT(*) as total_apps FROM apps;
SELECT id, name, is_premium, is_active FROM apps LIMIT 5;

-- 5. 检查新创建的表
SELECT 'mood_entries' as table_name, COUNT(*) as count FROM mood_entries
UNION ALL
SELECT 'workouts', COUNT(*) FROM workouts
UNION ALL
SELECT 'matches', COUNT(*) FROM matches
UNION ALL
SELECT 'writings', COUNT(*) FROM writings
UNION ALL
SELECT 'test_cases', COUNT(*) FROM test_cases;

-- 6. 检查test_cases表结构
SELECT column_name, data_type, is_nullable
FROM information_schema.columns 
WHERE table_name = 'test_cases' AND table_schema = 'public'
ORDER BY ordinal_position;

-- 7. 检查membership_plans表结构和数据
SELECT column_name, data_type
FROM information_schema.columns 
WHERE table_name = 'membership_plans' AND table_schema = 'public'
ORDER BY ordinal_position;

SELECT id, name, features FROM membership_plans LIMIT 3;
