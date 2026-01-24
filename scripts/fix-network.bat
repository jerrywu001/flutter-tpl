@echo off
chcp 65001 >nul
echo ========================================
echo Flutter 网络问题完整修复方案
echo ========================================
echo.

echo [1/6] 停止 Gradle 守护进程...
cd android
call gradlew.bat --stop
cd ..

echo.
echo [2/6] 清理 Flutter 缓存...
call flutter clean

echo.
echo [3/6] 删除 Gradle 缓存目录...
if exist android\.gradle (
    echo 删除 android\.gradle
    rmdir /s /q android\.gradle
)
if exist android\.kotlin (
    echo 删除 android\.kotlin
    rmdir /s /q android\.kotlin
)
if exist android\build (
    echo 删除 android\build
    rmdir /s /q android\build
)

echo.
echo [4/6] 验证镜像配置...
echo 检查环境变量:
echo PUB_HOSTED_URL=%PUB_HOSTED_URL%
echo FLUTTER_STORAGE_BASE_URL=%FLUTTER_STORAGE_BASE_URL%

echo.
echo [5/6] 重新获取 Flutter 依赖...
call flutter pub get

echo.
echo [6/6] 尝试构建...
echo 如果仍然失败，请检查:
echo 1. 网络连接是否正常
echo 2. 是否可以访问清华镜像: https://mirrors.tuna.tsinghua.edu.cn
echo 3. 防火墙/代理设置
echo.

echo ========================================
echo 修复完成！
echo ========================================
echo.
echo 现在可以尝试运行:
echo   npm run dev
echo.
echo 如果仍然失败，请尝试:
echo 1. 重启电脑
echo 2. 使用 VPN
echo 3. 检查 BUILD_ISSUES.md 文档
echo.

pause
