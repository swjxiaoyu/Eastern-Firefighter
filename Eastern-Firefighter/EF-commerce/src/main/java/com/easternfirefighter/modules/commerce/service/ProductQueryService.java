package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.entity.Product;

public interface ProductQueryService {
	Page<Product> page(String keyword, Long categoryId, int page, int size);
	Product detail(Long id);
} 