package com.easternfirefighter.modules.auth.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.auth.dto.AddressSaveRequest;
import com.easternfirefighter.modules.auth.entity.UserAddress;

public interface AddressService {
	Page<UserAddress> page(Long userId, int page, int size);
	void saveOrUpdate(Long userId, AddressSaveRequest req);
	void remove(Long userId, Long id);
	void setDefault(Long userId, Long id);
} 