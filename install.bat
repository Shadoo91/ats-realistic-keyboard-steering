@echo off
title ATS Turbo-Input Installer
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
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91
echo   [PRECISE INDEX INJECTOR - NO DUPLICATES]
echo ===================================================================================
echo.

:: 1. Pfade definieren (Standard und OneDrive)
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Patching configuration files via local sandbox...
echo.

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        copy /y "%%P\controls.sii" "%temp%\controls_sandbox.sii" >nul 2>&1
        
        type nul > "%temp%\controls_ready.tmp"
        
        :: 3. Datei Zeile fuer Zeile lesen und die Indizes 330 bis 341 exakt austauschen
        for /f "usebackq tokens=* delims=" %%L in ("%temp%\controls_sandbox.sii") do (
            set "line=%%L"
            set "written=0"
            
            if not "!line:config_lines[330]:=!"=="!line!" ( echo  config_lines[330]: "mix dsteerleft `keyboard.a?0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[331]:=!"=="!line!" ( echo  config_lines[331]: "mix dsteerright `keyboard.d?0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[332]:=!"=="!line!" ( echo  config_lines[332]: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[333]:=!"=="!line!" ( echo  config_lines[333]: "mix steering `dsteering`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[334]:=!"=="!line!" ( echo  config_lines[334]: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[335]:=!"=="!line!" ( echo  config_lines[335]: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[336]:=!"=="!line!" ( echo  config_lines[336]: "mix dforward `0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[337]:=!"=="!line!" ( echo  config_lines[337]: "mix dbackward `0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[338]:=!"=="!line!" ( echo  config_lines[338]: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[339]:=!"=="!line!" ( echo  config_lines[339]: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[340]:=!"=="!line!" ( echo  config_lines[340]: "mix forward `aforward`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:config_lines[341]:=!"=="!line!" ( echo  config_lines[341]: "mix backward `abackward`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            
            if "!written!"=="0" (
                echo !line! >> "%temp%\controls_ready.tmp"
            )
        )
        
        copy /y "%temp%\controls_ready.tmp" "%%P\controls.sii" >nul 2>&1
        del /f /q /a "%temp%\controls_sandbox.sii" "%temp%\controls_ready.tmp" >nul 2>&1
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched^!
    )
)

echo.
echo [INFO] Installation process finished.
pause
