package com.easternfirefighter.modules.commerce.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class OrderDraftRequest {
	@NotNull
	private Long addressId;
} 