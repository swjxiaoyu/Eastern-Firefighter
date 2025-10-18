package com.easternfirefighter.modules.user.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.common.ApiResponse;
import com.easternfirefighter.modules.commerce.entity.Product;
import com.easternfirefighter.modules.commerce.entity.ProductSku;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductSkuMapper;
import com.easternfirefighter.modules.user.service.ProductPublicService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user/products")
public class UserProductController {
	private final ProductPublicService productPublicService;
	private final ProductMapper productMapper;
	private final ProductSkuMapper productSkuMapper;

	public UserProductController(ProductPublicService productPublicService, ProductMapper productMapper, ProductSkuMapper productSkuMapper) {
		this.productPublicService = productPublicService;
		this.productMapper = productMapper;
		this.productSkuMapper = productSkuMapper;
	}

	@GetMapping
	public Page<Product> page(@RequestParam(required = false) String keyword,
	                          @RequestParam(required = false) Long categoryId,
	                          @RequestParam(defaultValue = "1") int page,
	                          @RequestParam(defaultValue = "20") int size) {
		return productPublicService.page(keyword, categoryId, page, size);
	}

	@GetMapping("/{id}")
	public Product detail(@PathVariable Long id) {
		return productPublicService.detail(id);
	}

	@GetMapping("/{id}/skus")
	public ApiResponse<List<ProductSku>> skus(@PathVariable Long id) {
		Product p = productMapper.selectById(id);
		if (p == null || p.getDeleted() != null && p.getDeleted() == 1 || p.getStatus() == null || p.getStatus() != 1) {
			return ApiResponse.success(List.of());
		}
		List<ProductSku> list = productSkuMapper.selectList(new LambdaQueryWrapper<ProductSku>()
			.eq(ProductSku::getProductId, id)
			.eq(ProductSku::getDeleted, 0)
			.eq(ProductSku::getStatus, 1));
		return ApiResponse.success(list);
	}
} 