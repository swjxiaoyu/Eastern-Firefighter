package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.easternfirefighter.modules.auth.entity.UserAddress;
import com.easternfirefighter.modules.auth.entity.repository.mapper.UserAddressMapper;
import com.easternfirefighter.modules.commerce.dto.OrderSubmitRequest;
import com.easternfirefighter.modules.commerce.entity.*;
import com.easternfirefighter.modules.commerce.repository.mapper.*;
import com.easternfirefighter.modules.commerce.vo.OrderSubmitVO;
import com.easternfirefighter.util.OrderNoUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class OrderServiceImpl implements OrderService {
	private static final Logger log = LoggerFactory.getLogger(OrderServiceImpl.class);
	private final CartItemMapper cartItemMapper;
	private final ProductSkuMapper skuMapper;
	private final ProductMapper productMapper;
	private final UserAddressMapper addressMapper;
	private final OrderMapper orderMapper;
	private final OrderItemMapper orderItemMapper;
	private final PaymentMapper paymentMapper;
	private final ObjectMapper objectMapper;

	public OrderServiceImpl(CartItemMapper cartItemMapper, ProductSkuMapper skuMapper, ProductMapper productMapper,
							 UserAddressMapper addressMapper, OrderMapper orderMapper, OrderItemMapper orderItemMapper,
							 PaymentMapper paymentMapper, ObjectMapper objectMapper) {
		this.cartItemMapper = cartItemMapper;
		this.skuMapper = skuMapper;
		this.productMapper = productMapper;
		this.addressMapper = addressMapper;
		this.orderMapper = orderMapper;
		this.orderItemMapper = orderItemMapper;
		this.paymentMapper = paymentMapper;
		this.objectMapper = objectMapper;
	}

	@Override
	@Transactional
	public OrderSubmitVO submit(Long userId, OrderSubmitRequest req) {
		List<CartItem> items = cartItemMapper.selectList(new LambdaQueryWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getSelected, 1)
			.eq(CartItem::getDeleted, 0));
		if (items.isEmpty()) {
			throw new IllegalStateException("购物车为空");
		}
		Set<Long> skuIds = items.stream().map(CartItem::getSkuId).collect(Collectors.toSet());
		List<ProductSku> skus = skuMapper.selectBatchIds(skuIds);
		Map<Long, ProductSku> skuMap = skus.stream().collect(Collectors.toMap(ProductSku::getId, s -> s));
		Set<Long> productIds = skus.stream().map(ProductSku::getProductId).collect(Collectors.toSet());
		List<Product> products = productMapper.selectBatchIds(productIds);
		Map<Long, Product> prodMap = products.stream().collect(Collectors.toMap(Product::getId, p -> p));

		// 地址查找：先按传入ID匹配；不存在则回退到默认地址
		UserAddress addr = null;
		if (req.getAddressId() != null) {
			addr = addressMapper.selectOne(new LambdaQueryWrapper<UserAddress>()
				.eq(UserAddress::getId, req.getAddressId())
				.eq(UserAddress::getUserId, userId)
				.eq(UserAddress::getDeleted, 0));
		}
		if (addr == null) {
			addr = addressMapper.selectOne(new LambdaQueryWrapper<UserAddress>()
				.eq(UserAddress::getUserId, userId)
				.eq(UserAddress::getIsDefault, 1)
				.eq(UserAddress::getDeleted, 0)
				.last("limit 1"));
		}
		if (addr == null) {
			log.warn("[ORDER_SUBMIT] address not found userId={} req.addressId={}", userId, req.getAddressId());
			throw new IllegalArgumentException("地址不存在或不可用");
		}

		BigDecimal total = BigDecimal.ZERO;
		List<OrderItem> orderItems = new ArrayList<>();
		for (CartItem ci : items) {
			ProductSku sku = skuMap.get(ci.getSkuId());
			if (sku == null) continue;
			Product p = prodMap.get(sku.getProductId());
			OrderItem oi = new OrderItem();
			// orderId 待插入后回填
			oi.setSkuId(ci.getSkuId());
			oi.setProductName(p != null ? p.getName() : null);
			oi.setSkuAttrs(sku.getAttrsJson());
			oi.setPrice(sku.getPrice());
			oi.setQuantity(ci.getQuantity());
			oi.setRefundStatus(0);
			oi.setRefundAmount(BigDecimal.ZERO);
			oi.setCreatedAt(LocalDateTime.now());
			oi.setUpdatedAt(LocalDateTime.now());
			orderItems.add(oi);
			total = total.add(sku.getPrice().multiply(BigDecimal.valueOf(ci.getQuantity())));
		}
		BigDecimal discount = BigDecimal.ZERO;
		BigDecimal freight = BigDecimal.ZERO;
		BigDecimal pay = total.subtract(discount).add(freight);

		String orderNo = OrderNoUtils.newOrderNo();
		String addressSnap;
		try {
			var snap = new LinkedHashMap<String, Object>();
			snap.put("contactName", addr.getContactName());
			snap.put("contactPhone", addr.getContactPhone());
			snap.put("country", addr.getCountry());
			snap.put("province", addr.getProvince());
			snap.put("city", addr.getCity());
			snap.put("district", addr.getDistrict());
			snap.put("addressLine", addr.getAddressLine());
			snap.put("postalCode", addr.getPostalCode());
			addressSnap = objectMapper.writeValueAsString(snap);
		} catch (Exception e) {
			throw new RuntimeException(e);
		}

		Order order = new Order();
		order.setOrderNo(orderNo);
		order.setUserId(userId);
		order.setStatus(10);
		order.setTotalAmount(total);
		order.setDiscountAmount(discount);
		order.setFreightAmount(freight);
		order.setPayAmount(pay);
		order.setAddressSnapshot(addressSnap);
		order.setInvoiceSnapshot(null);
		order.setRemark(req.getRemark());
		order.setCreatedAt(LocalDateTime.now());
		order.setUpdatedAt(LocalDateTime.now());
		orderMapper.insert(order);

		for (OrderItem oi : orderItems) {
			oi.setOrderId(order.getId());
			orderItemMapper.insert(oi);
		}

		// 清理购物车中已选中项
		cartItemMapper.update(null, new LambdaUpdateWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getSelected, 1)
			.eq(CartItem::getDeleted, 0)
			.set(CartItem::getDeleted, 1)
			.set(CartItem::getUpdatedAt, LocalDateTime.now()));

		// 创建支付记录（待支付）
		Payment payRec = new Payment();
		payRec.setOrderNo(orderNo);
		payRec.setChannel("offline"); // 默认渠道占位，避免DB非空/无默认值
		payRec.setStatus(0);
		payRec.setAmount(pay);
		payRec.setCreatedAt(LocalDateTime.now());
		payRec.setUpdatedAt(LocalDateTime.now());
		paymentMapper.insert(payRec);

		OrderSubmitVO vo = new OrderSubmitVO();
		vo.setOrderNo(orderNo);
		vo.setPayAmount(pay);
		return vo;
	}
} 