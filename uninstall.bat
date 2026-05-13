@echo off
title ATS Profile Uninstaller
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
echo   ATS Realistic-Keyboard-Steering (RKS) ~ by Shadoo91
echo   [UNIVERSAL UNINSTALLER - RESTORE ALL PROFILES]
echo ===================================================================================
echo.

:: 1. Automatische Pfad-Erkennung (Fokus auf echten lokalen Dokumentenordner)
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    echo Nothing to restore.
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Searching for backups and restoring original controls...
echo.

set "RESTORED_ANY=0"

:: 2. Alle Profile im Ordner durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii.bak" (
        echo Processing ATS Profile: %%~nxP
        set "RESTORED_ANY=1"
        
        :: Attribute aufheben, um Schreibblockaden zu verhindern
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        attrib -r -s -h "%%P\controls.sii.bak" >nul 2>&1
        
        :: Aktuelle modifizierte Datei loeschen
        del /f /q "%%P\controls.sii" >nul 2>&1
        
        :: Backup-Sicherung in die originale controls.sii zurueckkopieren
        copy /y "%%P\controls.sii.bak" "%%P\controls.sii" >nul 2>&1
        
        :: Optionale Bereinigung: Die .bak Datei nach der Wiederherstellung entfernen
        del /f /q "%%P\controls.sii.bak" >nul 2>&1
        
        echo   -^> Original backup successfully restored!
        echo -----------------------------------------------------------------------------------
    )
)

echo.
if "!RESTORED_ANY!"=="0" (
    echo [INFO] No backup files (.bak) found. Your profiles are already using default controls.
) else (
    echo [INFO] Uninstallation completed successfully! All profiles restored to original layout.
)

pause
