package com.easternfirefighter.common;

import lombok.Data;

/**
 * 通用 API 响应包装器。
 * <p>
 * 规范：
 * - 成功：code=0，message="OK"，data 为具体返回值
 * - 失败：code!=0，message 为错误描述，data 为空
 * </p>
 * @param <T> 业务数据类型
 */
@Data
public class ApiResponse<T> {
	/** 业务码：0 表示成功，非 0 表示失败 */
	private Integer code;
	/** 提示信息：成功固定为 "OK"，失败为错误描述 */
	private String message;
	/** 业务数据载体 */
	private T data;

	/**
	 * 构造一个成功响应。
	 * @param data 业务数据
	 * @return 包装后的成功响应
	 */
	public static <T> ApiResponse<T> success(T data) {
		ApiResponse<T> r = new ApiResponse<>();
		r.setCode(0);
		r.setMessage("OK");
		r.setData(data);
		return r;
	}

	/**
	 * 构造一个失败响应。
	 * @param code 非 0 的业务错误码（同时亦可映射为 HTTP 状态码）
	 * @param message 错误描述信息
	 * @return 包装后的失败响应
	 */
	public static <T> ApiResponse<T> fail(int code, String message) {
		ApiResponse<T> r = new ApiResponse<>();
		r.setCode(code);
		r.setMessage(message);
		return r;
	}
} 