package com.easternfirefighter.modules.museum.dto;

import lombok.Data;

@Data
public class MuseumPageQuery {
	private String city;
	private String theme; // fire/earthquake/firstaid
	private int page = 1;
	private int size = 10;
} 