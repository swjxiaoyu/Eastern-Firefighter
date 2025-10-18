package com.easternfirefighter.modules.agent.test;

import com.easternfirefighter.modules.agent.core.AgentCore;
import com.easternfirefighter.modules.agent.tools.AgentTools;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * 智能体功能测试
 * 在应用启动时自动运行测试用例
 */
@Slf4j
@Component
public class AgentTestRunner implements CommandLineRunner {
    
    private final AgentCore agentCore;
    private final AgentTools agentTools;
    
    public AgentTestRunner(AgentCore agentCore, AgentTools agentTools) {
        this.agentCore = agentCore;
        this.agentTools = agentTools;
    }
    
    @Override
    public void run(String... args) throws Exception {
        log.info("开始智能体功能测试...");
        
        // 测试1: 信息收集任务
        testInformationCollection();
        
        // 测试2: 文件操作任务
        testFileOperation();
        
        // 测试3: 系统监控任务
        testSystemMonitoring();
        
        // 测试4: 记忆管理
        testMemoryManagement();
        
        log.info("智能体功能测试完成！");
    }
    
    /**
     * 测试信息收集任务
     */
    private void testInformationCollection() {
        log.info("测试1: 信息收集任务");
        
        CompletableFuture<String> taskFuture = agentCore.createTask(
            "搜索最新的消防技术发展趋势",
            Map.of("category", "technology", "priority", "high")
        );
        
        taskFuture.thenAccept(taskId -> {
            log.info("信息收集任务创建成功: {}", taskId);
            
            // 等待任务完成
            CompletableFuture.runAsync(() -> {
                try {
                    Thread.sleep(5000); // 等待5秒
                    AgentCore.AgentTask task = agentCore.getTask(taskId);
                    if (task != null) {
                        log.info("任务状态: {}, 结果: {}", 
                                task.getStatus(), 
                                task.getResult() != null ? task.getResult().substring(0, Math.min(100, task.getResult().length())) : "无结果");
                    }
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                }
            });
        });
    }
    
    /**
     * 测试文件操作任务
     */
    private void testFileOperation() {
        log.info("测试2: 文件操作任务");
        
        CompletableFuture<String> taskFuture = agentCore.createTask(
            "读取项目配置文件",
            Map.of("path", "./README.md", "operation", "read")
        );
        
        taskFuture.thenAccept(taskId -> {
            log.info("文件操作任务创建成功: {}", taskId);
        });
    }
    
    /**
     * 测试系统监控任务
     */
    private void testSystemMonitoring() {
        log.info("测试3: 系统监控任务");
        
        CompletableFuture<String> taskFuture = agentCore.createTask(
            "检查系统资源使用情况",
            Map.of("type", "all", "alertThreshold", 80)
        );
        
        taskFuture.thenAccept(taskId -> {
            log.info("系统监控任务创建成功: {}", taskId);
        });
    }
    
    /**
     * 测试记忆管理
     */
    private void testMemoryManagement() {
        log.info("测试4: 记忆管理");
        
        // 保存测试记忆
        agentCore.saveMemory(
            "智能体系统测试完成，所有功能正常运行",
            AgentCore.AgentMemory.MemoryType.SEMANTIC,
            Map.of("testType", "system", "timestamp", System.currentTimeMillis())
        );
        
        // 搜索记忆
        var memories = agentCore.searchMemory("智能体", 5);
        log.info("搜索到 {} 条相关记忆", memories.size());
        
        for (var memory : memories) {
            log.info("记忆: {} - {}", memory.getType(), memory.getContent());
        }
    }
}

