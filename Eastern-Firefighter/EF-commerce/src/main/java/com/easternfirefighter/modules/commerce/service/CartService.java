package com.easternfirefighter.modules.commerce.service;

import com.easternfirefighter.modules.commerce.dto.CartAddRequest;
import com.easternfirefighter.modules.commerce.dto.CartUpdateRequest;
import com.easternfirefighter.modules.commerce.vo.CartItemVO;

import java.util.List;

public interface CartService {
	List<CartItemVO> list(Long userId);
	void add(Long userId, CartAddRequest req);
	int updateQty(Long userId, CartUpdateRequest req);
	void remove(Long userId, Long id);
	void removeBatch(Long userId, List<Long> ids);
	void clear(Long userId);
} 