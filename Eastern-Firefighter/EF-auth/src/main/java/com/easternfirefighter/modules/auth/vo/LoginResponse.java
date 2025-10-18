package com.easternfirefighter.modules.auth.vo;

import lombok.Data;

@Data
public class LoginResponse {
	private Long userId;
	private String token; // 简化：此处用JTI占位
} 