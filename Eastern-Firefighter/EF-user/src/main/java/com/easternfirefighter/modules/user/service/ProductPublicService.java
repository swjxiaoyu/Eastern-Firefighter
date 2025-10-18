package com.easternfirefighter.modules.user.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.entity.Product;
import com.easternfirefighter.modules.commerce.entity.ProductSku;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductSkuMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.Duration;
import java.util.*;

@Slf4j
@Service
public class ProductPublicService {
	private final ProductMapper productMapper;
	private final ProductSkuMapper productSkuMapper;
	private final StringRedisTemplate stringRedisTemplate;

	public ProductPublicService(ProductMapper productMapper, ProductSkuMapper productSkuMapper, StringRedisTemplate stringRedisTemplate) {
		this.productMapper = productMapper;
		this.productSkuMapper = productSkuMapper;
		this.stringRedisTemplate = stringRedisTemplate;
	}

	public Page<Product> page(String keyword, Long categoryId, int page, int size) {
		String key = "product:list:public:" + (keyword == null ? "" : keyword) + ":" + (categoryId == null ? "" : categoryId) + ":" + page + ":" + size;
		String cached = safeGet(key);
		if (cached != null && cached.startsWith("page:")) {
			// 简化：此处省略反序列化，直接走数据库。可以换成 JSON 序列化 Page 数据。
		}
		LambdaQueryWrapper<Product> qw = new LambdaQueryWrapper<>();
		qw.eq(Product::getDeleted, 0).eq(Product::getStatus, 1)
			.eq(categoryId != null, Product::getCategoryId, categoryId)
			.like(keyword != null && !keyword.isBlank(), Product::getName, keyword)
			.orderByDesc(Product::getUpdatedAt);
		Page<Product> po = productMapper.selectPage(Page.of(page, size), qw);
		po.getRecords().removeIf(p -> p.getMerchantId() != null && !isMerchantApproved(p.getMerchantId()));

		if (!po.getRecords().isEmpty()) {
			List<Long> productIds = po.getRecords().stream().map(Product::getId).toList();
			List<ProductSku> skus = productSkuMapper.selectList(new LambdaQueryWrapper<ProductSku>()
				.in(ProductSku::getProductId, productIds)
				.eq(ProductSku::getDeleted, 0)
				.eq(ProductSku::getStatus, 1));
			Map<Long, BigDecimal> minMap = new HashMap<>();
			for (ProductSku s : skus) {
				BigDecimal price = s.getPrice() == null ? BigDecimal.ZERO : s.getPrice();
				minMap.merge(s.getProductId(), price, (a, b) -> (a == null || (b != null && b.compareTo(a) < 0)) ? b : a);
			}
			po.getRecords().forEach(p -> {
				BigDecimal mp = minMap.get(p.getId());
				if (mp != null && (p.getPrice() == null || p.getPrice().compareTo(mp) != 0)) p.setPrice(mp);
			});
		}

		safeSet(key, "page:" + po.getTotal(), Duration.ofMinutes(2));
		return po;
	}

	public Product detail(Long id) {
		String key = "product:public:" + id;
		String cached = safeGet(key);
		Product p = productMapper.selectById(id);
		if (p == null || p.getDeleted() != null && p.getDeleted() == 1 || p.getStatus() == null || p.getStatus() != 1) return null;
		if (p.getMerchantId() != null && !isMerchantApproved(p.getMerchantId())) return null;
		List<ProductSku> skus = productSkuMapper.selectList(new LambdaQueryWrapper<ProductSku>()
			.eq(ProductSku::getProductId, id)
			.eq(ProductSku::getDeleted, 0)
			.eq(ProductSku::getStatus, 1));
		BigDecimal mp = skus.stream().map(ProductSku::getPrice).filter(Objects::nonNull).min(Comparator.naturalOrder()).orElse(null);
		if (mp != null) p.setPrice(mp);
		safeSet(key, "1", Duration.ofMinutes(2));
		return p;
	}

	private String safeGet(String key) {
		try { return stringRedisTemplate.opsForValue().get(key); } catch (Exception e) {
			if (log.isDebugEnabled()) log.debug("redis get fallback key={} err={}", key, e.getMessage());
			return null;
		}
	}

	private void safeSet(String key, String value, Duration ttl) {
		try { stringRedisTemplate.opsForValue().set(key, value, ttl); } catch (Exception e) {
			if (log.isDebugEnabled()) log.debug("redis set fallback key={} err={}", key, e.getMessage());
		}
	}

	private boolean isMerchantApproved(Long merchantId) {
		// 简化为默认通过，避免对 EF-merchant 的编译期强依赖
		return true;
	}
}