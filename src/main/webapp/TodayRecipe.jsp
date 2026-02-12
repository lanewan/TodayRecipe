<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

    /* 標題 */
    .page-title {
        font-size: clamp(32px, 8vw, 48px);
        font-weight: bold;
        color: #333;
        margin: 20px 0;
        text-align: center;
        text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
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
</style>
</head>
<body>

<h1 class="page-title">今天吃什麽</h1>

<div class="container">
    <!-- 主按钮 -->
    <button class="btn-main" onclick="randomPick()">听天由命</button>

    <!-- 三个功能按钮 -->
    <div class="secondary-buttons">
        <button class="btn-health" onclick="dailyPick()">健康</button>
        <button class="btn-dining" onclick="cruisePick()">外食</button>
        <button class="btn-material" onclick="showMaterialInput()">想吃○○！</button>
    </div>

    <!-- 添加食物按钮 -->
    <button class="btn-add" onclick="showModal()">+ 添加食物</button>
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
">
    <h2 style="margin:0 0 20px 0; color:#ff6b6b; text-align:center;">🍽️ 今天吃这个！</h2>

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
">
    <h2 style="margin:0 0 20px 0; color:#ff6b6b; text-align:center;">🍽️ 今天吃这个！</h2>

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
">
    <h2 style="margin:0 0 20px 0; color:#fd7e14; text-align:center;">🍽️ 出去吃这个！</h2>

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
                <div style="margin-bottom:8px;">
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">🥘 食材：</span>
                    <span id="foodMaterial1" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
                <div style="margin-bottom:8px;">
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">🍖 类型：</span>
                    <span id="foodKind1" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
                <div>
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">📍 场景：</span>
                    <span id="foodSituation1" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
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
                <div style="margin-bottom:8px;">
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">🥘 食材：</span>
                    <span id="foodMaterial2" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
                <div style="margin-bottom:8px;">
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">🍖 类型：</span>
                    <span id="foodKind2" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
                <div>
                    <span style="color:#666; font-size:clamp(11px, 3vw, 13px);">📍 场景：</span>
                    <span id="foodSituation2" style="color:#333; font-size:clamp(11px, 3vw, 13px);">-</span>
                </div>
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
    document.getElementById("modal").style.display = "block";
    document.getElementById("overlay").style.display = "block";
}

function showMaterialInput() {
    document.getElementById("materialInput").style.display = "block";
    document.getElementById("overlay").style.display = "block";
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
    document.getElementById("foodKind1").textContent = "-";
    document.getElementById("foodSituation1").textContent = "-";

    foodName2.textContent = "加载中...";
    foodName2.classList.remove("rolling-animation");
    setTimeout(function() { foodName2.classList.add("rolling-animation"); }, 10);

    document.getElementById("foodMaterial2").textContent = "-";
    document.getElementById("foodKind2").textContent = "-";
    document.getElementById("foodSituation2").textContent = "-";

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
                document.getElementById("foodKind1").textContent = data.kindMeat || '无';
                document.getElementById("foodSituation1").textContent = data.situationMeat || '无';

                document.getElementById("foodName2").textContent = data.foodVeg || '未知';
                document.getElementById("foodMaterial2").textContent = data.materialVeg || '无';
                document.getElementById("foodKind2").textContent = data.kindVeg || '无';
                document.getElementById("foodSituation2").textContent = data.situationVeg || '无';
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
                document.getElementById("foodName").textContent = data.food || '未知';
                document.getElementById("foodMaterial").textContent = data.material || '无';
                document.getElementById("foodKind").textContent = data.kind || '无';
                document.getElementById("foodSituation").textContent = data.situation || '无';
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
                document.getElementById("cruiseFoodName").textContent = data.food || '未知';
                document.getElementById("cruiseFoodMaterial").textContent = data.material || '无';
                document.getElementById("cruiseFoodKind").textContent = data.kind || '无';
                document.getElementById("cruiseFoodSituation").textContent = data.situation || '无';
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
                document.getElementById("materialFoodName").textContent = data.food || '未知';
                document.getElementById("materialFoodMaterial").textContent = data.material || '无';
                document.getElementById("materialFoodKind").textContent = data.kind || '无';
                document.getElementById("materialFoodSituation").textContent = data.situation || '无';
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

console.log('JavaScript 已加载');
</script>

</body>
</html>