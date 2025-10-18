package com.easternfirefighter.modules.auth.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SetPasswordRequest {
	@NotBlank
	private String newPassword;
} 