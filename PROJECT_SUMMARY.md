# 东方消防员培训平台 - 项目启动脚本总结

## 项目概述

这是一个完整的Spring Boot + Vue.js消防员培训平台，包含以下核心功能：

- **用户认证系统**: 注册、登录、权限管理
- **电商模块**: 消防用品销售、订单管理
- **培训系统**: 在线课程、学习进度跟踪
- **博物馆模块**: 消防博物馆信息、预订管理
- **AI助手**: 智能问答、内容推荐
- **内容管理**: 文章发布、内容管理

## 技术栈

### 后端
- **框架**: Spring Boot 3.5.4
- **语言**: Java 17
- **数据库**: MySQL 8.0
- **缓存**: Redis
- **ORM**: MyBatis Plus
- **数据库迁移**: Flyway
- **AI服务**: Ollama

### 前端
- **框架**: Vue.js 3
- **语言**: TypeScript
- **构建工具**: Vite
- **状态管理**: Pinia
- **路由**: Vue Router
- **HTTP客户端**: Axios

## 启动脚本说明

### 1. 环境检查脚本
- **Windows**: `check-env.bat`
- **功能**: 检查Java、Node.js、MySQL、Redis环境

### 2. 本地环境启动脚本

#### Windows
- **批处理**: `start-all.bat` / `stop-all.bat`
- **PowerShell**: `start-all.ps1`

#### Linux/macOS
- **Shell**: `start-all.sh` / `stop-all.sh`

### 3. Docker环境启动脚本
- **Windows**: `start-docker.bat`
- **Linux/macOS**: `docker-compose up -d`

## 服务端口

- **前端应用**: http://localhost:5173
- **后端API**: http://localhost:8080
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Ollama**: localhost:11434

## 数据库配置

### 默认配置
- **数据库名**: e-fire
- **用户名**: root
- **密码**: huashidai
- **字符集**: utf8mb4

### 数据库表结构
脚本会自动创建以下表：
- `user_account` - 用户账户
- `product` - 商品信息
- `product_sku` - 商品SKU
- `order` - 订单信息
- `order_item` - 订单项
- `museum` - 博物馆信息
- `article` - 文章内容
- `course` - 课程信息
- `cart_item` - 购物车
- `user_address` - 用户地址
- `inventory_stock` - 库存管理
- `data_sync_log` - 数据同步日志
- `museum_booking` - 博物馆预订
- `course_enrollment` - 课程报名

## 使用说明

### 首次启动
1. 确保已安装所需环境（Java 17、Node.js 16、MySQL 8.0、Redis）
2. 运行环境检查脚本确认环境就绪
3. 选择启动方式：
   - **推荐**: 使用Docker启动依赖服务
   - **传统**: 使用本地环境启动脚本

### 日常使用
- 启动: 运行对应的启动脚本
- 停止: 运行对应的停止脚本
- 重启: 先停止再启动

## 故障排除

### 常见问题
1. **端口占用**: 检查8080、5173端口是否被占用
2. **数据库连接失败**: 确认MySQL服务运行且配置正确
3. **Redis连接失败**: 确认Redis服务运行
4. **前端启动失败**: 确认Node.js环境正确

### 日志文件
- **后端日志**: backend.log
- **前端日志**: frontend.log

## 开发建议

1. **环境隔离**: 建议使用Docker进行开发环境隔离
2. **数据库管理**: 使用Flyway进行数据库版本管理
3. **代码规范**: 遵循项目中的checkstyle配置
4. **API文档**: 参考项目中的API契约文档

## 扩展功能

项目支持以下扩展：
- **AI助手**: 集成Ollama进行智能问答
- **数据同步**: 支持多数据源同步
- **内容管理**: 支持富文本内容编辑
- **培训系统**: 支持课程进度跟踪

## 联系支持

如有问题，请参考项目README.md或联系开发团队。

