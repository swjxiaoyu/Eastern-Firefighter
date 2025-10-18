package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.entity.Product;
import com.easternfirefighter.modules.commerce.repository.mapper.ProductMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductQueryServiceImpl implements ProductQueryService {
	private final ProductMapper productMapper;

	@Override
	public Page<Product> page(String keyword, Long categoryId, int page, int size) {
		LambdaQueryWrapper<Product> wrapper = new LambdaQueryWrapper<>();
		if (keyword != null && !keyword.trim().isEmpty()) {
			wrapper.like(Product::getName, keyword);
		}
		if (categoryId != null) {
			wrapper.eq(Product::getCategoryId, categoryId);
		}
		wrapper.eq(Product::getDeleted, 0);
		return productMapper.selectPage(new Page<>(page, size), wrapper);
	}

	@Override
	public Product detail(Long id) {
		return productMapper.selectById(id);
	}
} 