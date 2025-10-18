package com.easternfirefighter.modules.agent.core;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * 智能体核心引擎
 * 负责任务规划、执行控制、状态管理
 */
@Slf4j
@Component
public class AgentCore {
    
    private final ExecutorService executorService = Executors.newFixedThreadPool(10);
    private final Map<String, AgentTask> activeTasks = new ConcurrentHashMap<>();
    private final Map<String, AgentMemory> memories = new ConcurrentHashMap<>();
    private final List<AgentTool> availableTools = new ArrayList<>();
    
    /**
     * 智能体任务
     */
    @Data
    @JsonIgnoreProperties(ignoreUnknown = true)
    public static class AgentTask {
        private String taskId;
        private String goal;
        private TaskStatus status;
        private List<AgentAction> actions;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;
        private String result;
        private Map<String, Object> context;
        
        public enum TaskStatus {
            PLANNING, EXECUTING, PAUSED, COMPLETED, FAILED
        }
    }
    
    /**
     * 智能体动作
     */
    @Data
    public static class AgentAction {
        private String actionId;
        private String toolName;
        private Map<String, Object> parameters;
        private ActionStatus status;
        private String result;
        private LocalDateTime executedAt;
        
        public enum ActionStatus {
            PENDING, EXECUTING, COMPLETED, FAILED
        }
    }
    
    /**
     * 智能体记忆
     */
    @Data
    public static class AgentMemory {
        private String memoryId;
        private String content;
        private MemoryType type;
        private LocalDateTime createdAt;
        private LocalDateTime lastAccessedAt;
        private int accessCount;
        private Map<String, Object> metadata;
        
        public enum MemoryType {
            SHORT_TERM, LONG_TERM, EPISODIC, SEMANTIC
        }
    }
    
    /**
     * 智能体工具接口
     */
    public interface AgentTool {
        String getName();
        String getDescription();
        Map<String, Object> getParameters();
        CompletableFuture<String> execute(Map<String, Object> parameters);
    }
    
    /**
     * 创建新任务
     */
    public CompletableFuture<String> createTask(String goal, Map<String, Object> context) {
        return CompletableFuture.supplyAsync(() -> {
            String taskId = UUID.randomUUID().toString();
            AgentTask task = new AgentTask();
            task.setTaskId(taskId);
            task.setGoal(goal);
            task.setStatus(AgentTask.TaskStatus.PLANNING);
            task.setActions(new ArrayList<>());
            task.setCreatedAt(LocalDateTime.now());
            task.setUpdatedAt(LocalDateTime.now());
            task.setContext(context != null ? context : new HashMap<>());
            
            activeTasks.put(taskId, task);
            log.info("创建新任务: {} - {}", taskId, goal);
            
            // 开始任务规划
            planTask(taskId);
            
            return taskId;
        }, executorService);
    }
    
    /**
     * 任务规划
     */
    private void planTask(String taskId) {
        AgentTask task = activeTasks.get(taskId);
        if (task == null) return;
        
        try {
            task.setStatus(AgentTask.TaskStatus.PLANNING);
            task.setUpdatedAt(LocalDateTime.now());
            
            // 分析目标，生成行动计划
            List<AgentAction> actions = generateActionPlan(task.getGoal(), task.getContext());
            task.setActions(actions);
            
            task.setStatus(AgentTask.TaskStatus.EXECUTING);
            task.setUpdatedAt(LocalDateTime.now());
            
            // 开始执行任务
            executeTask(taskId);
            
        } catch (Exception e) {
            log.error("任务规划失败: {}", taskId, e);
            task.setStatus(AgentTask.TaskStatus.FAILED);
            task.setResult("任务规划失败: " + e.getMessage());
        }
    }
    
    /**
     * 生成行动计划
     */
    private List<AgentAction> generateActionPlan(String goal, Map<String, Object> context) {
        List<AgentAction> actions = new ArrayList<>();
        
        // 基于目标分析，生成具体的执行步骤
        // 这里可以根据不同的目标类型，生成不同的行动计划
        
        if (goal.contains("收集信息") || goal.contains("搜索")) {
            // 信息收集类任务
            AgentAction searchAction = new AgentAction();
            searchAction.setActionId(UUID.randomUUID().toString());
            searchAction.setToolName("web_search");
            searchAction.setParameters(Map.of("query", goal, "maxResults", 10));
            searchAction.setStatus(AgentAction.ActionStatus.PENDING);
            actions.add(searchAction);
            
            AgentAction saveAction = new AgentAction();
            saveAction.setActionId(UUID.randomUUID().toString());
            saveAction.setToolName("save_memory");
            saveAction.setParameters(Map.of("type", "SEMANTIC", "content", "搜索结果"));
            saveAction.setStatus(AgentAction.ActionStatus.PENDING);
            actions.add(saveAction);
            
        } else if (goal.contains("文件操作") || goal.contains("读写")) {
            // 文件操作类任务
            AgentAction fileAction = new AgentAction();
            fileAction.setActionId(UUID.randomUUID().toString());
            fileAction.setToolName("file_operation");
            fileAction.setParameters(Map.of("operation", "read", "path", context.getOrDefault("path", "")));
            fileAction.setStatus(AgentAction.ActionStatus.PENDING);
            actions.add(fileAction);
            
        } else if (goal.contains("系统监控") || goal.contains("状态检查")) {
            // 系统监控类任务
            AgentAction systemAction = new AgentAction();
            systemAction.setActionId(UUID.randomUUID().toString());
            systemAction.setToolName("system_info");
            systemAction.setParameters(Map.of("type", "all"));
            systemAction.setStatus(AgentAction.ActionStatus.PENDING);
            actions.add(systemAction);
        }
        
        return actions;
    }
    
