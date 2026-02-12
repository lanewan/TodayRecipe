package controller;

import data.Data;

public class Test {

	public static void main(String[] args) {
		// TODO 自動生成されたメソッド・スタブ

		try {
			Data data = new Data();
			data.dbSelect();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
