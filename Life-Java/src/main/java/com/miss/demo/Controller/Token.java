package com.miss.demo.Controller;

import com.miss.demo.Service.ServiceCode;
import com.qiniu.util.Auth;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;

@RestController
public class Token {
	@ResponseBody
	@RequestMapping("/getQiNiuToken")
	public HashMap<String, Object> getToken(HttpServletRequest request) throws Exception {

		String accessKey = "KI-LVvFejFAMCvwJ-Q8k-u9BYDuO0Wkz9z-m87HP";
		String secretKey = "jHsTuqTtiiL8pqXIy1tHZbnIjwAxZeeeZLWh9tQ-";
		String bucket = "miss";
		Auth auth = Auth.create(accessKey, secretKey);
		String upToken = auth.uploadToken(bucket);
		System.out.println(upToken);

		HashMap<String, Object> map = new HashMap<>();
		if (upToken != null && upToken.length() > 0) {
			map.put("code", ServiceCode.Success.getCode());
			map.put("message", ServiceCode.Success.getDesc());
			HashMap<String, Object> tokenMap = new HashMap<>();
			tokenMap.put("token", upToken);
			map.put("data", tokenMap);
		}else  {
			map.put("code", ServiceCode.Error_ServiceError.getCode());
			map.put("message", "token生成失败");
		}
		return map;
	}
}
