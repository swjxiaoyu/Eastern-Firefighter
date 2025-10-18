package com.easternfirefighter.modules.auth.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("auth_sms_log")
public class AuthSmsLog {
	@TableId
	private Long id;
	private String phone;
	private String scene;
	@TableField("code_hash")
	private String codeHash;
	@TableField("send_success")
	private Integer sendSuccess;
	private String ip;
	@TableField("retry_count")
	private Integer retryCount;
	@TableField("sent_at")
	private LocalDateTime sentAt;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 