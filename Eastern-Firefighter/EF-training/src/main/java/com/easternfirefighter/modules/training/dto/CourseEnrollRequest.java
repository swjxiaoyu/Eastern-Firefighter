package com.easternfirefighter.modules.training.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class CourseEnrollRequest {
	@NotNull
	private Long courseId;
	@NotBlank
	private String realName;
	@NotBlank
	private String phone;
} 