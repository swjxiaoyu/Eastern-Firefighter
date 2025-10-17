@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - 完整启动脚本
echo ==========================================
echo.

:: 设置颜色
color 0A

:: 检查环境
echo [1/6] 检查环境依赖...
echo.

:: 检查Java
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java 17 未安装或未配置到PATH
    echo 请安装Java 17并配置环境变量
    pause
    exit /b 1
)
echo ✅ Java 环境检查通过

:: 检查Maven
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven 未安装或未配置到PATH
    echo 请安装Maven并配置环境变量
    pause
    exit /b 1
)
echo ✅ Maven 环境检查通过

:: 检查Node.js
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装或未配置到PATH
    echo 请安装Node.js 18+并配置环境变量
    pause
    exit /b 1
)
echo ✅ Node.js 环境检查通过

:: 检查Docker
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Docker 未安装，将使用本地环境启动
    set USE_DOCKER=false
) else (
    echo ✅ Docker 环境检查通过
    set USE_DOCKER=true
)

echo.
echo [2/6] 启动依赖服务...
echo.

if "%USE_DOCKER%"=="true" (
    echo 🐳 使用Docker启动MySQL和Redis...
    docker-compose -f docker-compose-simple.yml up -d
    if %errorlevel% neq 0 (
        echo ❌ Docker服务启动失败
        pause
        exit /b 1
    )
    echo ✅ Docker服务启动成功
    timeout /t 10 /nobreak >nul
) else (
    echo ⚠️  请确保MySQL和Redis服务已手动启动
    echo MySQL: localhost:3306, 数据库: e-fire, 用户: root, 密码: swj21bsss
    echo Redis: localhost:6379
    echo.
    echo 按任意键继续...
    pause >nul
)

echo.
echo [3/6] 初始化数据库...
echo.

:: 检查数据库连接
echo 正在检查数据库连接...
mysql -h localhost -P 3306 -u root -pswj21bsss -e "USE \`e-fire\`; SELECT 1;" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ 数据库连接失败，正在尝试导入SQL文件...
    mysql -h localhost -P 3306 -u root -pswj21bsss < E-fire.sql
    if %errorlevel% neq 0 (
        echo ❌ 数据库初始化失败
        echo 请检查MySQL服务是否运行，或手动导入E-fire.sql文件
        pause
        exit /b 1
    )
    echo ✅ 数据库初始化成功
) else (
    echo ✅ 数据库连接正常
)

echo.
echo [4/6] 编译后端项目...
echo.

cd Eastern-Firefighter
echo 📦 正在编译所有模块...
call mvn -q -DskipTests clean install
if %errorlevel% neq 0 (
    echo ❌ 后端编译失败
    pause
    exit /b 1
)
echo ✅ 后端编译成功

echo.
echo [5/6] 启动后端服务...
echo.

cd EF-webapp
echo 🚀 启动Spring Boot应用...
start "后端服务" cmd /k "mvn spring-boot:run"
timeout /t 15 /nobreak >nul

:: 检查后端是否启动成功
echo 检查后端服务状态...
curl -s http://localhost:8080/actuator/health >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  后端服务可能还在启动中，请稍等...
    timeout /t 10 /nobreak >nul
)

echo.
echo [6/6] 启动前端服务...
echo.

cd ..\frontend
echo 📦 安装前端依赖...
call npm install
if %errorlevel% neq 0 (
    echo ❌ 前端依赖安装失败
    pause
    exit /b 1
)

echo 🌐 启动前端开发服务器...
start "前端服务" cmd /k "npm run dev -- --host"

echo.
echo ==========================================
echo 🎉 启动完成！
echo ==========================================
echo.
echo 📱 前端地址: http://localhost:5173
echo 🔧 后端API: http://localhost:8080
echo 📊 健康检查: http://localhost:8080/actuator/health
echo 🗄️  数据库: localhost:3306 (e-fire)
echo 🔴 Redis: localhost:6379
echo.
echo 💡 提示:
echo - 前端和后端服务已在独立窗口中运行
echo - 如需停止服务，请关闭对应的命令行窗口
echo - 或运行 stop-all.bat 脚本停止所有服务
echo.
echo 按任意键退出...
pause >nul