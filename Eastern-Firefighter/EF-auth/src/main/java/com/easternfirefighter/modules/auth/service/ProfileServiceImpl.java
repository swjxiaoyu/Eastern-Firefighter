package com.easternfirefighter.modules.auth.service;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.easternfirefighter.modules.auth.dto.ProfileUpdateRequest;
import com.easternfirefighter.modules.auth.entity.UserAccount;
import com.easternfirefighter.modules.auth.entity.repository.mapper.UserAccountMapper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class ProfileServiceImpl implements ProfileService {
	private final UserAccountMapper userAccountMapper;
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	public ProfileServiceImpl(UserAccountMapper userAccountMapper) {
		this.userAccountMapper = userAccountMapper;
	}

	@Override
	public UserAccount me(Long userId) {
		return userAccountMapper.selectById(userId);
	}

	@Override
	public void update(Long userId, ProfileUpdateRequest req) {
		LambdaUpdateWrapper<UserAccount> uw = new LambdaUpdateWrapper<>();
		uw.eq(UserAccount::getId, userId)
			.set(req.getRealName() != null, UserAccount::getRealName, req.getRealName())
			.set(req.getGender() != null, UserAccount::getGender, req.getGender())
			.set(req.getBirthday() != null, UserAccount::getBirthday, req.getBirthday())
			.set(req.getAvatarUrl() != null, UserAccount::getAvatarUrl, req.getAvatarUrl());
		userAccountMapper.update(null, uw);
	}

	@Override
	public void setPassword(Long userId, String rawPassword) {
		String hash = passwordEncoder.encode(rawPassword);
		userAccountMapper.update(null, new LambdaUpdateWrapper<UserAccount>()
			.eq(UserAccount::getId, userId)
			.set(UserAccount::getPasswordHash, hash));
	}

	@Override
	public void changePassword(Long userId, String oldPassword, String newPassword) {
		UserAccount ua = userAccountMapper.selectById(userId);
		if (ua == null || ua.getPasswordHash() == null) throw new IllegalArgumentException("账户不存在或未设置密码");
		if (!passwordEncoder.matches(oldPassword, ua.getPasswordHash())) throw new IllegalArgumentException("原密码不正确");
		String hash = passwordEncoder.encode(newPassword);
		userAccountMapper.update(null, new LambdaUpdateWrapper<UserAccount>()
			.eq(UserAccount::getId, userId)
			.set(UserAccount::getPasswordHash, hash));
	}
} 