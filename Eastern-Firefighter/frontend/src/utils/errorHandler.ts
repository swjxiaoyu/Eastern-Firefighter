/**
 * 错误处理工具函数
 * 提供统一的错误处理和报告机制
 */

export interface ErrorInfo {
  message: string;
  stack?: string;
  url?: string;
  timestamp: string;
  userAgent: string;
  userId?: string;
}

/**
 * 错误类型枚举
 */
export enum ErrorType {
  NETWORK = 'NETWORK',
  AUTH = 'AUTH',
  PERMISSION = 'PERMISSION',
  NOT_FOUND = 'NOT_FOUND',
  SERVER = 'SERVER',
  UNKNOWN = 'UNKNOWN'
}

/**
 * 根据错误信息判断错误类型
 */
export function getErrorType(error: any): ErrorType {
  if (!error.response) {
    return ErrorType.NETWORK;
  }
  
  const status = error.response.status;
  
  switch (status) {
    case 401:
      return ErrorType.AUTH;
    case 403:
      return ErrorType.PERMISSION;
    case 404:
      return ErrorType.NOT_FOUND;
    case 500:
    case 502:
    case 503:
    case 504:
      return ErrorType.SERVER;
    default:
      return ErrorType.UNKNOWN;
  }
}

/**
 * 创建错误信息对象
 */
export function createErrorInfo(error: any, userId?: string): ErrorInfo {
  return {
    message: error.message || '未知错误',
    stack: error.stack,
    url: window.location.href,
    timestamp: new Date().toISOString(),
    userAgent: navigator.userAgent,
    userId
  };
}

/**
 * 处理错误并重定向到相应页面
 */
export function handleError(error: any, userId?: string): void {
  const errorType = getErrorType(error);
  const errorInfo = createErrorInfo(error, userId);
  
  // 记录错误日志
  console.error('Error handled:', errorInfo);
  
  // 根据错误类型重定向
  switch (errorType) {
    case ErrorType.NETWORK:
      window.location.href = '/network-error';
      break;
    case ErrorType.AUTH:
      localStorage.removeItem('token');
      window.location.href = '/login';
      break;
    case ErrorType.PERMISSION:
      window.location.href = '/403';
      break;
    case ErrorType.NOT_FOUND:
      window.location.href = '/404';
      break;
    case ErrorType.SERVER:
      window.location.href = '/500';
      break;
    default:
      window.location.href = '/500';
  }
}

/**
 * 报告错误到服务器
 */
export async function reportError(errorInfo: ErrorInfo): Promise<void> {
  try {
    // 这里可以集成错误报告服务，如 Sentry、Bugsnag 等
    console.log('Reporting error:', errorInfo);
    
    // 示例：发送到后端API
    // await fetch('/api/errors', {
    //   method: 'POST',
    //   headers: { 'Content-Type': 'application/json' },
    //   body: JSON.stringify(errorInfo)
    // });
  } catch (reportError) {
    console.error('Failed to report error:', reportError);
  }
}

/**
 * 全局错误处理器
 */
export function setupGlobalErrorHandler(): void {
  // 捕获未处理的Promise错误
  window.addEventListener('unhandledrejection', (event) => {
    console.error('Unhandled promise rejection:', event.reason);
    handleError(event.reason);
  });
  
  // 捕获全局JavaScript错误
  window.addEventListener('error', (event) => {
    console.error('Global error:', event.error);
    handleError(event.error);
  });
}
