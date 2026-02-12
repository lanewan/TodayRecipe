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
