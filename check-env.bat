@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - 环境检查脚本
echo ==========================================
echo.

:: 设置颜色
color 0B

echo 🔍 正在检查环境依赖...
echo.

:: 检查Java
echo [1/5] 检查Java环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java 17 未安装或未配置到PATH
    echo 请安装Java 17并配置环境变量
    set JAVA_OK=false
) else (
    echo ✅ Java 环境检查通过
    java -version
    set JAVA_OK=true
)
echo.

:: 检查Maven
echo [2/5] 检查Maven环境...
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Maven 未安装或未配置到PATH
    echo 请安装Maven并配置环境变量
    set MAVEN_OK=false
) else (
    echo ✅ Maven 环境检查通过
    mvn -version
    set MAVEN_OK=true
)
echo.

:: 检查Node.js
echo [3/5] 检查Node.js环境...
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js 未安装或未配置到PATH
    echo 请安装Node.js 18+并配置环境变量
    set NODE_OK=false
) else (
    echo ✅ Node.js 环境检查通过
    node -v
    npm -v
    set NODE_OK=true
)
echo.

:: 检查Docker
echo [4/5] 检查Docker环境...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Docker 未安装
    echo 建议安装Docker Desktop以简化依赖服务管理
    set DOCKER_OK=false
) else (
    echo ✅ Docker 环境检查通过
    docker --version
    set DOCKER_OK=true
)
echo.

:: 检查MySQL
echo [5/5] 检查MySQL环境...
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  MySQL 客户端未安装
    echo 建议安装MySQL客户端或使用Docker运行MySQL
    set MYSQL_OK=false
) else (
    echo ✅ MySQL 客户端检查通过
    mysql --version
    set MYSQL_OK=true
)
echo.

:: 检查Redis
redis-cli --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Redis 客户端未安装
    echo 建议安装Redis客户端或使用Docker运行Redis
    set REDIS_OK=false
) else (
    echo ✅ Redis 客户端检查通过
    redis-cli --version
    set REDIS_OK=true
)
echo.

:: 总结
echo ==========================================
echo 📋 环境检查总结
echo ==========================================
echo.

if "%JAVA_OK%"=="true" (
    echo ✅ Java 17 - 正常
) else (
    echo ❌ Java 17 - 缺失
)

if "%MAVEN_OK%"=="true" (
    echo ✅ Maven - 正常
) else (
    echo ❌ Maven - 缺失
)

if "%NODE_OK%"=="true" (
    echo ✅ Node.js - 正常
) else (
    echo ❌ Node.js - 缺失
)

if "%DOCKER_OK%"=="true" (
    echo ✅ Docker - 正常
) else (
    echo ⚠️  Docker - 缺失 (可选)
)

if "%MYSQL_OK%"=="true" (
    echo ✅ MySQL - 正常
) else (
    echo ⚠️  MySQL - 缺失 (可选)
)

if "%REDIS_OK%"=="true" (
    echo ✅ Redis - 正常
) else (
    echo ⚠️  Redis - 缺失 (可选)
)

echo.
if "%JAVA_OK%"=="true" if "%MAVEN_OK%"=="true" if "%NODE_OK%"=="true" (
    echo 🎉 核心环境检查通过，可以启动项目！
    echo.
    echo 💡 建议:
    echo - 如果Docker可用，推荐使用Docker启动依赖服务
    echo - 如果MySQL/Redis不可用，请手动安装或使用Docker
    echo - 运行 start-all.bat 开始启动项目
) else (
    echo ❌ 核心环境缺失，请先安装必要的依赖
    echo.
    echo 📝 安装指南:
    echo - Java 17: https://adoptium.net/
    echo - Maven: https://maven.apache.org/download.cgi
    echo - Node.js: https://nodejs.org/
    echo - Docker: https://www.docker.com/products/docker-desktop
)

echo.
echo 按任意键退出...
pause >nul

