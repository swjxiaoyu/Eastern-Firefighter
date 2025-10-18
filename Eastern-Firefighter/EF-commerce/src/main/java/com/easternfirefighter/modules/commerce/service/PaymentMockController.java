package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.modules.commerce.entity.Order;
import com.easternfirefighter.modules.commerce.entity.Payment;
import com.easternfirefighter.modules.commerce.repository.mapper.OrderMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.PaymentMapper;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/commerce/payments/mock-notify")
public class PaymentMockController {
	private final PaymentMapper paymentMapper;
	private final OrderMapper orderMapper;

	public PaymentMockController(PaymentMapper paymentMapper, OrderMapper orderMapper) {
		this.paymentMapper = paymentMapper;
		this.orderMapper = orderMapper;
	}

	@PostMapping
	public ApiResponse<Boolean> notify(@RequestParam String orderNo, @RequestParam(defaultValue = "1") int success) {
		Payment pay = paymentMapper.selectOne(new LambdaQueryWrapper<Payment>().eq(Payment::getOrderNo, orderNo));
		if (pay == null) return ApiResponse.fail(404, "payment not found");
		if (success == 1) {
			pay.setStatus(1);
			pay.setTradeNo("MOCK-" + orderNo);
			pay.setUpdatedAt(LocalDateTime.now());
			paymentMapper.updateById(pay);
			Order order = orderMapper.selectOne(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Order>().eq(Order::getOrderNo, orderNo));
			if (order != null) {
				order.setStatus(20);
				order.setPayTime(LocalDateTime.now());
				order.setUpdatedAt(LocalDateTime.now());
				orderMapper.updateById(order);
			}
		} else {
			pay.setStatus(2);
			pay.setUpdatedAt(LocalDateTime.now());
			paymentMapper.updateById(pay);
		}
		return ApiResponse.success(true);
	}
} 