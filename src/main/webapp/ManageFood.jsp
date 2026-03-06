<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="data.User, data.Data, data.Stock, java.util.List"%>

<%
    User loginUser = (User) session.getAttribute("loginUser");

    // 如果未登录，重定向到主页
    if (loginUser == null) {
        response.sendRedirect("TodayRecipe.jsp");
        return;
    }

    // 获取用户的食物列表
    List<Stock> foodList = null;
    try {
        Data dt = new Data();
        foodList = dt.getUserFoods(loginUser.getUserId());
        dt.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>管理我的食物</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        padding: 0;
        background: linear-gradient(135deg, #f5f5f5 0%, #ffffff 100%);
        min-height: 100vh;
    }

    .header {
        background: white;
        padding: 15px 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        display: flex;
        justify-content: space-between;
        align-items: center;
        position: sticky;
        top: 0;
        z-index: 100;
    }

    .header h1 {
        margin: 0;
        font-size: clamp(20px, 5vw, 28px);
        color: #333;
    }

    .btn-back {
        padding: 8px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border: none;
        border-radius: 20px;
        cursor: pointer;
        font-size: clamp(14px, 3.5vw, 16px);
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .btn-back:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .container {
        max-width: 1000px;
        margin: 20px auto;
        padding: 20px;
    }

    .stats {
        background: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        margin-bottom: 20px;
        text-align: center;
    }

    .stats h2 {
        margin: 0 0 10px 0;
        color: #ff6b6b;
        font-size: clamp(18px, 4.5vw, 24px);
    }

    .food-list {
        background: white;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        overflow: hidden;
    }

    .food-item {
        padding: 15px 20px;
        border-bottom: 1px solid #f0f0f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        transition: background 0.2s ease;
    }

    .food-item:hover {
        background: #f8f9fa;
    }

    .food-item:last-child {
        border-bottom: none;
    }

    .food-info {
        flex: 1;
    }

    .food-name {
        font-size: clamp(16px, 4vw, 18px);
        font-weight: bold;
        color: #333;
        margin-bottom: 5px;
    }

    .food-details {
        font-size: clamp(12px, 3vw, 14px);
        color: #666;
    }

    .food-tag {
        display: inline-block;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: clamp(11px, 2.5vw, 12px);
        margin-right: 5px;
    }

    .tag-meat {
        background: #ffe0e0;
        color: #ff6b6b;
    }

    .tag-veg {
        background: #d4edda;
        color: #28a745;
    }

    .tag-daily {
        background: #e7f3ff;
        color: #0066cc;
    }

    .tag-enjoy {
        background: #fff3cd;
        color: #ff9800;
    }

    .btn-delete {
        padding: 6px 15px;
        background: #ff6b6b;
        color: white;
        border: none;
        border-radius: 15px;
        cursor: pointer;
        font-size: clamp(12px, 3vw, 14px);
        transition: all 0.3s ease;
    }

    .btn-delete:hover {
        background: #ff5252;
        transform: scale(1.05);
    }

    .empty-state {
        text-align: center;
        padding: 60px 20px;
        color: #999;
    }

    .empty-state-icon {
        font-size: 64px;
        margin-bottom: 20px;
    }

    .empty-state-text {
        font-size: clamp(16px, 4vw, 18px);
        margin-bottom: 20px;
    }

    .btn-add-first {
        padding: 12px 30px;
        background: linear-gradient(135deg, #28a745 0%, #34ce57 100%);
        color: white;
        border: none;
        border-radius: 25px;
        cursor: pointer;
        font-size: clamp(14px, 3.5vw, 16px);
        text-decoration: none;
        display: inline-block;
        transition: all 0.3s ease;
    }

    .btn-add-first:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
    }

    @media (max-width: 600px) {
        .food-item {
            flex-direction: column;
            align-items: flex-start;
        }

        .btn-delete {
            margin-top: 10px;
            align-self: flex-end;
        }
    }
</style>
</head>
<body>

<div class="header">
    <h1>我的食物库</h1>
    <a href="TodayRecipe.jsp" class="btn-back">返回主页</a>
</div>

<div class="container">
    <div class="stats">
        <h2>📊 统计信息</h2>
        <p style="font-size: clamp(14px, 3.5vw, 16px); color: #666; margin: 5px 0;">
            共有 <strong style="color: #ff6b6b; font-size: clamp(20px, 5vw, 24px);"><%= foodList != null ? foodList.size() : 0 %></strong> 道美食
        </p>
    </div>

    <div class="food-list">
        <% if (foodList == null || foodList.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-state-icon">🍽️</div>
                <div class="empty-state-text">还没有添加任何食物</div>
                <a href="TodayRecipe.jsp" class="btn-add-first">去添加第一道美食</a>
            </div>
        <% } else { %>
            <% for (Stock food : foodList) { %>
                <div class="food-item" id="food-<%= food.getNumber() %>">
                    <div class="food-info">
                        <div class="food-name"><%= food.getName() %></div>
                        <div class="food-details">
                            <span class="food-tag <%= "荤".equals(food.getKind()) ? "tag-meat" : "tag-veg" %>">
                                <%= food.getKind() %>
                            </span>
                            <span class="food-tag <%= "日常".equals(food.getSituation()) ? "tag-daily" : "tag-enjoy" %>">
                                <%= food.getSituation() %>
                            </span>
                            <span style="margin-left: 5px;">🥘 <%= food.getMaterial() %></span>
                        </div>
                    </div>
                    <button class="btn-delete" onclick="deleteFood(<%= food.getNumber() %>)">删除</button>
                </div>
            <% } %>
        <% } %>
    </div>
</div>

<script>
function deleteFood(foodNo) {
    if (!confirm('确定要删除这道美食吗？')) {
        return;
    }

    fetch('food', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=delete&foodNo=' + foodNo
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            const element = document.getElementById('food-' + foodNo);
            element.style.transition = 'opacity 0.3s ease';
            element.style.opacity = '0';
            setTimeout(() => {
                element.remove();
                if (document.querySelectorAll('.food-item').length === 0) {
                    location.reload();
                }
            }, 300);
        } else {
            alert('删除失败: ' + (data.error || '未知错误'));
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('删除失败，请重试');
    });
}
</script>

</body>
</html>
