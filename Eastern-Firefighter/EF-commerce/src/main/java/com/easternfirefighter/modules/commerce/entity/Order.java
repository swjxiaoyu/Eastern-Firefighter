package com.easternfirefighter.modules.commerce.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@TableName("`order`")
public class Order {
	@TableId
	private Long id;
	@TableField("order_no")
	private String orderNo;
	@TableField("user_id")
	private Long userId;
	private Integer status;
	@TableField("total_amount")
	private BigDecimal totalAmount;
	@TableField("discount_amount")
	private BigDecimal discountAmount;
	@TableField("freight_amount")
	private BigDecimal freightAmount;
	@TableField("pay_amount")
	private BigDecimal payAmount;
	@TableField("address_snapshot")
	private String addressSnapshot;
	@TableField("invoice_snapshot")
	private String invoiceSnapshot;
	private String remark;
	@TableField("pay_channel")
	private String payChannel;
	@TableField("pay_time")
	private LocalDateTime payTime;
	@TableField("shipping_company")
	private String shippingCompany;
	@TableField("tracking_no")
	private String trackingNo;
	@TableField("ship_time")
	private LocalDateTime shipTime;
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 