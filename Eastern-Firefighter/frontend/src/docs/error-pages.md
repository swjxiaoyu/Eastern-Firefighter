# 错误页面与路由守卫文档

## 概述

本文档介绍了东方灭火侠平台的错误处理机制，包括错误页面、路由守卫和全局错误处理。

## 错误页面

### 1. 404 页面 (`/404`)
- **用途**: 页面不存在
- **组件**: `NotFound.vue`
- **触发条件**: 
  - 访问不存在的路由
  - API返回404状态码
- **功能**: 
  - 返回首页
  - 返回上页

### 2. 500 页面 (`/500`)
- **用途**: 服务器内部错误
- **组件**: `ServerError.vue`
- **触发条件**: 
  - 服务器返回5xx状态码
  - 路由守卫发生错误
- **功能**: 
  - 重试页面
  - 返回首页

### 3. 403 页面 (`/403`)
- **用途**: 权限不足
- **组件**: `Forbidden.vue`
- **触发条件**: 
  - 用户角色不符合要求
  - API返回403状态码
- **功能**: 
  - 返回首页
  - 返回上页

### 4. 网络错误页面 (`/network-error`)
- **用途**: 网络连接问题
- **组件**: `NetworkError.vue`
- **触发条件**: 
  - 网络连接失败
  - 请求超时
- **功能**: 
  - 重试连接
  - 返回首页

## 路由守卫

### 认证检查
```typescript
// 需要登录的页面
{ path: '/profile', meta: { auth: true } }
```

### 权限检查
```typescript
// 需要管理员权限
{ path: '/admin/articles', meta: { auth: true, admin: true } }

// 需要商家权限
{ path: '/merchant', meta: { auth: true, merchant: true } }
```

### 路由守卫逻辑
1. **认证检查**: 检查用户是否已登录
2. **角色检查**: 验证用户角色是否符合要求
3. **重定向处理**: 根据权限重定向到相应页面
4. **错误处理**: 捕获路由守卫中的错误

## 全局错误处理

### ErrorBoundary 组件
- 捕获子组件中的JavaScript错误
- 提供错误恢复机制
- 显示友好的错误界面

### HTTP 拦截器
- 自动处理API错误
- 根据状态码重定向到相应错误页面
- 记录错误日志

### 全局错误处理器
- 捕获未处理的Promise错误
- 捕获全局JavaScript错误
- 自动报告错误

## 使用示例

### 在组件中处理错误
```typescript
import { inject } from 'vue';

const errorHandler = inject('errorHandler');

// 手动触发错误
errorHandler.handleError(new Error('Something went wrong'));

// 清除错误
errorHandler.clearError();
```

### 自定义错误处理
```typescript
import { handleError, reportError } from '@/utils/errorHandler';

try {
  // 业务逻辑
} catch (error) {
  handleError(error);
  reportError(createErrorInfo(error));
}
```

## 错误页面样式

所有错误页面都采用统一的设计风格：
- 响应式布局
- 渐变背景
- 友好的图标和文案
- 操作按钮
- 移动端适配

## 最佳实践

### 1. 错误分类
- 网络错误：显示重试选项
- 权限错误：引导用户登录或申请权限
- 服务器错误：显示联系信息
- 页面不存在：提供导航选项

### 2. 用户体验
- 提供明确的错误信息
- 给出可行的解决方案
- 保持页面美观和一致性
- 支持键盘导航

### 3. 开发调试
- 在开发环境显示详细错误信息
- 在生产环境隐藏敏感信息
- 记录错误日志便于排查

## 配置说明

### 路由配置
```typescript
// 错误页面路由（按优先级排序）
{ path: '/404', component: () => import('@/views/errors/NotFound.vue') },
{ path: '/500', component: () => import('@/views/errors/ServerError.vue') },
{ path: '/403', component: () => import('@/views/errors/Forbidden.vue') },
{ path: '/network-error', component: () => import('@/views/errors/NetworkError.vue') },
// 通配符路由（必须放在最后）
{ path: '/:pathMatch(.*)*', component: () => import('@/views/errors/NotFound.vue') }
```

### HTTP 拦截器配置
```typescript
// 根据状态码自动重定向
if (err.response?.status === 401) {
  location.href = '/login';
} else if (err.response?.status === 403) {
  location.href = '/403';
} else if (err.response?.status === 404) {
  location.href = '/404';
} else if (err.response?.status >= 500) {
  location.href = '/500';
}
```

## 测试建议

### 1. 手动测试
- 访问不存在的URL
- 模拟网络错误
- 测试权限控制
- 验证错误页面功能

### 2. 自动化测试
- 单元测试错误处理函数
- 集成测试路由守卫
- E2E测试错误页面流程

## 维护说明

### 1. 错误监控
- 集成错误监控服务（如Sentry）
- 定期分析错误日志
- 优化错误处理逻辑

### 2. 用户反馈
- 收集用户反馈
- 改进错误页面设计
- 优化错误信息文案

### 3. 性能优化
- 懒加载错误页面组件
- 优化错误页面加载速度
- 减少不必要的重定向
