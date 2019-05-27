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

import javax.servlet.http.HttpServletRequest;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

@CrossOrigin
@RestController
public class Photo {
	@ResponseBody
	@RequestMapping("/addAlbum")
	public HashMap<String, Object> addAlbum(HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		String name = request.getParameter("name");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}
		if (name == null || name.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(),"相册名不能为空");
		}

		DatabaseManager manager = new DatabaseManager();

		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		String time = format.format(new Date());

		String sql = "INSERT INTO album (userId, name, active, time) VALUES (?, ?, ?, ?)";

		Object[] data = new Object[4];
		data[0] = Integer.parseInt(userId);
		data[1] = name;
		data[2] = 1;
		data[3] = time;

		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line, "添加成功", "添加失败");

	}

	@ResponseBody
	@RequestMapping("/albumList")
	public HashMap<String, Object> albumList (HttpServletRequest request) throws Exception {
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}

		DatabaseManager manager = new DatabaseManager();
		int page = Integer.parseInt(request.getParameter("page"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		if (page == 0) page = 1;
		if (pageSize == 0) pageSize = 50;

		String sql = "SELECT * FROM album WHERE userId=? AND active=1 ORDER BY id DESC LIMIT ?,?";
		Object[] data = new Object[3];
		data[0] = Integer.parseInt(userId);
		data[1] = (page-1)*pageSize;
		data[2] = pageSize;
		ResultSet set = manager.executeQuery(sql, data);
		ArrayList list = ResultSetJson.toList(set);

		manager.close();
		return ReturnMap.mapWithObject(list);
	}

	@ResponseBody
	@RequestMapping("/addPhoto")
	public HashMap<String, Object> addPhoto(HttpServletRequest request) throws Exception {
		String albumId = request.getParameter("albumId");
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}
		if (albumId == null || albumId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "相册id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String coverSql = "SELECT * FROM album WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(albumId);
		ResultSet coverSet = manager.executeQuery(coverSql, data);
		String cover = null;
		while (coverSet.next()) {
			cover = coverSet.getString("cover");
		}

		String sql = "INSERT INTO photo (url, albumId, userId, active) VALUES";

		JSONArray jsonArray = JSONArray.fromObject(request.getParameter("images"));

		if (cover == null || cover.length() == 0) {
			if (jsonArray.size() > 0) {
				cover = jsonArray.getString(0);
				coverSql = "UPDATE album SET cover=? WHERE id=?";
				data = new Object[2];
				data[0] = cover;
				data[1] = Integer.parseInt(albumId);
				manager.executeUpdate(coverSql, data);
			}

		}

		for (int i = 0; i < jsonArray.size(); i++) {
			String url = jsonArray.getString(i);
			String endStr = ",";
			if (i == jsonArray.size()-1) {
				endStr = "";
			}

			String sqlStr = " (" + "'"+ url + "'" + ", " + albumId + ", " + Integer.parseInt(userId) + ", " + 1 + ")" + endStr;
			sql = sql + sqlStr;
		}

		int line = manager.executeUpdate(sql, null);

		manager.close();
		return ReturnMap.mapWithLine(line,"添加成功", "添加失败");
	}

	@ResponseBody
	@RequestMapping("/photoList")
	public HashMap<String, Object> photoList (HttpServletRequest request) throws Exception {
		String albumId = request.getParameter("albumId");
		String userId = request.getHeader("userId");
		if (userId == null || userId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_NotLogin.getCode(), ServiceCode.Error_NotLogin.getDesc());
		}
		if (albumId == null || albumId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "相册id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		int page = Integer.parseInt(request.getParameter("page"));
		int pageSize = Integer.parseInt(request.getParameter("pageSize"));
		if (page == 0) page = 1;
		if (pageSize == 0) pageSize = 50;

		String sql = "SELECT * FROM photo WHERE albumId=? AND userId=? AND active=1 ORDER BY id DESC LIMIT ?,?";
		Object[] data = new Object[4];
		data[0] = Integer.parseInt(albumId);
		data[1] = Integer.parseInt(userId);
		data[2] = (page-1)*pageSize;
		data[3] = pageSize;

		ResultSet set = manager.executeQuery(sql, data);
		ArrayList list = ResultSetJson.toList(set);

		manager.close();
		return ReturnMap.mapWithObject(list);
	}

	@ResponseBody
	@RequestMapping("/editAlbum")
	public HashMap<String, Object> editAlbumName(HttpServletRequest request) throws Exception {
		String albumId = request.getParameter("albumId");
		if (albumId == null || albumId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "相册id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String name = request.getParameter("name");

		String sql = "UPDATE album SET name=? WHERE id=?";
		Object[] data = new Object[2];
		data[0] = name;
		data[1] = Integer.parseInt(albumId);
		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line, "修改成功", "修改失败");
	}

	@ResponseBody
	@RequestMapping("/deleteAlbum")
	public HashMap<String, Object> deleteAlbum(HttpServletRequest request) throws Exception {
		String albumId = request.getParameter("albumId");
		if (albumId == null || albumId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "相册id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String sql = "UPDATE album SET active=0 WHERE id=?";
		Object[] data = new Object[1];
		data[0] = Integer.parseInt(albumId);
		int line = manager.executeUpdate(sql, data);

		manager.close();
		return ReturnMap.mapWithLine(line, "删除成功", "删除失败");
	}

	@ResponseBody
	@RequestMapping("/setCover")
	public HashMap<String, Object> setCover(HttpServletRequest request) throws Exception {
		String albumId = request.getParameter("albumId");
		if (albumId == null || albumId.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "相册id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		String cover = request.getParameter("cover");

		String sql = "UPDATE album SET cover=? WHERE id=?";
		Object[] data = new Object[2];
		data[0] = cover;
		data[1] = Integer.parseInt(albumId);
		int line = manager.executeUpdate(sql, data);
		manager.close();
		return ReturnMap.mapWithLine(line, "更改成功", "更改失败");
	}

	@ResponseBody
	@RequestMapping("/deletePhoto")
	public HashMap<String, Object> deletePhoto(HttpServletRequest request) throws Exception {
		String imagesJsonStr = request.getParameter("images");
		if (imagesJsonStr == null || imagesJsonStr.length() == 0) {
			return ReturnMap.errorMap(ServiceCode.Error_ParamNull.getCode(), "照片id不能为空");
		}

		DatabaseManager manager = new DatabaseManager();
		JSONArray jsonArray = JSONArray.fromObject(imagesJsonStr);
		String arrayStr = jsonArray.toString();
		arrayStr = arrayStr.replace("[", "(");
		arrayStr = arrayStr.replace("]", ")");

		String sql = "UPDATE photo SET active=0 WHERE id in " + arrayStr;
		int line = manager.executeUpdate(sql, null);
		manager.close();
		return ReturnMap.mapWithLine(line, "删除成功", "删除失败");
	}

}
