package com.easternfirefighter.modules.training.dto;

import lombok.Data;

@Data
public class CoursePageQuery {
	private String keyword;
	private String level; // beginner/intermediate/advanced
	private int page = 1;
	private int size = 10;
} 