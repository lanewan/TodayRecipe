package data;

import java.util.List;
import java.util.Random;

public class Pick {

	public Result print(Stock stock) {

		String foodName = stock.getName();
		String foodMaterial = stock.getMaterial();
		Result food = new Result(foodName, foodMaterial);

		return food;
	}

	public Stock randomPick(String userid) throws Exception {

		Data dt = null;
		try {
			System.out.println("[Pick] 创建 Data 对象...");
			dt = new Data();

			System.out.println("[Pick] 调用 dbSelect()...");
			List<Stock> all = dt.dbSelect(userid);

			System.out.println("[Pick] 获取到用户 " + userid + " 的 " + (all != null ? all.size() : "null") + " 条数据");

			if (all == null || all.isEmpty()) {
				throw new Exception("没有找到该用户的食品数据");
			}

			Random random = new Random();
			int index = random.nextInt(all.size());
			Stock result = all.get(index);

			System.out.println("[Pick] 选中索引 " + index + ": " + result.getName());
			return result;

		} catch (Exception e) {
			System.err.println("[Pick] 异常: " + e.getClass().getName());
			System.err.println("[Pick] 消息: " + e.getMessage());
			e.printStackTrace(System.err);
			throw e; // 重新抛出

		} finally {
			if (dt != null) {
				System.out.println("[Pick] 关闭 Data 对象...");
				try {
					dt.close();
				} catch (Exception e) {
					System.err.println("[Pick] 关闭失败: " + e.getMessage());
				}
			}
		}
	}

	public Stock meatPick(String userid) throws Exception {

		Data dt = null;
		try {
			System.out.println("[Pick] 开始选择荤菜...");
			dt = new Data();

			List<Stock> all = dt.dailySelect(1, userid);
			List<Stock> meat = new java.util.ArrayList<>();

			System.out.println("[Pick] 从用户 " + userid + " 的 " + (all != null ? all.size() : "null") + " 条数据中筛选荤菜");

			for (Stock i : all) {
				if (i.getKind().equals("荤")) {
					meat.add(i);
					System.out.println("[Pick] 找到荤菜: " + i.getName());
				}
			}

			if (meat == null || meat.isEmpty()) {
				throw new Exception("没有找到荤菜数据");
			}

			Random random = new Random();
			int index = random.nextInt(meat.size());
			Stock result = meat.get(index);

			System.out.println("[Pick] 选中荤菜索引 " + index + ": " + result.getName());
			return result;

		} catch (Exception e) {
			System.err.println("[Pick] meatPick 异常: " + e.getMessage());
			e.printStackTrace(System.err);
			throw e; // 重新抛出

		} finally {
			if (dt != null) {
				System.out.println("[Pick] 关闭 Data 对象...");
				try {
					dt.close();
				} catch (Exception e) {
					System.err.println("[Pick] 关闭失败: " + e.getMessage());
				}
			}
		}
	}

	public Stock vegPick(String userid) throws Exception {

		Data dt = null;
		try {
			System.out.println("[Pick] 开始选择素菜...");
			dt = new Data();

			List<Stock> all = dt.dailySelect(1, userid);
			List<Stock> veg = new java.util.ArrayList<>();

			System.out.println("[Pick] 从用户 " + userid + " 的 " + (all != null ? all.size() : "null") + " 条数据中筛选素菜");

			for (Stock i : all) {
				if (i.getKind().equals("素")) {
					veg.add(i);
					System.out.println("[Pick] 找到素菜: " + i.getName());
				}
			}

			if (veg == null || veg.isEmpty()) {
				throw new Exception("没有找到素菜数据");
			}

			Random random = new Random();
			int index = random.nextInt(veg.size());
			Stock result = veg.get(index);

			System.out.println("[Pick] 选中素菜索引 " + index + ": " + result.getName());
			return result;

		} catch (Exception e) {
			System.err.println("[Pick] vegPick 异常: " + e.getMessage());
			e.printStackTrace(System.err);
			throw e; // 重新抛出

		} finally {
			if (dt != null) {
				System.out.println("[Pick] 关闭 Data 对象...");
				try {
					dt.close();
				} catch (Exception e) {
					System.err.println("[Pick] 关闭失败: " + e.getMessage());
				}
			}
		}
	}

	public Stock cruisePick(String userid) throws Exception {

		Data dt = null;
		try {
			System.out.println("[Pick] 开始选择外食...");
			dt = new Data();

			List<Stock> all = dt.dbSelect(userid);
			List<Stock> cruise = new java.util.ArrayList<>();

			System.out.println("[Pick] 从用户 " + userid + " 的 " + (all != null ? all.size() : "null") + " 条数据中筛选外食");

			for (Stock i : all) {
				if (i.getSituation().equals("享受")) {
					cruise.add(i);
					System.out.println("[Pick] 找到外食: " + i.getName());
				}
			}

			if (cruise == null || cruise.isEmpty()) {
				throw new Exception("没有找到外食数据");
			}

			Random random = new Random();
			int index = random.nextInt(cruise.size());
			Stock result = cruise.get(index);

			System.out.println("[Pick] 选中外食索引 " + index + ": " + result.getName());
			return result;

		} catch (Exception e) {
			System.err.println("[Pick] cruisePick 异常: " + e.getMessage());
			e.printStackTrace(System.err);
			throw e; // 重新抛出

		} finally {
			if (dt != null) {
				System.out.println("[Pick] 关闭 Data 对象...");
				try {
					dt.close();
				} catch (Exception e) {
					System.err.println("[Pick] 关闭失败: " + e.getMessage());
				}
			}
		}
	}

	public Stock materialPick(String dailyFlag, String material, String userid) throws Exception {

		Data dt = null;
		try {
			System.out.println("[Pick] 开始根據食材選擇...");
			dt = new Data();

			List<Stock> all = dt.materialSelect(dailyFlag, material, userid);

			System.out.println("[Pick] 从用户 " + userid + " 的 " + (all != null ? all.size() : "null") + " 条数据");

			Random random = new Random();
			int index = random.nextInt(all.size());
			Stock result = all.get(index);

			System.out.println("[Pick] 选中索引 " + index + ": " + result.getName());
			return result;

		} catch (Exception e) {
			System.err.println("[Pick] materialPick 异常: " + e.getMessage());
			e.printStackTrace(System.err);
			throw e; // 重新抛出

		} finally {
			if (dt != null) {
				System.out.println("[Pick] 关闭 Data 对象...");
				try {
					dt.close();
				} catch (Exception e) {
					System.err.println("[Pick] 关闭失败: " + e.getMessage());
				}
			}
		}
	}

}
