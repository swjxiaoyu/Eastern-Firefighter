package com.easternfirefighter.modules.commerce.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.commerce.dto.RefundApplyRequest;
import com.easternfirefighter.modules.commerce.entity.Refund;

public interface RefundService {
	Refund apply(Long userId, RefundApplyRequest req);
	Page<Refund> page(Long userId, int page, int size);
} 