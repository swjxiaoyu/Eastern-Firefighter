# 东方灭火侠 API 接口契约文档

## 概述

本文档定义了东方灭火侠平台的前端与后端API接口契约，包括请求参数、响应格式、错误处理等规范。

## 基础信息

- **API基础路径**: `/api`
- **认证方式**: Bearer Token (JWT)
- **内容类型**: `application/json`
- **字符编码**: UTF-8

## 通用响应格式

所有API接口都遵循统一的响应格式：

```typescript
interface ApiResponse<T = any> {
  code: number;      // 状态码，0表示成功
  message: string;   // 响应消息
  data: T;          // 响应数据
}
```

### 状态码说明

- `0`: 成功
- `400`: 请求参数错误
- `401`: 未授权/登录过期
- `403`: 权限不足
- `404`: 资源不存在
- `500`: 服务器内部错误

## 商品相关接口

### 1. 获取商品详情

**接口**: `GET /user/products/{id}`

**描述**: 获取指定商品的详细信息

**路径参数**:
- `id` (number): 商品ID

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": {
    "id": 1,
    "name": "干粉灭火器 4KG",
    "subtitle": "适用于A、B、C类火灾",
    "price": 89.00,
    "originPrice": 120.00,
    "coverUrl": "https://example.com/image.jpg",
    "mediaJson": "[\"https://example.com/img1.jpg\", \"https://example.com/img2.jpg\"]",
    "status": 1,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

### 2. 获取商品SKU列表

**接口**: `GET /user/products/{id}/skus`

**描述**: 获取指定商品的所有SKU规格

**路径参数**:
- `id` (number): 商品ID

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": [
    {
      "id": 1,
      "productId": 1,
      "skuCode": "MF-4KG-001",
      "attrsJson": "{\"color\":\"红色\",\"weight\":\"4KG\"}",
      "price": 89.00,
      "stock": 100,
      "status": 1
    }
  ]
}
```

### 3. 加入购物车

**接口**: `POST /user/cart/add`

**描述**: 将商品SKU加入购物车

**请求体**:
```json
{
  "skuId": 1,
  "quantity": 2
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "已加入购物车",
  "data": null
}
```

## 用户相关接口

### 1. 获取用户资料

**接口**: `GET /auth/profile/me`

**描述**: 获取当前登录用户的个人资料

**请求头**:
- `Authorization: Bearer {token}`

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": {
    "id": 1,
    "phone": "13800138000",
    "realName": "张三",
    "gender": 1,
    "birthday": "1990-01-01",
    "avatarUrl": "https://example.com/avatar.jpg",
    "status": 1,
    "createdAt": "2024-01-01T00:00:00Z",
    "updatedAt": "2024-01-01T00:00:00Z"
  }
}
```

### 2. 更新用户资料

**接口**: `POST /auth/profile/update`

**描述**: 更新当前用户的个人资料

**请求头**:
- `Authorization: Bearer {token}`

**请求体**:
```json
{
  "realName": "张三",
  "gender": 1,
  "birthday": "1990-01-01",
  "avatarUrl": "https://example.com/avatar.jpg"
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "已保存",
  "data": null
}
```

### 3. 设置密码

**接口**: `POST /auth/profile/password/set`

**描述**: 为没有密码的用户设置密码

**请求头**:
- `Authorization: Bearer {token}`

**请求体**:
```json
{
  "newPassword": "newPassword123"
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "已设置密码",
  "data": null
}
```

### 4. 修改密码

**接口**: `POST /auth/profile/password/change`

**描述**: 修改用户密码

**请求头**:
- `Authorization: Bearer {token}`

**请求体**:
```json
{
  "oldPassword": "oldPassword123",
  "newPassword": "newPassword123"
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "已修改密码",
  "data": null
}
```

## 认证相关接口

### 1. 发送短信验证码

**接口**: `POST /auth/sms/send`

**描述**: 发送短信验证码

**请求体**:
```json
{
  "phone": "13800138000",
  "scene": "login"
}
```

**参数说明**:
- `phone`: 手机号码
- `scene`: 场景类型 (`login` | `register` | `reset`)

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": "123456"
}
```

### 2. 短信登录

**接口**: `POST /auth/sms/login`

**描述**: 使用短信验证码登录

**请求体**:
```json
{
  "phone": "13800138000",
  "code": "123456",
  "deviceInfo": "web"
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": {
    "userId": 1,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 3. 密码登录

**接口**: `POST /auth/password/login`

**描述**: 使用密码登录

**请求体**:
```json
{
  "username": "13800138000",
  "password": "password123",
  "deviceInfo": "web"
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": {
    "userId": 1,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### 4. 用户注册

**接口**: `POST /auth/register`

**描述**: 用户注册

**请求体**:
```json
{
  "phone": "13800138000",
  "code": "123456",
  "password": "password123",
  "deviceInfo": "web"
}
```

**响应示例**:
```json
{
  "code": 0,
  "message": "OK",
  "data": {
    "userId": 1,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

## 错误处理

### 常见错误响应

#### 参数验证错误 (400)
```json
{
  "code": 400,
  "message": "手机号格式不正确",
  "data": null
}
```

#### 认证失败 (401)
```json
{
  "code": 401,
  "message": "登录已过期，请重新登录",
  "data": null
}
```

#### 权限不足 (403)
```json
{
  "code": 403,
  "message": "权限不足",
  "data": null
}
```

#### 资源不存在 (404)
```json
{
  "code": 404,
  "message": "商品不存在",
  "data": null
}
```

#### 服务器错误 (500)
```json
{
  "code": 500,
  "message": "服务器内部错误",
  "data": null
}
```

## 数据类型定义

### 商品类型 (Product)
```typescript
interface Product {
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
```

### 商品SKU类型 (ProductSku)
```typescript
interface ProductSku {
  id: number;
  productId: number;
  skuCode?: string;
  attrsJson?: string;
  price: number;
  stock: number;
  status: number;
}
```

### 用户资料类型 (UserProfile)
```typescript
interface UserProfile {
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
```

## 前端类型安全

项目已集成TypeScript类型定义，位于 `src/types/api.ts`，提供完整的类型安全支持：

- 自动补全和类型检查
- 编译时错误检测
- 接口契约验证
- 重构安全保障

## API服务层

项目提供了统一的API服务层 (`src/api/services.ts`)，封装了所有业务接口调用：

- **ProductService**: 商品相关接口
- **UserService**: 用户相关接口  
- **AuthService**: 认证相关接口

### 使用示例

```typescript
import { ProductService, UserService } from '@/api/services';

// 获取商品详情
const product = await ProductService.getProduct(1);

// 获取用户资料
const profile = await UserService.getProfile();

// 更新用户资料
await UserService.updateProfile({
  realName: '张三',
  gender: 1
});
```

## 版本历史

- **v1.0.0** (2024-01-01): 初始版本，包含基础商品和用户接口
- **v1.1.0** (2024-01-15): 添加购物车功能
- **v1.2.0** (2024-02-01): 完善用户资料管理

## 注意事项

1. 所有时间字段使用ISO 8601格式 (UTC时间)
2. 价格字段使用数字类型，单位为元
3. 图片URL需要支持HTTPS
4. 手机号格式：11位数字，以1开头
5. 密码长度：6-20位字符
6. 性别字段：0-未知，1-男，2-女
