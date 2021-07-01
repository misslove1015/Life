package com.miss.demo.Controller;

import com.miss.demo.Service.DatabaseManager;
import com.miss.demo.Service.ResultSetJson;
import com.miss.demo.Service.ReturnMap;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

@RestController
@CrossOrigin
public class Constellation {
	@ResponseBody
	@RequestMapping("/constellationList")
	public HashMap<String, Object> getWeightList(HttpServletRequest request) throws Exception {
		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM constellation ORDER BY id ASC";
		ResultSet set = manager.executeQuery(sql, null);
		ArrayList list = ResultSetJson.toList(set);
		manager.close();
		return ReturnMap.mapWithObject(list);
	}
}
