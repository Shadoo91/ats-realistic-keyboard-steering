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
echo   [SANDBOX APPENDER - ONEDRIVE SAFE]
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
        
        :: Backup erstellen, falls noch nicht vorhanden
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        :: Schreibschutz im OneDrive aufheben
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        :: Kopiere die Datei in das lokale Temp-Verzeichnis (Sandbox)
        copy /y "%%P\controls.sii" "%temp%\controls_sandbox.sii" >nul 2>&1
        
        :: Bereinige die Sandkasten-Datei von alten Zeilen
        findstr /v /c:"mix dsteer" /c:"mix steering" /c:"mix msteering" /c:"mix mpedals" /c:"mix dforward" /c:"mix dbackward" /c:"mix aforward" /c:"mix abackward" /c:"mix forward" /c:"mix backward" "%temp%\controls_sandbox.sii" > "%temp%\controls_filtered.tmp" 2>nul
        
        :: Entferne die schliessende Klammer am Ende
        findstr /v /x "}" "%temp%\controls_filtered.tmp" > "%temp%\controls_ready.tmp" 2>nul
        
        :: Schreibe deine neuen Turbo-Zeilen direkt in die lokale Sandbox-Datei
        echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix steering `dsteering`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dforward `0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix dbackward `0`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix forward `aforward`" >> "%temp%\controls_ready.tmp"
        echo  config_lines: "mix backward `abackward`" >> "%temp%\controls_ready.tmp"
        echo } >> "%temp%\controls_ready.tmp"
        
        :: Schiebe die fertig modifizierte Datei per erzwungenem Overwrite zurück zu OneDrive
        copy /y "%temp%\controls_ready.tmp" "%%P\controls.sii" >nul 2>&1
        
        :: Aufraeumen in der lokalen Sandbox mit erzwungenem Kill
        del /f /q /a "%temp%\controls_sandbox.sii" "%temp%\controls_filtered.tmp" "%temp%\controls_ready.tmp" >nul 2>&1
        
        :: Schreibschutz im OneDrive wieder rein, damit ATS die Datei akzeptiert
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched^!
    )
)

echo.
echo [INFO] Installation process finished.
pause
