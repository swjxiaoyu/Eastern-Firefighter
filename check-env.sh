#!/bin/bash

# 东方消防员培训平台 - 环境检查脚本 (Linux/macOS)
# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "东方消防员培训平台 - 环境检查脚本"
echo -e "==========================================${NC}"
echo

echo -e "${YELLOW}🔍 正在检查环境依赖...${NC}"
echo

# 检查Java
echo -e "${YELLOW}[1/5] 检查Java环境...${NC}"
if ! command -v java &> /dev/null; then
    echo -e "${RED}❌ Java 17 未安装或未配置到PATH${NC}"
    echo "请安装Java 17并配置环境变量"
    JAVA_OK=false
else
    echo -e "${GREEN}✅ Java 环境检查通过${NC}"
    java -version
    JAVA_OK=true
fi
echo

# 检查Maven
echo -e "${YELLOW}[2/5] 检查Maven环境...${NC}"
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}❌ Maven 未安装或未配置到PATH${NC}"
    echo "请安装Maven并配置环境变量"
    MAVEN_OK=false
else
    echo -e "${GREEN}✅ Maven 环境检查通过${NC}"
    mvn -version
    MAVEN_OK=true
fi
echo

# 检查Node.js
echo -e "${YELLOW}[3/5] 检查Node.js环境...${NC}"
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js 未安装或未配置到PATH${NC}"
    echo "请安装Node.js 18+并配置环境变量"
    NODE_OK=false
else
    echo -e "${GREEN}✅ Node.js 环境检查通过${NC}"
    echo "Node.js: $(node -v)"
    echo "npm: $(npm -v)"
    NODE_OK=true
fi
echo

# 检查Docker
echo -e "${YELLOW}[4/5] 检查Docker环境...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker 未安装${NC}"
    echo "建议安装Docker以简化依赖服务管理"
    DOCKER_OK=false
else
    echo -e "${GREEN}✅ Docker 环境检查通过${NC}"
    docker --version
    DOCKER_OK=true
fi
echo

# 检查MySQL
echo -e "${YELLOW}[5/5] 检查MySQL环境...${NC}"
if ! command -v mysql &> /dev/null; then
    echo -e "${YELLOW}⚠️  MySQL 客户端未安装${NC}"
    echo "建议安装MySQL客户端或使用Docker运行MySQL"
    MYSQL_OK=false
else
    echo -e "${GREEN}✅ MySQL 客户端检查通过${NC}"
    mysql --version
    MYSQL_OK=true
fi
echo

# 检查Redis
if ! command -v redis-cli &> /dev/null; then
    echo -e "${YELLOW}⚠️  Redis 客户端未安装${NC}"
    echo "建议安装Redis客户端或使用Docker运行Redis"
    REDIS_OK=false
else
    echo -e "${GREEN}✅ Redis 客户端检查通过${NC}"
    redis-cli --version
    REDIS_OK=true
fi
echo

# 总结
echo -e "${BLUE}=========================================="
echo -e "📋 环境检查总结"
echo -e "==========================================${NC}"
echo

if [ "$JAVA_OK" = true ]; then
    echo -e "${GREEN}✅ Java 17 - 正常${NC}"
else
    echo -e "${RED}❌ Java 17 - 缺失${NC}"
fi

if [ "$MAVEN_OK" = true ]; then
    echo -e "${GREEN}✅ Maven - 正常${NC}"
else
    echo -e "${RED}❌ Maven - 缺失${NC}"
fi

if [ "$NODE_OK" = true ]; then
    echo -e "${GREEN}✅ Node.js - 正常${NC}"
else
    echo -e "${RED}❌ Node.js - 缺失${NC}"
fi

if [ "$DOCKER_OK" = true ]; then
    echo -e "${GREEN}✅ Docker - 正常${NC}"
else
    echo -e "${YELLOW}⚠️  Docker - 缺失 (可选)${NC}"
fi

if [ "$MYSQL_OK" = true ]; then
    echo -e "${GREEN}✅ MySQL - 正常${NC}"
else
    echo -e "${YELLOW}⚠️  MySQL - 缺失 (可选)${NC}"
fi

if [ "$REDIS_OK" = true ]; then
    echo -e "${GREEN}✅ Redis - 正常${NC}"
else
    echo -e "${YELLOW}⚠️  Redis - 缺失 (可选)${NC}"
fi

echo
if [ "$JAVA_OK" = true ] && [ "$MAVEN_OK" = true ] && [ "$NODE_OK" = true ]; then
    echo -e "${GREEN}🎉 核心环境检查通过，可以启动项目！${NC}"
    echo
    echo -e "${YELLOW}💡 建议:${NC}"
    echo "- 如果Docker可用，推荐使用Docker启动依赖服务"
    echo "- 如果MySQL/Redis不可用，请手动安装或使用Docker"
    echo "- 运行 ./start-all.sh 开始启动项目"
else
    echo -e "${RED}❌ 核心环境缺失，请先安装必要的依赖${NC}"
    echo
    echo -e "${YELLOW}📝 安装指南:${NC}"
    echo "- Java 17: https://adoptium.net/"
    echo "- Maven: https://maven.apache.org/download.cgi"
    echo "- Node.js: https://nodejs.org/"
    echo "- Docker: https://www.docker.com/products/docker-desktop"
fi

echo

