package com.easternfirefighter.modules.commerce.controller; // 包：电商-退款

import com.baomidou.mybatisplus.extension.plugins.pagination.Page; // 分页
import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.common.UserContext; // 用户上下文
import com.easternfirefighter.modules.commerce.dto.RefundApplyRequest; // 退款申请请求
import com.easternfirefighter.modules.commerce.entity.Refund; // 退款实体
import com.easternfirefighter.modules.commerce.service.RefundService; // 退款服务
import jakarta.validation.Valid; // 校验
import org.springframework.web.bind.annotation.*; // Web 注解

@RestController // 控制器
@RequestMapping("/api/commerce/refunds") // 前缀
public class RefundController { // 退款控制器
	private final RefundService refundService; // 服务

	public RefundController(RefundService refundService) { // 构造注入
		this.refundService = refundService; // 赋值
	}

	@PostMapping("/apply") // 申请退款
	public ApiResponse<Refund> apply(@Valid @RequestBody RefundApplyRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		return ApiResponse.success(refundService.apply(uid, req)); // 调服务
	}

	@GetMapping // 退款分页
	public ApiResponse<Page<Refund>> page(@RequestParam(defaultValue = "1") int page,
											@RequestParam(defaultValue = "10") int size) { // 分页参数
		Long uid = UserContext.getUserId(); // 用户
		return ApiResponse.success(refundService.page(uid, page, size)); // 调服务
	}
} // 类结束 