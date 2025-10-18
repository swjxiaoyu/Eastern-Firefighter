@echo off
chcp 65001 >nul
echo ==========================================
echo 东方消防员培训平台 - 数据库初始化脚本
echo ==========================================
echo.

:: 设置颜色
color 0E

echo 🗄️ 正在初始化数据库...
echo.

:: 检查MySQL连接
echo 🔍 检查MySQL连接...
mysql -h localhost -P 3306 -u root -pswj21bsss -e "SELECT 1;" >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ MySQL连接失败
    echo 请检查MySQL服务是否运行
    pause
    exit /b 1
)
echo ✅ MySQL连接正常

:: 创建数据库
echo 📦 创建数据库 e-fire...
mysql -h localhost -P 3306 -u root -pswj21bsss -e "CREATE DATABASE IF NOT EXISTS \`e-fire\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul
if %errorlevel% neq 0 (
    echo ❌ 数据库创建失败
    pause
    exit /b 1
)
echo ✅ 数据库创建成功

:: 检查数据库表
echo 🔍 检查数据库表...
mysql -h localhost -P 3306 -u root -pswj21bsss -e "USE \`e-fire\`; SHOW TABLES;" 2>nul | findstr /C:"Tables_in_e-fire" >nul
if %errorlevel% neq 0 (
    echo 📥 数据库为空，正在导入SQL文件...
    mysql -h localhost -P 3306 -u root -pswj21bsss e-fire < E-fire.sql 2>nul
    if %errorlevel% neq 0 (
        echo ❌ SQL文件导入失败
        echo 请检查E-fire.sql文件是否存在
        pause
        exit /b 1
    )
    echo ✅ SQL文件导入成功
) else (
    echo ✅ 数据库表已存在
)

:: 显示表信息
echo.
echo 📊 数据库表信息:
mysql -h localhost -P 3306 -u root -pswj21bsss -e "USE \`e-fire\`; SHOW TABLES;" 2>nul

echo.
echo ==========================================
echo 🎉 数据库初始化完成！
echo ==========================================
echo.
echo 💡 提示:
echo - 现在可以运行 start-all-complete.bat 启动完整服务
echo - 或运行 start-quick.bat 快速启动
echo.
echo 按任意键退出...
pause >nul

