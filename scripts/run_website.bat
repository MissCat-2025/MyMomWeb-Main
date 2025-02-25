@echo off
chcp 65001 >nul
echo 正在处理照片规范化命名...

REM 获取当前脚本所在目录
set SCRIPT_DIR=%~dp0
set ROOT_DIR=%SCRIPT_DIR%..

REM 执行PowerShell脚本进行图片重命名
powershell -ExecutionPolicy Bypass -File "%SCRIPT_DIR%rename_food_images.ps1"

echo 图片处理完成！
echo 正在启动网站...

REM 打开网站首页
start "" "%ROOT_DIR%\index.html"

echo 网站已启动！
echo 月子餐与服务照片已根据文件夹中的实际数量自适应显示。
pause 