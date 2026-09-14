@echo off
cd /d "%~dp0"
echo.
echo  =========================================================
echo   Uploading to GitHub:
echo   https://github.com/baojian0209/Aa
echo  =========================================================
echo.
echo   1. A GitHub login window may pop up. Click
echo      "Sign in with your browser", then click "Authorize".
echo   2. Do NOT close this window. Wait for the word DONE.
echo.
echo   ---------------------------------------------------------
echo   Starting now, please wait...
echo.

git remote remove origin 1>nul 2>nul
git remote add origin https://github.com/baojian0209/Aa.git
git push -u origin master > "upload-log.txt" 2>&1

echo.
echo  --------------- result ---------------
type "upload-log.txt"
echo  --------------------------------------
echo.
echo   DONE. Log saved in upload-log.txt
echo   Check the website: https://github.com/baojian0209/Aa
echo.
pause
