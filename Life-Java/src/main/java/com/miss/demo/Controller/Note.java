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
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

@CrossOrigin
@RestController
public class Note {

	@ResponseBody
	@RequestMapping("/noteList")
	public HashMap<String, Object> getNoteList(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}
		int page = Integer.parseInt(request.getParameter("page"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		if (page == 0) page = 1;
		if (pageSize == 0) pageSize = 50;

		DatabaseManager manager = new DatabaseManager();
		String sql = "SELECT * FROM note WHERE userId=? AND active=1 ORDER BY id DESC LIMIT ?,?";
		Object[] data = new Object[3];
		data[0] = userId;
		data[1] = (page-1)*pageSize;
		data[2] = pageSize;
		ResultSet set = manager.executeQuery(sql, data);
		ArrayList list = ResultSetJson.toList(set);

		manager.close();
		return ReturnMap.mapWithObject(list);
	}

	@ResponseBody
	@RequestMapping("/editNote")
	public HashMap<String, Object> editNote(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		String noteId = request.getParameter("noteId");
		String title = request.getParameter("title");
		String content = request.getParameter("content");

		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}

		if ((title == null || title.length() == 0) && (content == null || content.length() == 0)) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "标题和内容不能都为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql;
		Object[] data;
		if (noteId != null && noteId.length() > 0) {
			sql = "UPDATE note SET title=?, content=? WHERE id=?";
			data = new Object[3];
			data[0] = title;
			data[1] = content;
			data[2] = Integer.parseInt(noteId);
		}else  {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			String time = format.format(new Date());

			sql = "INSERT INTO note (userId, title, content, active, time) VALUES (?, ?, ?, ?, ?)";
			data = new Object[5];
			data[0] = Integer.parseInt(userId);
			data[1] = title;
			data[2] = content;
			data[3] = 1;
			data[4] = time;
		}

		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line,"保存成功", "保存失败");
	}

	@ResponseBody
	@RequestMapping("/deleteNote")
	public HashMap<String, Object> deleteNote(HttpServletRequest request) throws Exception {
		String noteId = request.getParameter("noteId");
		if (noteId == null || noteId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "笔记id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "UPDATE note SET active=0 WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(noteId);
		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line, "删除成功", "删除失败");
	}

}


