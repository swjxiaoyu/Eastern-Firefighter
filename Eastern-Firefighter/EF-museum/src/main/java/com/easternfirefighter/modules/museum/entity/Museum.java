package com.easternfirefighter.modules.museum.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("museum")
public class Museum {
	@TableId
	private Long id;
	private String name;
	private String city;
	@TableField(exist = false)
	private String theme; // 不在当前表中，保留给未来扩展
	@TableField(value = "theme_name", exist = false)
	private String themeName; // 不在当前表中，保留给未来扩展
	@TableField("cover_url")
	private String coverUrl;
	// 兼容现有种子数据的字段
	@TableField("description_html")
	private String descriptionHtml;
	private String country;
	private String province;
	private String addressLine;
	@TableField("open_time")
	private String openTime;
	@TableField("contact_phone")
	private String contactPhone;

	// 旧版字段保留为非持久化，避免下游使用报错
	@TableField(exist = false)
	private String summary;
	@TableField(value = "content_html", exist = false)
	private String contentHtml;
	private Integer status; // 1=上架 0=下架
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 