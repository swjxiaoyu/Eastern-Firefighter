package com.easternfirefighter.modules.commerce.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

import java.math.BigDecimal;

@Data
public class RefundApplyRequest {
	@NotBlank
	private String orderNo;
	private Long orderItemId; // 为空为整单退款
	@NotNull @Min(1)
	private BigDecimal amount;
	@NotBlank
	private String reason;
} 