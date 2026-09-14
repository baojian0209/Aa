@echo off
chcp 65001 >nul
title 百日筑基 - 手机访问服务
cd /d "%~dp0"

where python >nul 2>nul
if errorlevel 1 (
  echo.
  echo  没有找到 python，这个方式用不了，请改用微信传文件的办法。
  echo.
  pause
  exit /b
)

echo.
echo  ============================================================
echo   手机和这台电脑要连同一个 WiFi。
echo   然后在手机浏览器里输入下面任意一个地址：
echo  ============================================================
echo.
powershell -NoProfile -Command "$a = ipconfig | Select-String -Pattern 'IPv4'; foreach ($l in $a) { $ip = ($l.ToString() -split ':')[-1].Trim(); if ($ip -ne '127.0.0.1') { '     http://' + $ip + ':8777/index.html' } }"
echo.
echo  ------------------------------------------------------------
echo   第一次运行时，如果 Windows 弹出防火墙提示，请点"允许访问"。
echo   这个黑窗口不要关，关了就访问不了了。用完再关。
echo  ------------------------------------------------------------
echo.

python -m http.server 8777 --bind 0.0.0.0
pause
