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
echo   [UNIVERSAL LOCAL PATCH ENGINE - ANALOG CHANNEL FIX]
echo ===================================================================================
echo.

:: 1. Automatische Pfad-Erkennung
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    echo Please make sure the profile folder is placed inside your Documents folder.
    pause
    exit
)

echo Real active profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Patching configuration files...
echo.

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing ATS Profile: %%~nxP
        
        :: Schreibschutz aufheben
        attrib -r "%%P\controls.sii" >nul 2>&1
        
        :: Backup erstellen, falls noch nicht vorhanden
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        )
        
        :: Filtert die alten Zeilen sauber heraus
        findstr /v /c:"mix dsteer" /c:"mix steering" /c:"mix msteering" /c:"mix mpedals" /c:"mix dforward" /c:"mix dbackward" /c:"mix aforward" /c:"mix abackward" /c:"mix forward" /c:"mix backward" "%%P\controls.sii" > "%temp%\controls_filtered.tmp" 2>nul
        
        :: Entfernt die schliessende Klammer "}" am Ende der Datei
        findstr /v /x "}" "%temp%\controls_filtered.tmp" > "%temp%\controls_ready.tmp" 2>nul
        
        :: Trennt die Logik in saubere analoge Kanaele auf - Verhindert das automatische Zurücksetzen durch das Spiel!
        echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix steering `dsteering`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dforward `0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dbackward `0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix aforward `deadzone((keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55), 0)`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix abackward `deadzone(keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50), 0)`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix forward `aforward`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix backward `abackward`" >> "%temp%\controls_ready.tmp"
        echo } >> "%temp%\controls_ready.tmp"
        
        :: Schiebt die fertige Datei zurueck ins Profil
        copy /y "%temp%\controls_ready.tmp" "%%P\controls.sii" >nul
        
        :: Sandbox bereinigen
        del /f /q "%temp%\controls_filtered.tmp" "%temp%\controls_ready.tmp" >nul 2>&1
        
        :: Schreibschutz für das Spiel wieder rein
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched profile^!
        echo -----------------------------------------------------------------------------------
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
