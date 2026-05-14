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
echo   [PRECISE PRESET INJECTOR - 100%% STABLE]
echo ===================================================================================
echo.

:: 1. Prüfen ob die Preset-Datei im selben Ordner existiert
if not exist "controls_preset.sii" (
    echo [ERROR] 'controls_preset.sii' not found in this directory!
    echo Please make sure to extract all files from the ZIP archive.
    pause
    exit
)

:: 2. Automatische Pfad-Erkennung
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    echo Please make sure the game is installed in your Documents folder.
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Injecting working control preset...
echo.

:: 3. Profile durchlaufen und die funktionierende Datei direkt reinkopieren
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Patching ATS Profile: %%~nxP
        
        :: Schreibschutz aufheben
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        :: Backup erstellen, falls noch nicht vorhanden
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists.
        )
        
        :: Überschreibe die Datei direkt mit deinem funktionierenden Preset!
        copy /y "controls_preset.sii" "%%P\controls.sii" >nul 2>&1
        
        :: Schreibschutz für das Spiel wieder rein
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully injected verified preset!
        echo -----------------------------------------------------------------------------------
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
