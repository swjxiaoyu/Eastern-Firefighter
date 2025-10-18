package com.easternfirefighter.modules.commerce.vo;

import lombok.Data;

import java.math.BigDecimal;

@Data
public class OrderSubmitVO {
	private String orderNo;
	private BigDecimal payAmount;
} 