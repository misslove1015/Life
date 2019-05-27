package com.miss.demo.Controller;

import com.miss.demo.Service.DatabaseManager;
import com.miss.demo.Service.ReturnMap;
import com.miss.demo.Service.ServiceCode;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;


@RestController
public class Post {

	@ResponseBody
	@RequestMapping("/post")
	public HashMap<String, Object> post (HttpServletRequest request) throws Exception {
		String text = request.getParameter("text");
		String images = request.getParameter("images");
		String longitude = request.getParameter("longitude");
		String latitude = request.getParameter("latitude");
		String locationName = request.getParameter("locationName");
		String userId = request.getHeader("userId");

		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}

		DatabaseManager manager = new DatabaseManager();

		String sql = "SELECT * FROM user WHERE id=?";
		Object[] data = new  Object[1];
		data[0] = Integer.parseInt(userId);
		ResultSet userSet = manager.executeQuery(sql, data);
		String name = null;
		String header = null;
		while (userSet.next()) {
			name = userSet.getNString("name");
			header = userSet.getNString("header");
		}

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String time = format.format(new Date());

		sql = "INSERT INTO dynamic (header, name, time, text, images, userId," +
				"longitude, latitude, locationName, active) VALUES (?,?,?,?," +
				"?,?,?,?,?,?)" ;
		data = new Object[10];
		data[0] = header;
		data[1] = name;
		data[2] = time;
		data[3] = text;
		data[4] = images;
		data[5] = Integer.parseInt(userId);
		data[6] = longitude;
		data[7] = latitude;
		data[8] = locationName;
		data[9] = 1;

		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line, "发布成功", "发布失败");
	}

}
