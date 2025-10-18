@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - Docker环境启动
echo ==========================================
echo.

:: 设置颜色
color 0E

echo 🐳 使用Docker启动所有服务...
echo.

:: 检查Docker是否安装
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Docker 未安装或未启动
    echo 请安装Docker Desktop并确保服务运行
    pause
    exit /b 1
)

:: 启动Docker服务
echo 📦 启动MySQL、Redis和Ollama服务...
docker-compose up -d
if %errorlevel% neq 0 (
    echo ❌ Docker服务启动失败
    pause
    exit /b 1
)

echo ✅ Docker服务启动成功
echo.
echo 🔄 等待服务完全启动...
timeout /t 15 /nobreak >nul

:: 检查服务状态
echo 📊 检查服务状态...
echo.

echo MySQL状态:
docker-compose ps mysql

echo.
echo Redis状态:
docker-compose ps redis

echo.
echo Ollama状态:
docker-compose ps ollama

echo.
echo ==========================================
echo 🎉 Docker环境启动完成！
echo ==========================================
echo.
echo 📱 服务地址:
echo - MySQL: localhost:3306 (e-fire数据库)
echo - Redis: localhost:6379
echo - Ollama: localhost:11434
echo.
echo 💡 下一步:
echo - 运行 start-all.bat 启动应用服务
echo - 或运行 stop-docker.bat 停止Docker服务
echo.
echo 按任意键退出...
pause >nul

