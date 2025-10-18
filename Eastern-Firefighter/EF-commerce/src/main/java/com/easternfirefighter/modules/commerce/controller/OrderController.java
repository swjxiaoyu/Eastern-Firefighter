package com.easternfirefighter.modules.commerce.controller; // 包：电商-下单

import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.common.UserContext; // 用户上下文
import com.easternfirefighter.modules.commerce.dto.OrderSubmitRequest; // 下单请求
import com.easternfirefighter.modules.commerce.service.OrderService; // 下单服务
import com.easternfirefighter.modules.commerce.vo.OrderSubmitVO; // 下单返回
import jakarta.validation.Valid; // 校验
import org.springframework.web.bind.annotation.PostMapping; // POST
import org.springframework.web.bind.annotation.RequestBody; // 请求体
import org.springframework.web.bind.annotation.RequestMapping; // 前缀
import org.springframework.web.bind.annotation.RestController; // 控制器

@RestController // 控制器
@RequestMapping("/api/commerce/orders") // 前缀
public class OrderController { // 下单控制器
	private final OrderService orderService; // 服务

	public OrderController(OrderService orderService) { // 构造注入
		this.orderService = orderService; // 赋值
	}

	@PostMapping("/submit") // 提交订单
	public ApiResponse<OrderSubmitVO> submit(@Valid @RequestBody OrderSubmitRequest req) { // 入参
		Long uid = UserContext.getUserId(); // 用户
		return ApiResponse.success(orderService.submit(uid, req)); // 调服务并返回
	}
} // 类结束 