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

echo -e "${YELLOW}🔍 正在检查环境依赖...${NC}"
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

# 检查MySQL
if ! command -v mysql &> /dev/null; then
    echo -e "${RED}❌ MySQL 客户端未安装${NC}"
    echo "请安装MySQL客户端或使用Docker运行MySQL"
    exit 1
fi
echo -e "${GREEN}✅ MySQL 客户端检查通过${NC}"

echo
echo -e "${YELLOW}🗄️ 正在初始化数据库...${NC}"
echo

# 创建数据库
echo -e "${BLUE}📦 创建数据库 e-fire...${NC}"
mysql -h localhost -P 3306 -u root -pswj21bsss -e "CREATE DATABASE IF NOT EXISTS \`e-fire\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 数据库创建失败${NC}"
    echo "请检查MySQL服务是否运行"
    exit 1
fi
echo -e "${GREEN}✅ 数据库创建成功${NC}"

# 检查数据库是否为空
echo -e "${BLUE}🔍 检查数据库表...${NC}"
TABLE_COUNT=$(mysql -h localhost -P 3306 -u root -pswj21bsss -e "USE \`e-fire\`; SHOW TABLES;" 2>/dev/null | wc -l)
if [ $TABLE_COUNT -le 1 ]; then
    echo -e "${BLUE}📥 数据库为空，正在导入SQL文件...${NC}"
    mysql -h localhost -P 3306 -u root -pswj21bsss e-fire < E-fire.sql 2>/dev/null
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ SQL文件导入失败${NC}"
        echo "请检查E-fire.sql文件是否存在"
        exit 1
    fi
    echo -e "${GREEN}✅ SQL文件导入成功${NC}"
else
    echo -e "${GREEN}✅ 数据库表已存在${NC}"
fi

echo
echo -e "${YELLOW}📦 正在编译后端项目...${NC}"
echo

cd Eastern-Firefighter
echo -e "${BLUE}🔨 编译所有模块...${NC}"
mvn -q -DskipTests clean install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 后端编译失败${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 后端编译成功${NC}"

echo
echo -e "${YELLOW}🚀 启动后端服务...${NC}"
echo

cd EF-webapp
echo -e "${BLUE}🌐 启动Spring Boot应用...${NC}"
nohup mvn spring-boot:run > ../backend.log 2>&1 &
BACKEND_PID=$!
echo $BACKEND_PID > ../backend.pid
sleep 20

# 检查后端是否启动成功
echo -e "${BLUE}🔍 检查后端服务状态...${NC}"
curl -s http://localhost:8080/actuator/health &>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠️  后端服务可能还在启动中，请稍等...${NC}"
    sleep 10
fi

echo
echo -e "${YELLOW}🌐 启动前端服务...${NC}"
echo

cd ../frontend
echo -e "${BLUE}📦 安装前端依赖...${NC}"
npm install
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ 前端依赖安装失败${NC}"
    exit 1
fi

echo -e "${BLUE}🎨 启动前端开发服务器...${NC}"
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
echo
echo -e "${YELLOW}💡 提示:${NC}"
echo "- 后端PID: $BACKEND_PID"
echo "- 前端PID: $FRONTEND_PID"
echo "- 日志文件: backend.log, frontend.log"
echo "- 如需停止服务，运行 ./stop-all.sh 脚本"
echo "- 如果遇到500错误，请检查数据库是否正确初始化"
echo