    /**
     * 执行任务
     */
    private void executeTask(String taskId) {
        AgentTask task = activeTasks.get(taskId);
        if (task == null) return;
        
        CompletableFuture.runAsync(() -> {
            try {
                for (AgentAction action : task.getActions()) {
                    if (action.getStatus() == AgentAction.ActionStatus.PENDING) {
                        executeAction(action);
                    }
                }
                
                task.setStatus(AgentTask.TaskStatus.COMPLETED);
                task.setResult("任务执行完成");
                task.setUpdatedAt(LocalDateTime.now());
                
                log.info("任务执行完成: {}", taskId);
                
            } catch (Exception e) {
                log.error("任务执行失败: {}", taskId, e);
                task.setStatus(AgentTask.TaskStatus.FAILED);
                task.setResult("任务执行失败: " + e.getMessage());
                task.setUpdatedAt(LocalDateTime.now());
            }
        }, executorService);
    }
    
    /**
     * 执行动作
     */
    private void executeAction(AgentAction action) {
        try {
            action.setStatus(AgentAction.ActionStatus.EXECUTING);
            action.setExecutedAt(LocalDateTime.now());
            
            AgentTool tool = findTool(action.getToolName());
            if (tool != null) {
                CompletableFuture<String> result = tool.execute(action.getParameters());
                action.setResult(result.get());
                action.setStatus(AgentAction.ActionStatus.COMPLETED);
            } else {
                action.setResult("工具未找到: " + action.getToolName());
                action.setStatus(AgentAction.ActionStatus.FAILED);
            }
            
        } catch (Exception e) {
            log.error("动作执行失败: {}", action.getActionId(), e);
            action.setResult("执行失败: " + e.getMessage());
            action.setStatus(AgentAction.ActionStatus.FAILED);
        }
    }
    
    /**
     * 查找工具
     */
    private AgentTool findTool(String toolName) {
        return availableTools.stream()
                .filter(tool -> tool.getName().equals(toolName))
                .findFirst()
                .orElse(null);
    }
    
    /**
     * 注册工具
     */
    public void registerTool(AgentTool tool) {
        availableTools.add(tool);
        log.info("注册工具: {}", tool.getName());
    }
    
    /**
     * 获取任务状态
     */
    public AgentTask getTask(String taskId) {
        return activeTasks.get(taskId);
    }
    
    /**
     * 获取所有活跃任务
     */
    public Map<String, AgentTask> getActiveTasks() {
        return new HashMap<>(activeTasks);
    }
    
    /**
     * 暂停任务
     */
    public void pauseTask(String taskId) {
        AgentTask task = activeTasks.get(taskId);
        if (task != null) {
            task.setStatus(AgentTask.TaskStatus.PAUSED);
            task.setUpdatedAt(LocalDateTime.now());
        }
    }
    
    /**
     * 恢复任务
     */
    public void resumeTask(String taskId) {
        AgentTask task = activeTasks.get(taskId);
        if (task != null && task.getStatus() == AgentTask.TaskStatus.PAUSED) {
            task.setStatus(AgentTask.TaskStatus.EXECUTING);
            task.setUpdatedAt(LocalDateTime.now());
            executeTask(taskId);
        }
    }
    
    /**
     * 保存记忆
     */
    public void saveMemory(String content, AgentMemory.MemoryType type, Map<String, Object> metadata) {
        String memoryId = UUID.randomUUID().toString();
        AgentMemory memory = new AgentMemory();
        memory.setMemoryId(memoryId);
        memory.setContent(content);
        memory.setType(type);
        memory.setCreatedAt(LocalDateTime.now());
        memory.setLastAccessedAt(LocalDateTime.now());
        memory.setAccessCount(1);
        memory.setMetadata(metadata != null ? metadata : new HashMap<>());
        
        memories.put(memoryId, memory);
        log.info("保存记忆: {} - {}", memoryId, content.substring(0, Math.min(50, content.length())));
    }
    
    /**
     * 检索记忆
     */
    public List<AgentMemory> searchMemory(String query, int limit) {
        return memories.values().stream()
                .filter(memory -> memory.getContent().toLowerCase().contains(query.toLowerCase()))
                .sorted((a, b) -> b.getLastAccessedAt().compareTo(a.getLastAccessedAt()))
                .limit(limit)
                .peek(memory -> {
                    memory.setLastAccessedAt(LocalDateTime.now());
                    memory.setAccessCount(memory.getAccessCount() + 1);
                })
                .toList();
    }
}

