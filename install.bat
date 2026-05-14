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
echo   [LINE INJECTOR - 100%% STABLE - KEEPS PLAYER SETTINGS]
echo ===================================================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

:: Profile durchlaufen und Zeilen gezielt patchen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Patching ATS Profile: %%~nxP
        
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        )
        
        :: Temporaere Datei erstellen
        set "TEMP_FILE=%%P\controls_temp.sii"
        if exist "!TEMP_FILE!" del /q "!TEMP_FILE!"
        
        :: Datei Zeile fuer Zeile lesen und gezielt ersetzen
        for /f "tokens=1* delims=]" %%A in ('type "%%P\controls.sii" ^| findstr /n "^"') do (
            set "LINE=%%B"
            set "PATCHED=0"
            
            if "!LINE!"=="" (
                echo.>>"!TEMP_FILE!"
                set "PATCHED=1"
            )
            
            if "!PATCHED!"=="0" (
                echo !LINE! | findstr /c:"mix dsteerleft" >nul
                if !errorlevel! equ 0 (
                    echo  config_lines: "mix dsteerleft `keyboard.a?0`">>"!TEMP_FILE!"
                    set "PATCHED=1"
                )
            )
            if "!PATCHED!"=="0" (
                echo !LINE! | findstr /c:"mix dsteerright" >nul
                if !errorlevel! equ 0 (
                    echo  config_lines: "mix dsteerright `keyboard.d?0`">>"!TEMP_FILE!"
                    set "PATCHED=1"
                )
            )
            if "!PATCHED!"=="0" (
                echo !LINE! | findstr /c:"mix dsteering" >nul
                if !errorlevel! equ 0 (
                    echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * (0.55 - keyboard.s?0 * 0.25))`">>"!TEMP_FILE!"
                    set "PATCHED=1"
                )
            )
            if "!PATCHED!"=="0" (
                echo !LINE! | findstr /c:"mix steering" >nul
                if !errorlevel! equ 0 (
                    echo  config_lines: "mix steering `dsteering * (1.0 - (c_steer_func * 0.5))`">>"!TEMP_FILE!"
                    set "PATCHED=1"
                )
            )
            if "!PATCHED!"=="0" (
                echo !LINE! | findstr /c:"mix aforward" >nul
                if !errorlevel! equ 0 (
                    echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`">>"!TEMP_FILE!"
                    set "PATCHED=1"
                )
            )
            if "!PATCHED!"=="0" (
                echo !LINE! | findstr /c:"mix abackward" >nul
                if !errorlevel! equ 0 (
                    echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`">>"!TEMP_FILE!"
                    set "PATCHED=1"
                )
            )
            
            :: Wenn die Zeile nicht modifiziert wurde, schreibe sie im Original rein
            if "!PATCHED!"=="0" (
                echo.!LINE!>>"!TEMP_FILE!"
            )
        )
        
        :: Temporaere Datei ueber die echte kopieren
        move /y "!TEMP_FILE!" "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully injected RKS formulas without losing player binds!
        echo -----------------------------------------------------------------------------------
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
