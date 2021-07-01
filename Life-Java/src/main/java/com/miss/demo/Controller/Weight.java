package com.miss.demo.Controller;

import com.miss.demo.Service.DatabaseManager;
import com.miss.demo.Service.ResultSetJson;
import com.miss.demo.Service.ReturnMap;
import com.miss.demo.Service.ServiceCode;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

@RestController
@CrossOrigin
public class Weight {
	@ResponseBody
	@RequestMapping("/weightList")
	public HashMap<String, Object> getWeightList(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			userId = "29";
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM weight WHERE userId=? AND active=1 ORDER BY STR_TO_DATE(`date`,'%Y-%m-%d') ASC";
		Object[] data = new Object[1];
		data[0] = userId;
		ResultSet set = manager.executeQuery(sql, data);
		ArrayList list = ResultSetJson.toList(set);

		manager.close();
		return ReturnMap.mapWithObject(list);
	}

	@ResponseBody
	@RequestMapping("/addWeight")
	public HashMap<String, Object> editNote(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		String weight = request.getParameter("weight");
		String date = request.getParameter("date");
		if (userId == null || userId.length() == 0) {
			userId = "29";
		}
		if (weight == null || weight.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "体重数据不能为空");
		}
		if (date == null || date.length() == 0) {
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			date = dateFormat.format(new Date());
		}

		DatabaseManager manager = new DatabaseManager();
		String sql;
		Object[] data;

		sql = "INSERT INTO weight (userId, weight, date, active) VALUES (?, ?, ?, ?)";
		data = new Object[4];
		data[0] = Integer.parseInt(userId);
		data[1] = weight;
		data[2] = date;
		data[3] = 1;

		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line,"保存成功", "保存失败");
	}

	@ResponseBody
	@RequestMapping("/deleteWeight")
	public HashMap<String, Object> deleteWeight(HttpServletRequest request) throws Exception {
		String weightId = request.getParameter("weightId");
		if (weightId == null || weightId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "体重记录id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "UPDATE weight SET active=0 WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(weightId);
		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line, "删除成功", "删除失败");
	}
}
