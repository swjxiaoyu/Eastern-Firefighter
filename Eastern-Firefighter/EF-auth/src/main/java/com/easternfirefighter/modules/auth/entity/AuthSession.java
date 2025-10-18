package com.easternfirefighter.modules.auth.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("auth_session")
public class AuthSession {
	@TableId
	private Long id;
	@TableField("user_id")
	private Long userId;
	private String jti;
	@TableField("device_info")
	private String deviceInfo;
	private String ip;
	private Integer status;
	@TableField("expires_at")
	private LocalDateTime expiresAt;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 