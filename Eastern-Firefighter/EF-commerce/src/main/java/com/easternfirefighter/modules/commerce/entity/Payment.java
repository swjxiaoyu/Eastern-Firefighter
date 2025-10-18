package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("payment")
public class Payment {
	@TableId
	private Long id;
	@TableField("order_no")
	private String orderNo;
	@TableField("trade_no")
	private String tradeNo;
	private String channel; // wechat/alipay
	private Integer status; // 0待确认/1成功/2失败
	private BigDecimal amount;
	@TableField("request_payload")
	private String requestPayload;
	@TableField("notify_payload")
	private String notifyPayload;
	@TableField("notified_at")
	private LocalDateTime notifiedAt;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 