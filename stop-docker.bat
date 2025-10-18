@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - 停止Docker服务
echo ==========================================
echo.

:: 设置颜色
color 0C

echo 🛑 正在停止Docker服务...
echo.

:: 停止Docker服务
docker-compose down
if %errorlevel% neq 0 (
    echo ❌ Docker服务停止失败
    pause
    exit /b 1
)

echo ✅ Docker服务已停止
echo.
echo ==========================================
echo 🎉 Docker服务停止完成！
echo ==========================================
echo.
echo 💡 提示:
echo - MySQL、Redis、Ollama服务已停止
echo - 如需重新启动，请运行 start-docker.bat
echo - 如需启动完整项目，请运行 start-all.bat
echo.
echo 按任意键退出...
pause >nul

