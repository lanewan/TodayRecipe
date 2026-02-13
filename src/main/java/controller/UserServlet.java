package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import data.Data;
import data.User;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// GET 請求也調用 doPost 處理
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {

		req.setCharacterEncoding("UTF-8");

		String action = req.getParameter("action");
		System.out.println("[UserServlet] doPost 被調用 - action: " + action);

		if ("login".equals(action)) {
			resp.setContentType("text/html;charset=UTF-8");
			login(req, resp);
			return;
		}

		if ("logout".equals(action)) {
			resp.setContentType("text/html;charset=UTF-8");
			logout(req, resp);
			return;
		}

		if ("signup".equals(action)) {
			resp.setContentType("application/json;charset=UTF-8");
			signUp(req, resp);
			return;
		}

		// 如果沒有匹配的 action，返回錯誤
		System.err.println("[UserServlet] 未知的 action: " + action);
		resp.setContentType("application/json;charset=UTF-8");
		resp.getWriter().write("{\"success\":false, \"error\":\"未知的操作\"}");
		resp.getWriter().flush();
	}

	public void login(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		String user = req.getParameter("userid");
		String password = req.getParameter("password");

		try {
			Data service = new Data();
			User us = service.logInCheck(user, password);

			if (us != null) {

				HttpSession session = req.getSession();
				session.setAttribute("loginUser", us);

				resp.sendRedirect("TodayRecipe.jsp");

			} else {
				resp.getWriter().write("用户名或密码错误");
			}

		} catch (Exception e) {
			e.printStackTrace();
			resp.getWriter().write("登录失败");
		}
	}

	public void logout(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		HttpSession session = req.getSession();
		session.removeAttribute("loginUser");
		session.invalidate();

		resp.sendRedirect("TodayRecipe.jsp");
	}

	private void signUp(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {

		System.out.println("[UserServlet] signUp 方法被調用");
		resp.setContentType("application/json;charset=UTF-8");

		String userIdCreate = req.getParameter("useridCreate");
		String passwordCreate = req.getParameter("passwordCreate");
		String passwordConfirm = req.getParameter("passwordConfirm");

		System.out.println("[UserServlet] 註冊請求 - 用戶名: " + userIdCreate);

		try {
			Data service = new Data();

			try {
				boolean existed = service.signupCheck(userIdCreate, passwordCreate);

				if (existed) {
					System.out.println("[UserServlet] 用戶已存在: " + userIdCreate);
					resp.getWriter().write("{\"success\":false, \"message\":\"用户已存在\"}");
					resp.getWriter().flush();
				} else {
					service.signUp(userIdCreate, passwordCreate);
					System.out.println("[UserServlet] 用戶註冊成功: " + userIdCreate);

					// 註冊成功後自動登錄：創建 User 對象並存儲到 session
					User newUser = new User();
					newUser.setUserId(userIdCreate);
					newUser.setPassWord(passwordCreate);
					HttpSession session = req.getSession();
					session.setAttribute("loginUser", newUser);
					System.out.println("[UserServlet] 自動登錄成功: " + userIdCreate);

					resp.getWriter().write("{\"success\":true}");
					resp.getWriter().flush();

				}
			} finally {
				service.close();
			}

		} catch (Exception e) {
			System.err.println("[UserServlet] 註冊失敗: " + e.getMessage());
			e.printStackTrace();

			String errorMsg = e.getMessage() != null ? e.getMessage() : "註冊失敗";
			String json = String.format(
					"{\"success\":false, \"error\":\"%s\"}",
					escapeJson(errorMsg));

			resp.getWriter().write(json);
			resp.getWriter().flush();
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
