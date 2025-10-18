package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.easternfirefighter.modules.auth.entity.UserAddress;
import com.easternfirefighter.modules.auth.entity.repository.mapper.UserAddressMapper;
import com.easternfirefighter.modules.commerce.dto.OrderDraftRequest;
import com.easternfirefighter.modules.commerce.entity.CartItem;
import com.easternfirefighter.modules.commerce.entity.Product;
import com.easternfirefighter.modules.commerce.entity.ProductSku;
import com.easternfirefighter.modules.commerce.repository.mapper.CartItemMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductSkuMapper;
import com.easternfirefighter.modules.commerce.vo.OrderDraftVO;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class OrderDraftServiceImpl implements OrderDraftService {
	private final CartItemMapper cartItemMapper;
	private final ProductSkuMapper skuMapper;
	private final ProductMapper productMapper;
	private final UserAddressMapper addressMapper;
	private final ObjectMapper objectMapper;

	public OrderDraftServiceImpl(CartItemMapper cartItemMapper, ProductSkuMapper skuMapper, ProductMapper productMapper, UserAddressMapper addressMapper, ObjectMapper objectMapper) {
		this.cartItemMapper = cartItemMapper;
		this.skuMapper = skuMapper;
		this.productMapper = productMapper;
		this.addressMapper = addressMapper;
		this.objectMapper = objectMapper;
	}

	@Override
	public OrderDraftVO createDraft(Long userId, OrderDraftRequest req) {
		List<CartItem> items = cartItemMapper.selectList(new LambdaQueryWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getSelected, 1)
			.eq(CartItem::getDeleted, 0));
		OrderDraftVO vo = new OrderDraftVO();
		vo.setItems(new ArrayList<>());
		BigDecimal total = BigDecimal.ZERO;
		if (!items.isEmpty()) {
			Set<Long> skuIds = items.stream().map(CartItem::getSkuId).collect(Collectors.toSet());
			List<ProductSku> skus = skuMapper.selectBatchIds(skuIds);
			Map<Long, ProductSku> skuMap = skus.stream().collect(Collectors.toMap(ProductSku::getId, s -> s));
			Set<Long> productIds = skus.stream().map(ProductSku::getProductId).collect(Collectors.toSet());
			List<Product> products = productMapper.selectBatchIds(productIds);
			Map<Long, Product> prodMap = products.stream().collect(Collectors.toMap(Product::getId, p -> p));

			for (CartItem ci : items) {
				ProductSku sku = skuMap.get(ci.getSkuId());
				if (sku == null) continue;
				Product p = prodMap.get(sku.getProductId());
				OrderDraftVO.Item it = new OrderDraftVO.Item();
				it.setSkuId(ci.getSkuId());
				it.setProductName(p != null ? p.getName() : null);
				it.setSkuAttrsJson(sku.getAttrsJson());
				it.setQuantity(ci.getQuantity());
				it.setPrice(sku.getPrice());
				BigDecimal amount = sku.getPrice().multiply(BigDecimal.valueOf(ci.getQuantity()));
				it.setAmount(amount);
				vo.getItems().add(it);
				total = total.add(amount);
			}
		}
		vo.setTotalAmount(total);
		vo.setDiscountAmount(BigDecimal.ZERO);
		vo.setFreightAmount(BigDecimal.ZERO);
		vo.setPayAmount(total);

		UserAddress addr = addressMapper.selectOne(new LambdaQueryWrapper<UserAddress>()
			.eq(UserAddress::getId, req.getAddressId())
			.eq(UserAddress::getUserId, userId)
			.eq(UserAddress::getDeleted, 0));
		if (addr == null) {
			throw new IllegalArgumentException("地址不存在或不可用");
		}
		try {
			var snap = new java.util.LinkedHashMap<String, Object>();
			snap.put("contactName", addr.getContactName());
			snap.put("contactPhone", addr.getContactPhone());
			snap.put("country", addr.getCountry());
			snap.put("province", addr.getProvince());
			snap.put("city", addr.getCity());
			snap.put("district", addr.getDistrict());
			snap.put("addressLine", addr.getAddressLine());
			snap.put("postalCode", addr.getPostalCode());
			vo.setAddressSnapshotJson(objectMapper.writeValueAsString(snap));
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return vo;
	}
} 