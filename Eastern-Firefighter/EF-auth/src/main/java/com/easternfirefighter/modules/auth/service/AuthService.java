package com.easternfirefighter.modules.auth.service;

import com.easternfirefighter.modules.auth.vo.LoginResponse;

public interface AuthService {
	LoginResponse loginBySms(String phone, String code, String deviceInfo, String ip);
	LoginResponse loginByPassword(String usernameOrPhone, String password, String deviceInfo, String ip);
	LoginResponse register(String phone, String code, String password, String deviceInfo, String ip);
} 