@echo off
title ATS Turbo-Input Installer
echo Launching Installer...
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (New-Object Net.WebClient).DownloadString('https://github.com/Shadoo91/ats-realistic-keyboard-steering')"
if %errorlevel% neq 0 (
    echo [ERROR] Script failed to launch! Make sure you are connected to the internet.
    pause
)
