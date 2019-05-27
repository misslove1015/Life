package com.miss.demo.Service;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;

public class ResultSetJson {

	public static HashMap<String, Object> toMap(ResultSet set) throws Exception{
		HashMap<String, Object> map = new HashMap<>();
		ResultSetMetaData data = set.getMetaData();
		int count = data.getColumnCount();
		while (set.next()) {
			for (int i = 1; i <= count; i++) {
				String key = data.getColumnLabel(i);
				String value = set.getString(i);
				map.put(key, value);
			}
		}
		return map;
	}

	public static ArrayList toList (ResultSet rs) throws Exception {
		ArrayList list = new ArrayList();
		ResultSetMetaData md = rs.getMetaData();
		int columnCount = md.getColumnCount(); //Map rowData;
		while (rs.next()) { //rowData = new HashMap(columnCount);
			HashMap rowData = new HashMap();
			for (int i = 1; i <= columnCount; i++) {
				rowData.put(md.getColumnName(i), rs.getObject(i));
			}
			list.add(rowData);
		}
		return list;
	}


}
