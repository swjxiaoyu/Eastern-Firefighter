@echo off
chcp 65001 >nul
echo ========================================
echo    快速解决方案 - Docker网络问题
echo ========================================
echo.

echo 检测到Docker网络问题，提供以下解决方案:
echo.

echo [方案1] 使用简化Docker启动 (推荐)
echo   只启动MySQL和Redis，跳过Ollama
echo   运行: start-docker-simple.bat
echo.

echo [方案2] 使用本地环境启动
echo   需要本地安装MySQL和Redis
echo   运行: start-all.bat
echo.

echo [方案3] 网络诊断和修复
echo   尝试修复Docker网络问题
echo   运行: fix-docker-network.bat
echo.

echo [方案4] 手动启动服务
echo   1. 启动MySQL服务
echo   2. 启动Redis服务
echo   3. 运行后端: cd Eastern-Firefighter ^&^& mvn spring-boot:run -pl EF-webapp
echo   4. 运行前端: cd frontend ^&^& npm run dev
echo.

echo 请选择解决方案:
echo 1 - 简化Docker启动
echo 2 - 本地环境启动
echo 3 - 网络诊断
echo 4 - 手动启动
echo 0 - 退出
echo.

set /p choice=请输入选择 (0-4): 

if "%choice%"=="1" (
    echo 启动简化Docker服务...
    call start-docker-simple.bat
) else if "%choice%"=="2" (
    echo 启动本地环境...
    call start-all.bat
) else if "%choice%"=="3" (
    echo 运行网络诊断...
    call fix-docker-network.bat
) else if "%choice%"=="4" (
    echo 手动启动指南:
    echo 1. 确保MySQL服务运行 (端口3306)
    echo 2. 确保Redis服务运行 (端口6379)
    echo 3. 在命令行中运行:
    echo    cd Eastern-Firefighter
    echo    mvn spring-boot:run -pl EF-webapp
    echo 4. 在新命令行中运行:
    echo    cd Eastern-Firefighter/frontend
    echo    npm run dev
    echo.
    echo 服务地址:
    echo   前端: http://localhost:5173
    echo   后端: http://localhost:8080
    pause
) else if "%choice%"=="0" (
    echo 退出...
    exit /b 0
) else (
    echo 无效选择，请重新运行脚本
    pause
    exit /b 1
)

echo.
echo 按任意键退出...
pause >nul

