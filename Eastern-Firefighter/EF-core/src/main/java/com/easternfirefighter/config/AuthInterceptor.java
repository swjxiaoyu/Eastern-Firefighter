package com.easternfirefighter.config;

import com.easternfirefighter.common.UserContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 认证拦截器
 * 解析JWT token并设置用户上下文
 */
@Component
public class AuthInterceptor implements HandlerInterceptor {
    
    private static final Logger log = LoggerFactory.getLogger(AuthInterceptor.class);
    
    @Autowired
    private AuthProperties authProperties;
    
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 清理之前的上下文
        UserContext.clear();
        
        // 开发模式下绕过认证
        if (authProperties.getDev().isBypassAuth()) {
            log.debug("开发模式：绕过认证，使用测试用户ID: {}", authProperties.getDev().getTestUserId());
            UserContext.setUserId(authProperties.getDev().getTestUserId());
            UserContext.setRole("USER");
            return true;
        }
        
        // 获取Authorization头
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            log.debug("未找到有效的Authorization头");
            return true; // 继续处理，让业务层决定是否需要认证
        }
        
        // 提取token
        String token = authHeader.substring(7);
        log.debug("解析token: {}", token);
        
        // 简化处理：在开发模式下，任何有效的Bearer token都使用测试用户ID
        if (token != null && !token.isEmpty()) {
            UserContext.setUserId(authProperties.getDev().getTestUserId());
            UserContext.setRole("USER");
            log.debug("设置用户上下文: userId={}", authProperties.getDev().getTestUserId());
        }
        
        return true;
    }
    
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 清理用户上下文
        UserContext.clear();
    }
}
