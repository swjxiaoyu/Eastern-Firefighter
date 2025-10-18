package com.easternfirefighter.modules.commerce.service;

import com.easternfirefighter.modules.commerce.dto.OrderDraftRequest;
import com.easternfirefighter.modules.commerce.vo.OrderDraftVO;

public interface OrderDraftService {
	OrderDraftVO createDraft(Long userId, OrderDraftRequest req);
} 