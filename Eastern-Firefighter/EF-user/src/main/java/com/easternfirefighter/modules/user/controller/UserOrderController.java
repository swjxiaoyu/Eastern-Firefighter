package com.easternfirefighter.modules.user.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.common.UserContext;
import com.easternfirefighter.modules.commerce.dto.OrderSubmitRequest;
import com.easternfirefighter.modules.commerce.service.OrderQueryService;
import com.easternfirefighter.modules.commerce.service.OrderService;
import com.easternfirefighter.modules.commerce.vo.OrderDetailVO;
import com.easternfirefighter.modules.commerce.vo.OrderListItemVO;
import com.easternfirefighter.modules.commerce.vo.OrderSubmitVO;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user/orders")
public class UserOrderController {
	private final OrderService orderService;
	private final OrderQueryService orderQueryService;

	public UserOrderController(OrderService orderService, OrderQueryService orderQueryService) {
		this.orderService = orderService;
		this.orderQueryService = orderQueryService;
	}

	@PostMapping("/submit")
	public ApiResponse<OrderSubmitVO> submit(@Valid @RequestBody OrderSubmitRequest req) {
		Long uid = UserContext.getUserId();
		return ApiResponse.success(orderService.submit(uid, req));
	}

	@GetMapping
	public ApiResponse<Page<OrderListItemVO>> page(@RequestParam(required = false) Integer status,
	                                              @RequestParam(defaultValue = "1") int page,
	                                              @RequestParam(defaultValue = "10") int size) {
		Long uid = UserContext.getUserId();
		Page<OrderListItemVO> po = (status == null)
			? orderQueryService.page(uid, page, size)
			: orderQueryService.page(uid, status, page, size);
		return ApiResponse.success(po);
	}

	@GetMapping("/{orderNo}")
	public ApiResponse<OrderDetailVO> detail(@PathVariable String orderNo) {
		Long uid = UserContext.getUserId();
		return ApiResponse.success(orderQueryService.detail(uid, orderNo));
	}
} 