-- TodayRecipe 數據庫表結構
-- 創建 recipes 表

CREATE TABLE IF NOT EXISTS recipes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    material TEXT,
    kind VARCHAR(50),
    situation VARCHAR(50)
);

-- 創建索引以提高查詢性能
CREATE INDEX IF NOT EXISTS idx_recipes_kind ON recipes(kind);
CREATE INDEX IF NOT EXISTS idx_recipes_situation ON recipes(situation);
CREATE INDEX IF NOT EXISTS idx_recipes_material ON recipes USING gin(to_tsvector('simple', material));

-- 示例數據（可選）
-- INSERT INTO recipes (name, material, kind, situation) VALUES
-- ('宮保雞丁', '雞肉,花生,辣椒', '葷', '日常'),
-- ('麻婆豆腐', '豆腐,豬肉,辣椒', '葷', '日常'),
-- ('清炒時蔬', '青菜,蒜', '素', '日常');

-- ========================================
-- 新增：历史记录表
-- ========================================
-- 用于记录用户的食物选择历史，避免连续两次抽中重复的食物

CREATE TABLE IF NOT EXISTS history (
    id SERIAL PRIMARY KEY,
    userid VARCHAR(50) NOT NULL,
    food_no INTEGER NOT NULL,
    pick_time TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_history_userid ON history(userid);
CREATE INDEX IF NOT EXISTS idx_history_pick_time ON history(pick_time DESC);
CREATE INDEX IF NOT EXISTS idx_history_food_no ON history(food_no);

-- 注意：如果需要外键约束，请确保 users 表的 userid 是主键或有唯一约束
-- 如果 users 表的 userid 是主键，可以取消下面两行的注释：
-- ALTER TABLE history ADD CONSTRAINT fk_history_userid FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE;
-- ALTER TABLE history ADD CONSTRAINT fk_history_food_no FOREIGN KEY (food_no) REFERENCES recipe(no) ON DELETE CASCADE;

-- 查看表结构（可选）
-- \d history

-- 测试查询（可选）
-- SELECT * FROM history ORDER BY pick_time DESC LIMIT 10;
