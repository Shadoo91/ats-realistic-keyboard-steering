@echo off
title SCS Games Turbo-Input Installer
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
echo   ATS ^& ETS2 Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
echo   [OMNIPRESENT TARGET INJECTOR - ATS ^& ETS2 MULTI-PATCH]
echo ===================================================================================
echo.

echo Scanning your system for active ATS ^& ETS2 profiles...
echo Please wait a moment...
echo.

set "FOUND_ANY=0"

:: Durchsucht den gesamten Benutzerordner (inklusive Dokumente und OneDrive) nach JEDER controls.sii
for /f "delims=" %%F in ('dir "%USERPROFILE%\controls.sii" /s /b 2^>nul') do (
    set "FILE_PATH=%%F"
    set "DIR_PATH=%%~dpF"
    
    if exist "!FILE_PATH!" (
        echo Target Profile Detected:
        echo "!FILE_PATH!"
        set "FOUND_ANY=1"
        
        attrib -r -s -h "!FILE_PATH!" >nul 2>&1
        
        if not exist "!DIR_PATH!controls.sii.bak" (
            copy /y "!FILE_PATH!" "!DIR_PATH!controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists.
        )
        
        copy /y "!FILE_PATH!" "%temp%\controls_sandbox.sii" >nul 2>&1
        if exist "%temp%\controls_ready.tmp" del /f /q "%temp%\controls_ready.tmp" >nul
        
        for /f "usebackq tokens=* delims=" %%L in ("%temp%\controls_sandbox.sii") do (
            set "line=%%L"
            set "written=0"
            
            if not "!line:mix dsteerleft=! "=="!line! " ( echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dsteerright=! "=="!line! " ( echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dsteering=! "=="!line! " ( echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix steering=! "=="!line! " ( echo  config_lines: "mix steering `dsteering`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix msteering=! "=="!line! " ( echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix mpedals=! "=="!line! " ( echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dforward=! "=="!line! " ( echo  config_lines: "mix dforward `0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dbackward=! "=="!line! " ( echo  config_lines: "mix dbackward `0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix aforward=! "=="!line! " ( echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix abackward=! "=="!line! " ( echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix forward=! "=="!line! " ( echo  config_lines: "mix forward `aforward`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix backward=! "=="!line! " ( echo  config_lines: "mix backward `abackward`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            
            if "!written!"=="0" (
                echo !line! >> "%temp%\controls_ready.tmp"
            )
        )
        
        replace "%temp%\controls_ready.tmp" "!DIR_PATH!." /R /U >nul 2>&1
        copy /y "%temp%\controls_ready.tmp" "!FILE_PATH!" >nul 2>&1
        
        del /f /q "%temp%\controls_sandbox.sii" "%temp%\controls_ready.tmp" >nul 2>&1
        attrib +r "!FILE_PATH!" >nul 2>&1
        echo   -^> SUCCESSFULLY PATCHED!
        echo -----------------------------------------------------------------------------------
    )
)

if "!FOUND_ANY!"=="0" (
    echo [ERROR] No active ATS or ETS2 profiles found on this PC.
)

echo.
echo [INFO] Installation completed. Both games patched if detected.
pause
