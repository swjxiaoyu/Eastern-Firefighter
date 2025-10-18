package com.easternfirefighter.modules.auth.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Data;

@Data
public class AddressSaveRequest {
	private Long id; // 更新时必传
	@NotBlank
	@Size(min = 2, max = 20, message = "收件人长度需 2-20 个字符")
	private String contactName;
	@NotBlank
	@Pattern(regexp = "^1[3-9]\\d{9}$", message = "请输入有效的手机号")
	private String contactPhone;
	private String country;
	private String province;
	private String city;
	private String district;
	@NotBlank
	@Size(min = 5, max = 200, message = "详细地址长度需 5-200 个字符")
	private String addressLine;
	private String postalCode;
	private Integer isDefault; // 1设为默认
} 