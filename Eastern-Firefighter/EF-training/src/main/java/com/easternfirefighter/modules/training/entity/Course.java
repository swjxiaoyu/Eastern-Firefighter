package com.easternfirefighter.modules.training.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("training_course")
public class Course {
	@TableId
	private Long id;
	private String title;
	@TableField("cover_url")
	private String coverUrl;
	private String summary;
	private String level; // beginner/intermediate/advanced
	private Integer duration; // 学时
	private String lecturer;
	@TableField("content_html")
	private String contentHtml;
	private Integer status; // 1=上架 0=下架
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 