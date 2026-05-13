@echo off
title ATS Profile Installer
setlocal enabledelayedexpansion

:: ==========================================
:: ADMIN-RECHTE PRÜFEN & ANFORDERN
:: ==========================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

cd /d "%~dp0"

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
echo   [SAFE POWERSHELL ENGINE - ORIGINAL VALUES PROTECTED]
echo ===================================================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Patching configuration files with your original math...
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$dir = '%PROFILE_DIR%'; ^
     $files = Get-ChildItem -Path $dir -Filter 'controls.sii' -Recurse; ^
     foreach ($file in $files) { ^
         Write-Host 'Patching Profile:' $file.Directory.Name -ForegroundColor Cyan; ^
         $bak = $file.FullName + '.bak'; ^
         if (-not (Test-Path $bak)) { Copy-Item $file.FullName $bak -Force }; ^
         [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal); ^
         $text = [System.IO.File]::ReadAllText($file.FullName); ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix dsteerleft\s+.*\"', ' config_lines: \"mix dsteerleft `keyboard.a?0`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix dsteerright\s+.*\"', ' config_lines: \"mix dsteerright `keyboard.d?0`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix dsteering\s+.*\"', ' config_lines: \"mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix steering\s+.*\"', ' config_lines: \"mix steering `dsteering`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix msteering\s+.*\"', ' config_lines: \"mix msteering `-mouse.rel_position.x?0 * c_msens`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix mpedals\s+.*\"', ' config_lines: \"mix mpedals `-mouse.rel_position.y?0 * c_msens`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix dforward\s+.*\"', ' config_lines: \"mix dforward `0`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix dbackward\s+.*\"', ' config_lines: \"mix dbackward `0`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix aforward\s+.*\"', ' config_lines: \"mix aforward `0`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix abackward\s+.*\"', ' config_lines: \"mix abackward `0`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix forward\s+.*\"', ' config_lines: \"mix forward `deadzone((keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55), 0)`\"'; ^
         $text = $text -replace '(?m)^\s*config_lines\[\d+\]:\s*\"mix backward\s+.*\"', ' config_lines: \"mix backward `deadzone(keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50), 0)`\"'; ^
         [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.Encoding]::ASCII); ^
         [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly); ^
         Write-Host '  -> Successfully patched with your exact values!' -ForegroundColor Green; ^
     }"

echo.
echo [INFO] Installation completed successfully!
pause
