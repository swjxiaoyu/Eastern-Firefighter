package com.easternfirefighter.modules.commerce.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderListItemVO {
	@Data
	public static class ItemBrief {
		private Long skuId;
		private String productName;
		private Integer quantity;
		private BigDecimal amount; // 单行总额 price*quantity
		private String coverUrl;
	}

	private String orderNo;
	private Integer status;
	private BigDecimal payAmount;
	private LocalDateTime createdAt;
	// 新增：条目概览
	private List<ItemBrief> items;
} 