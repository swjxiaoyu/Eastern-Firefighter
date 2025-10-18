package com.easternfirefighter.modules.content.vo;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class ArticleAdminVO {
	private String id; // String 避免前端JS精度丢失
	private String title;
	private String channel;
	private Integer status;
	private String summary;
	private String coverUrl;
	private LocalDateTime publishedAt;
	private LocalDateTime updatedAt;
} 