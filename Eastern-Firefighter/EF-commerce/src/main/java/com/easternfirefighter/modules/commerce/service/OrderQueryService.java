package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.vo.OrderDetailVO;
import com.easternfirefighter.modules.commerce.vo.OrderListItemVO;

public interface OrderQueryService {
	Page<OrderListItemVO> page(Long userId, int page, int size);
	Page<OrderListItemVO> page(Long userId, Integer status, int page, int size);
	OrderDetailVO detail(Long userId, String orderNo);
} 