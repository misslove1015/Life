package com.miss.demo.Controller;

import com.miss.demo.Service.DatabaseManager;
import com.miss.demo.Service.ResultSetJson;
import com.miss.demo.Service.ReturnMap;
import com.miss.demo.Service.ServiceCode;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.sql.*;
import java.util.HashMap;

@RestController

public class Login {
	@ResponseBody
	@RequestMapping("/login")
	public HashMap<String, Object>login (HttpServletRequest request) throws Exception {
		String userName = request.getParameter("userName");
		String password = request.getParameter("password");
		if (userName == null || userName.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "用户名不能为空");
		}
		if (password == null || password.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "密码不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM user WHERE userName=?";
		Object[] data = new Object[1];
		data[0] = userName;
		ResultSet set = manager.executeQuery(sql, data);

		String DUserName = null;
		String DPassword = null;
		while (set.next()) {
			DUserName = set.getNString("userName");
			DPassword = set.getNString("password");
		}
		HashMap<String, Object> map = new HashMap<>();
		if (DUserName == null){
			map.put("message", "用户不存在");
			map.put("code", ServiceCode.Error_UserNotExist.getCode());
		}else if (DUserName.equals(userName) && DPassword.equals(password)) {
			set = manager.executeQuery(sql, data);
			HashMap<String, Object> userMap = ResultSetJson.toMap(set);
			userMap.remove("password");
			map.put("message", ServiceCode.Success.getDesc());
			map.put("code", ServiceCode.Success.getCode());
			map.put("data", userMap);
		}else if (DUserName.equals(userName) && !DPassword.equals(password)) {
			map.put("message", ServiceCode.Error_PassWordError.getDesc());
			map.put("code", ServiceCode.Error_PassWordError.getCode());
		}else {
			map.put("message", "登录失败");
			map.put("code", ServiceCode.Error_ServiceError.getCode());
		}
		manager.close();
		return map;
	}

	@ResponseBody
	@RequestMapping("/changePassword")
	public HashMap<String, Object> changePassword(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		String password = request.getParameter("password");
		String newPassword = request.getParameter("newPassword");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), "未登录");
		}
		if (password == null || password.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "密码不能为空");
		}
		if (newPassword == null || newPassword.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "新密码不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM user where id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(userId);
		ResultSet set = manager.executeQuery(sql, data);
		String DPassword = null;
		while (set.next()) {
			DPassword = set.getString("password");
		}

		HashMap<String, Object> map = new HashMap<>();
		if (DPassword == null) {
			map.put("code", ServiceCode.Error_UserNotExist.getCode());
			map.put("message", "用户不存在");
		}else if (!DPassword.equals(password)) {
			map.put("code", ServiceCode.Error_PassWordError.getCode());
			map.put("message", "密码错误");
		}else if (DPassword.equals(password)) {
            sql = "UPDATE user SET password=? WHERE id=?";
            data = new Object[2];
            data[0] = newPassword;
            data[1] = Integer.parseInt(userId);
            int line = manager.executeUpdate(sql, data);
            map = ReturnMap.mapWithLine(line, "修改成功", "修改失败");
		}else  {
			map.put("code", ServiceCode.Error_ServiceError.getCode());
			map.put("message", "修改失败");
		}
		manager.close();
		return map;
	}
}
