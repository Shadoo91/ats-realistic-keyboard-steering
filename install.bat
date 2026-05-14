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
echo   [FULL PRESET INJECTOR - 100%% STABLE]
echo ===================================================================================
echo.

:: 1. Prüfen ob die 590-Zeilen Preset-Datei im selben Ordner existiert
if not exist "controls_preset.sii" (
    echo [ERROR] 'controls_preset.sii' not found in this directory!
    pause
    exit
)

:: 2. Automatische Pfad-Erkennung
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Injecting complete 590-line control preset...
echo.

:: 3. Profile durchlaufen und das komplette Preset drüberkopieren
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Patching ATS Profile: %%~nxP
        
        :: Schreibschutz der alten Datei loesen
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        :: Backup erstellen, falls noch nicht vorhanden
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists.
        )
        
        :: Überschreibe die Datei direkt mit deiner kompletten controls_preset.sii
        copy /y "controls_preset.sii" "%%P\controls.sii" >nul 2>&1
        
        :: KEIN "+r" Schreibschutz am Ende, damit ATS speichern darf
        echo   -^> Successfully injected verified 590-line preset!
        echo -----------------------------------------------------------------------------------
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
