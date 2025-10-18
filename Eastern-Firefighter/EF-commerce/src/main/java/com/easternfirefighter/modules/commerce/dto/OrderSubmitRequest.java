package com.easternfirefighter.modules.commerce.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class OrderSubmitRequest {
	@NotNull
	private Long addressId;
	private String remark;
} 