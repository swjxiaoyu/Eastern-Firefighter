@echo off
echo ========================================
echo    东方灭火侠 - 智能体系统启动脚本
echo ========================================
echo.

echo [1/4] 检查环境...
where java >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到Java环境，请先安装JDK 17
    pause
    exit /b 1
)

where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到Maven，请先安装Maven
    pause
    exit /b 1
)

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到Node.js，请先安装Node.js
    pause
    exit /b 1
)

echo 环境检查通过！
echo.

echo [2/4] 编译后端模块...
call mvn clean install -DskipTests -q
if %errorlevel% neq 0 (
    echo 错误: 后端编译失败
    pause
    exit /b 1
)
echo 后端编译完成！
echo.

echo [3/4] 安装前端依赖...
cd frontend
call npm install --silent
if %errorlevel% neq 0 (
    echo 错误: 前端依赖安装失败
    pause
    exit /b 1
)
echo 前端依赖安装完成！
cd ..
echo.

echo [4/4] 启动服务...
echo 正在启动后端服务...
start "后端服务" cmd /k "cd EF-webapp && mvn spring-boot:run"

echo 等待后端服务启动...
timeout /t 10 /nobreak >nul

echo 正在启动前端服务...
start "前端服务" cmd /k "cd frontend && npm run dev"

echo.
echo ========================================
echo    服务启动完成！
echo ========================================
echo.
echo 访问地址:
echo   前端界面: http://localhost:3000
echo   智能体控制台: http://localhost:3000/agent
echo   后端API: http://localhost:8080
echo   健康检查: http://localhost:8080/actuator/health
echo.
echo 智能体功能:
echo   - 创建任务: POST /api/agent/tasks
echo   - 任务状态: GET /api/agent/tasks/{taskId}
echo   - 任务流: GET /api/agent/tasks/{taskId}/stream
echo   - 搜索记忆: GET /api/agent/memory/search
echo.
echo 按任意键退出...
pause >nul

