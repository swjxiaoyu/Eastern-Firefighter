package com.easternfirefighter.modules.auth.service;

import com.easternfirefighter.config.AuthProperties;
import com.easternfirefighter.modules.auth.entity.AuthSmsLog;
import com.easternfirefighter.modules.auth.entity.repository.mapper.AuthSmsLogMapper;
import com.easternfirefighter.util.CryptoUtils;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;

@Service
public class SmsServiceImpl implements SmsService {
	private final AuthSmsLogMapper smsLogMapper;
	private final AuthProperties props;
	private final Random random = new Random();

	public SmsServiceImpl(AuthSmsLogMapper smsLogMapper, AuthProperties props) {
		this.smsLogMapper = smsLogMapper;
		this.props = props;
	}

	@Override
	public String sendCode(String phone, String scene, String ip) {
		String code = String.format("%06d", random.nextInt(1000000));
		String codeHash = CryptoUtils.sha256(code + props.getSms().getPepper());
		AuthSmsLog log = new AuthSmsLog();
		log.setPhone(phone);
		log.setScene(scene);
		log.setCodeHash(codeHash);
		log.setSendSuccess(1);
		log.setIp(ip);
		log.setRetryCount(0);
		LocalDateTime now = LocalDateTime.now();
		log.setSentAt(now);
		log.setCreatedAt(now);
		log.setUpdatedAt(now);
		smsLogMapper.insert(log);
		return props.getSms().isDevMode() ? code : ""; // 生产不回传明文
	}

	@Override
	public boolean verifyCode(String phone, String code, String scene) {
		String codeHash = CryptoUtils.sha256(code + props.getSms().getPepper());
		// 简化：查最近一条匹配hash的记录
		return smsLogMapper.selectCount(
			new com.baomidou.mybatisplus.core.conditions.query.QueryWrapper<AuthSmsLog>()
				.eq("phone", phone)
				.eq("scene", scene)
				.eq("code_hash", codeHash)
		) > 0;
	}
} 