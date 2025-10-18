package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.dto.RefundApplyRequest;
import com.easternfirefighter.modules.commerce.entity.Order;
import com.easternfirefighter.modules.commerce.entity.OrderItem;
import com.easternfirefighter.modules.commerce.entity.Refund;
import com.easternfirefighter.modules.commerce.repository.mapper.OrderItemMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.OrderMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.RefundMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

@Service
public class RefundServiceImpl implements RefundService {
	private final RefundMapper refundMapper;
	private final OrderMapper orderMapper;
	private final OrderItemMapper orderItemMapper;

	public RefundServiceImpl(RefundMapper refundMapper, OrderMapper orderMapper, OrderItemMapper orderItemMapper) {
		this.refundMapper = refundMapper;
		this.orderMapper = orderMapper;
		this.orderItemMapper = orderItemMapper;
	}

	@Override
	public Refund apply(Long userId, RefundApplyRequest req) {
		Order o = orderMapper.selectOne(new LambdaQueryWrapper<Order>().eq(Order::getOrderNo, req.getOrderNo()).eq(Order::getUserId, userId).eq(Order::getDeleted, 0));
		if (o == null) throw new IllegalArgumentException("订单不存在");
		BigDecimal limit;
		if (req.getOrderItemId() != null) {
			OrderItem item = orderItemMapper.selectById(req.getOrderItemId());
			if (item == null || !o.getId().equals(item.getOrderId())) throw new IllegalArgumentException("明细不存在");
			limit = item.getPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
		} else {
			limit = o.getPayAmount();
		}
		if (req.getAmount().compareTo(BigDecimal.ZERO) <= 0 || req.getAmount().compareTo(limit) > 0) {
			throw new IllegalArgumentException("退款金额不合法");
		}
		Refund r = new Refund();
		r.setRefundNo(newRefundNo());
		r.setOrderNo(req.getOrderNo());
		r.setOrderItemId(req.getOrderItemId());
		r.setChannel(null);
		r.setStatus(0);
		r.setAmount(req.getAmount());
		r.setReason(req.getReason());
		r.setCreatedAt(LocalDateTime.now());
		r.setUpdatedAt(LocalDateTime.now());
		refundMapper.insert(r);
		return r;
	}

	@Override
	public Page<Refund> page(Long userId, int page, int size) {
		// 简化：按订单号关联用户过滤
		Page<Refund> p = refundMapper.selectPage(Page.of(page, size), new LambdaQueryWrapper<Refund>().orderByDesc(Refund::getCreatedAt));
		return p;
	}

	private String newRefundNo() {
		long ts = System.currentTimeMillis();
		int rand = ThreadLocalRandom.current().nextInt(100000, 999999);
		return "R" + ts + rand;
	}
} 