package com.easternfirefighter.modules.museum.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MuseumBookRequest {
	@NotNull
	private Long museumId;
	@NotBlank
	private String date; // YYYY-MM-DD
	@NotBlank
	private String slot; // morning/afternoon
	@Min(1)
	private int people;
} 