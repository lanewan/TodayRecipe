package data;

public class Result {
	private String foodName;
	private String foodMaterial;

	public Result(String name, String material) {
		foodName = name;
		foodMaterial = material;
	}

	public String getFoodName() {
		return foodName;
	}

	public void setFoodName(String foodName) {
		this.foodName = foodName;
	}

	public String getFoodMaterial() {
		return foodMaterial;
	}

	public void setFoodMaterial(String foodMaterial) {
		this.foodMaterial = foodMaterial;
	}

}
