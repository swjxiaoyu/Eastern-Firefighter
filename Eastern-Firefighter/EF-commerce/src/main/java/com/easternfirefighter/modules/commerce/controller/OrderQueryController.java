package com.easternfirefighter.modules.commerce.controller; // 包：电商-订单查询

import com.baomidou.mybatisplus.extension.plugins.pagination.Page; // 分页
import com.easternfirefighter.common.ApiResponse; // 通用响应
import com.easternfirefighter.common.UserContext; // 用户上下文
import com.easternfirefighter.modules.commerce.service.OrderQueryService; // 服务
import com.easternfirefighter.modules.commerce.vo.OrderDetailVO; // VO-明细
import com.easternfirefighter.modules.commerce.vo.OrderListItemVO; // VO-列表项
import org.springframework.web.bind.annotation.GetMapping; // GET 映射
import org.springframework.web.bind.annotation.PathVariable; // 路径参数
import org.springframework.web.bind.annotation.RequestMapping; // 前缀
import org.springframework.web.bind.annotation.RequestParam; // 查询参数
import org.springframework.web.bind.annotation.RestController; // 控制器

@RestController // REST 控制器
@RequestMapping("/api/commerce/orders") // 订单查询前缀
public class OrderQueryController { // 订单查询控制器
	private final OrderQueryService orderQueryService; // 服务

	public OrderQueryController(OrderQueryService orderQueryService) { // 构造注入
		this.orderQueryService = orderQueryService; // 赋值
	}

		@GetMapping // 分页列表
	public ApiResponse<Page<OrderListItemVO>> page(@RequestParam(defaultValue = "1") int page,
													 @RequestParam(defaultValue = "10") int size,
													 @RequestParam(required = false) Integer status) { // 支持状态筛选
		Long uid = UserContext.getUserId(); // 当前用户
		return ApiResponse.success(orderQueryService.page(uid, status, page, size)); // 调服务
	}

	@GetMapping("/{orderNo}") // 详情
	public ApiResponse<OrderDetailVO> detail(@PathVariable String orderNo) { // 路径参数
		Long uid = UserContext.getUserId(); // 当前用户
		return ApiResponse.success(orderQueryService.detail(uid, orderNo)); // 查询详情
	}
} // 类结束 