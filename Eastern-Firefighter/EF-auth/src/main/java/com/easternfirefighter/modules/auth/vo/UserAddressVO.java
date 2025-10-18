package com.easternfirefighter.modules.auth.vo;

import lombok.Data;

@Data
public class UserAddressVO {
	private String id; // String to avoid JS precision loss
	private String contactName;
	private String contactPhone;
	private String addressLine;
	private Integer isDefault;
	private String country;
	private String province;
	private String city;
	private String district;
	private String postalCode;
} 