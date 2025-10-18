package com.easternfirefighter.modules.commerce.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CartUpdateRequest {
	@NotBlank
	private String id;
	@Min(1)
	private Integer quantity;
} 