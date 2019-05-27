package com.miss.demo.Controller;

import com.miss.demo.Service.DatabaseManager;
import com.miss.demo.Service.ResultSetJson;
import com.miss.demo.Service.ReturnMap;
import com.miss.demo.Service.ServiceCode;
import net.sf.json.JSONArray;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.LastModified;

import javax.servlet.http.HttpServletRequest;
import javax.xml.crypto.Data;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

@CrossOrigin
@RestController
public class
Dynamic {
	@ResponseBody
	@RequestMapping("/dynamicList")
	public HashMap<String, Object> getDynamic(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}
		int page = Integer.parseInt(request.getParameter("page"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		if (page == 0) page = 1;
		if (pageSize == 0) pageSize = 50;

		DatabaseManager manager = new DatabaseManager();
		// 从用户表获取最新的名字和头像
		String sql = "SELECT * FROM user WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(userId);
		ResultSet set = manager.executeQuery(sql, data);
		String latestName = null;
		String latestHeader = null;
		while (set.next()) {
			latestName = set.getNString("name");
			latestHeader = set.getNString("header");
		}

		sql = "SELECT * FROM dynamic WHERE userId=? AND active=1 ORDER By id desc limit ?,?";
		data = new Object[3];
		data[0] = Integer.parseInt(userId);
		data[1] = (page-1)*pageSize;
		data[2] = pageSize;
		set = manager.executeQuery(sql, data);

		ArrayList<Object> list = new ArrayList<>();
		while (set.next()) {
			HashMap<String, Object> map = new HashMap<>();
			map.put("header", latestHeader);
			map.put("name", latestName);
			map.put("time", set.getString("time"));
			map.put("text", set.getString("text"));
			map.put("id", set.getString("id"));
			JSONArray jsonArray = JSONArray.fromObject(set.getString("images"));
			ArrayList<String> images = new ArrayList<>();
				for (int i = 0; i < jsonArray.size(); i++){
					String image = jsonArray.getString(i);
					if (image !=null && image.length() > 0 &&!image.equals("null")) {
						images.add(image);
					}

				}
			map.put("images", images);

			HashMap<String, Object> locationMap = new HashMap<>();
			locationMap.put("longitude", set.getString("longitude"));
			locationMap.put("latitude", set.getString("latitude"));
			locationMap.put("locationName", set.getString("locationName"));
			map.put("location", locationMap);
			list.add(map);
		}

		manager.close();
		return ReturnMap.mapWithObject(list);
	}

	@ResponseBody
	@RequestMapping("/dynamicDetail")
	public HashMap<String, Object> dynamicDetail(HttpServletRequest request) {
		String dynamicId = request.getParameter("dynamicId");
		if (dynamicId == null || dynamicId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "动态id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM dynamic WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(dynamicId);
		ResultSet set = manager.executeQuery(sql, data);
		manager.close();
		return ReturnMap.mapWithObject(set);
	}

	@ResponseBody
	@RequestMapping("/deleteDynamic")
	public HashMap<String, Object> delete(HttpServletRequest request) throws Exception {
		String dynamicId = request.getParameter("dynamicId");
		if (dynamicId == null || dynamicId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "动态id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "UPDATE dynamic SET active=0 WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(dynamicId);
		int line = manager.executeUpdate(sql, data);
		manager.close();
		return ReturnMap.mapWithLine(line, "删除成功", "删除失败");
	}

}
