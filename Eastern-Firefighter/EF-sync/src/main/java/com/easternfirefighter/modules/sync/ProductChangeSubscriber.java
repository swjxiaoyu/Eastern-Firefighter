package com.easternfirefighter.modules.sync;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Component;

@Component
public class ProductChangeSubscriber implements MessageListener {
	private static final Logger log = LoggerFactory.getLogger(ProductChangeSubscriber.class);
	private final StringRedisTemplate stringRedisTemplate;

	public ProductChangeSubscriber(StringRedisTemplate stringRedisTemplate) {
		this.stringRedisTemplate = stringRedisTemplate;
	}

	@Override
	public void onMessage(Message message, byte[] pattern) {
		String body = new String(message.getBody());
		log.info("on product.changed: {}", body);
		// 简单失效：删除详情缓存与列表缓存
		try {
			// 详情：product:public:{id}
			Long id = extractId(body);
			if (id != null) {
				stringRedisTemplate.delete("product:public:" + id);
			}
			// 列表：粗暴策略，清空所有公共列表缓存
			var keys = stringRedisTemplate.keys("product:list:public:*");
			if (keys != null && !keys.isEmpty()) {
				stringRedisTemplate.delete(keys);
			}
		} catch (Exception ignored) {}
	}

	private Long extractId(String json) {
		try {
			int i = json.indexOf("\"id\":");
			if (i < 0) return null;
			int j = json.indexOf(',', i + 5);
			String sub = (j > 0 ? json.substring(i + 5, j) : json.substring(i + 5)).replaceAll("[^0-9]", "").trim();
			if (sub.isEmpty()) return null;
			return Long.parseLong(sub);
		} catch (Exception e) {
			return null;
		}
	}
} 