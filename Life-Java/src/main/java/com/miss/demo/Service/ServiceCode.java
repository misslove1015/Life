package com.miss.demo.Service;

public enum ServiceCode {

	Success(200, "请求成功"),

	Error_NotLogin(1001,"未登录"),
	Error_UserNotExist(1002,"用户不存在"),
	Error_UserIsExist(1003,"用户已存在"),
	Error_PassWordError(1004,"密码错误"),
	Error_ParamNull(1005,"参数不能为空"),

	Error_ServiceError(1101,"服务器出错");


	private int code;
	private String desc;

	ServiceCode(int code, String desc) {
		this.code = code;
		this.desc = desc;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getDesc() {
		return desc;
	}

	public void setDesc(String desc) {
		this.desc = desc;
	}
}
