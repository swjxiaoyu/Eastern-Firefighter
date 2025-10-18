package com.easternfirefighter.modules.training.entity;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@TableName("training_course_enrollment")
public class CourseEnrollment {
	@TableId
	private Long id;
	@TableField("course_id")
	private Long courseId;
	@TableField("user_id")
	private Long userId;
	@TableField("real_name")
	private String realName;
	@TableField("phone")
	private String phone;
	@TableField("status")
	private Integer status; // 0=待审核 1=已确认 2=已取消
	@TableField("created_at")
	private LocalDateTime createdAt;
	@TableField("updated_at")
	private LocalDateTime updatedAt;
	private Integer deleted;
} 