@echo off
title ATS Profile Uninstaller
setlocal enabledelayedexpansion

:: ==========================================
:: ADMIN-RECHTE PRFEN & ANFORDERN
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
echo   ATS Realistic-Keyboard-Steering (RKS) ~ Uninstaller
echo   [RESTORING ORIGINAL BACKUPS - 100%% SAFE]
echo ===================================================================================
echo.

:: 1. Automatische Pfad-Erkennung
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Restoring original backups...
echo.

:: 2. Profile durchlaufen und das Backup zurckspielen
set "BACKUP_FOUND=0"

for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii.bak" (
        set "BACKUP_FOUND=1"
        echo Restoring Profile: %%~nxP
        
        :: Eventuelle Sperren aufheben
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        attrib -r -s -h "%%P\controls.sii.bak" >nul 2>&1
        
        :: Modifizierte Datei loeschen und Backup umbenennen
        del /q "%%P\controls.sii" >nul 2>&1
        ren "%%P\controls.sii.bak" "controls.sii" >nul 2>&1
        
        echo   -^> Backup successfully restored!
        echo -----------------------------------------------------------------------------------
    )
)

if "!BACKUP_FOUND!"=="0" (
    echo [INFO] No backups found. Nothing to restore.
) else (
    echo.
    echo [INFO] Uninstallation completed successfully! All profiles restored.
)

pause
