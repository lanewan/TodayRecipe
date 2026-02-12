package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import data.Data;
import data.Pick;
import data.Stock;

@WebServlet("/food")
public class FoodServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");
		resp.setContentType("text/html;charset=UTF-8");

		String action = req.getParameter("action");

		if ("add".equals(action)) {
			addFood(req, resp);
		}

		if ("randomPick".equals(action)) {
			randomPick(req, resp);
		}

		if ("dailyPick".equals(action)) {
			dailyPick(req, resp);
		}

		if ("cruisePick".equals(action)) {
			cruisePick(req, resp);
		}

		if ("materialPick".equals(action)) {
			materialPick(req, resp);
		}
	}

	private void addFood(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		String name = req.getParameter("name");
		String material = req.getParameter("material");
		String kind = req.getParameter("kind");
		String situation = req.getParameter("situation");

		try {
			Data service = new Data();

			service.addFood(name, material, kind, situation);

			resp.sendRedirect("TodayRecipe.jsp");
		} catch (Exception e) {
			e.printStackTrace();
			resp.getWriter().write("添加失败");
		}
	}

	private void randomPick(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		resp.setContentType("application/json;charset=UTF-8");

		try {
			System.out.println("========== 开始随机选择 ==========");

			Pick pick = new Pick();
			Stock stock = pick.randomPick();

			if (stock == null) {
				System.err.println("ERROR: randomPick() 返回了 null");
				resp.getWriter().write("{\"success\":false, \"error\":\"未找到食品\"}");
				return;
			}

			// ✅ 获取所有字段
			String food = stock.getName();
			String material = stock.getMaterial();
			String kind = stock.getKind();
			String situation = stock.getSituation();

			// ✅ 打印调试信息
			System.out.println("名称: " + food);
			System.out.println("材料: " + material);
			System.out.println("类型: " + kind);
			System.out.println("场景: " + situation);

			// ✅ 构建完整的 JSON（注意字段名要和前端一致）
			StringBuilder jsonBuilder = new StringBuilder();
			jsonBuilder.append("{");
			jsonBuilder.append("\"success\":true,");
			jsonBuilder.append("\"food\":\"").append(escapeJson(food)).append("\",");
			jsonBuilder.append("\"material\":\"").append(escapeJson(material)).append("\",");
			jsonBuilder.append("\"kind\":\"").append(escapeJson(kind)).append("\",");
			jsonBuilder.append("\"situation\":\"").append(escapeJson(situation)).append("\"");
			jsonBuilder.append("}");

			String json = jsonBuilder.toString();
			System.out.println("准备返回 JSON: " + json);

			resp.getWriter().write(json);
			System.out.println("========== 随机选择完成 ==========");

		} catch (Exception e) {
			System.err.println("========== 发生严重错误 ==========");
			System.err.println("异常类型: " + e.getClass().getName());
			System.err.println("异常消息: " + e.getMessage());
			e.printStackTrace(System.err);
			System.err.println("=====================================");

			String errorMsg = e.getMessage() != null ? e.getMessage() : "未知错误";
			String json = String.format("{\"success\":false, \"error\": \"%s\"}", escapeJson(errorMsg));
			resp.getWriter().write(json);
		}
	}

	private void dailyPick(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		resp.setContentType("application/json;charset=UTF-8");

		try {
			System.out.println("========== 开始健康搭配选择 ==========");

			Pick pick = new Pick();
			Stock stockMeat = pick.meatPick();
			Stock stockVeg = pick.vegPick();

			if (stockMeat == null || stockVeg == null) {
				System.err.println("ERROR: 未找到足够的食品");
				resp.getWriter().write("{\"success\":false, \"error\":\"未找到食品\"}");
				return;
			}

			// ✅ 获取荤菜字段
			String foodMeat = stockMeat.getName();
			String materialMeat = stockMeat.getMaterial();
			String kindMeat = stockMeat.getKind();
			String situationMeat = stockMeat.getSituation();

			// ✅ 获取素菜字段
			String foodVeg = stockVeg.getName();
			String materialVeg = stockVeg.getMaterial();
			String kindVeg = stockVeg.getKind();
			String situationVeg = stockVeg.getSituation();

			// ✅ 打印调试信息
			System.out.println("荤菜: " + foodMeat + ", 材料: " + materialMeat);
			System.out.println("素菜: " + foodVeg + ", 材料: " + materialVeg);

			// ✅ 构建单一的 JSON 对象，包含荤菜和素菜数据
			StringBuilder jsonBuilder = new StringBuilder();
			jsonBuilder.append("{");
			jsonBuilder.append("\"success\":true,");
			jsonBuilder.append("\"foodMeat\":\"").append(escapeJson(foodMeat)).append("\",");
			jsonBuilder.append("\"materialMeat\":\"").append(escapeJson(materialMeat)).append("\",");
			jsonBuilder.append("\"kindMeat\":\"").append(escapeJson(kindMeat)).append("\",");
			jsonBuilder.append("\"situationMeat\":\"").append(escapeJson(situationMeat)).append("\",");
			jsonBuilder.append("\"foodVeg\":\"").append(escapeJson(foodVeg)).append("\",");
			jsonBuilder.append("\"materialVeg\":\"").append(escapeJson(materialVeg)).append("\",");
			jsonBuilder.append("\"kindVeg\":\"").append(escapeJson(kindVeg)).append("\",");
			jsonBuilder.append("\"situationVeg\":\"").append(escapeJson(situationVeg)).append("\"");
			jsonBuilder.append("}");

			String json = jsonBuilder.toString();
			System.out.println("准备返回 JSON: " + json);

			resp.getWriter().write(json);
			System.out.println("========== 健康搭配选择完成 ==========");

		} catch (Exception e) {
			System.err.println("========== 发生严重错误 ==========");
			System.err.println("异常类型: " + e.getClass().getName());
			System.err.println("异常消息: " + e.getMessage());
			e.printStackTrace(System.err);
			System.err.println("=====================================");

			String errorMsg = e.getMessage() != null ? e.getMessage() : "未知错误";
			String json = String.format("{\"success\":false, \"error\": \"%s\"}", escapeJson(errorMsg));
			resp.getWriter().write(json);
		}
	}

	private void cruisePick(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		resp.setContentType("application/json;charset=UTF-8");

		try {
			System.out.println("========== 开始外食选择 ==========");

			Pick pick = new Pick();
			Stock stock = pick.cruisePick();

			if (stock == null) {
				System.err.println("ERROR: 未找到足够的食品");
				resp.getWriter().write("{\"success\":false, \"error\":\"未找到食品\"}");
				return;
			}

			// ✅ 获取荤菜字段
			String food = stock.getName();
			String material = stock.getMaterial();
			String kind = stock.getKind();
			String situation = stock.getSituation();

			// ✅ 打印调试信息
			System.out.println("外食: " + food + ", 材料: " + material);

			// ✅ 构建单一的 JSON 对象，包含荤菜和素菜数据
			StringBuilder jsonBuilder = new StringBuilder();
			jsonBuilder.append("{");
			jsonBuilder.append("\"success\":true,");
			jsonBuilder.append("\"food\":\"").append(escapeJson(food)).append("\",");
			jsonBuilder.append("\"material\":\"").append(escapeJson(material)).append("\",");
			jsonBuilder.append("\"kind\":\"").append(escapeJson(kind)).append("\",");
			jsonBuilder.append("\"situation\":\"").append(escapeJson(situation)).append("\"");
			jsonBuilder.append("}");

			String json = jsonBuilder.toString();
			System.out.println("准备返回 JSON: " + json);

			resp.getWriter().write(json);
			System.out.println("========== 外食选择完成 ==========");

		} catch (Exception e) {
			System.err.println("========== 发生严重错误 ==========");
			System.err.println("异常类型: " + e.getClass().getName());
			System.err.println("异常消息: " + e.getMessage());
			e.printStackTrace(System.err);
			System.err.println("=====================================");

			String errorMsg = e.getMessage() != null ? e.getMessage() : "未知错误";
			String json = String.format("{\"success\":false, \"error\": \"%s\"}", escapeJson(errorMsg));
			resp.getWriter().write(json);
		}
	}

	private void materialPick(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		resp.setContentType("application/json;charset=UTF-8");
		String materialName = req.getParameter("materialName");
		String situationFlag = req.getParameter("kind");

		try {
			System.out.println("========== 根據食材选择 ==========");

			Pick pick = new Pick();
			Stock stock = pick.materialPick(situationFlag, materialName);

			if (stock == null) {
				System.err.println("ERROR: 未找到足够的食品");
				resp.getWriter().write("{\"success\":false, \"error\":\"未找到食品\"}");
				return;
			}

			// ✅ 获取荤菜字段
			String food = stock.getName();
			String material = stock.getMaterial();
			String kind = stock.getKind();
			String situation = stock.getSituation();

			// ✅ 打印调试信息
			System.out.println("食物: " + food + ", 材料: " + material);

			// ✅ 构建单一的 JSON 对象，包含荤菜和素菜数据
			StringBuilder jsonBuilder = new StringBuilder();
			jsonBuilder.append("{");
			jsonBuilder.append("\"success\":true,");
			jsonBuilder.append("\"food\":\"").append(escapeJson(food)).append("\",");
			jsonBuilder.append("\"material\":\"").append(escapeJson(material)).append("\",");
			jsonBuilder.append("\"kind\":\"").append(escapeJson(kind)).append("\",");
			jsonBuilder.append("\"situation\":\"").append(escapeJson(situation)).append("\"");
			jsonBuilder.append("}");

			String json = jsonBuilder.toString();
			System.out.println("准备返回 JSON: " + json);

			resp.getWriter().write(json);
			System.out.println("========== 外食选择完成 ==========");

		} catch (Exception e) {
			System.err.println("========== 发生严重错误 ==========");
			System.err.println("异常类型: " + e.getClass().getName());
			System.err.println("异常消息: " + e.getMessage());
			e.printStackTrace(System.err);
			System.err.println("=====================================");

			String errorMsg = e.getMessage() != null ? e.getMessage() : "未知错误";
			String json = String.format("{\"success\":false, \"error\": \"%s\"}", escapeJson(errorMsg));
			resp.getWriter().write(json);
		}
	}

	// ✅ JSON 转义方法
	private String escapeJson(String str) {
		if (str == null || str.isEmpty()) {
			return ""; // 空值返回空字符串
		}
		return str.replace("\\", "\\\\")
				.replace("\"", "\\\"")
				.replace("\n", "\\n")
				.replace("\r", "\\r");
	}

}
