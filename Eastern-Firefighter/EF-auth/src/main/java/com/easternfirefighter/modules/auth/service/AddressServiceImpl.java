package com.easternfirefighter.modules.auth.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.easternfirefighter.modules.auth.dto.AddressSaveRequest;
import com.easternfirefighter.modules.auth.entity.UserAddress;
import com.easternfirefighter.modules.auth.entity.repository.mapper.UserAddressMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class AddressServiceImpl implements AddressService {
	private final UserAddressMapper addressMapper;

	public AddressServiceImpl(UserAddressMapper addressMapper) {
		this.addressMapper = addressMapper;
	}

	@Override
	public Page<UserAddress> page(Long userId, int page, int size) {
		LambdaQueryWrapper<UserAddress> qw = new LambdaQueryWrapper<>();
		qw.eq(UserAddress::getUserId, userId).eq(UserAddress::getDeleted, 0).orderByDesc(UserAddress::getIsDefault).orderByDesc(UserAddress::getUpdatedAt);
		return addressMapper.selectPage(Page.of(page, size), qw);
	}

	@Override
	@Transactional
	public void saveOrUpdate(Long userId, AddressSaveRequest req) {
		UserAddress ua = new UserAddress();
		ua.setUserId(userId);
		ua.setContactName(req.getContactName());
		ua.setContactPhone(req.getContactPhone());
		ua.setCountry(req.getCountry());
		ua.setProvince(req.getProvince());
		ua.setCity(req.getCity());
		ua.setDistrict(req.getDistrict());
		ua.setAddressLine(req.getAddressLine());
		ua.setPostalCode(req.getPostalCode());
		ua.setIsDefault(req.getIsDefault() != null ? req.getIsDefault() : 0);
		ua.setUpdatedAt(LocalDateTime.now());

		if (req.getId() == null) {
			// 去重：同一用户相同姓名+电话+地址则视为更新
			UserAddress exist = addressMapper.selectOne(new LambdaQueryWrapper<UserAddress>()
				.eq(UserAddress::getUserId, userId)
				.eq(UserAddress::getContactName, req.getContactName())
				.eq(UserAddress::getContactPhone, req.getContactPhone())
				.eq(UserAddress::getAddressLine, req.getAddressLine())
				.eq(UserAddress::getDeleted, 0)
				.last("limit 1"));
			if (exist != null) {
				ua.setId(exist.getId());
				addressMapper.updateById(ua);
			} else {
			ua.setCreatedAt(LocalDateTime.now());
			addressMapper.insert(ua);
			}
		} else {
			ua.setId(req.getId());
			addressMapper.updateById(ua);
		}
		// 仅当设为默认时，清空其他地址的默认，并确保当前为默认
		if (ua.getIsDefault() != null && ua.getIsDefault() == 1) {
			LambdaUpdateWrapper<UserAddress> clear = new LambdaUpdateWrapper<>();
			clear.eq(UserAddress::getUserId, userId).ne(UserAddress::getId, ua.getId()).set(UserAddress::getIsDefault, 0);
			addressMapper.update(null, clear);
			LambdaUpdateWrapper<UserAddress> ensure = new LambdaUpdateWrapper<>();
			ensure.eq(UserAddress::getUserId, userId).eq(UserAddress::getId, ua.getId()).set(UserAddress::getIsDefault, 1);
			addressMapper.update(null, ensure);
		}
	}

	@Override
	public void remove(Long userId, Long id) {
		LambdaUpdateWrapper<UserAddress> uw = new LambdaUpdateWrapper<>();
		uw.eq(UserAddress::getUserId, userId).eq(UserAddress::getId, id).set(UserAddress::getDeleted, 1);
		addressMapper.update(null, uw);
	}

	@Override
	@Transactional
	public void setDefault(Long userId, Long id) {
		LambdaUpdateWrapper<UserAddress> uw0 = new LambdaUpdateWrapper<>();
		uw0.eq(UserAddress::getUserId, userId).set(UserAddress::getIsDefault, 0);
		addressMapper.update(null, uw0);
		LambdaUpdateWrapper<UserAddress> uw1 = new LambdaUpdateWrapper<>();
		uw1.eq(UserAddress::getUserId, userId).eq(UserAddress::getId, id).set(UserAddress::getIsDefault, 1);
		addressMapper.update(null, uw1);
	}
} 