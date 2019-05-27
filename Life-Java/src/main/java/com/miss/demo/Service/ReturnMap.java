package com.miss.demo.Service;

import java.util.HashMap;

public class ReturnMap {

	public static HashMap<String, Object> mapWithLine(int line, String successStr, String failStr) {
		HashMap<String, Object> map = new HashMap<>();

		if (line >= 0) {
			map.put("code", 200);
			if (successStr != null && successStr.length() > 0){
				map.put("message", successStr);
			}else  {
				map.put("message", "success");
			}

		}else  {
			map.put("code", 406);
			if (failStr != null && failStr.length() > 0){
				map.put("message", failStr);
			}else  {
				map.put("message", "fail");
			}
		}
		return map;
	}

	public static HashMap<String, Object> mapWithObject(Object obj) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("code", ServiceCode.Success.getCode());
		map.put("message", ServiceCode.Success.getDesc());
		map.put("data", obj);
		return map;
	}

	public static HashMap<String, Object> errorMap(int code, String message) {
		HashMap<String, Object> map = new HashMap<>();
		map.put("code", code);
		map.put("message", message);
		return map;
	}
}
