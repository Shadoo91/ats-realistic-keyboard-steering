@echo off
title ATS Profile Installer
setlocal enabledelayedexpansion

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
echo   [PRECISE PRESET INJECTOR - 100%% STABLE]
echo ===================================================================================
echo.

if not exist "controls_preset.sii" (
    echo [ERROR] 'controls_preset.sii' not found in this directory!
    pause
    exit
)

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Patching ATS Profile: %%~nxP
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        )
        
        copy /y "controls_preset.sii" "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully injected verified preset!
        echo -----------------------------------------------------------------------------------
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
