package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.entity.Order;
import com.easternfirefighter.modules.commerce.entity.OrderItem;
import com.easternfirefighter.modules.commerce.entity.Payment;
import com.easternfirefighter.modules.commerce.repository.mapper.OrderItemMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.OrderMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.PaymentMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductSkuMapper;
import com.easternfirefighter.modules.commerce.entity.Product;
import com.easternfirefighter.modules.commerce.entity.ProductSku;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Map;
import com.easternfirefighter.modules.commerce.vo.OrderDetailVO;
import com.easternfirefighter.modules.commerce.vo.OrderListItemVO;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class OrderQueryServiceImpl implements OrderQueryService {
	private final OrderMapper orderMapper;
	private final OrderItemMapper orderItemMapper;
	private final PaymentMapper paymentMapper;
	private final ProductSkuMapper productSkuMapper;
	private final ProductMapper productMapper;

	public OrderQueryServiceImpl(OrderMapper orderMapper, OrderItemMapper orderItemMapper, PaymentMapper paymentMapper, ProductSkuMapper productSkuMapper, ProductMapper productMapper) {
		this.orderMapper = orderMapper;
		this.orderItemMapper = orderItemMapper;
		this.paymentMapper = paymentMapper;
		this.productSkuMapper = productSkuMapper;
		this.productMapper = productMapper;
	}

	@Override
	public Page<OrderListItemVO> page(Long userId, int page, int size) {
		return page(userId, null, page, size);
	}

	@Override
	public Page<OrderListItemVO> page(Long userId, Integer status, int page, int size) {
		Page<Order> po = orderMapper.selectPage(Page.of(page, size), new LambdaQueryWrapper<Order>()
			.eq(Order::getUserId, userId)
			.eq(Order::getDeleted, 0)
			.eq(status != null, Order::getStatus, status)
			.orderByDesc(Order::getCreatedAt));
		Page<OrderListItemVO> vo = new Page<>(po.getCurrent(), po.getSize(), po.getTotal());
		List<Long> orderIds = po.getRecords().stream().map(Order::getId).toList();
		List<OrderItem> allItems = orderIds.isEmpty() ? List.of() : orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>()
			.in(OrderItem::getOrderId, orderIds)
			.eq(OrderItem::getDeleted, 0));
		Map<Long, List<OrderItem>> orderIdToItems = allItems.stream().collect(Collectors.groupingBy(OrderItem::getOrderId));
		List<Long> skuIds = allItems.stream().map(OrderItem::getSkuId).distinct().toList();
		Map<Long, ProductSku> skuIdToSku = skuIds.isEmpty() ? Map.of() : productSkuMapper.selectBatchIds(skuIds).stream().collect(Collectors.toMap(ProductSku::getId, s -> s));
		List<Long> productIds = skuIdToSku.values().stream().map(ProductSku::getProductId).distinct().toList();
		Map<Long, Product> productIdToProduct = productIds.isEmpty() ? Map.of() : productMapper.selectBatchIds(productIds).stream().collect(Collectors.toMap(Product::getId, p -> p));

		vo.setRecords(po.getRecords().stream().map(o -> {
			OrderListItemVO item = new OrderListItemVO();
			item.setOrderNo(o.getOrderNo());
			item.setStatus(o.getStatus());
			item.setPayAmount(o.getPayAmount());
			item.setCreatedAt(o.getCreatedAt());
			List<OrderItem> items = orderIdToItems.getOrDefault(o.getId(), List.of());
			List<OrderListItemVO.ItemBrief> briefs = new java.util.ArrayList<>();
			for (OrderItem oi : items) {
				OrderListItemVO.ItemBrief b = new OrderListItemVO.ItemBrief();
				b.setSkuId(oi.getSkuId());
				b.setProductName(oi.getProductName());
				b.setQuantity(oi.getQuantity());
				b.setAmount(oi.getPrice() == null ? java.math.BigDecimal.ZERO : oi.getPrice().multiply(java.math.BigDecimal.valueOf(oi.getQuantity() == null ? 0 : oi.getQuantity())));
				ProductSku sku = skuIdToSku.get(oi.getSkuId());
				if (sku != null) {
					Product p = productIdToProduct.get(sku.getProductId());
					if (p != null) b.setCoverUrl(p.getCoverUrl());
				}
				briefs.add(b);
			}
			item.setItems(briefs);
			return item;
		}).collect(Collectors.toList()));
		return vo;
	}

	@Override
	public OrderDetailVO detail(Long userId, String orderNo) {
		Order o = orderMapper.selectOne(new LambdaQueryWrapper<Order>()
			.eq(Order::getOrderNo, orderNo)
			.eq(Order::getUserId, userId)
			.eq(Order::getDeleted, 0));
		if (o == null) return null;
		OrderDetailVO d = new OrderDetailVO();
		d.setOrderNo(o.getOrderNo());
		d.setStatus(o.getStatus());
		d.setTotalAmount(o.getTotalAmount());
		d.setDiscountAmount(o.getDiscountAmount());
		d.setFreightAmount(o.getFreightAmount());
		d.setPayAmount(o.getPayAmount());
		d.setAddressSnapshot(o.getAddressSnapshot());
		d.setRemark(o.getRemark());
		d.setCreatedAt(o.getCreatedAt());
		List<OrderItem> items = orderItemMapper.selectList(new LambdaQueryWrapper<OrderItem>().eq(OrderItem::getOrderId, o.getId()).eq(OrderItem::getDeleted, 0));

		// 预取 SKU 与产品以补充 coverUrl
		List<Long> skuIds = items.stream().map(OrderItem::getSkuId).distinct().toList();
		Map<Long, ProductSku> skuIdToSku = skuIds.isEmpty() ? Map.of() : productSkuMapper.selectBatchIds(skuIds).stream().collect(Collectors.toMap(ProductSku::getId, s -> s));
		List<Long> productIds = skuIdToSku.values().stream().map(ProductSku::getProductId).distinct().toList();
		Map<Long, Product> productIdToProduct = productIds.isEmpty() ? Map.of() : productMapper.selectBatchIds(productIds).stream().collect(Collectors.toMap(Product::getId, p -> p));

		d.setItems(items.stream().map(oi -> {
			OrderDetailVO.Item it = new OrderDetailVO.Item();
			it.setId(oi.getId());
			it.setSkuId(oi.getSkuId());
			it.setProductName(oi.getProductName());
			it.setSkuAttrs(oi.getSkuAttrs());
			it.setPrice(oi.getPrice());
			it.setQuantity(oi.getQuantity());
			it.setAmount(oi.getPrice() == null ? BigDecimal.ZERO : oi.getPrice().multiply(BigDecimal.valueOf(oi.getQuantity() == null ? 0 : oi.getQuantity())));
			ProductSku sku = skuIdToSku.get(oi.getSkuId());
			if (sku != null) {
				Product p = productIdToProduct.get(sku.getProductId());
				if (p != null) it.setCoverUrl(p.getCoverUrl());
			}
			return it;
		}).collect(Collectors.toList()));
		Payment p = paymentMapper.selectOne(new LambdaQueryWrapper<Payment>().eq(Payment::getOrderNo, o.getOrderNo()).eq(Payment::getDeleted, 0));
		if (p != null) {
			OrderDetailVO.PaymentInfo pi = new OrderDetailVO.PaymentInfo();
			pi.setOrderNo(p.getOrderNo());
			pi.setChannel(p.getChannel());
			pi.setStatus(p.getStatus());
			pi.setAmount(p.getAmount());
			d.setPayment(pi);
		}

		// 构造简单时间线（可按业务进一步完善）
		List<OrderDetailVO.TimelineNode> timeline = new ArrayList<>();
		OrderDetailVO.TimelineNode created = new OrderDetailVO.TimelineNode();
		created.setTime(o.getCreatedAt());
		created.setText("订单已创建");
		timeline.add(created);
		if (o.getPayTime() != null) {
			OrderDetailVO.TimelineNode paid = new OrderDetailVO.TimelineNode();
			paid.setTime(o.getPayTime());
			paid.setText("支付成功");
			timeline.add(paid);
		}
		d.setTimeline(timeline);
		return d;
	}
} 