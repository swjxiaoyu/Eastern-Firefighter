package com.easternfirefighter.modules.auth.dto;

import lombok.Data;

import java.time.LocalDate;

@Data
public class ProfileUpdateRequest {
	private String realName;
	private Integer gender;
	private LocalDate birthday;
	private String avatarUrl;
} 