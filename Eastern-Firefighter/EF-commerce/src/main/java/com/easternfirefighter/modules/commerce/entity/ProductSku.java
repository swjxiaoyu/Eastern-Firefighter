package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("product_sku")
public class ProductSku {
	@TableId
	private Long id;
	@TableField("product_id")
	private Long productId;
	@TableField("sku_code")
	private String skuCode;
	@TableField("attrs_json")
	private String attrsJson;
	private String barcode;
	@TableField("weight_g")
	private Integer weightG;
	@TableField("volume_cm3")
	private Integer volumeCm3;
	private java.math.BigDecimal price;
	@TableField("origin_price")
	private java.math.BigDecimal originPrice;
	private Integer status;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 