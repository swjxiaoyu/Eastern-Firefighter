package com.easternfirefighter.modules.commerce.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class CartItemVO {
	private String id;
	private String skuId;
	private String productId;
	private String productName;
	private String skuAttrsJson;
	private Integer quantity;
	private Integer selected;
	private BigDecimal price;
	private String coverUrl;
} 