package com.easternfirefighter.modules.commerce.controller; // 包：电商-下单草稿

import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.common.UserContext; // 用户上下文
import com.easternfirefighter.modules.commerce.dto.OrderDraftRequest; // 草稿请求
import com.easternfirefighter.modules.commerce.service.OrderDraftService; // 草稿服务
import com.easternfirefighter.modules.commerce.vo.OrderDraftVO; // 草稿返回
import jakarta.validation.Valid; // 校验
import org.springframework.web.bind.annotation.PostMapping; // POST
import org.springframework.web.bind.annotation.RequestBody; // 请求体
import org.springframework.web.bind.annotation.RequestMapping; // 前缀
import org.springframework.web.bind.annotation.RestController; // 控制器

@RestController // 控制器
@RequestMapping("/api/commerce/orders/draft") // 草稿前缀
public class OrderDraftController { // 下单草稿控制器
	private final OrderDraftService orderDraftService; // 服务

	public OrderDraftController(OrderDraftService orderDraftService) { // 构造注入
		this.orderDraftService = orderDraftService; // 赋值
	}

	@PostMapping // 创建草稿
	public ApiResponse<OrderDraftVO> create(@Valid @RequestBody OrderDraftRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		return ApiResponse.success(orderDraftService.createDraft(uid, req)); // 调服务
	}
} // 类结束 