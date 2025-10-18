@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - 停止所有服务
echo ==========================================
echo.

:: 设置颜色
color 0C

echo 🛑 正在停止所有服务...
echo.

:: 停止前端服务
echo 停止前端服务...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :5173') do (
    taskkill /PID %%a /F >nul 2>&1
)
echo ✅ 前端服务已停止

:: 停止后端服务
echo 停止后端服务...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080') do (
    taskkill /PID %%a /F >nul 2>&1
)
echo ✅ 后端服务已停止

:: 停止Docker服务
echo 停止Docker服务...
docker-compose -f docker-compose-simple.yml down >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Docker服务已停止
) else (
    echo ⚠️  Docker服务可能未运行
)

echo.
echo ==========================================
echo 🎉 所有服务已停止
echo ==========================================
echo.
echo 💡 提示:
echo - 如需重新启动，请运行 start-all.bat
echo - 如需仅启动Docker服务，请运行 docker-compose -f docker-compose-simple.yml up -d
echo.
echo 按任意键退出...
pause >nul