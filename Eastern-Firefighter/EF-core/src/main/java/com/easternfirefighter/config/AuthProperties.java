package com.easternfirefighter.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

@Data
@Component
@ConfigurationProperties(prefix = "auth")
public class AuthProperties {
	private Sms sms = new Sms();
	private Session session = new Session();
	private Dev dev = new Dev();

	@Data
	public static class Sms {
		private boolean devMode = true;
		private int codeTtlSeconds = 300;
		private String pepper = "change_me";
	}

	@Data
	public static class Session {
		private int ttlMinutes = 10080; // 7 days
	}

	@Data
	public static class Dev {
		private boolean bypassAuth = true; // 非生产环境下默认放行，便于测试
		private Long testUserId = 1L; // 测试用户ID
	}
} 