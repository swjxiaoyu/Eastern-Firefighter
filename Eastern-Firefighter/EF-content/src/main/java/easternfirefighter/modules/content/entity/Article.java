package com.easternfirefighter.modules.content.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("article")
public class Article {
	@TableId
	private Long id;
	private String channel;
	private String title;
	private String slug;
	@TableField("cover_url")
	private String coverUrl;
	private String summary;
	@TableField("content_html")
	private String contentHtml;
	@TableField("seo_json")
	private String seoJson;
	private Integer status;
	@TableField("published_at")
	private LocalDateTime publishedAt;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 