package com.miss.demo.Service;

import java.sql.*;

public class DatabaseManager {

	private final static String DB_URL = "jdbc:mysql://localhost:3306/test?useSSL=false";
	private static final String DB_USER = "root";
	private static final String DB_PWD = "12345678";
	private Connection conn = null;
	private PreparedStatement pst = null;

	public DatabaseManager() {
		try {
			conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PWD);
		}catch (SQLException e) {
			System.out.println("数据库连接失败");
			e.printStackTrace();
		}
	}

	public ResultSet executeQuery(String sql, Object[] params) {
		try {
			pst = conn.prepareStatement(sql);
			if (params != null) {
				for (int i = 0; i < params.length; i++) {
					pst.setObject(i + 1, params[i]);
				}
			}
			ResultSet set = pst.executeQuery();
			return set;
		}catch (SQLException e) {
			System.out.println("查询失败");
			e.printStackTrace();
		}
		return null;
	}

	public int executeUpdate(String sql, Object[] params) {
		try {
			pst = conn.prepareStatement(sql);
			if (params != null) {
				for (int i = 0; i < params.length; i++) {
					pst.setObject(i + 1, params[i]);
				}
			}
			int affectedLine = pst.executeUpdate();
			return affectedLine;
		} catch (SQLException e) {
			System.out.println("修改失败");
			e.printStackTrace();
		}
		return -1;
	}

	public void close() {
		try {
			if (pst != null)
				pst.close();
			if (conn != null)
				conn.close();
		} catch (SQLException e) {
			System.out.println("关闭失败");
			e.printStackTrace();
		}
	}

}
