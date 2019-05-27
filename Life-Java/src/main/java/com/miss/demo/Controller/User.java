package com.miss.demo.Controller;

import com.miss.demo.Service.DatabaseManager;
import com.miss.demo.Service.ResultSetJson;
import com.miss.demo.Service.ReturnMap;
import com.miss.demo.Service.ServiceCode;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.util.HashMap;

@RestController
public class User {
	@ResponseBody
	@RequestMapping("/editUserInfo")
	public HashMap<String, Object> editName (HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		String name = request.getParameter("name");
		String header = request.getParameter("header");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}

		DatabaseManager manager = new DatabaseManager();
		int nameLine = -1;
		int headerLine = -1;
		if (name != null && name.length() > 0) {
			String sql = "UPDATE user SET name=? WHERE id=?";
			Object[] data = new Object[2];
			data[0] = name;
			data[1] = Integer.parseInt(userId);
		    nameLine = manager.executeUpdate(sql, data);
		}

		if (header != null && header.length() > 0) {
			String sql = "UPDATE user SET header=? WHERE id=?";
			Object[] data = new Object[2];
			data[0] = header;
			data[1] = Integer.parseInt(userId);
			headerLine = manager.executeUpdate(sql, data);
		}

		HashMap<String, Object> map = new HashMap<>();
		if (nameLine >= 0 || headerLine >= 0) {
			map.put("code", ServiceCode.Success.getCode());
			map.put("message", "修改成功");
		}else  {
			map.put("code", ServiceCode.Error_ServiceError.getCode());
			map.put("message", "修改失败");
		}

		manager.close();
		return map;
	}


	@ResponseBody
	@RequestMapping("/getUserInfo")
	public HashMap<String, Object> getUserInfo(HttpServletRequest request) throws  Exception{
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM user WHERE id = ?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(userId);
		ResultSet set = manager.executeQuery(sql, data);
		HashMap map = ResultSetJson.toMap(set);

		manager.close();
		return ReturnMap.mapWithObject(map);
	}
}

