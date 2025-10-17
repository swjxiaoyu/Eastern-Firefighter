# 东方灭火侠应急物资平台 (Eastern-Firefighter)

## 📋 项目概述

这是一个完整的Spring Boot + Vue.js消防员培训平台，包含以下核心功能：

- **用户认证系统**: 注册、登录、权限管理
- **电商模块**: 消防用品销售、订单管理
- **培训系统**: 在线课程、学习进度跟踪
- **博物馆模块**: 消防博物馆信息、预订管理
- **AI助手**: 智能问答、内容推荐
- **内容管理**: 文章发布、内容管理

## 🛠️ 技术栈

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

## 🚀 快速开始

### 环境要求
- Java 17+
- Node.js 18+
- MySQL 8.0+
- Redis
- Maven 3.6+

### 启动步骤

#### Windows环境
```bash
# 1. 检查环境
check-env.bat

# 2. 启动所有服务
start-all.bat

# 3. 停止所有服务
stop-all.bat
```

#### Linux/macOS环境
```bash
# 1. 检查环境
chmod +x check-env.sh
./check-env.sh

# 2. 启动所有服务
chmod +x start-all.sh
./start-all.sh

# 3. 停止所有服务
chmod +x stop-all.sh
./stop-all.sh
```

#### Docker环境
```bash
# Windows
start-docker.bat

# Linux/macOS
docker-compose up -d
```

## 🌐 服务端口

- **前端应用**: http://localhost:5173
- **后端API**: http://localhost:8080
- **健康检查**: http://localhost:8080/actuator/health
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Ollama**: localhost:11434

## 🗄️ 数据库配置

### 默认配置
- **数据库名**: e-fire
- **用户名**: root
- **密码**: swj21bsss
- **字符集**: utf8mb4

### 数据库表结构
项目包含以下主要表：
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

## 📁 项目结构

```
Eastern-Firefighter/
├── EF-core/              # 核心模块
├── EF-auth/              # 认证模块
├── EF-commerce/          # 电商模块
├── EF-merchant/          # 商户模块
├── EF-user/              # 用户模块
├── EF-content/           # 内容管理模块
├── EF-sync/              # 数据同步模块
├── EF-museum/            # 博物馆模块
├── EF-training/          # 培训模块
├── EF-ai/                # AI助手模块
├── EF-agent/             # 智能体模块
├── EF-webapp/            # Web应用模块
├── frontend/             # Vue.js前端
├── docker-compose.yml    # Docker配置
├── E-fire.sql           # 数据库脚本
└── 启动脚本/             # 各种启动脚本
```

## ✨ 主要功能

### 1. 用户认证系统
- 用户注册/登录
- 权限管理
- 角色控制

### 2. 电商功能
- 商品浏览与搜索
- 购物车管理
- 订单处理
- 库存管理

### 3. 培训系统
- 在线课程
- 学习进度跟踪
- 课程报名

### 4. 博物馆模块
- 博物馆信息展示
- 在线预订
- 场次管理

### 5. AI助手
- 智能问答
- 内容推荐
- 流式对话

### 6. 内容管理
- 文章发布
- 内容编辑
- 分类管理

## 🔧 开发指南

### 后端开发
```bash
# 进入后端目录
cd Eastern-Firefighter

# 编译项目
mvn clean compile

# 运行测试
mvn test

# 打包
mvn clean package
```

### 前端开发
```bash
# 进入前端目录
cd Eastern-Firefighter/frontend

# 安装依赖
npm install

# 开发模式
npm run dev

# 构建生产版本
npm run build
```

## 📝 API文档

项目提供完整的REST API，主要接口包括：

- `/api/auth/*` - 认证相关接口
- `/api/commerce/*` - 电商相关接口
- `/api/user/*` - 用户相关接口
- `/api/content/*` - 内容管理接口
- `/api/museum/*` - 博物馆相关接口
- `/api/training/*` - 培训相关接口
- `/api/ai/*` - AI助手接口

## 🐳 Docker部署

项目支持Docker部署，包含以下服务：

- MySQL 8.0
- Redis
- Ollama AI服务

```bash
# 启动所有服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 停止所有服务
docker-compose down
```

## 🔍 故障排除

### 常见问题

1. **端口占用**
   - 检查8080、5173端口是否被占用
   - 使用`netstat -ano | findstr :8080`检查端口

2. **数据库连接失败**
   - 确认MySQL服务运行
   - 检查数据库配置信息

3. **Redis连接失败**
   - 确认Redis服务运行
   - 检查Redis配置

4. **前端启动失败**
   - 确认Node.js环境正确
   - 检查依赖安装

### 日志文件
- **后端日志**: backend.log
- **前端日志**: frontend.log

## 🤝 贡献指南

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情

## 📞 联系方式

如有问题或建议，请通过以下方式联系：

- 提交 Issue
- 发送邮件
- 项目讨论区

## 🙏 致谢

感谢所有为这个项目做出贡献的开发者和用户！

---

**东方灭火侠应急物资平台** - 让消防培训更智能、更高效！