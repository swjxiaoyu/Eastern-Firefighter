package com.easternfirefighter.modules.auth.service;

import com.easternfirefighter.modules.auth.dto.ProfileUpdateRequest;
import com.easternfirefighter.modules.auth.entity.UserAccount;

public interface ProfileService {
	UserAccount me(Long userId);
	void update(Long userId, ProfileUpdateRequest req);
	void setPassword(Long userId, String rawPassword);
	void changePassword(Long userId, String oldPassword, String newPassword);
} 