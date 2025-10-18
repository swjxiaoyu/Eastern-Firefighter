package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("cart_item")
public class CartItem {
	@TableId
	private Long id;
	@TableField("user_id")
	private Long userId;
	@TableField("sku_id")
	private Long skuId;
	private Integer quantity;
	private Integer selected;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 