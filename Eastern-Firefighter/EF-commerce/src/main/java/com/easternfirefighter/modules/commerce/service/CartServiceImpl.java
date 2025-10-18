package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.easternfirefighter.modules.commerce.dto.CartAddRequest;
import com.easternfirefighter.modules.commerce.dto.CartUpdateRequest;
import com.easternfirefighter.modules.commerce.entity.CartItem;
import com.easternfirefighter.modules.commerce.entity.Product;
import com.easternfirefighter.modules.commerce.entity.ProductSku;
import com.easternfirefighter.modules.commerce.repository.mapper.CartItemMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductSkuMapper;
import com.easternfirefighter.modules.commerce.vo.CartItemVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class CartServiceImpl implements CartService {
	private static final Logger log = LoggerFactory.getLogger(CartServiceImpl.class);
	private final CartItemMapper cartItemMapper;
	private final ProductSkuMapper skuMapper;
	private final ProductMapper productMapper;

	public CartServiceImpl(CartItemMapper cartItemMapper, ProductSkuMapper skuMapper, ProductMapper productMapper) {
		this.cartItemMapper = cartItemMapper;
		this.skuMapper = skuMapper;
		this.productMapper = productMapper;
	}

	@Override
	public List<CartItemVO> list(Long userId) {
		List<CartItem> items = cartItemMapper.selectList(new LambdaQueryWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getDeleted, 0)
			.orderByAsc(CartItem::getCreatedAt));
		if (items.isEmpty()) return Collections.emptyList();
		Set<Long> skuIds = items.stream().map(CartItem::getSkuId).collect(Collectors.toSet());
		List<ProductSku> skus = skuMapper.selectBatchIds(skuIds);
		Map<Long, ProductSku> skuMap = skus.stream().collect(Collectors.toMap(ProductSku::getId, s -> s));
		Set<Long> productIds = skus.stream().map(ProductSku::getProductId).collect(Collectors.toSet());
		List<Product> products = productMapper.selectBatchIds(productIds);
		Map<Long, Product> prodMap = products.stream().collect(Collectors.toMap(Product::getId, p -> p));
		List<CartItemVO> result = new ArrayList<>();
		for (CartItem ci : items) {
			ProductSku sku = skuMap.get(ci.getSkuId());
			if (sku == null) continue;
			Product p = prodMap.get(sku.getProductId());
			CartItemVO vo = new CartItemVO();
			vo.setId(String.valueOf(ci.getId()));
			vo.setSkuId(String.valueOf(ci.getSkuId()));
			vo.setProductId(String.valueOf(sku.getProductId()));
			vo.setProductName(p != null ? p.getName() : null);
			vo.setSkuAttrsJson(sku.getAttrsJson());
			vo.setQuantity(ci.getQuantity());
			vo.setSelected(ci.getSelected());
			vo.setPrice(sku.getPrice());
			vo.setCoverUrl(p != null ? p.getCoverUrl() : null);
			result.add(vo);
		}
		return result;
	}

	@Override
	@Transactional
	public void add(Long userId, CartAddRequest req) {
		// 校验 SKU 是否存在且可用
		ProductSku sku = skuMapper.selectById(req.getSkuId());
		if (sku == null || Objects.equals(sku.getDeleted(), 1) || !Objects.equals(sku.getStatus(), 1)) {
			throw new IllegalArgumentException("SKU 不存在或不可用");
		}
		CartItem existed = cartItemMapper.selectOne(new LambdaQueryWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getSkuId, req.getSkuId())
			.eq(CartItem::getDeleted, 0));
		// 直接使用请求中的数量，确保最小值为1
		int quantity = Math.max(1, req.getQuantity() != null ? req.getQuantity() : 1);
		
		if (existed == null) {
			// 商品不存在，直接添加
			cartItemMapper.upsertAdd(userId, req.getSkuId(), quantity);
		} else {
			// 商品已存在，直接设置为请求的数量（不累加）
			cartItemMapper.update(null, new LambdaUpdateWrapper<CartItem>()
				.eq(CartItem::getId, existed.getId())
				.set(CartItem::getQuantity, quantity)
				.set(CartItem::getUpdatedAt, LocalDateTime.now()));
		}
	}

	@Override
	public int updateQty(Long userId, CartUpdateRequest req) {
		log.info("[CART] updateQty userId={} itemId={} newQuantity={}", userId, req.getId(), req.getQuantity());

		Long itemId = Long.valueOf(req.getId());

		// 先查询当前数量
		CartItem current = cartItemMapper.selectOne(new LambdaQueryWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getId, itemId)
			.eq(CartItem::getDeleted, 0));

		if (current == null) {
			log.warn("[CART] updateQty failed: item not found userId={} itemId={}", userId, req.getId());
			return 0;
		}

		log.info("[CART] updateQty before: userId={} itemId={} oldQuantity={}", userId, req.getId(), current.getQuantity());

		int affected = cartItemMapper.update(null, new LambdaUpdateWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getId, itemId)
			.set(CartItem::getQuantity, req.getQuantity()));

		log.info("[CART] updateQty after: userId={} itemId={} newQuantity={} affected={}",
			userId, req.getId(), req.getQuantity(), affected);

		return affected;
	}

	@Override
	public void remove(Long userId, Long id) {
		System.out.println("[CART_SERVICE] 删除购物车项: userId=" + userId + ", itemId=" + id);
		int affected = cartItemMapper.update(null, new LambdaUpdateWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.eq(CartItem::getId, id)
			.set(CartItem::getDeleted, 1)
			.set(CartItem::getUpdatedAt, LocalDateTime.now()));
		System.out.println("[CART_SERVICE] 删除结果: affected=" + affected);
	}

	@Override
	public void removeBatch(Long userId, List<Long> ids) {
		if (ids == null || ids.isEmpty()) {
			System.out.println("[CART_SERVICE] 批量删除: ids为空，跳过删除");
			return;
		}
		System.out.println("[CART_SERVICE] 批量删除购物车项: userId=" + userId + ", ids=" + ids);
		
		// 先查询要删除的商品，确认它们存在
		List<CartItem> itemsToDelete = cartItemMapper.selectList(new LambdaQueryWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.in(CartItem::getId, ids)
			.eq(CartItem::getDeleted, 0));
		System.out.println("[CART_SERVICE] 找到要删除的商品数量: " + itemsToDelete.size());
		
		if (itemsToDelete.isEmpty()) {
			System.out.println("[CART_SERVICE] 没有找到要删除的商品，可能已经被删除");
			return;
		}
		
		int affected = cartItemMapper.update(null, new LambdaUpdateWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.in(CartItem::getId, ids)
			.set(CartItem::getDeleted, 1)
			.set(CartItem::getUpdatedAt, LocalDateTime.now()));
		System.out.println("[CART_SERVICE] 批量删除结果: affected=" + affected);
		
		if (affected == 0) {
			System.out.println("[CART_SERVICE] 警告: 没有商品被删除，可能数据库操作失败");
		}
	}

	@Override
	public void clear(Long userId) {
		System.out.println("[CART_SERVICE] 清空购物车: userId=" + userId);
		int affected = cartItemMapper.update(null, new LambdaUpdateWrapper<CartItem>()
			.eq(CartItem::getUserId, userId)
			.set(CartItem::getDeleted, 1)
			.set(CartItem::getUpdatedAt, LocalDateTime.now()));
		System.out.println("[CART_SERVICE] 清空购物车结果: affected=" + affected);
	}
} 