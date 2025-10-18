package com.easternfirefighter.modules.agent.controller;

import com.easternfirefighter.modules.agent.core.AgentCore;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

/**
 * 智能体控制器
 * 提供REST API和SSE接口
 */
@Slf4j
@RestController
@RequestMapping("/api/agent")
public class AgentController {
    
    private final AgentCore agentCore;
    
    public AgentController(AgentCore agentCore) {
        this.agentCore = agentCore;
    }
    
    /**
     * 创建新任务
     */
    @PostMapping("/tasks")
    public ResponseEntity<Map<String, Object>> createTask(@RequestBody CreateTaskRequest request) {
        try {
            CompletableFuture<String> taskFuture = agentCore.createTask(request.getGoal(), request.getContext());
            String taskId = taskFuture.get();
            
            Map<String, Object> response = new HashMap<>();
            response.put("taskId", taskId);
            response.put("status", "created");
            response.put("message", "任务创建成功");
            
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("创建任务失败", e);
            Map<String, Object> error = new HashMap<>();
            error.put("error", "创建任务失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    /**
     * 获取任务状态
     */
    @GetMapping("/tasks/{taskId}")
    public ResponseEntity<AgentCore.AgentTask> getTask(@PathVariable String taskId) {
        AgentCore.AgentTask task = agentCore.getTask(taskId);
        if (task != null) {
            return ResponseEntity.ok(task);
        } else {
            return ResponseEntity.notFound().build();
        }
    }
    
    /**
     * 获取所有活跃任务
     */
    @GetMapping("/tasks")
    public ResponseEntity<Map<String, AgentCore.AgentTask>> getActiveTasks() {
        Map<String, AgentCore.AgentTask> tasks = agentCore.getActiveTasks();
        return ResponseEntity.ok(tasks);
    }
    
    /**
     * 暂停任务
     */
    @PostMapping("/tasks/{taskId}/pause")
    public ResponseEntity<Map<String, Object>> pauseTask(@PathVariable String taskId) {
        agentCore.pauseTask(taskId);
        Map<String, Object> response = new HashMap<>();
        response.put("taskId", taskId);
        response.put("status", "paused");
        response.put("message", "任务已暂停");
        return ResponseEntity.ok(response);
    }
    
    /**
     * 恢复任务
     */
    @PostMapping("/tasks/{taskId}/resume")
    public ResponseEntity<Map<String, Object>> resumeTask(@PathVariable String taskId) {
        agentCore.resumeTask(taskId);
        Map<String, Object> response = new HashMap<>();
        response.put("taskId", taskId);
        response.put("status", "resumed");
        response.put("message", "任务已恢复");
        return ResponseEntity.ok(response);
    }
    
    /**
     * 搜索记忆
     */
    @GetMapping("/memory/search")
    public ResponseEntity<List<AgentCore.AgentMemory>> searchMemory(
            @RequestParam String query,
            @RequestParam(defaultValue = "10") int limit) {
        List<AgentCore.AgentMemory> memories = agentCore.searchMemory(query, limit);
        return ResponseEntity.ok(memories);
    }
    
    /**
     * 保存记忆
     */
    @PostMapping("/memory")
    public ResponseEntity<Map<String, Object>> saveMemory(@RequestBody SaveMemoryRequest request) {
        try {
            agentCore.saveMemory(request.getContent(), request.getType(), request.getMetadata());
            Map<String, Object> response = new HashMap<>();
            response.put("status", "success");
            response.put("message", "记忆保存成功");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            log.error("保存记忆失败", e);
            Map<String, Object> error = new HashMap<>();
            error.put("error", "保存记忆失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(error);
        }
    }
    
    /**
     * 任务状态SSE流
     */
    @GetMapping(value = "/tasks/{taskId}/stream", produces = "text/event-stream")
    public SseEmitter streamTaskStatus(@PathVariable String taskId) {
        SseEmitter emitter = new SseEmitter(30000L); // 30秒超时
        
        // 启动任务状态监控
        CompletableFuture.runAsync(() -> {
            try {
                AgentCore.AgentTask task = agentCore.getTask(taskId);
                if (task == null) {
                    emitter.send(SseEmitter.event()
                            .name("error")
                            .data("任务不存在: " + taskId));
                    emitter.complete();
                    return;
                }
                
                // 发送初始状态
                emitter.send(SseEmitter.event()
                        .name("status")
                        .data(Map.of(
                                "taskId", taskId,
                                "status", task.getStatus().toString(),
                                "timestamp", LocalDateTime.now()
                        )));
                
                // 监控任务状态变化
                AgentCore.AgentTask.TaskStatus lastStatus = task.getStatus();
                while (!emitter.getTimeout() && task.getStatus() != AgentCore.AgentTask.TaskStatus.COMPLETED 
                       && task.getStatus() != AgentCore.AgentTask.TaskStatus.FAILED) {
                    
                    task = agentCore.getTask(taskId);
                    if (task == null) break;
                    
                    if (task.getStatus() != lastStatus) {
                        emitter.send(SseEmitter.event()
                                .name("status")
                                .data(Map.of(
                                        "taskId", taskId,
                                        "status", task.getStatus().toString(),
                                        "timestamp", LocalDateTime.now()
                                )));
                        lastStatus = task.getStatus();
                    }
                    
                    // 发送动作执行状态
                    if (task.getActions() != null) {
                        for (AgentCore.AgentAction action : task.getActions()) {
                            if (action.getStatus() == AgentCore.AgentAction.ActionStatus.COMPLETED 
                                && action.getResult() != null) {
                                emitter.send(SseEmitter.event()
                                        .name("action_result")
                                        .data(Map.of(
                                                "actionId", action.getActionId(),
                                                "toolName", action.getToolName(),
                                                "result", action.getResult(),
                                                "timestamp", LocalDateTime.now()
                                        )));
                            }
                        }
                    }
                    
                    Thread.sleep(1000); // 每秒检查一次
                }
                
                // 发送最终结果
                if (task != null) {
                    emitter.send(SseEmitter.event()
                            .name("final_result")
                            .data(Map.of(
                                    "taskId", taskId,
                                    "status", task.getStatus().toString(),
                                    "result", task.getResult() != null ? task.getResult() : "",
                                    "timestamp", LocalDateTime.now()
                            )));
                }
                
                emitter.complete();
                
            } catch (IOException e) {
                log.error("SSE流发送失败", e);
                emitter.completeWithError(e);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                emitter.completeWithError(e);
            }
        });
        
        return emitter;
    }
    
    /**
     * 智能体健康检查
     */
    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", LocalDateTime.now());
        health.put("activeTasks", agentCore.getActiveTasks().size());
        health.put("availableTools", 7); // 当前可用的工具数量
        return ResponseEntity.ok(health);
    }
    
    /**
     * 创建任务请求
     */
    @Data
    public static class CreateTaskRequest {
        private String goal;
        private Map<String, Object> context;
    }
    
    /**
     * 保存记忆请求
     */
    @Data
    public static class SaveMemoryRequest {
        private String content;
        private AgentCore.AgentMemory.MemoryType type;
        private Map<String, Object> metadata;
    }
}

