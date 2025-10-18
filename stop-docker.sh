#!/bin/bash

# 东方消防员培训平台 - 停止Docker服务 (Linux/macOS)
# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "东方消防员培训平台 - 停止Docker服务"
echo -e "==========================================${NC}"
echo

echo -e "${RED}🛑 正在停止Docker服务...${NC}"
echo

# 停止Docker服务
docker-compose down
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Docker服务停止失败${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Docker服务已停止${NC}"
echo
echo -e "${GREEN}=========================================="
echo -e "🎉 Docker服务停止完成！"
echo -e "==========================================${NC}"
echo
echo -e "${YELLOW}💡 提示:${NC}"
echo "- MySQL、Redis、Ollama服务已停止"
echo "- 如需重新启动，请运行 ./start-docker.sh"
echo "- 如需启动完整项目，请运行 ./start-all.sh"
echo
