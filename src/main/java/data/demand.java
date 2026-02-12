package data;

public class demand {
	private int randomFlag;
	private int dailyFlag;
	private int preferFlag;

	public demand(int randomFlag) {
		randomFlag = 1;
		dailyFlag = 0;
		preferFlag = 0;
	}

	public int getRandomFlag() {
		return randomFlag;
	}

	public int getPreferFlag() {
		return preferFlag;
	}

	public void setPreferFlag(int preferFlag) {
		this.preferFlag = preferFlag;
	}

	public void setRandomFlag(int randomFlag) {
		this.randomFlag = randomFlag;
	}

	public int getDailyFlag() {
		return dailyFlag;
	}

	public void setDailyFlag(int dailyFlag) {
		this.dailyFlag = dailyFlag;
	}

}
