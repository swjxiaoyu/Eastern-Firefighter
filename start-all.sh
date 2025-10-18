#!/bin/bash

# 东方消防员培训平台 - 完整启动脚本 (Linux/macOS)
# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "东方消防员培训平台 - 完整启动脚本"
echo -e "==========================================${NC}"
echo

# 检查环境
echo -e "${YELLOW}[1/6] 检查环境依赖...${NC}"
echo

# 检查Java
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java 17 未安装或未配置到PATH${NC}"
    echo "请安装Java 17并配置环境变量"
    exit 1
fi
echo -e "${GREEN}✅ Java 环境检查通过${NC}"

# 检查Maven
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven 未安装或未配置到PATH${NC}"
    echo "请安装Maven并配置环境变量"
    exit 1
fi
echo -e "${GREEN}✅ Maven 环境检查通过${NC}"

# 检查Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js 未安装或未配置到PATH${NC}"
    echo "请安装Node.js 18+并配置环境变量"
    exit 1
fi
echo -e "${GREEN}✅ Node.js 环境检查通过${NC}"

# 检查Docker
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker 未安装，将使用本地环境启动${NC}"
    USE_DOCKER=false
else
    echo -e "${GREEN}✅ Docker 环境检查通过${NC}"
    USE_DOCKER=true
fi

echo
echo -e "${YELLOW}[2/6] 启动依赖服务...${NC}"
echo

if [ "$USE_DOCKER" = true ]; then
    echo -e "${BLUE}🐳 使用Docker启动MySQL和Redis...${NC}"
    docker-compose -f docker-compose-simple.yml up -d
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Docker服务启动失败${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Docker服务启动成功${NC}"
    sleep 10
else
    echo -e "${YELLOW}⚠️  请确保MySQL和Redis服务已手动启动${NC}"
    echo "MySQL: localhost:3306, 数据库: e-fire, 用户: root, 密码: swj21bsss"
    echo "Redis: localhost:6379"
    echo
    echo "按任意键继续..."
    read -n 1
fi

echo
echo -e "${YELLOW}[3/6] 初始化数据库...${NC}"
echo

# 检查数据库连接
echo "正在检查数据库连接..."
mysql -h localhost -P 3306 -u root -pswj21bsss -e "USE \`e-fire\`; SELECT 1;" &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 数据库连接失败，正在尝试导入SQL文件...${NC}"
    mysql -h localhost -P 3306 -u root -pswj21bsss < E-fire.sql
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ 数据库初始化失败${NC}"
        echo "请检查MySQL服务是否运行，或手动导入E-fire.sql文件"
        exit 1
    fi
    echo -e "${GREEN}✅ 数据库初始化成功${NC}"
else
    echo -e "${GREEN}✅ 数据库连接正常${NC}"
fi

echo
echo -e "${YELLOW}[4/6] 编译后端项目...${NC}"
echo

cd Eastern-Firefighter
echo -e "${BLUE}📦 正在编译所有模块...${NC}"
mvn -q -DskipTests clean install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 后端编译失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 后端编译成功${NC}"

echo
echo -e "${YELLOW}[5/6] 启动后端服务...${NC}"
echo

cd EF-webapp
echo -e "${BLUE}🚀 启动Spring Boot应用...${NC}"
nohup mvn spring-boot:run > ../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../backend.pid
sleep 15

# 检查后端是否启动成功
echo "检查后端服务状态..."
curl -s http://localhost:8080/actuator/health &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  后端服务可能还在启动中，请稍等...${NC}"
    sleep 10
fi

echo
echo -e "${YELLOW}[6/6] 启动前端服务...${NC}"
echo

cd ../frontend
echo -e "${BLUE}📦 安装前端依赖...${NC}"
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 前端依赖安装失败${NC}"
    exit 1
fi

echo -e "${BLUE}🌐 启动前端开发服务器...${NC}"
nohup npm run dev -- --host > ../frontend.log 2>&1 &
FRONTEND_PID=$!
echo $FRONTEND_PID > ../frontend.pid

echo
echo -e "${GREEN}=========================================="
echo -e "🎉 启动完成！"
echo -e "==========================================${NC}"
echo
echo -e "${BLUE}📱 前端地址: http://localhost:5173${NC}"
echo -e "${BLUE}🔧 后端API: http://localhost:8080${NC}"
echo -e "${BLUE}📊 健康检查: http://localhost:8080/actuator/health${NC}"
echo -e "${BLUE}🗄️  数据库: localhost:3306 (e-fire)${NC}"
echo -e "${BLUE}🔴 Redis: localhost:6379${NC}"
echo
echo -e "${YELLOW}💡 提示:${NC}"
echo "- 后端PID: $BACKEND_PID"
echo "- 前端PID: $FRONTEND_PID"
echo "- 日志文件: backend.log, frontend.log"
echo "- 如需停止服务，运行 ./stop-all.sh 脚本"
echo
echo "按任意键退出..."
read -n 1