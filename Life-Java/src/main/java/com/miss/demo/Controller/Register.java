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
import java.util.Random;

@RestController
public class Register {
	@ResponseBody
	@RequestMapping("/register")
	public HashMap<String, Object> register(HttpServletRequest request) throws Exception{
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

		System.out.println(set);
		boolean isExist = false;
		while (set.next()) {
			isExist = true;
		}

		HashMap<String, Object> map = new HashMap<>();
		if (isExist) {
			map.put("message", ServiceCode.Error_UserIsExist.getDesc());
			map.put("code", ServiceCode.Error_UserIsExist.getCode());
		}else  {
			sql = "INSERT INTO user (userName, password, header, name) values(?, ?, ?, ?)";
			data = new Object[4];
			data[0] = userName;
			data[1] = password;
			data[2] = "https://oss.zhihanyun.com/FuNO2jS0zyBNSCYlNc2P8cV9QJJp";
			data[3] = getStringRandom(4);
			int line = manager.executeUpdate(sql, data);
			if (line >= 0) {
				sql = "SELECT * FROM user WHERE userName=?";
				data = new Object[1];
				data[0] = userName;
				set = manager.executeQuery(sql, data);
				HashMap<String, Object> userMap = ResultSetJson.toMap(set);
				userMap.remove("password");

				map.put("message", ServiceCode.Success.getDesc());
				map.put("code", ServiceCode.Success.getCode());
				map.put("data", userMap);
			}else  {
				map.put("message", "注册失败");
				map.put("code", ServiceCode.Error_ServiceError.getCode());
			}
		}
		manager.close();
		return map;
	}


	public String getStringRandom(int length) {

		String val = "";
		Random random = new Random();
		for(int i = 0; i < length; i++) {
			String charOrNum = random.nextInt(2) % 2 == 0 ? "char" : "num";
			if( "char".equalsIgnoreCase(charOrNum) ) {
				int temp = random.nextInt(2) % 2 == 0 ? 65 : 97;
				val += (char)(random.nextInt(26) + temp);
			} else if( "num".equalsIgnoreCase(charOrNum) ) {
				val += String.valueOf(random.nextInt(10));
			}
		}
		return "旅行者" + val;
	}

}
