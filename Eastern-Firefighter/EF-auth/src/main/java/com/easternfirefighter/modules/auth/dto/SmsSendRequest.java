package com.easternfirefighter.modules.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SmsSendRequest {
	@NotBlank
	private String phone;
	@NotBlank
	private String scene; // login/register/reset
} 