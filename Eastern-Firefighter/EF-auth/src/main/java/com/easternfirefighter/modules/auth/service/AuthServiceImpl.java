package com.easternfirefighter.modules.auth.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.easternfirefighter.config.AuthProperties;
import com.easternfirefighter.modules.auth.entity.AuthSession;
import com.easternfirefighter.modules.auth.entity.UserAccount;
import com.easternfirefighter.modules.auth.entity.repository.mapper.AuthSessionMapper;
import com.easternfirefighter.modules.auth.entity.repository.mapper.UserAccountMapper;
import com.easternfirefighter.modules.auth.vo.LoginResponse;
import com.easternfirefighter.util.CryptoUtils;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class AuthServiceImpl implements AuthService {
	private final SmsService smsService;
	private final UserAccountMapper userAccountMapper;
	private final AuthSessionMapper authSessionMapper;
	private final AuthProperties props;
	private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

	public AuthServiceImpl(SmsService smsService, UserAccountMapper userAccountMapper, AuthSessionMapper authSessionMapper, AuthProperties props) {
		this.smsService = smsService;
		this.userAccountMapper = userAccountMapper;
		this.authSessionMapper = authSessionMapper;
		this.props = props;
	}

	@Override
	@Transactional
	public LoginResponse loginBySms(String phone, String code, String deviceInfo, String ip) {
		boolean ok = smsService.verifyCode(phone, code, "login");
		if (!ok) {
			throw new IllegalArgumentException("验证码错误或已失效");
		}
		UserAccount user = userAccountMapper.selectOne(new LambdaQueryWrapper<UserAccount>().eq(UserAccount::getPhone, phone));
		if (user == null) {
			user = new UserAccount();
			user.setPhone(phone);
			user.setStatus(1);
			user.setCreatedAt(LocalDateTime.now());
			user.setUpdatedAt(LocalDateTime.now());
			userAccountMapper.insert(user);
		}
		String jti = CryptoUtils.newJti();
		AuthSession session = new AuthSession();
		session.setUserId(user.getId());
		session.setJti(jti);
		session.setDeviceInfo(deviceInfo);
		session.setIp(ip);
		session.setStatus(1);
		session.setExpiresAt(LocalDateTime.now().plusMinutes(props.getSession().getTtlMinutes()));
		session.setCreatedAt(LocalDateTime.now());
		session.setUpdatedAt(LocalDateTime.now());
		authSessionMapper.insert(session);

		LoginResponse resp = new LoginResponse();
		resp.setUserId(user.getId());
		resp.setToken(jti);
		return resp;
	}

	@Override
	@Transactional
	public LoginResponse loginByPassword(String usernameOrPhone, String password, String deviceInfo, String ip) {
		if (usernameOrPhone == null || usernameOrPhone.isBlank()) {
			throw new IllegalArgumentException("用户名或手机号不能为空");
		}
		UserAccount user;
		if (looksLikePhone(usernameOrPhone)) {
			user = userAccountMapper.selectOne(new LambdaQueryWrapper<UserAccount>().eq(UserAccount::getPhone, usernameOrPhone));
		} else {
			user = userAccountMapper.selectOne(new LambdaQueryWrapper<UserAccount>().eq(UserAccount::getEmail, usernameOrPhone));
		}
		if (user == null || user.getPasswordHash() == null) {
			throw new IllegalArgumentException("账户不存在或未设置密码");
		}
		if (!passwordEncoder.matches(password, user.getPasswordHash())) {
			throw new IllegalArgumentException("账号或密码错误");
		}
		String jti = CryptoUtils.newJti();
		AuthSession session = new AuthSession();
		session.setUserId(user.getId());
		session.setJti(jti);
		session.setDeviceInfo(deviceInfo);
		session.setIp(ip);
		session.setStatus(1);
		session.setExpiresAt(LocalDateTime.now().plusMinutes(props.getSession().getTtlMinutes()));
		session.setCreatedAt(LocalDateTime.now());
		session.setUpdatedAt(LocalDateTime.now());
		authSessionMapper.insert(session);

		LoginResponse resp = new LoginResponse();
		resp.setUserId(user.getId());
		resp.setToken(jti);
		return resp;
	}

	@Override
	@Transactional
	public LoginResponse register(String phone, String code, String password, String deviceInfo, String ip) {
		boolean ok = smsService.verifyCode(phone, code, "register");
		if (!ok) {
			throw new IllegalArgumentException("验证码错误或已失效");
		}
		UserAccount exist = userAccountMapper.selectOne(new LambdaQueryWrapper<UserAccount>().eq(UserAccount::getPhone, phone));
		if (exist != null) {
			throw new IllegalArgumentException("手机号已注册");
		}
		UserAccount user = new UserAccount();
		user.setPhone(phone);
		if (password != null && !password.isBlank()) {
			user.setPasswordHash(passwordEncoder.encode(password));
		}
		user.setStatus(1);
		user.setCreatedAt(LocalDateTime.now());
		user.setUpdatedAt(LocalDateTime.now());
		userAccountMapper.insert(user);

		String jti = CryptoUtils.newJti();
		AuthSession session = new AuthSession();
		session.setUserId(user.getId());
		session.setJti(jti);
		session.setDeviceInfo(deviceInfo);
		session.setIp(ip);
		session.setStatus(1);
		session.setExpiresAt(LocalDateTime.now().plusMinutes(props.getSession().getTtlMinutes()));
		session.setCreatedAt(LocalDateTime.now());
		session.setUpdatedAt(LocalDateTime.now());
		authSessionMapper.insert(session);

		LoginResponse resp = new LoginResponse();
		resp.setUserId(user.getId());
		resp.setToken(jti);
		return resp;
	}

	private boolean looksLikePhone(String v) {
		for (int i = 0; i < v.length(); i++) {
			char c = v.charAt(i);
			if (c < '0' || c > '9') return false;
		}
		return v.length() >= 6; // 粗略判断
	}
} 