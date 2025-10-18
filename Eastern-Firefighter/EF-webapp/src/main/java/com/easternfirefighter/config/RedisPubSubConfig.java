package com.easternfirefighter.config;

import com.easternfirefighter.modules.sync.ProductChangeSubscriber;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;

@Configuration
public class RedisPubSubConfig {
	@Bean
	@ConditionalOnProperty(name = "app.redis.pubsub", havingValue = "true", matchIfMissing = false)
	public RedisMessageListenerContainer redisMessageListenerContainer(RedisConnectionFactory connectionFactory, ProductChangeSubscriber subscriber) {
		RedisMessageListenerContainer container = new RedisMessageListenerContainer();
		container.setConnectionFactory(connectionFactory);
		container.addMessageListener(subscriber, new PatternTopic("product.changed"));
		return container;
	}
} 