/**
 * API服务层
 * 封装所有业务接口调用，提供类型安全的API调用方法
 */

import http from './http';
import type {
  ApiResponse,
  Product,
  ProductSku,
  UserProfile,
  ProfileUpdateRequest,
  PasswordSetRequest,
  PasswordChangeRequest,
  CartAddRequest,
  SmsSendRequest,
  SmsLoginRequest,
  PasswordLoginRequest,
  RegisterRequest,
  LoginResponse
} from '@/types/api';

/**
 * 商品相关API服务
 */
export class ProductService {
  /**
   * 获取商品详情
   * @param id 商品ID
   * @returns 商品详情
   */
  static async getProduct(id: number): Promise<Product> {
    const response = await http.get<ApiResponse<Product>>(`/user/products/${id}`);
    return response.data.data;
  }

  /**
   * 获取商品SKU列表
   * @param id 商品ID
   * @returns SKU列表
   */
  static async getProductSkus(id: number): Promise<ProductSku[]> {
    const response = await http.get<ApiResponse<ProductSku[]>>(`/user/products/${id}/skus`);
    return response.data.data;
  }

  /**
   * 加入购物车
   * @param request 购物车请求
   * @returns 操作结果
   */
  static async addToCart(request: CartAddRequest): Promise<void> {
    await http.post<ApiResponse>('/user/cart/add', request);
  }
}

/**
 * 用户相关API服务
 */
export class UserService {
  /**
   * 获取用户资料
   * @returns 用户资料
   */
  static async getProfile(): Promise<UserProfile> {
    const response = await http.get<ApiResponse<UserProfile>>('/auth/profile/me');
    return response.data.data;
  }

  /**
   * 更新用户资料
   * @param request 更新请求
   * @returns 操作结果
   */
  static async updateProfile(request: ProfileUpdateRequest): Promise<void> {
    await http.post<ApiResponse>('/auth/profile/update', request);
  }

  /**
   * 设置密码
   * @param request 设置密码请求
   * @returns 操作结果
   */
  static async setPassword(request: PasswordSetRequest): Promise<void> {
    await http.post<ApiResponse>('/auth/profile/password/set', request);
  }

  /**
   * 修改密码
   * @param request 修改密码请求
   * @returns 操作结果
   */
  static async changePassword(request: PasswordChangeRequest): Promise<void> {
    await http.post<ApiResponse>('/auth/profile/password/change', request);
  }
}

/**
 * 认证相关API服务
 */
export class AuthService {
  /**
   * 发送短信验证码
   * @param request 短信发送请求
   * @returns 验证码（开发环境）
   */
  static async sendSms(request: SmsSendRequest): Promise<string> {
    const response = await http.post<ApiResponse<string>>('/auth/sms/send', request);
    return response.data.data;
  }

  /**
   * 短信登录
   * @param request 短信登录请求
   * @returns 登录响应
   */
  static async smsLogin(request: SmsLoginRequest): Promise<LoginResponse> {
    const response = await http.post<ApiResponse<LoginResponse>>('/auth/sms/login', request);
    return response.data.data;
  }

  /**
   * 密码登录
   * @param request 密码登录请求
   * @returns 登录响应
   */
  static async passwordLogin(request: PasswordLoginRequest): Promise<LoginResponse> {
    const response = await http.post<ApiResponse<LoginResponse>>('/auth/password/login', request);
    return response.data.data;
  }

  /**
   * 用户注册
   * @param request 注册请求
   * @returns 登录响应
   */
  static async register(request: RegisterRequest): Promise<LoginResponse> {
    const response = await http.post<ApiResponse<LoginResponse>>('/auth/register', request);
    return response.data.data;
  }
}
