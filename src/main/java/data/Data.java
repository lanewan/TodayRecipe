package data;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class Data implements AutoCloseable {
	// PostgreSQL 連接信息
	private static final String DB_URL = "jdbc:postgresql://dpg-d66nctp4tr6s73af5bo0-a.oregon-postgres.render.com:5432/recipe_nv2m";
	private static final String DB_USER = "recipe_nv2m_user";
	private static final String DB_PASSWORD = "PQ2drpJ6gcCyz9ZIZvAzPHRKc6Xgf0EI";

	private Connection connection;

	// 構造函數：建立數據庫連接
	public Data() throws Exception {
		try {
			Class.forName("org.postgresql.Driver");
			connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
			System.out.println("[Data] PostgreSQL 數據庫連接成功");
		} catch (Exception e) {
			System.err.println("[Data] 數據庫連接失敗: " + e.getMessage());
			throw e;
		}
	}

	// 關閉資源
	@Override
	public void close() throws Exception {
		if (connection != null && !connection.isClosed()) {
			connection.close();
			System.out.println("[Data] 數據庫連接已關閉");
		}
	}

	// 查詢所有食物數據（根據用戶ID過濾，如果 userid 為 null 則查詢所有用戶的數據）
	public List<Stock> dbSelect(String userid) throws Exception {
		List<Stock> rows = new ArrayList<>();
		String sql;

		if (userid == null) {
			// 未登錄用戶：查詢所有用戶的數據
			sql = "SELECT no, name, material, kind, situation FROM recipe ORDER BY no";
		} else {
			// 已登錄用戶：只查詢該用戶的數據
			sql = "SELECT no, name, material, kind, situation FROM recipe WHERE userid = ? ORDER BY no";
		}

		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			if (userid != null) {
				pstmt.setString(1, userid);
			}
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				Stock obj = new Stock();
				obj.setNumber(String.valueOf(rs.getInt("no")));
				obj.setName(rs.getString("name"));
				obj.setMaterial(rs.getString("material"));
				obj.setKind(rs.getString("kind"));
				obj.setSituation(rs.getString("situation"));
				rows.add(obj);
			}

			rs.close();
			if (userid == null) {
				System.out.println("[Data] 訪客模式：讀取了所有用戶的 " + rows.size() + " 條數據");
			} else {
				System.out.println("[Data] 讀取了用戶 " + userid + " 的 " + rows.size() + " 條數據");
			}
		} catch (Exception e) {
			System.err.println("[Data] 查詢數據失敗: " + e.getMessage());
			throw e;
		}

		return rows;
	}

	public User logInCheck(String userid, String password) throws Exception {

		String sql = "SELECT userid, password FROM users WHERE userid = ? AND password = ?";

		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

			pstmt.setString(1, userid);
			pstmt.setString(2, password);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					User user = new User();
					user.setUserId(rs.getString("userid"));
					user.setPassWord(rs.getString("password"));
					return user;
				}
			}
		}

		return null; // 查不到返回 null
	}

	public boolean signupCheck(String userid, String password) throws Exception {

		String sql = "SELECT userid FROM users WHERE userid = ? ";

		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

			pstmt.setString(1, userid);

			try (ResultSet rs = pstmt.executeQuery()) {

				if (rs.next()) {
					return true;

				} else {
					return false;
				}

			}
		}

	}

	public boolean signUp(String userid, String password) throws Exception {

		String sql = "INSERT INTO users (userid, password) VALUES (?, ?)";

		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {

			pstmt.setString(1, userid);
			pstmt.setString(2, password);
			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				System.out.println("[Data] 用戶註冊成功: " + userid);
				return true;
			} else {
				System.err.println("[Data] 用戶註冊失敗");
				return false;
			}

		} catch (Exception e) {
			System.err.println("[Data] 用戶註冊失敗: " + e.getMessage());
			throw e;
		}

	}

	// 根據場景查詢食物（日常/享受）並按用戶ID過濾（如果 userid 為 null 則查詢所有用戶的數據）
	public List<Stock> dailySelect(int dailyFlag, String userid) throws Exception {
		List<Stock> result = new ArrayList<>();
		String situation = (dailyFlag == 1) ? "日常" : "享受";
		String sql;

		if (userid == null) {
			// 未登錄用戶：查詢所有用戶的數據
			sql = "SELECT no, name, material, kind, situation FROM recipe WHERE situation = ? ORDER BY no";
		} else {
			// 已登錄用戶：只查詢該用戶的數據
			sql = "SELECT no, name, material, kind, situation FROM recipe WHERE situation = ? AND userid = ? ORDER BY no";
		}

		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setString(1, situation);
			if (userid != null) {
				pstmt.setString(2, userid);
			}
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				Stock obj = new Stock();
				obj.setNumber(String.valueOf(rs.getInt("no")));
				obj.setName(rs.getString("name"));
				obj.setMaterial(rs.getString("material"));
				obj.setKind(rs.getString("kind"));
				obj.setSituation(rs.getString("situation"));
				result.add(obj);
			}

			rs.close();
			if (userid == null) {
				System.out.println("[Data] 訪客模式：查詢到所有用戶的 " + result.size() + " 條 " + situation + " 數據");
			} else {
				System.out.println("[Data] 查詢到用戶 " + userid + " 的 " + result.size() + " 條 " + situation + " 數據");
			}
		} catch (Exception e) {
			System.err.println("[Data] 查詢場景數據失敗: " + e.getMessage());
			throw e;
		}

		return result;
	}

	// 根據食材查詢食物並按用戶ID過濾（如果 userid 為 null 則查詢所有用戶的數據）
	public List<Stock> materialSelect(String dailyFlag, String material, String userid) throws Exception {
		List<Stock> result = new ArrayList<>();
		StringBuilder sql = new StringBuilder(
				"SELECT no, name, material, kind, situation FROM recipe WHERE material LIKE ?");

		// 如果 userid 不為 null，添加用戶過濾
		if (userid != null) {
			sql.append(" AND userid = ?");
		}

		// 根據 dailyFlag 添加場景過濾
		if ("1".equals(dailyFlag)) {
			sql.append(" AND situation = '日常'");
		} else if ("2".equals(dailyFlag)) {
			sql.append(" AND situation = '享受'");
		}
		sql.append(" ORDER BY no");

		try (PreparedStatement pstmt = connection.prepareStatement(sql.toString())) {
			pstmt.setString(1, "%" + material + "%");
			if (userid != null) {
				pstmt.setString(2, userid);
			}
			ResultSet rs = pstmt.executeQuery();

			while (rs.next()) {
				Stock obj = new Stock();
				obj.setNumber(String.valueOf(rs.getInt("no")));
				obj.setName(rs.getString("name"));
				obj.setMaterial(rs.getString("material"));
				obj.setKind(rs.getString("kind"));
				obj.setSituation(rs.getString("situation"));
				result.add(obj);
			}

			rs.close();
			if (userid == null) {
				System.out.println("[Data] 訪客模式：根據食材 '" + material + "' 查詢到所有用戶的 " + result.size() + " 條數據");
			} else {
				System.out.println("[Data] 根據食材 '" + material + "' 查詢到用戶 " + userid + " 的 " + result.size() + " 條數據");
			}
		} catch (Exception e) {
			System.err.println("[Data] 查詢食材數據失敗: " + e.getMessage());
			throw e;
		}

		return result;
	}

	// 添加新食物（包含用戶ID）
	public Boolean addFood(String name, String material, String kind, String situation, String userid)
			throws Exception {
		String sql = "INSERT INTO recipe (name, material, kind, situation, userid) VALUES (?, ?, ?, ?, ?)";

		try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
			pstmt.setString(1, name);
			pstmt.setString(2, material);
			pstmt.setString(3, kind);
			pstmt.setString(4, situation);
			pstmt.setString(5, userid);

			int rowsAffected = pstmt.executeUpdate();

			if (rowsAffected > 0) {
				System.out.println("[Data] 用戶 " + userid + " 添加食物成功: " + name);
				return true;
			} else {
				System.err.println("[Data] 添加食物失敗");
				return false;
			}
		} catch (Exception e) {
			System.err.println("[Data] 添加食物失敗: " + e.getMessage());
			throw e;
		}
	}
}