@echo off
chcp 65001 >nul
echo 正在处理照片规范化命名...

REM 获取当前脚本所在目录
set SCRIPT_DIR=%~dp0
set ROOT_DIR=%SCRIPT_DIR%..

REM 执行PowerShell脚本进行图片重命名
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%rename_food_images.ps1"

echo 图片处理完成！

:menu
cls
echo 请选择要启动的网站版本:
echo 1. 桌面版网站
echo 2. 移动端网站
echo 3. 退出
set /p choice=请输入选择(1-3): 

if "%choice%"=="1" goto desktop
if "%choice%"=="2" goto mobile
if "%choice%"=="3" goto end
goto menu

:desktop
echo 正在启动桌面版网站...
start "" "%ROOT_DIR%\index.html"
goto end

:mobile
echo 正在启动移动端网站...
start "" "%ROOT_DIR%\mobile.html"
goto end

:end
echo 网站已启动！
echo 月子餐与服务照片已根据文件夹中的实际数量自适应显示。
pause 