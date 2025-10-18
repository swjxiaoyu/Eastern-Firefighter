#!/bin/bash

# 东方消防员培训平台 - Docker环境启动 (Linux/macOS)
# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "东方消防员培训平台 - Docker环境启动"
echo -e "==========================================${NC}"
echo

echo -e "${YELLOW}🐳 使用Docker启动所有服务...${NC}"
echo

# 检查Docker是否安装
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker 未安装或未启动${NC}"
    echo "请安装Docker并确保服务运行"
    exit 1
fi

# 启动Docker服务
echo -e "${BLUE}📦 启动MySQL、Redis和Ollama服务...${NC}"
docker-compose up -d
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Docker服务启动失败${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker服务启动成功${NC}"
echo
echo -e "${YELLOW}🔄 等待服务完全启动...${NC}"
sleep 15

# 检查服务状态
echo -e "${BLUE}📊 检查服务状态...${NC}"
echo

echo "MySQL状态:"
docker-compose ps mysql

echo
echo "Redis状态:"
docker-compose ps redis

echo
echo "Ollama状态:"
docker-compose ps ollama

echo
echo -e "${GREEN}=========================================="
echo -e "🎉 Docker环境启动完成！"
echo -e "==========================================${NC}"
echo
echo -e "${BLUE}📱 服务地址:${NC}"
echo "- MySQL: localhost:3306 (e-fire数据库)"
echo "- Redis: localhost:6379"
echo "- Ollama: localhost:11434"
echo
echo -e "${YELLOW}💡 下一步:${NC}"
echo "- 运行 ./start-all.sh 启动应用服务"
echo "- 或运行 ./stop-docker.sh 停止Docker服务"
echo

