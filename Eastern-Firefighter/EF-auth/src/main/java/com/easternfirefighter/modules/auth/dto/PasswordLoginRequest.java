package com.easternfirefighter.modules.auth.dto;

import lombok.Data;

@Data
public class PasswordLoginRequest {
	private String username; // 二选一
	private String phone;    // 二选一
	private String password;
	private String deviceInfo;
} 