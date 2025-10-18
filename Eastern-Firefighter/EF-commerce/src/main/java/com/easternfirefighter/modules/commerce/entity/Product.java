package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("product")
public class Product {
	@TableId
	private Long id;
	@TableField("category_id")
	private Long categoryId;
	private String name;
	private String subtitle;
	private String brand;
	@TableField("cover_url")
	private String coverUrl;
	// 新增：价格与库存
	private BigDecimal price;
	private Integer stock;
	@TableField("media_json")
	private String mediaJson;
	@TableField("detail_html")
	private String detailHtml;
	@TableField("attributes_json")
	private String attributesJson;
	@TableField("compliance_json")
	private String complianceJson;
	private Integer status;
	@TableField("sale_start_at")
	private LocalDateTime saleStartAt;
	@TableField("sale_end_at")
	private LocalDateTime saleEndAt;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
	@TableField("merchant_id")
	private Long merchantId;
} 