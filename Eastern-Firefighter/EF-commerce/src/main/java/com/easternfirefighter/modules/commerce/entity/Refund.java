package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("refund")
public class Refund {
	@TableId
	private Long id;
	@TableField("refund_no")
	private String refundNo;
	@TableField("order_no")
	private String orderNo;
	@TableField("order_item_id")
	private Long orderItemId; // null表示整单退款
	private String channel;
	private Integer status; // 0提交/1处理中/2成功/3失败
	private BigDecimal amount;
	private String reason;
	@TableField("out_refund_no")
	private String outRefundNo;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 