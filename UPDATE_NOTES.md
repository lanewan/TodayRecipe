# TodayRecipe 功能更新说明

## 📝 更新内容

本次更新添加了两个重要功能：

### 1. ✅ 历史记录功能 - 避免重复抽取

**功能说明：**
- 系统会记录用户每次选择的食物
- 下次随机选择时，会自动排除最近一次选过的食物
- 避免连续两次抽中相同的食物，提升用户体验

**实现细节：**
- 新增 `history` 数据库表，记录用户选择历史
- 修改 `Pick.java` 的随机选择逻辑，自动过滤最近选过的食物
- 在 `FoodServlet.java` 中，每次选择后自动保存历史记录
- 仅对登录用户生效（访客模式不记录历史）

### 2. 📋 食物管理页面

**功能说明：**
- 登录用户可以查看自己添加的所有食物
- 支持删除不需要的食物
- 显示食物的详细信息（名称、食材、荤素、场景）
- 统计用户的食物总数

**页面特点：**
- 响应式设计，适配移动端和桌面端
- 美观的卡片式布局
- 平滑的删除动画效果
- 空状态提示，引导用户添加食物

## 🗄️ 数据库变更

需要在 PostgreSQL 数据库中执行以下 SQL 创建历史记录表：

```sql
CREATE TABLE IF NOT EXISTS history (
    id SERIAL PRIMARY KEY,
    userid VARCHAR(50) NOT NULL,
    food_no INTEGER NOT NULL,
    pick_time TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (userid) REFERENCES users(userid) ON DELETE CASCADE,
    FOREIGN KEY (food_no) REFERENCES recipe(no) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_history_userid ON history(userid);
CREATE INDEX IF NOT EXISTS idx_history_pick_time ON history(pick_time DESC);
```

**执行方法：**
1. 连接到你的 PostgreSQL 数据库
2. 执行 `database_setup.sql` 文件中的 SQL 语句
3. 或者直接在数据库管理工具中运行上述 SQL

## 📂 文件变更清单

### 新增文件：
- `src/main/webapp/ManageFood.jsp` - 食物管理页面

### 修改文件：
1. `src/main/java/data/Data.java`
   - 新增 `addHistory()` - 添加历史记录
   - 新增 `getLastPickedFoodNo()` - 获取最近选择的食物
   - 新增 `deleteFood()` - 删除食物
   - 新增 `getUserFoods()` - 查询用户的所有食物

2. `src/main/java/data/Pick.java`
   - 修改 `randomPick()` - 排除最近选过的食物

3. `src/main/java/controller/FoodServlet.java`
   - 修改 `randomPick()` - 添加历史记录保存逻辑
   - 新增 `deleteFood()` - 处理删除食物请求
   - 修改 `doPost()` - 添加删除操作的路由

4. `src/main/webapp/TodayRecipe.jsp`
   - 新增"管理我的食物"按钮（仅登录用户可见）
   - 新增按钮样式 `.btn-manage`

5. `database_setup.sql`
   - 新增 history 表的创建语句

## 🚀 使用说明

### 历史记录功能
1. 登录后，每次点击"听天由命"、"健康"、"外食"或"想吃○○"按钮
2. 系统会自动记录你的选择
3. 下次选择时，会自动避开上一次选过的食物
4. 如果只有一道食物，则不会排除（避免无法选择）

### 食物管理页面
1. 登录后，在主页点击"📋 管理我的食物"按钮
2. 查看你添加的所有食物列表
3. 点击"删除"按钮可以删除不需要的食物
4. 点击"返回主页"回到主页面

## 🎯 技术亮点

1. **智能过滤算法**：自动排除最近选过的食物，但保证至少有一个可选项
2. **数据库优化**：使用索引提升历史记录查询性能
3. **用户体验**：平滑的动画效果，响应式设计
4. **安全性**：删除操作需要验证用户身份，防止误删他人数据
5. **容错处理**：历史记录失败不影响主流程，保证系统稳定性

## 📱 界面预览

### 主页新增按钮
- 登录用户会看到"📋 管理我的食物"按钮
- 按钮采用紫色渐变设计，与整体风格协调

### 管理页面
- 顶部显示食物总数统计
- 卡片式列表展示所有食物
- 每个食物显示：名称、荤素标签、场景标签、食材
- 右侧有删除按钮
- 空状态时显示友好提示

## ⚠️ 注意事项

1. **必须先创建数据库表**：在使用新功能前，请先执行 `database_setup.sql` 中的 SQL 语句
2. **仅登录用户可用**：历史记录和食物管理功能仅对登录用户开放
3. **访客模式**：访客模式下不会记录历史，每次都是完全随机
4. **删除操作不可恢复**：删除食物后无法恢复，请谨慎操作

## 🔮 未来可扩展功能

基于当前的历史记录功能，未来可以扩展：
- 查看历史记录列表
- 统计最常吃的食物
- 避免最近 N 天内选过的食物（目前只避免最近一次）
- 导出历史记录为 CSV
- 食物评分系统

---

**更新日期：** 2026-03-06
**版本：** v1.1.0
