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
echo   [NATIVE BATCH INJECTOR - NO POWERSHELL]
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

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        :: Attribute aufheben und Windows zwingen, die Datei lokal bereitzustellen
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        type "%%P\controls.sii" >nul 2>&1
        
        :: Backup erstellen per nativem Windows-Befehl
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        :: Temporaere Arbeitsdatei loeschen falls vorhanden
        if exist "%%P\controls.tmp" del /f /q "%%P\controls.tmp" >nul
        
        :: Datei Zeile fuer Zeile auslesen und manipulierten Block injizieren
        set "in_block=0"
        for /f "usebackq tokens=* delims=" %%L in ("%%P\controls.sii") do (
            set "line=%%L"
            
            :: Pruefen ob der zu ersetzende Block beginnt
            echo !line! | findstr /c:"config_lines[330]:" >nul
            if !errorlevel! equ 0 (
                set "in_block=1"
                echo  config_lines[330]: "mix dsteerleft `keyboard.a?0`" >> "%%P\controls.tmp"
                echo  config_lines[331]: "mix dsteerright `keyboard.d?0`" >> "%%P\controls.tmp"
                echo  config_lines[332]: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%%P\controls.tmp"
                echo  config_lines[333]: "mix steering `dsteering`" >> "%%P\controls.tmp"
                echo  config_lines[334]: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%%P\controls.tmp"
                echo  config_lines[335]: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%%P\controls.tmp"
                echo  config_lines[336]: "mix dforward `0`" >> "%%P\controls.tmp"
                echo  config_lines[337]: "mix dbackward `0`" >> "%%P\controls.tmp"
                echo  config_lines[338]: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%%P\controls.tmp"
                echo  config_lines[339]: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%%P\controls.tmp"
                echo  config_lines[340]: "mix forward `aforward`" >> "%%P\controls.tmp"
                echo  config_lines[341]: "mix backward `abackward`" >> "%%P\controls.tmp"
            )
            
            :: Pruefen ob der Block endet
            echo !line! | findstr /c:"config_lines[341]:" >nul
            if !errorlevel! equ 0 (
                set "in_block=0"
                goto :skip_line
            )
            
            if !in_block! equ 0 (
                echo !line! >> "%%P\controls.tmp"
            )
            :skip_line
            set "dummy=1"
        )
        
        :: Temporaere Datei ueber die originale Datei kopieren (erhaelt UTF-8-Format)
        copy /y "%%P\controls.tmp" "%%P\controls.sii" >nul
        del /f /q "%%P\controls.tmp" >nul
        
        :: Schreibschutz wieder aktivieren fuer das Spiel
        attrib +r "%%P\controls.sii"
        echo   -^> Successfully patched^!
    )
)

echo.
echo [INFO] Installation process finished.
pause
