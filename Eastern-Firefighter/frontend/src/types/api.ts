/**
 * API接口类型定义
 * 为东方灭火侠平台提供完整的类型安全支持
 */

// ==================== 通用响应类型 ====================

export interface ApiResponse<T = any> {
  code: number;
  message: string;
  data: T;
}

// ==================== 商品相关类型 ====================

export interface Product {
  id: number;
  name: string;
  subtitle?: string;
  price: number;
  originPrice?: number;
  coverUrl?: string;
  mediaJson?: string;
  status: number;
  createdAt: string;
  updatedAt: string;
}

export interface ProductSku {
  id: number;
  productId: number;
  skuCode?: string;
  attrsJson?: string;
  price: number;
  stock: number;
  status: number;
}

export interface ProductDetailResponse {
  product: Product;
  skus: ProductSku[];
}

// ==================== 用户相关类型 ====================

export interface UserProfile {
  id: number;
  phone: string;
  realName?: string;
  gender?: number; // 0-未知, 1-男, 2-女
  birthday?: string;
  avatarUrl?: string;
  status: number;
  createdAt: string;
  updatedAt: string;
}

export interface ProfileUpdateRequest {
  realName?: string;
  gender?: number;
  birthday?: string;
  avatarUrl?: string;
}

export interface PasswordSetRequest {
  newPassword: string;
}

export interface PasswordChangeRequest {
  oldPassword: string;
  newPassword: string;
}

// ==================== 购物车相关类型 ====================

export interface CartAddRequest {
  skuId: number;
  quantity: number;
}

export interface CartItem {
  id: number;
  userId: number;
  skuId: number;
  quantity: number;
  createdAt: string;
  updatedAt: string;
}

// ==================== 错误类型 ====================

export interface ApiError {
  code: number;
  message: string;
  details?: any;
}

// ==================== 分页相关类型 ====================

export interface PageQuery {
  page?: number;
  size?: number;
}

export interface PageResponse<T> {
  list: T[];
  total: number;
  page: number;
  size: number;
}

// ==================== 认证相关类型 ====================

export interface LoginResponse {
  userId: number;
  token: string;
}

export interface SmsSendRequest {
  phone: string;
  scene: 'login' | 'register' | 'reset';
}

export interface SmsLoginRequest {
  phone: string;
  code: string;
  deviceInfo: string;
}

export interface PasswordLoginRequest {
  username?: string;
  phone?: string;
  password: string;
  deviceInfo: string;
}

export interface RegisterRequest {
  phone: string;
  code: string;
  password?: string;
  deviceInfo: string;
}
