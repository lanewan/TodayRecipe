<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"  import="data.User"%>
    
<%
    User loginUser = (User) session.getAttribute("loginUser");
%>

    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
<title>今天吃什么？</title>
<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        margin: 0;
        padding: 0;
        background: linear-gradient(135deg, #f5f5f5 0%, #ffffff 100%);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
    }

    /* 標題容器 */
    .title-container {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 15px;
        margin: 20px 0;
    }

    /* 標題 */
    .page-title {
        font-size: clamp(32px, 8vw, 48px);
        font-weight: bold;
        color: #333;
        margin: 0;
        text-align: center;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
    }

    /* 滾動食物 emoji 容器 */
    .food-emoji-scroll {
        font-size: clamp(24px, 6vw, 36px);
        width: clamp(40px, 10vw, 60px);
        height: clamp(40px, 10vw, 60px);
        display: flex;
        align-items: center;
        justify-content: center;
        overflow: hidden;
        position: relative;
    }

    /* 滾動動畫 */
    .food-emoji-scroll span {
        position: absolute;
        animation: scrollUp 2s ease-in-out infinite;
        opacity: 0;
    }

    @keyframes scrollUp {
        0% {
            transform: translateY(100%);
            opacity: 0;
        }
        10% {
            opacity: 1;
        }
        90% {
            opacity: 1;
        }
        100% {
            transform: translateY(-100%);
            opacity: 0;
        }
    }

    .container {
        text-align: center;
        padding: 20px;
        width: 100%;
        max-width: 600px;
    }

    /* 主按钮 - 听天由命 */
    .btn-main {
        width: clamp(180px, 50vw, 200px);
        height: clamp(180px, 50vw, 200px);
        border-radius: 50%;
        background: linear-gradient(135deg, #ff6b6b 0%, #ff8787 100%);
        color: white;
        font-size: clamp(24px, 6vw, 28px);
        font-weight: bold;
        border: none;
        cursor: pointer;
        box-shadow: 0 10px 30px rgba(255, 107, 107, 0.4);
        transition: all 0.3s ease;
        animation: bounce 2s ease-in-out infinite;
        margin-bottom: 30px;
    }

    .btn-main:hover {
        transform: scale(1.05);
        box-shadow: 0 15px 40px rgba(255, 107, 107, 0.6);
    }

    .btn-main:active {
        transform: scale(0.95);
    }

    @keyframes bounce {
        0%, 100% {
            transform: translateY(0);
        }
        50% {
            transform: translateY(-15px);
        }
    }

    /* 三个功能按钮 */
    .secondary-buttons {
        display: flex;
        gap: clamp(10px, 3vw, 20px);
        justify-content: center;
        margin-bottom: 30px;
        flex-wrap: wrap;
    }

    .secondary-buttons button {
        width: clamp(120px, 28vw, 140px);
        height: clamp(70px, 18vw, 80px);
        border-radius: 20px;
        font-size: clamp(16px, 4.5vw, 20px);
        font-weight: 600;
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        color: white;
    }

    .btn-health {
        background: linear-gradient(135deg, #20c997 0%, #36d9b4 100%);
        box-shadow: 0 8px 20px rgba(32, 201, 151, 0.3);
    }

    .btn-dining {
        background: linear-gradient(135deg, #fd7e14 0%, #ff9142 100%);
        box-shadow: 0 8px 20px rgba(253, 126, 20, 0.3);
    }

    .btn-material {
        background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%);
        box-shadow: 0 8px 20px rgba(108, 92, 231, 0.3);
    }

    .secondary-buttons button:hover {
        transform: translateY(-5px);
        box-shadow: 0 12px 25px rgba(0, 0, 0, 0.3);
    }

    .secondary-buttons button:active {
        transform: translateY(-2px);
    }

    /* 添加食物按钮 */
    .btn-add {
        width: clamp(110px, 30vw, 120px);
        height: clamp(40px, 12vw, 45px);
        border-radius: 25px;
        background: linear-gradient(135deg, #28a745 0%, #34ce57 100%);
        color: white;
        font-size: clamp(14px, 4vw, 16px);
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
    }

    .btn-add:hover {
        background: linear-gradient(135deg, #218838 0%, #28a745 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
    }

    .btn-add:active {
        transform: translateY(0);
    }

    /* 管理食物按钮 */
    .btn-manage {
        width: clamp(140px, 38vw, 160px);
        height: clamp(40px, 12vw, 45px);
        border-radius: 25px;
        background: linear-gradient(135deg, #6c5ce7 0%, #a29bfe 100%);
        color: white;
        font-size: clamp(14px, 4vw, 16px);
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(108, 92, 231, 0.3);
        margin-top: 10px;
    }

    .btn-manage:hover {
        background: linear-gradient(135deg, #5f4dd1 0%, #8b7fe6 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(108, 92, 231, 0.4);
    }

    .btn-manage:active {
        transform: translateY(0);
    }

    /* 登錄按钮 */
    .login{
        width: clamp(110px, 30vw, 120px);
        height: clamp(40px, 12vw, 45px);
        border-radius: 25px;
        background: linear-gradient(135deg, #28a745 0%, #34ce57 100%);
        color: white;
        font-size: clamp(14px, 4vw, 16px);
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        position: fixed;
        top: 20px;
        right: 20px;
    }

    .login:hover {
        background: linear-gradient(135deg, #218838 0%, #28a745 100%);
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
    }

    .login:active {
        transform: translateY(0);
    }


    /* 滚动动画效果 */
    @keyframes rolling {
        0% {
            transform: translateY(0);
            opacity: 1;
        }
        25% {
            transform: translateY(-10px);
            opacity: 0.7;
        }
        50% {
            transform: translateY(0);
            opacity: 1;
        }
        75% {
            transform: translateY(10px);
            opacity: 0.7;
        }
        100% {
            transform: translateY(0);
            opacity: 1;
        }
    }

    .rolling-animation {
        animation: rolling 0.6s ease-in-out infinite;
    }

    /* 弹窗淡入动画 */
    @keyframes fadeIn {
        from {
            opacity: 0;
            transform: translate(-50%, -45%);
        }
        to {
            opacity: 1;
            transform: translate(-50%, -50%);
        }
    }

    .fade-in {
        animation: fadeIn 0.3s ease-out;
    }

    /* 點擊彈出的食物 emoji */
    .click-emoji {
        position: fixed;
        font-size: 24px;
        pointer-events: none;
        z-index: 9999;
        animation: emojiPopOut 1s ease-out forwards;
    }

    @keyframes emojiPopOut {
        0% {
            opacity: 1;
            transform: translate(-50%, -50%) scale(0.5);
        }
        30% {
            opacity: 1;
            transform: translate(-50%, -50%) scale(1.2);
        }
        100% {
            opacity: 0;
            transform: translate(-50%, -80%) scale(0.8);
        }
    }

    /* 用戶歡迎信息 */
    .user-welcome {
        position: fixed;
        top: 20px;
        right: 20px;
        background: white;
        padding: 10px 20px;
        border-radius: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        font-size: clamp(14px, 3.5vw, 16px);
        color: #333;
        z-index: 100;
    }

    /* 登錄按鈕樣式 */
    .btn-login {
        width: clamp(80px, 22vw, 100px);
        height: clamp(35px, 10vw, 40px);
        border-radius: 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        font-size: clamp(14px, 3.5vw, 16px);
        border: none;
        cursor: pointer;
        transition: all 0.3s ease;
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        margin-top: 10px;
    }

    .btn-login:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
    }
</style>
</head>
<body>

<!-- 用戶歡迎信息 -->
<% if(loginUser != null){ %>
    <div class="user-welcome">
        歡迎，<%= loginUser.getUserId() %> 👋
        <button onclick="logout()" style="margin-left:10px; padding:5px 15px; background:#ff6b6b; color:white; border:none; border-radius:15px; cursor:pointer; font-size:clamp(12px, 3vw, 14px);">登出</button>
    </div>
<% } else { %>
    <!-- 未登錄用戶提示 -->
    <div style="background:#fff3cd; color:#856404; padding:12px 20px; border-radius:8px; margin:15px auto; max-width:500px; text-align:center; font-size:clamp(12px, 3vw, 14px); box-shadow:0 2px 8px rgba(0,0,0,0.1);">
        💡 當前為訪客模式，抽取的是所有用戶的美食庫<br>
        <span style="font-size:clamp(11px, 2.5vw, 13px); color:#666;">登錄後可以添加和抽取你的專屬美食庫</span>
    </div>
<% } %>

<div class="title-container">
    <h1 class="page-title">今天吃什麽</h1>
    <div class="food-emoji-scroll" id="foodEmojiScroll">
        <span>🍗</span>
    </div>
</div>

<div class="container">
    <!-- 主按钮 -->
    <button class="btn-main" onclick="randomPick()">听天由命<br>🙏</button>

    <!-- 三个功能按钮 -->
    <div class="secondary-buttons">
        <button class="btn-health" onclick="dailyPick()">健康 🏃</button>
        <button class="btn-dining" onclick="cruisePick()">外食 🍴</button>
        <button class="btn-material" onclick="showMaterialInput()">想吃○○！🤤</button>
    </div>

    <!-- 添加食物按钮 -->
    <button class="btn-add" onclick="showModal()">+ 添加食物</button>

    <!-- 管理食物按钮（仅登录用户可见） -->
    <% if(loginUser != null){ %>
        <button class="btn-manage" onclick="location.href='ManageFood.jsp'">📋 管理我的食物</button>
    <% } %>

    <!-- 登錄按钮 -->
    <% if(loginUser == null){ %>
        <button class="btn-login" onclick="showLogin()">登錄</button>
    <% } %>
</div>

<!-- 添加食物弹窗 -->
<div id="modal" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:350px;
">
    <h3 style="margin-top:0; color:#333;">添加食物</h3>

    <form method="post" action="food">
        <input type="hidden" name="action" value="add">

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">名称：</label>
            <input type="text" name="name" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">材料：</label>
            <input type="text" name="material" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">荤/素：</label>
            <select name="kind" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
                <option value="">请选择荤素</option>
                <option value="荤">荤</option>
                <option value="素">素</option>
            </select>
        </div>

        <div style="margin-bottom:20px;">
            <label style="display:block; margin-bottom:5px; color:#666;">场景：</label>
            <select name="situation" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
                <option value="">请选择场景</option>
                <option value="日常">日常</option>
                <option value="享受">享受</option>
            </select>
        </div>

        <div style="display:flex; gap:10px; justify-content:center;">
            <button type="submit" style="padding:10px 30px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">确定</button>
            <button type="button" onclick="closeAllModals()" style="padding:10px 30px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">取消</button>
        </div>
    </form>
</div>

<!--登錄弹窗 -->
<div id="login" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:350px;
">
    <h3 style="margin-top:0; color:#333;">登錄你的美食庫</h3>

    <form method="post" action="user">
        <input type="hidden" name="action" value="login">

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">用戶名：</label>
            <input type="text" name="userid" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">密碼：</label>
            <input type="text" name="password" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

       

        <div style="display:flex; gap:10px; justify-content:center;">
            <button type="submit" style="padding:10px 30px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">确定</button>
            <button type="button" onclick="closeAllModals()" style="padding:10px 30px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">取消</button>
             <button type="button" onclick="showSignup()" style="padding:10px 30px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">注冊</button>
        </div>
    </form>
</div>

<!--注冊弹窗 -->
<div id="signup" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:350px;
">
    <h3 style="margin-top:0; color:#333;">創建你的賬戶</h3>

    <div id="signupMessage" style="display:none; padding:10px; margin-bottom:15px; border-radius:5px; text-align:center;"></div>

    <form id="signupForm" method="post" action="user" onsubmit="return handleSignup(event);">
        <input type="hidden" name="action" value="signup">

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">用戶名：</label>
            <input type="text" name="useridCreate" id="useridCreate" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">密碼：</label>
            <input type="password" name="passwordCreate" id="passwordCreate" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

        <div style="margin-bottom:15px;">
            <label style="display:block; margin-bottom:5px; color:#666;">確認密碼：</label>
            <input type="password" name="passwordConfirm" id="passwordConfirm" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
        </div>

       

        <div style="display:flex; gap:10px; justify-content:center;">
            <button type="submit" style="padding:10px 30px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">提交</button>
            <button type="button" onclick="closeAllModals()" style="padding:10px 30px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">取消</button>
             
        </div>
    </form>
</div>


<!-- 食材搜索弹窗 -->
<div id="materialInput" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:350px;
">
    <h3 style="margin-top:0; color:#333;">想吃什麽食材</h3>

    <div style="margin-bottom:15px;">
        <label style="display:block; margin-bottom:5px; color:#666;">食材：</label>
        <input type="text" id="materialNameInput" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
    </div>

    <div style="margin-bottom:15px;">
        <label style="display:block; margin-bottom:5px; color:#666;">在家吃/出去吃：</label>
        <select id="situationInput" required style="width:100%; padding:8px; border:1px solid #ddd; border-radius:4px; box-sizing:border-box;">
            <option value="3">隨便</option>
            <option value="1">在家吃</option>
            <option value="2">出去吃</option>
        </select>
    </div>

    <div style="display:flex; gap:10px; justify-content:center;">
        <button type="button" onclick="materialPick()" style="padding:10px 30px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">🔍搜索</button>
        <button type="button" onclick="closeMaterialInputModal()" style="padding:10px 30px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">取消</button>
    </div>
</div>

<!--食材選擇结果弹窗 -->
<div id="materialResult" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:380px;
    max-width:500px;
">
    <h2 style="margin:0 0 20px 0; color:#ff6b6b; text-align:center;">🍽️ 今天吃这个！</h2>

    <!-- 食物圖片 -->
    <div id="materialFoodImageContainer" style="text-align:center; margin-bottom:20px; display:none;">
        <img id="materialFoodImage" src="" alt="食物圖片" style="width:100%; max-width:300px; height:auto; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
    </div>

    <div style="background:#f8f9fa; padding:20px; border-radius:8px; margin-bottom:20px;">
        <div style="margin-bottom:15px;">
            <span style="color:#999; font-size:13px;">菜名</span>
            <div style="font-size:22px; font-weight:bold; color:#333; margin-top:5px;" id="materialFoodName">加载中...</div>
        </div>

        <div style="border-top:1px solid #dee2e6; padding-top:15px;">
            <div style="margin-bottom:10px;">
                <span style="color:#666; font-size:14px;">🥘 食材：</span>
                <span id="materialFoodMaterial" style="color:#333;">-</span>
            </div>
            <div style="margin-bottom:10px;">
                <span style="color:#666; font-size:14px;">🍖 类型：</span>
                <span id="materialFoodKind" style="color:#333;">-</span>
            </div>
            <div>
                <span style="color:#666; font-size:14px;">📍 场景：</span>
                <span id="materialFoodSituation" style="color:#333;">-</span>
            </div>
        </div>
    </div>

    <div style="display:flex; gap:10px; justify-content:center;">
        <button type="button" onclick="confirmMaterialChoice()" style="padding:10px 20px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">✓ 确定</button>
        <button type="button" onclick="materialPick()" style="padding:10px 20px; background:#007bff; color:white; border:none; border-radius:5px; cursor:pointer;">🔄 重选</button>
        <button type="button" onclick="closeMaterialResultModal()" style="padding:10px 20px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">✕ 取消</button>
    </div>
</div>


<!-- 随机结果弹窗 -->
<div id="result" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:380px;
    max-width:500px;
">
    <h2 style="margin:0 0 20px 0; color:#ff6b6b; text-align:center;">🍽️ 今天吃这个！</h2>

    <!-- 食物圖片 -->
    <div id="foodImageContainer" style="text-align:center; margin-bottom:20px; display:none;">
        <img id="foodImage" src="" alt="食物圖片" style="width:100%; max-width:300px; height:auto; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
    </div>

    <div style="background:#f8f9fa; padding:20px; border-radius:8px; margin-bottom:20px;">
        <div style="margin-bottom:15px;">
            <span style="color:#999; font-size:13px;">菜名</span>
            <div style="font-size:22px; font-weight:bold; color:#333; margin-top:5px;" id="foodName">加载中...</div>
        </div>

        <div style="border-top:1px solid #dee2e6; padding-top:15px;">
            <div style="margin-bottom:10px;">
                <span style="color:#666; font-size:14px;">🥘 食材：</span>
                <span id="foodMaterial" style="color:#333;">-</span>
            </div>
            <div style="margin-bottom:10px;">
                <span style="color:#666; font-size:14px;">🍖 类型：</span>
                <span id="foodKind" style="color:#333;">-</span>
            </div>
            <div>
                <span style="color:#666; font-size:14px;">📍 场景：</span>
                <span id="foodSituation" style="color:#333;">-</span>
            </div>
        </div>
    </div>

    <div style="display:flex; gap:10px; justify-content:center;">
        <button type="button" onclick="confirmChoice()" style="padding:10px 20px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">✓ 确定</button>
        <button type="button" onclick="randomPick()" style="padding:10px 20px; background:#007bff; color:white; border:none; border-radius:5px; cursor:pointer;">🔄 重选</button>
        <button type="button" onclick="closeResultModal()" style="padding:10px 20px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">✕ 取消</button>
    </div>
</div>

<!-- 随机外食弹窗 -->
<div id="cruiseResult" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:30px;
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    min-width:380px;
    max-width:500px;
">
    <h2 style="margin:0 0 20px 0; color:#fd7e14; text-align:center;">🍽️ 出去吃这个！</h2>

    <!-- 食物圖片 -->
    <div id="cruiseFoodImageContainer" style="text-align:center; margin-bottom:20px; display:none;">
        <img id="cruiseFoodImage" src="" alt="食物圖片" style="width:100%; max-width:300px; height:auto; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
    </div>

    <div style="background:#f8f9fa; padding:20px; border-radius:8px; margin-bottom:20px;">
        <div style="margin-bottom:15px;">
            <span style="color:#999; font-size:13px;">菜名</span>
            <div style="font-size:22px; font-weight:bold; color:#333; margin-top:5px;" id="cruiseFoodName">加载中...</div>
        </div>

        <div style="border-top:1px solid #dee2e6; padding-top:15px;">
            <div style="margin-bottom:10px;">
                <span style="color:#666; font-size:14px;">🥘 食材：</span>
                <span id="cruiseFoodMaterial" style="color:#333;">-</span>
            </div>
            <div style="margin-bottom:10px;">
                <span style="color:#666; font-size:14px;">🍖 类型：</span>
                <span id="cruiseFoodKind" style="color:#333;">-</span>
            </div>
            <div>
                <span style="color:#666; font-size:14px;">📍 场景：</span>
                <span id="cruiseFoodSituation" style="color:#333;">-</span>
            </div>
        </div>
    </div>

    <div style="display:flex; gap:10px; justify-content:center;">
        <button type="button" onclick="confirmCruiseChoice()" style="padding:10px 20px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">✓ 确定</button>
        <button type="button" onclick="cruisePick()" style="padding:10px 20px; background:#007bff; color:white; border:none; border-radius:5px; cursor:pointer;">🔄 重选</button>
        <button type="button" onclick="closeCruiseResultModal()" style="padding:10px 20px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">✕ 取消</button>
    </div>
</div>



<!-- 健康搭配结果弹窗 (葷菜+素菜) -->
<div id="dailyResult" style="
    display:none;
    position:fixed;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    background:#fff;
    padding:clamp(15px, 4vw, 30px);
    border-radius:10px;
    box-shadow:0 4px 20px rgba(0,0,0,0.3);
    z-index:1000;
    width:90%;
    max-width:600px;
    max-height:90vh;
    overflow-y:auto;
">
    <h2 style="margin:0 0 20px 0; color:#20c997; text-align:center; font-size:clamp(18px, 5vw, 24px);">🥗 健康搭配推荐</h2>

    <div style="display:flex; gap:15px; margin-bottom:20px; flex-direction:column;">
        <!-- 荤菜 -->
        <div style="flex:1; background:#fff5f5; padding:clamp(12px, 3vw, 20px); border-radius:8px; border:2px solid #ff6b6b;">
            <h3 style="margin:0 0 15px 0; color:#ff6b6b; text-align:center; font-size:clamp(16px, 4vw, 20px);">🍖 荤菜</h3>
            <div style="margin-bottom:15px;">
                <span style="color:#999; font-size:clamp(11px, 3vw, 13px);">菜名</span>
                <div style="font-size:clamp(16px, 4.5vw, 20px); font-weight:bold; color:#333; margin-top:5px;" id="foodName1">加载中...</div>
            </div>
            <div style="border-top:1px solid #ffe0e0; padding-top:15px;">
                <div>
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">🥘 食材：</span>
                    <span id="foodMaterial1" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
            </div>

            <!-- 食物圖片 -->            <div id="dailyImageContainer1" style="text-align:center; margin-top:15px; display:none;">
                <img id="dailyFoodImage1" src="" alt="食物圖片" style="width:100%; max-width:300px; height:auto; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
            </div>
        </div>

        <!-- 素菜 -->
        <div style="flex:1; background:#f0fdf4; padding:clamp(12px, 3vw, 20px); border-radius:8px; border:2px solid #20c997;">
            <h3 style="margin:0 0 15px 0; color:#20c997; text-align:center; font-size:clamp(16px, 4vw, 20px);">🥬 素菜</h3>
            <div style="margin-bottom:15px;">
                <span style="color:#999; font-size:clamp(11px, 3vw, 13px);">菜名</span>
                <div style="font-size:clamp(16px, 4.5vw, 20px); font-weight:bold; color:#333; margin-top:5px;" id="foodName2">加载中...</div>
            </div>
            <div style="border-top:1px solid #d1fae5; padding-top:15px;">
                <div>
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">🥘 食材：</span>
                    <span id="foodMaterial2" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
            </div>

            <!-- 食物圖片 -->
            <div id="dailyImageContainer2" style="text-align:center; margin-top:15px; display:none;">
                <img id="dailyFoodImage2" src="" alt="食物圖片" style="width:100%; max-width:300px; height:auto; border-radius:8px; box-shadow:0 2px 8px rgba(0,0,0,0.1);">
            </div>
        </div>
    </div>

    <div style="display:flex; gap:10px; justify-content:center; flex-wrap:wrap;">
        <button type="button" onclick="confirmDailyChoice()" style="padding:10px 20px; background:#28a745; color:white; border:none; border-radius:5px; cursor:pointer;">✓ 确定</button>
        <button type="button" onclick="dailyPick()" style="padding:10px 20px; background:#007bff; color:white; border:none; border-radius:5px; cursor:pointer;">🔄 重选</button>
        <button type="button" onclick="closeDailyResultModal()" style="padding:10px 20px; background:#6c757d; color:white; border:none; border-radius:5px; cursor:pointer;">✕ 取消</button>
    </div>
</div>

<!-- 遮罩层 -->
<div id="overlay" style="
    display:none;
    position:fixed;
    top:0; left:0;
    width:100%; height:100%;
    background:rgba(0,0,0,0.5);
    z-index:999;
" onclick="closeAllModals()"></div>

<script>
function showModal() {
    console.log('showModal 被调用');
    // 檢查是否登錄
    if (!isLogin) {
        alert('請先登錄才能添加食物到你的專屬美食庫！');
        showLogin();
        return;
    }
    document.getElementById("modal").style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

function showLogin() {
    console.log('showLogin 被调用');
    document.getElementById("login").style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

function logout() {
    if (confirm('確定要登出嗎？')) {
        window.location.href = 'user?action=logout';
    }
}

function showMaterialInput() {
    document.getElementById("materialInput").style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

function showLogin() {
    document.getElementById("login").style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

function showSignup() {
    document.getElementById("signup").style.display = "block";
    document.getElementById("overlay").style.display = "block";
    // 清空之前的消息
    document.getElementById("signupMessage").style.display = "none";
    document.getElementById("signupForm").reset();
}

function handleSignup(event) {
    event.preventDefault(); // 阻止表單默認提交
    console.log('[handleSignup] 函數被調用');

    var useridCreate = document.getElementById("useridCreate").value;
    var passwordCreate = document.getElementById("passwordCreate").value;
    var passwordConfirm = document.getElementById("passwordConfirm").value;
    var messageDiv = document.getElementById("signupMessage");

    console.log('[handleSignup] 用戶名:', useridCreate);
    console.log('[handleSignup] 密碼長度:', passwordCreate.length);

    // 驗證密碼是否一致
    if (passwordCreate !== passwordConfirm) {
        messageDiv.style.display = "block";
        messageDiv.style.background = "#ffebee";
        messageDiv.style.color = "#c62828";
        messageDiv.textContent = "兩次輸入的密碼不一致！";
        return false;
    }

    // 發送 AJAX 請求（使用 URLSearchParams 代替 FormData）
    var params = new URLSearchParams();
    params.append("action", "signup");
    params.append("useridCreate", useridCreate);
    params.append("passwordCreate", passwordCreate);
    params.append("passwordConfirm", passwordConfirm);

    console.log('[handleSignup] URLSearchParams 已創建');
    // 打印參數內容
    for (var pair of params.entries()) {
        console.log('[handleSignup] Param:', pair[0] + ' = ' + pair[1]);
    }

    fetch('user', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
        },
        body: params.toString()
    })
    .then(function(response) {
        console.log('Response status:', response.status);
        console.log('Response ok:', response.ok);
        if (!response.ok) {
            throw new Error('HTTP error! status: ' + response.status);
        }
        return response.text(); // 先獲取文本
    })
    .then(function(text) {
        console.log('Response text:', text);
        try {
            return JSON.parse(text); // 嘗試解析 JSON
        } catch (e) {
            console.error('JSON parse error:', e);
            console.error('Response was:', text);
            throw new Error('無效的 JSON 響應');
        }
    })
    .then(function(data) {
        console.log('Parsed data:', data);
        if (data.success) {
            // 註冊成功，顯示提示信息
            messageDiv.style.display = "block";
            messageDiv.style.background = "#e8f5e9";
            messageDiv.style.color = "#2e7d32";
            messageDiv.textContent = "註冊成功！正在自動登錄...";

            // 1.5秒後刷新頁面，顯示已登錄狀態
            setTimeout(function() {
                window.location.reload();
            }, 1500);
        } else {
            // 註冊失敗
            messageDiv.style.display = "block";
            messageDiv.style.background = "#ffebee";
            messageDiv.style.color = "#c62828";
            messageDiv.textContent = data.message || data.error || "註冊失敗";
        }
    })
    .catch(function(error) {
        messageDiv.style.display = "block";
        messageDiv.style.background = "#ffebee";
        messageDiv.style.color = "#c62828";
        messageDiv.textContent = "錯誤: " + error.message;
        console.error('Error:', error);
    });

    return false;
}

function dailyPick() {
    console.log('dailyPick 被调用');

    var modal = document.getElementById("dailyResult");

    // 先移除动画类，确保重选时动画能重新触发
    modal.classList.remove("fade-in");

    // 使用setTimeout确保类被移除后再添加
    setTimeout(function() {
        modal.style.display = "block";
        modal.classList.add("fade-in");
    }, 10);

    document.getElementById("overlay").style.display = "block";

    var foodName1 = document.getElementById("foodName1");
    var foodName2 = document.getElementById("foodName2");

    foodName1.textContent = "加载中...";
    foodName1.classList.remove("rolling-animation");
    setTimeout(function() { foodName1.classList.add("rolling-animation"); }, 10);

    document.getElementById("foodMaterial1").textContent = "-";

    foodName2.textContent = "加载中...";
    foodName2.classList.remove("rolling-animation");
    setTimeout(function() { foodName2.classList.add("rolling-animation"); }, 10);

    document.getElementById("foodMaterial2").textContent = "-";

    console.log('开始 fetch 请求');

    // 记录开始时间
    var startTime = Date.now();

    fetch('food?action=dailyPick', {
        method: 'POST'
    })
    .then(function(response) {
        console.log('收到响应，状态:', response.status);
        if (!response.ok) {
            throw new Error('HTTP ' + response.status);
        }
        return response.json();
    })
    .then(function(data) {
        console.log('解析后的数据:', data);

        // 计算已经过去的时间
        var elapsed = Date.now() - startTime;
        var remainingTime = Math.max(0, 1000 - elapsed); // 确保至少1秒

        // 延迟移除动画，确保至少显示1秒
        setTimeout(function() {
            foodName1.classList.remove("rolling-animation");
            foodName2.classList.remove("rolling-animation");

            if (data.success) {
                document.getElementById("foodName1").textContent = data.foodMeat || '未知';
                document.getElementById("foodMaterial1").textContent = data.materialMeat || '无';

                document.getElementById("foodName2").textContent = data.foodVeg || '未知';
                document.getElementById("foodMaterial2").textContent = data.materialVeg || '无';

                // 獲取食物圖片
                fetchFoodImage(data.foodMeat, 'dailyFoodImage1', 'dailyImageContainer1');
                fetchFoodImage(data.foodVeg, 'dailyFoodImage2', 'dailyImageContainer2');
            } else {
                document.getElementById("foodName1").textContent = "获取失败";
                document.getElementById("foodMaterial1").textContent = data.error || '未知错误';
            }
        }, remainingTime);
    })
    .catch(function(error) {
        console.error('发生错误:', error);
        foodName1.classList.remove("rolling-animation");
        foodName2.classList.remove("rolling-animation");
        document.getElementById("foodName1").textContent = "网络错误";
        document.getElementById("foodMaterial1").textContent = error.message;
    });
}

// 從 Pexels API 獲取食物圖片
function fetchFoodImage(foodName, imageElementId, containerElementId) {
    console.log('[Pexels] 開始搜索圖片:', foodName);

    var container = document.getElementById(containerElementId);
    var img = document.getElementById(imageElementId);

    // 初始化：隱藏圖片容器，準備淡入動畫
    if (img && container) {
        container.style.display = 'none';
        img.style.opacity = '0';
        img.style.transition = 'opacity 0.5s ease-in';
    }

    // Pexels API 憑證
    var PEXELS_API_KEY = 'Ws1cbPmcx1tRk1dc01eCrufE5o0XJEnbJMnNHG6uiuPTPDwv3JaBnUPX';

    // 構建搜索查詢（使用中文 "食物" 關鍵字以獲得更準確的中文食物圖片）
    var searchQuery = encodeURIComponent(foodName + ' 食物');
    var apiUrl = 'https://api.pexels.com/v1/search?query=' + searchQuery + '&per_page=1&orientation=landscape&locale=zh-TW';

    // 嘗試從 Pexels 獲取圖片
    fetch(apiUrl, {
        headers: {
            'Authorization': PEXELS_API_KEY
        }
    })
        .then(function(response) {
            if (!response.ok) {
                throw new Error('API 請求失敗: ' + response.status);
            }
            return response.json();
        })
        .then(function(data) {
            console.log('[Pexels] API 響應:', data);

            if (data.photos && data.photos.length > 0 && img) {
                // 找到匹配的圖片，使用 medium 尺寸
                var imageUrl = data.photos[0].src.medium;
                console.log('[Pexels] 找到圖片:', imageUrl);

                // 設置圖片源，等待加載完成
                img.src = imageUrl;
                img.alt = foodName;

                // 圖片加載完成後，淡入顯示
                img.onload = function() {
                    container.style.display = 'block';
                    setTimeout(function() {
                        img.style.opacity = '1';
                    }, 10);
                };

                // 處理圖片加載失敗的情況
                img.onerror = function() {
                    console.log('[Pexels] 圖片加載失敗，使用默認圖片');
                    img.src = 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png';
                    img.alt = '食物圖片';
                    container.style.display = 'block';
                    setTimeout(function() {
                        img.style.opacity = '1';
                    }, 10);
                };
            } else {
                console.log('[Pexels] 未找到匹配的食物圖片，使用默認圖片');
                if (img) {
                    img.src = 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png';
                    img.alt = '食物圖片';
                    img.onload = function() {
                        container.style.display = 'block';
                        setTimeout(function() {
                            img.style.opacity = '1';
                        }, 10);
                    };
                }
            }
        })
        .catch(function(error) {
            console.log('[Pexels] 獲取圖片失敗，使用默認圖片:', error.message);
            // 顯示默認圖片
            if (img) {
                img.src = 'https://cdn-icons-png.flaticon.com/512/3075/3075977.png';
                img.alt = '食物圖片';
                img.onload = function() {
                    container.style.display = 'block';
                    setTimeout(function() {
                        img.style.opacity = '1';
                    }, 10);
                };
            }
        });
}

function randomPick() {
    console.log('randomPick 被调用');

    var modal = document.getElementById("result");

    // 先移除动画类，确保重选时动画能重新触发
    modal.classList.remove("fade-in");

    // 使用setTimeout确保类被移除后再添加
    setTimeout(function() {
        modal.style.display = "block";
        modal.classList.add("fade-in");
    }, 10);

    document.getElementById("overlay").style.display = "block";

    var foodName = document.getElementById("foodName");
    foodName.textContent = "加载中...";
    foodName.classList.remove("rolling-animation");
    setTimeout(function() { foodName.classList.add("rolling-animation"); }, 10);

    document.getElementById("foodMaterial").textContent = "-";
    document.getElementById("foodKind").textContent = "-";
    document.getElementById("foodSituation").textContent = "-";

    console.log('开始 fetch 请求');

    // 记录开始时间
    var startTime = Date.now();

    fetch('food?action=randomPick', {
        method: 'POST'
    })
    .then(function(response) {
        console.log('收到响应，状态:', response.status);
        if (!response.ok) {
            throw new Error('HTTP ' + response.status);
        }
        return response.json();
    })
    .then(function(data) {
        console.log('解析后的数据:', data);

        // 计算已经过去的时间
        var elapsed = Date.now() - startTime;
        var remainingTime = Math.max(0, 1000 - elapsed); // 确保至少1秒

        // 延迟移除动画，确保至少显示1秒
        setTimeout(function() {
            foodName.classList.remove("rolling-animation");

            if (data.success) {
                var foodNameText = data.food || '未知';
                document.getElementById("foodName").textContent = foodNameText;
                document.getElementById("foodMaterial").textContent = data.material || '无';
                document.getElementById("foodKind").textContent = data.kind || '无';
                document.getElementById("foodSituation").textContent = data.situation || '无';

                // 獲取食物圖片
                fetchFoodImage(foodNameText, 'foodImage', 'foodImageContainer');
            } else {
                document.getElementById("foodName").textContent = "获取失败";
                document.getElementById("foodMaterial").textContent = data.error || '未知错误';
            }
        }, remainingTime);
    })
    .catch(function(error) {
        console.error('发生错误:', error);
        foodName.classList.remove("rolling-animation");
        document.getElementById("foodName").textContent = "网络错误";
        document.getElementById("foodMaterial").textContent = error.message;
    });
}

function cruisePick() {
    console.log('cruisePick 被调用');

    var modal = document.getElementById("cruiseResult");

    // 先移除动画类，确保重选时动画能重新触发
    modal.classList.remove("fade-in");

    // 使用setTimeout确保类被移除后再添加
    setTimeout(function() {
        modal.style.display = "block";
        modal.classList.add("fade-in");
    }, 10);

    document.getElementById("overlay").style.display = "block";

    var foodName = document.getElementById("cruiseFoodName");
    foodName.textContent = "加载中...";
    foodName.classList.remove("rolling-animation");
    setTimeout(function() { foodName.classList.add("rolling-animation"); }, 10);

    document.getElementById("cruiseFoodMaterial").textContent = "-";
    document.getElementById("cruiseFoodKind").textContent = "-";
    document.getElementById("cruiseFoodSituation").textContent = "-";

    console.log('开始 fetch 请求');

    // 记录开始时间
    var startTime = Date.now();

    fetch('food?action=cruisePick', {
        method: 'POST'
    })
    .then(function(response) {
        console.log('收到响应，状态:', response.status);
        if (!response.ok) {
            throw new Error('HTTP ' + response.status);
        }
        return response.json();
    })
    .then(function(data) {
        console.log('解析后的数据:', data);

        // 计算已经过去的时间
        var elapsed = Date.now() - startTime;
        var remainingTime = Math.max(0, 1000 - elapsed); // 确保至少1秒

        // 延迟移除动画，确保至少显示1秒
        setTimeout(function() {
            foodName.classList.remove("rolling-animation");

            if (data.success) {
                var foodNameText = data.food || '未知';
                document.getElementById("cruiseFoodName").textContent = foodNameText;
                document.getElementById("cruiseFoodMaterial").textContent = data.material || '无';
                document.getElementById("cruiseFoodKind").textContent = data.kind || '无';
                document.getElementById("cruiseFoodSituation").textContent = data.situation || '无';

                // 獲取食物圖片
                fetchFoodImage(foodNameText, 'cruiseFoodImage', 'cruiseFoodImageContainer');
            } else {
                document.getElementById("cruiseFoodName").textContent = "获取失败";
                document.getElementById("cruiseFoodMaterial").textContent = data.error || '未知错误';
            }
        }, remainingTime);
    })
    .catch(function(error) {
        console.error('发生错误:', error);
        foodName.classList.remove("rolling-animation");
        document.getElementById("cruiseFoodName").textContent = "网络错误";
        document.getElementById("cruiseFoodMaterial").textContent = error.message;
    });
}

function materialPick() {
    console.log('materialPick 被调用');

    // 獲取表單值
    var materialName = document.getElementById("materialNameInput").value;
    var situationFlag = document.getElementById("situationInput").value;

    if (!materialName) {
        alert("請輸入食材名稱！");
        return;
    }

    // 關閉輸入彈窗，顯示結果彈窗
    document.getElementById("materialInput").style.display = "none";
    var modal = document.getElementById("materialResult");

    // 先移除动画类，确保重选时动画能重新触发
    modal.classList.remove("fade-in");

    // 使用setTimeout确保类被移除后再添加
    setTimeout(function() {
        modal.style.display = "block";
        modal.classList.add("fade-in");
    }, 10);

    document.getElementById("overlay").style.display = "block";

    var foodName = document.getElementById("materialFoodName");
    foodName.textContent = "加载中...";
    foodName.classList.remove("rolling-animation");
    setTimeout(function() { foodName.classList.add("rolling-animation"); }, 10);

    document.getElementById("materialFoodMaterial").textContent = "-";
    document.getElementById("materialFoodKind").textContent = "-";
    document.getElementById("materialFoodSituation").textContent = "-";

    console.log('开始 fetch 请求，食材:', materialName, '场景:', situationFlag);

    // 记录开始时间
    var startTime = Date.now();

    // 構建 URL 參數
    var params = new URLSearchParams();
    params.append('action', 'materialPick');
    params.append('materialName', materialName);
    params.append('kind', situationFlag);

    fetch('food', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: params.toString()
    })
    .then(function(response) {
        console.log('收到响应，状态:', response.status);
        if (!response.ok) {
            throw new Error('HTTP ' + response.status);
        }
        return response.json();
    })
    .then(function(data) {
        console.log('解析后的数据:', data);

        // 计算已经过去的时间
        var elapsed = Date.now() - startTime;
        var remainingTime = Math.max(0, 1000 - elapsed); // 确保至少1秒

        // 延迟移除动画，确保至少显示1秒
        setTimeout(function() {
            foodName.classList.remove("rolling-animation");

            if (data.success) {
                var foodNameText = data.food || '未知';
                document.getElementById("materialFoodName").textContent = foodNameText;
                document.getElementById("materialFoodMaterial").textContent = data.material || '无';
                document.getElementById("materialFoodKind").textContent = data.kind || '无';
                document.getElementById("materialFoodSituation").textContent = data.situation || '无';

                // 獲取食物圖片
                fetchFoodImage(foodNameText, 'materialFoodImage', 'materialFoodImageContainer');
            } else {
                document.getElementById("materialFoodName").textContent = "获取失败";
                document.getElementById("materialFoodMaterial").textContent = data.error || '未知错误';
            }
        }, remainingTime);
    })
    .catch(function(error) {
        console.error('发生错误:', error);
        foodName.classList.remove("rolling-animation");
        document.getElementById("materialFoodName").textContent = "网络错误";
        document.getElementById("materialFoodMaterial").textContent = error.message;
    });
}


function closeAddModal() {
    console.log('closeAddModal 被调用');
    document.getElementById("modal").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function closeResultModal() {
    console.log('closeResultModal 被调用');
    document.getElementById("result").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function closeCruiseResultModal() {
    console.log('closeCruiseResultModal 被调用');
    document.getElementById("cruiseResult").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function closeMaterialInputModal() {
    console.log('closeMaterialInputModal 被调用');
    document.getElementById("materialInput").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function closeMaterialResultModal() {
    console.log('closeMaterialResultModal 被调用');
    document.getElementById("materialResult").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function closeDailyResultModal() {
    console.log('closeDailyResultModal 被调用');
    document.getElementById("dailyResult").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

function closeAllModals() {
    console.log('closeAllModals 被调用');
    document.getElementById("modal").style.display = "none";
    document.getElementById("result").style.display = "none";
    document.getElementById("cruiseResult").style.display = "none";
    document.getElementById("dailyResult").style.display = "none";
    document.getElementById("materialInput").style.display = "none";
    document.getElementById("materialResult").style.display = "none";
    document.getElementById("overlay").style.display = "none";
    document.getElementById("login").style.display = "none";
    document.getElementById("signup").style.display = "none";
}

function confirmChoice() {
    console.log('confirmChoice 被调用');
    var foodName = document.getElementById("foodName").textContent;
    if (foodName !== "加载中..." && foodName !== "未知" && foodName !== "网络错误") {
        alert("好的，就吃 " + foodName + "！");
    }
    closeResultModal();
}

function confirmCruiseChoice() {
    console.log('confirmCruiseChoice 被调用');
    var foodName = document.getElementById("cruiseFoodName").textContent;
    if (foodName !== "加载中..." && foodName !== "未知" && foodName !== "网络错误") {
        alert("好的，就吃 " + foodName + "！");
    }
    closeCruiseResultModal();
}

function confirmMaterialChoice() {
    console.log('confirmMaterialChoice 被调用');
    var foodName = document.getElementById("materialFoodName").textContent;
    if (foodName !== "加载中..." && foodName !== "未知" && foodName !== "网络错误") {
        alert("好的，就吃 " + foodName + "！");
    }
    closeMaterialResultModal();
}

function confirmDailyChoice() {
    console.log('confirmDailyChoice 被调用');
    var foodName1 = document.getElementById("foodName1").textContent;
    var foodName2 = document.getElementById("foodName2").textContent;
    if (foodName1 !== "加载中..." && foodName1 !== "未知" && foodName1 !== "网络错误") {
        alert("好的，今天吃 " + foodName1 + " 和 " + foodName2 + "！");
    }
    closeDailyResultModal();
}
var isLogin = <%= (loginUser != null) %>;

// 食物 emoji 滾動效果
var foodEmojis = ['🍗', '🥩', '🥬', '🍅', '🥕', '🍆', '🌽', '🥔', '🍄', '🥦', '🍖', '🍤', '🐟', '🦐', '🥓'];
var currentEmojiIndex = 0;

function updateFoodEmoji() {
    var container = document.getElementById('foodEmojiScroll');
    if (container) {
        var currentEmoji = container.querySelector('span');
        if (currentEmoji) {
            currentEmoji.remove();
        }

        currentEmojiIndex = (currentEmojiIndex + 1) % foodEmojis.length;
        var newEmoji = document.createElement('span');
        newEmoji.textContent = foodEmojis[currentEmojiIndex];
        container.appendChild(newEmoji);
    }
}

// 每2秒切換一個食物 emoji
setInterval(updateFoodEmoji, 2000);

// 點擊彈出隨機食物 emoji
var clickFoodEmojis = ['🍗', '🥩', '🥬', '🍅', '🥕', '🍆', '🌽', '🥔', '🍄', '🥦', '🍖', '🍤', '🐟', '🦐', '🥓', '🍕', '🍔', '🍟', '🌭', '🥪', '🌮', '🌯', '🥙', '🍝', '🍜', '🍲', '🍱', '🍛', '🍣', '🍤'];

function createClickEmoji(x, y) {
    // 隨機選擇一個食物 emoji
    var randomEmoji = clickFoodEmojis[Math.floor(Math.random() * clickFoodEmojis.length)];

    // 創建 emoji 元素
    var emojiElement = document.createElement('div');
    emojiElement.className = 'click-emoji';
    emojiElement.textContent = randomEmoji;
    emojiElement.style.left = x + 'px';
    emojiElement.style.top = y + 'px';

    // 添加到頁面
    document.body.appendChild(emojiElement);

    // 1秒後移除
    setTimeout(function() {
        emojiElement.remove();
    }, 1000);
}

// 監聽頁面點擊事件
document.addEventListener('click', function(event) {
    // 檢查點擊的是否是按鈕或其他交互元素
    var target = event.target;
    var isButton = target.tagName === 'BUTTON' ||
                   target.tagName === 'A' ||
                   target.tagName === 'INPUT' ||
                   target.tagName === 'SELECT' ||
                   target.closest('button') !== null ||
                   target.closest('a') !== null;

    // 如果不是按鈕，則創建 emoji
    if (!isButton) {
        createClickEmoji(event.clientX, event.clientY);
    }
});

// 移除自動彈出登錄窗口的邏輯
window.onload = function() {
    // 確保登錄窗口和遮罩層默認隱藏
    document.getElementById("login").style.display = "none";
    document.getElementById("overlay").style.display = "none";
}

console.log('JavaScript 已加载');
</script>

</body>
</html>