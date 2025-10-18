package com.easternfirefighter.modules.auth.service;

public interface SmsService {
	String sendCode(String phone, String scene, String ip);
	boolean verifyCode(String phone, String code, String scene);
} 