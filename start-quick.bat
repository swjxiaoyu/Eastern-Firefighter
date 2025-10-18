@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - 快速启动脚本
echo ==========================================
echo.

:: 设置颜色
color 0B

echo 🚀 快速启动模式 - 跳过环境检查
echo.

:: 直接启动后端
echo 📦 启动后端服务...
cd Eastern-Firefighter\EF-webapp
start "后端服务" cmd /k "mvn spring-boot:run"
timeout /t 15 /nobreak >nul

:: 启动前端
echo 🌐 启动前端服务...
cd ..\frontend
start "前端服务" cmd /k "npm run dev -- --host"

echo.
echo ==========================================
echo 🎉 快速启动完成！
echo ==========================================
echo.
echo 📱 前端地址: http://localhost:5173
echo 🔧 后端API: http://localhost:8080
echo.
echo 💡 提示:
echo - 如果遇到500错误，请运行 start-all-complete.bat
echo - 该脚本会检查环境并初始化数据库
echo.
echo 按任意键退出...
pause >nul

