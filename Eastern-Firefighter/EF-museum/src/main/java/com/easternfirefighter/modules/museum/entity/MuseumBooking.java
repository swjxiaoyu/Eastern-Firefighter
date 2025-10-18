package com.easternfirefighter.modules.museum.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@TableName("museum_booking")
public class MuseumBooking {
	@TableId
	private Long id;
	@TableField("museum_id")
	private Long museumId;
	@TableField("user_id")
	private Long userId;
	private LocalDate date;
	private String slot; // morning/afternoon
	private Integer people;
	private Integer status; // 0=待确认 1=已确认 2=取消
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 