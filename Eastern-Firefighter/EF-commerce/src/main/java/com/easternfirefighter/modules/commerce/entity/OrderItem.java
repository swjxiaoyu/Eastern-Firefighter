package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("order_item")
public class OrderItem {
	@TableId
	private Long id;
	@TableField("order_id")
	private Long orderId;
	@TableField("sku_id")
	private Long skuId;
	@TableField("product_name")
	private String productName;
	@TableField("sku_attrs")
	private String skuAttrs; // 对应 sku_attrs JSON
	private BigDecimal price;
	private Integer quantity;
	@TableField("refund_status")
	private Integer refundStatus;
	@TableField("refund_amount")
	private BigDecimal refundAmount;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 