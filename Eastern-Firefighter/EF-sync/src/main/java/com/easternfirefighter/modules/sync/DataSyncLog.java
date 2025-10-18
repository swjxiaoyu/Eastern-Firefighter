package com.easternfirefighter.modules.sync;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("data_sync_log")
public class DataSyncLog {
	@TableId
	private Long id;
	@TableField("table_name")
	private String tableName;
	@TableField("record_id")
	private Long recordId;
	private String operation;
	@TableField("sync_status")
	private Integer syncStatus;
	@TableField("sync_data")
	private String syncData;
	@TableField("error_message")
	private String errorMessage;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
} 