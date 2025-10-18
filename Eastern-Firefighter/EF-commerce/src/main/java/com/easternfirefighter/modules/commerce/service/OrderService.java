package com.easternfirefighter.modules.commerce.service;

import com.easternfirefighter.modules.commerce.dto.OrderSubmitRequest;
import com.easternfirefighter.modules.commerce.vo.OrderSubmitVO;

public interface OrderService {
	OrderSubmitVO submit(Long userId, OrderSubmitRequest req);
} 