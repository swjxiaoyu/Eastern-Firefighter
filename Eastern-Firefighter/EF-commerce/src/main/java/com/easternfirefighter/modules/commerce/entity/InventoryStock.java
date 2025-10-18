package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("inventory_stock")
public class InventoryStock {
	@TableId
	private Long id;
	@TableField("sku_id")
	private Long skuId;
	private Integer stock;
	private Integer reserved;
	@TableField("warehouse_id")
	private Long warehouseId;
	@TableField("updated_reason")
	private String updatedReason;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 