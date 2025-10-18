#!/bin/bash

# 东方消防员培训平台 - 停止所有服务 (Linux/macOS)
# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo -e "东方消防员培训平台 - 停止所有服务"
echo -e "==========================================${NC}"
echo

echo -e "${RED}🛑 正在停止所有服务...${NC}"
echo

# 停止前端服务
echo "停止前端服务..."
if [ -f frontend.pid ]; then
    FRONTEND_PID=$(cat frontend.pid)
    kill $FRONTEND_PID 2>/dev/null
    rm frontend.pid
    echo -e "${GREEN}✅ 前端服务已停止${NC}"
else
    # 通过端口查找并停止
    FRONTEND_PID=$(lsof -ti:5173)
    if [ ! -z "$FRONTEND_PID" ]; then
        kill $FRONTEND_PID
        echo -e "${GREEN}✅ 前端服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  前端服务可能未运行${NC}"
    fi
fi

# 停止后端服务
echo "停止后端服务..."
if [ -f backend.pid ]; then
    BACKEND_PID=$(cat backend.pid)
    kill $BACKEND_PID 2>/dev/null
    rm backend.pid
    echo -e "${GREEN}✅ 后端服务已停止${NC}"
else
    # 通过端口查找并停止
    BACKEND_PID=$(lsof -ti:8080)
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID
        echo -e "${GREEN}✅ 后端服务已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  后端服务可能未运行${NC}"
    fi
fi

# 停止Docker服务
echo "停止Docker服务..."
docker-compose -f docker-compose-simple.yml down &>/dev/null
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Docker服务已停止${NC}"
else
    echo -e "${YELLOW}⚠️  Docker服务可能未运行${NC}"
fi

echo
echo -e "${GREEN}=========================================="
echo -e "🎉 所有服务已停止"
echo -e "==========================================${NC}"
echo
echo -e "${YELLOW}💡 提示:${NC}"
echo "- 如需重新启动，请运行 ./start-all.sh"
echo "- 如需仅启动Docker服务，请运行 docker-compose -f docker-compose-simple.yml up -d"
echo