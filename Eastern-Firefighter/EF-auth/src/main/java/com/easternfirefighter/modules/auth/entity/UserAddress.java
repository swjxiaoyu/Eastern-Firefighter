package com.easternfirefighter.modules.auth.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.IdType;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("user_address")
public class UserAddress {
	@TableId(type = IdType.ASSIGN_ID)
	private Long id;
	@TableField("user_id")
	private Long userId;
	@TableField("contact_name")
	private String contactName;
	@TableField("contact_phone")
	private String contactPhone;
	private String country;
	private String province;
	private String city;
	private String district;
	@TableField("address_line")
	private String addressLine;
	@TableField("postal_code")
	private String postalCode;
	@TableField("is_default")
	private Integer isDefault;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 