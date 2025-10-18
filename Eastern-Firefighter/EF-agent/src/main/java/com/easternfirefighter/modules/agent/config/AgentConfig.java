package com.easternfirefighter.modules.agent.config;

import com.easternfirefighter.modules.agent.core.AgentCore;
import com.easternfirefighter.modules.agent.tools.AgentTools;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.Executor;

/**
 * 智能体配置类
 */
@Configuration
@EnableAsync
public class AgentConfig {
    
    /**
     * 智能体核心引擎
     */
    @Bean
    public AgentCore agentCore() {
        return new AgentCore();
    }
    
    /**
     * 智能体工具集合
     */
    @Bean
    public AgentTools agentTools(AgentCore agentCore) {
        return new AgentTools(agentCore);
    }
    
    /**
     * 异步任务执行器
     */
    @Bean(name = "agentTaskExecutor")
    public Executor agentTaskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(5);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("Agent-");
        executor.initialize();
        return executor;
    }
}

