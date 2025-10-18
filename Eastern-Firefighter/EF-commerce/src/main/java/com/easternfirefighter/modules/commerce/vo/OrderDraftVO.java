package com.easternfirefighter.modules.commerce.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class OrderDraftVO {
	@Data
	public static class Item {
		private Long skuId;
		private String productName;
		private String skuAttrsJson;
		private Integer quantity;
		private BigDecimal price;
		private BigDecimal amount;
	}

	private List<Item> items;
	private BigDecimal totalAmount;
	private BigDecimal discountAmount;
	private BigDecimal freightAmount;
	private BigDecimal payAmount;
	private String addressSnapshotJson;
} 