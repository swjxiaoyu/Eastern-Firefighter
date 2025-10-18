package com.easternfirefighter.modules.agent.tools;

import com.easternfirefighter.modules.agent.core.AgentCore;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.*;
import java.util.concurrent.CompletableFuture;

/**
 * 智能体工具集合
 * 提供各种自主操作能力
 */
@Slf4j
@Component
public class AgentTools {
    
    private final WebClient webClient;
    private final AgentCore agentCore;
    
    public AgentTools(AgentCore agentCore) {
        this.agentCore = agentCore;
        this.webClient = WebClient.builder().build();
        registerTools();
    }
    
    /**
     * 注册所有工具
     */
    private void registerTools() {
        agentCore.registerTool(new WebSearchTool());
        agentCore.registerTool(new FileOperationTool());
        agentCore.registerTool(new SystemInfoTool());
        agentCore.registerTool(new DatabaseQueryTool());
        agentCore.registerTool(new MemoryTool());
        agentCore.registerTool(new NetworkMonitorTool());
        agentCore.registerTool(new ProcessMonitorTool());
    }
    
    /**
     * 网络搜索工具
     */
    public class WebSearchTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "web_search";
        }
        
        @Override
        public String getDescription() {
            return "搜索网络信息，获取最新资讯";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("query", "搜索关键词");
            params.put("maxResults", "最大结果数量");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String query = (String) parameters.get("query");
                    int maxResults = (Integer) parameters.getOrDefault("maxResults", 5);
                    
                    // 模拟网络搜索（实际项目中可以接入真实的搜索API）
                    String result = performWebSearch(query, maxResults);
                    
                    // 保存搜索结果到记忆
                    agentCore.saveMemory(result, AgentCore.AgentMemory.MemoryType.SEMANTIC, 
                            Map.of("query", query, "timestamp", LocalDateTime.now()));
                    
                    return result;
                } catch (Exception e) {
                    log.error("网络搜索失败", e);
                    return "搜索失败: " + e.getMessage();
                }
            });
        }
        
        private String performWebSearch(String query, int maxResults) {
            // 这里可以接入真实的搜索API，如Google Search API、Bing API等
            // 目前返回模拟结果
            StringBuilder result = new StringBuilder();
            result.append("搜索结果 (关键词: ").append(query).append("):\n");
            
            for (int i = 1; i <= maxResults; i++) {
                result.append(i).append(". 标题: 关于").append(query).append("的信息\n");
                result.append("   摘要: 这是关于").append(query).append("的详细信息和最新动态\n");
                result.append("   来源: example.com\n");
                result.append("   时间: ").append(LocalDateTime.now().minusHours(i)).append("\n\n");
            }
            
            return result.toString();
        }
    }
    
    /**
     * 文件操作工具
     */
    public class FileOperationTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "file_operation";
        }
        
        @Override
        public String getDescription() {
            return "执行文件操作：读取、写入、创建、删除文件";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("operation", "操作类型: read/write/create/delete/list");
            params.put("path", "文件路径");
            params.put("content", "文件内容（写入时使用）");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String operation = (String) parameters.get("operation");
                    String path = (String) parameters.get("path");
                    
                    switch (operation.toLowerCase()) {
                        case "read":
                            return readFile(path);
                        case "write":
                            String content = (String) parameters.get("content");
                            return writeFile(path, content);
                        case "create":
                            return createFile(path);
                        case "delete":
                            return deleteFile(path);
                        case "list":
                            return listDirectory(path);
                        default:
                            return "不支持的操作: " + operation;
                    }
                } catch (Exception e) {
                    log.error("文件操作失败", e);
                    return "文件操作失败: " + e.getMessage();
                }
            });
        }
        
        private String readFile(String path) throws IOException {
            File file = new File(path);
            if (!file.exists()) {
                return "文件不存在: " + path;
            }
            
            String content = FileUtils.readFileToString(file, StandardCharsets.UTF_8);
            return "文件内容 (" + path + "):\n" + content;
        }
        
        private String writeFile(String path, String content) throws IOException {
            File file = new File(path);
            FileUtils.writeStringToFile(file, content, StandardCharsets.UTF_8);
            return "文件写入成功: " + path;
        }
        
        private String createFile(String path) throws IOException {
            File file = new File(path);
            if (file.createNewFile()) {
                return "文件创建成功: " + path;
            } else {
                return "文件已存在: " + path;
            }
        }
        
        private String deleteFile(String path) throws IOException {
            File file = new File(path);
            if (file.delete()) {
                return "文件删除成功: " + path;
            } else {
                return "文件删除失败: " + path;
            }
        }
        
        private String listDirectory(String path) {
            File dir = new File(path);
            if (!dir.exists() || !dir.isDirectory()) {
                return "目录不存在: " + path;
            }
            
            StringBuilder result = new StringBuilder();
            result.append("目录内容 (").append(path).append("):\n");
            
            File[] files = dir.listFiles();
            if (files != null) {
                for (File file : files) {
                    result.append(file.isDirectory() ? "[目录] " : "[文件] ")
                          .append(file.getName())
                          .append(" (大小: ").append(file.length()).append(" 字节)\n");
                }
            }
            
            return result.toString();
        }
    }
    
    /**
     * 系统信息工具
     */
    public class SystemInfoTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "system_info";
        }
        
        @Override
        public String getDescription() {
            return "获取系统信息：CPU、内存、磁盘、网络状态";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("type", "信息类型: all/cpu/memory/disk/network");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String type = (String) parameters.getOrDefault("type", "all");
                    return getSystemInfo(type);
                } catch (Exception e) {
                    log.error("获取系统信息失败", e);
                    return "获取系统信息失败: " + e.getMessage();
                }
            });
        }
        
        private String getSystemInfo(String type) {
            StringBuilder info = new StringBuilder();
            info.append("系统信息 (").append(LocalDateTime.now()).append("):\n\n");
            
            Runtime runtime = Runtime.getRuntime();
            
            if (type.equals("all") || type.equals("memory")) {
                long totalMemory = runtime.totalMemory();
                long freeMemory = runtime.freeMemory();
                long usedMemory = totalMemory - freeMemory;
                
                info.append("内存使用情况:\n");
                info.append("  总内存: ").append(totalMemory / 1024 / 1024).append(" MB\n");
                info.append("  已使用: ").append(usedMemory / 1024 / 1024).append(" MB\n");
                info.append("  可用内存: ").append(freeMemory / 1024 / 1024).append(" MB\n");
                info.append("  使用率: ").append(String.format("%.2f", (double) usedMemory / totalMemory * 100)).append("%\n\n");
            }
            
            if (type.equals("all") || type.equals("cpu")) {
                int processors = runtime.availableProcessors();
                info.append("CPU信息:\n");
                info.append("  处理器数量: ").append(processors).append("\n");
                info.append("  系统负载: ").append(System.getProperty("os.name")).append("\n\n");
            }
            
            if (type.equals("all") || type.equals("disk")) {
                File[] roots = File.listRoots();
                info.append("磁盘使用情况:\n");
                for (File root : roots) {
                    long totalSpace = root.getTotalSpace();
                    long freeSpace = root.getFreeSpace();
                    long usedSpace = totalSpace - freeSpace;
                    
                    info.append("  ").append(root.getPath()).append(":\n");
                    info.append("    总容量: ").append(totalSpace / 1024 / 1024 / 1024).append(" GB\n");
                    info.append("    已使用: ").append(usedSpace / 1024 / 1024 / 1024).append(" GB\n");
                    info.append("    可用空间: ").append(freeSpace / 1024 / 1024 / 1024).append(" GB\n");
                    info.append("    使用率: ").append(String.format("%.2f", (double) usedSpace / totalSpace * 100)).append("%\n");
                }
                info.append("\n");
            }
            
            return info.toString();
        }
    }
    
    /**
     * 数据库查询工具
     */
    public class DatabaseQueryTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "database_query";
        }
        
        @Override
        public String getDescription() {
            return "执行数据库查询操作";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("sql", "SQL查询语句");
            params.put("type", "查询类型: select/insert/update/delete");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String sql = (String) parameters.get("sql");
                    String type = (String) parameters.getOrDefault("type", "select");
                    
                    // 这里可以集成实际的数据库操作
                    // 目前返回模拟结果
                    return "数据库查询结果:\n" + sql + "\n查询类型: " + type + "\n结果: 模拟数据";
                } catch (Exception e) {
                    log.error("数据库查询失败", e);
                    return "数据库查询失败: " + e.getMessage();
                }
            });
        }
    }
    
    /**
     * 记忆管理工具
     */
    public class MemoryTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "save_memory";
        }
        
        @Override
        public String getDescription() {
            return "保存信息到智能体记忆";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("content", "要保存的内容");
            params.put("type", "记忆类型: SHORT_TERM/LONG_TERM/EPISODIC/SEMANTIC");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String content = (String) parameters.get("content");
                    String typeStr = (String) parameters.getOrDefault("type", "SEMANTIC");
                    
                    AgentCore.AgentMemory.MemoryType type = AgentCore.AgentMemory.MemoryType.valueOf(typeStr);
                    agentCore.saveMemory(content, type, Map.of("timestamp", LocalDateTime.now()));
                    
                    return "记忆保存成功: " + content.substring(0, Math.min(50, content.length()));
                } catch (Exception e) {
                    log.error("保存记忆失败", e);
                    return "保存记忆失败: " + e.getMessage();
                }
            });
        }
    }
    
    /**
     * 网络监控工具
     */
    public class NetworkMonitorTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "network_monitor";
        }
        
        @Override
        public String getDescription() {
            return "监控网络连接和状态";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("url", "要检查的URL");
            params.put("timeout", "超时时间（秒）");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String url = (String) parameters.get("url");
                    int timeout = (Integer) parameters.getOrDefault("timeout", 5);
                    
                    long startTime = System.currentTimeMillis();
                    String response = webClient.get()
                            .uri(url)
                            .retrieve()
                            .bodyToMono(String.class)
                            .timeout(java.time.Duration.ofSeconds(timeout))
                            .block();
                    
                    long responseTime = System.currentTimeMillis() - startTime;
                    
                    return String.format("网络检查结果:\nURL: %s\n响应时间: %d ms\n状态: 正常\n内容长度: %d 字符", 
                            url, responseTime, response != null ? response.length() : 0);
                } catch (Exception e) {
                    log.error("网络监控失败", e);
                    return "网络检查失败: " + e.getMessage();
                }
            });
        }
    }
    
    /**
     * 进程监控工具
     */
    public class ProcessMonitorTool implements AgentCore.AgentTool {
        @Override
        public String getName() {
            return "process_monitor";
        }
        
        @Override
        public String getDescription() {
            return "监控系统进程状态";
        }
        
        @Override
        public Map<String, Object> getParameters() {
            Map<String, Object> params = new HashMap<>();
            params.put("processName", "进程名称（可选）");
            return params;
        }
        
        @Override
        public CompletableFuture<String> execute(Map<String, Object> parameters) {
            return CompletableFuture.supplyAsync(() -> {
                try {
                    String processName = (String) parameters.get("processName");
                    
                    StringBuilder result = new StringBuilder();
                    result.append("进程监控信息:\n");
                    
                    if (processName != null && !processName.isEmpty()) {
                        result.append("查找进程: ").append(processName).append("\n");
                        // 这里可以添加具体的进程查找逻辑
                        result.append("进程状态: 运行中\n");
                    } else {
                        result.append("当前Java进程信息:\n");
                        result.append("  进程ID: ").append(ProcessHandle.current().pid()).append("\n");
                        result.append("  父进程ID: ").append(ProcessHandle.current().parent().map(ProcessHandle::pid).orElse(-1L)).append("\n");
                        result.append("  启动时间: ").append(ProcessHandle.current().info().startInstant().orElse(null)).append("\n");
                    }
                    
                    return result.toString();
                } catch (Exception e) {
                    log.error("进程监控失败", e);
                    return "进程监控失败: " + e.getMessage();
                }
            });
        }
    }
}

