package com.easternfirefighter.modules.auth.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("user_account")
public class UserAccount {
	@TableId
	private Long id;
	private String phone;
	private String email;
	@TableField("password_hash")
	private String passwordHash;
	@TableField("real_name")
	private String realName;
	@TableField("real_name_verified")
	private Integer realNameVerified;
	@TableField("id_card_hash")
	private String idCardHash;
	@TableField("avatar_url")
	private String avatarUrl;
	private Integer gender;
	private LocalDate birthday;
	private Integer status;
	@TableField("last_login_at")
	private LocalDateTime lastLoginAt;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
	@TableField("role")
	private String role;
} 