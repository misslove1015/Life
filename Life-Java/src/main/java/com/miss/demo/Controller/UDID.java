package com.miss.demo.Controller;


import net.sf.json.JSON;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
public class UDID {
	@ResponseBody
	@RequestMapping("/udid")
	public void getUDID(HttpServletRequest request) {
		System.out.println(request.getParameterMap());
	}
}
