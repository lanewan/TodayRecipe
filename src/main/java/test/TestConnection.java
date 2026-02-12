package test;

import data.Data;
import data.Stock;
import java.util.List;

public class TestConnection {
	public static void main(String[] args) {
		System.out.println("========== 開始測試數據庫連接 ==========");

		Data dt = null;
		try {
			// 測試連接
			dt = new Data();
			System.out.println("✓ 數據庫連接成功");

			// 測試查詢所有數據
			System.out.println("\n測試 dbSelect()...");
			List<Stock> all = dt.dbSelect();
			System.out.println("✓ 查詢成功，共 " + all.size() + " 條數據");

			if (all.size() > 0) {
				System.out.println("\n前 3 條數據：");
				for (int i = 0; i < Math.min(3, all.size()); i++) {
					Stock s = all.get(i);
					System.out.println((i+1) + ". " + s.getName() +
						" | 食材: " + s.getMaterial() +
						" | 類型: " + s.getKind() +
						" | 場景: " + s.getSituation());
				}
			}

			// 測試查詢日常食物
			System.out.println("\n測試 dailySelect(1)...");
			List<Stock> daily = dt.dailySelect(1);
			System.out.println("✓ 查詢成功，共 " + daily.size() + " 條日常數據");

			System.out.println("\n========== 測試完成 ==========");

		} catch (Exception e) {
			System.err.println("✗ 測試失敗");
			System.err.println("錯誤類型: " + e.getClass().getName());
			System.err.println("錯誤信息: " + e.getMessage());
			e.printStackTrace();
		} finally {
			if (dt != null) {
				try {
					dt.close();
				} catch (Exception e) {
					System.err.println("關閉連接失敗: " + e.getMessage());
				}
			}
		}
	}
}
