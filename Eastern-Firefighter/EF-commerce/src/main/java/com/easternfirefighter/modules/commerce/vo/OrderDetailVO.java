package com.easternfirefighter.modules.commerce.vo;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class OrderDetailVO {
	@Data
	public static class Item {
		private Long id;
		private Long skuId;
		private String productName;
		private String skuAttrs;
		private BigDecimal price;
		private Integer quantity;
		// 新增：用于前端展示的封面与金额
		private String coverUrl;
		private BigDecimal amount;
	}

	@Data
	public static class PaymentInfo {
		private String orderNo;
		private String channel;
		private Integer status;
		private BigDecimal amount;
	}

	// 新增：时间线节点
	@Data
	public static class TimelineNode {
		private LocalDateTime time;
		private String text;
	}

	private String orderNo;
	private Integer status;
	private BigDecimal totalAmount;
	private BigDecimal discountAmount;
	private BigDecimal freightAmount;
	private BigDecimal payAmount;
	private String addressSnapshot;
	private String remark;
	private LocalDateTime createdAt;
	private List<Item> items;
	private PaymentInfo payment;
	// 新增：时间线
	private List<TimelineNode> timeline;
} 