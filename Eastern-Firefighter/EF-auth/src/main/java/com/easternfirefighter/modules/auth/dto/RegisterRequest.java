package com.easternfirefighter.modules.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class RegisterRequest {
	@NotBlank
	private String phone;
	@NotBlank
	private String code;
	private String password;
	private String deviceInfo;
} 