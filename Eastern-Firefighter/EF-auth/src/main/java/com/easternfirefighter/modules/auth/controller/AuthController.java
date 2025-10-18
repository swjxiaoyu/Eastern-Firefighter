package com.easternfirefighter.modules.auth.controller; // 包：认证-控制器

import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.modules.auth.dto.SmsLoginRequest; // 短信登录请求
import com.easternfirefighter.modules.auth.dto.SmsSendRequest; // 发送短信请求
import com.easternfirefighter.modules.auth.dto.PasswordLoginRequest; // 密码登录请求
import com.easternfirefighter.modules.auth.dto.RegisterRequest; // 注册请求
import com.easternfirefighter.modules.auth.service.AuthService; // 认证服务
import com.easternfirefighter.modules.auth.service.SmsService; // 短信服务
import com.easternfirefighter.modules.auth.vo.LoginResponse; // 登录响应
import jakarta.servlet.http.HttpServletRequest; // 原始请求（取IP）
import jakarta.validation.Valid; // 参数校验
import org.springframework.web.bind.annotation.PostMapping; // POST 映射
import org.springframework.web.bind.annotation.RequestBody; // 请求体
import org.springframework.web.bind.annotation.RequestMapping; // 路由前缀
import org.springframework.web.bind.annotation.RestController; // 控制器

@RestController // REST 控制器
@RequestMapping("/api/auth") // 前缀
public class AuthController { // 认证控制器
	private final SmsService smsService; // 短信服务
	private final AuthService authService; // 认证服务

	public AuthController(SmsService smsService, AuthService authService) { // 构造注入
		this.smsService = smsService; // 赋值
		this.authService = authService; // 赋值
	}

	@PostMapping("/sms/send") // 发送短信验证码
	public ApiResponse<String> send(@Valid @RequestBody SmsSendRequest req, HttpServletRequest http) { // 入参校验
		String ip = http.getRemoteAddr(); // 获取客户端IP
		String codeMaybe = smsService.sendCode(req.getPhone(), req.getScene(), ip); // 发送验证码
		return ApiResponse.success(codeMaybe); // 返回（开发环境可能回显）
	}

	@PostMapping("/sms/login") // 短信登录
	public ApiResponse<LoginResponse> login(@Valid @RequestBody SmsLoginRequest req, HttpServletRequest http) { // 入参
		String ip = http.getRemoteAddr(); // IP
		LoginResponse resp = authService.loginBySms(req.getPhone(), req.getCode(), req.getDeviceInfo(), ip); // 登录
		return ApiResponse.success(resp); // 返回
	}

	@PostMapping("/password/login") // 账号/密码登录
	public ApiResponse<LoginResponse> passwordLogin(@Valid @RequestBody PasswordLoginRequest req, HttpServletRequest http) { // 入参
		String ip = http.getRemoteAddr(); // IP
		String principal = (req.getUsername() != null && !req.getUsername().isBlank()) ? req.getUsername() : req.getPhone(); // 账号或手机号
		LoginResponse resp = authService.loginByPassword(principal, req.getPassword(), req.getDeviceInfo(), ip); // 登录
		return ApiResponse.success(resp); // 返回
	}

	@PostMapping("/register") // 注册
	public ApiResponse<LoginResponse> register(@Valid @RequestBody RegisterRequest req, HttpServletRequest http) { // 入参
		String ip = http.getRemoteAddr(); // IP
		LoginResponse resp = authService.register(req.getPhone(), req.getCode(), req.getPassword(), req.getDeviceInfo(), ip); // 注册
		return ApiResponse.success(resp); // 返回
	}
} // 类结束 