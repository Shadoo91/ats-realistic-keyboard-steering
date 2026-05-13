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
echo   [SANDBOX FORCE INJECTOR - ONEDRIVE PROOF]
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
echo Forcing Cloud Sync and executing Sandbox Patch...
echo.

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        :: Aufheben aller Attribute im Cloud-Verzeichnis
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        :: Nativer Windows-Befehl ZWINGT OneDrive zum physischen Download auf die Festplatte
        copy /y "%%P\controls.sii" "%temp%\controls_sandbox.sii" >nul
        
        :: Erst wenn die Datei physisch in der Sandbox liegt, wird das Backup im Cloud-Ordner erstellt
        if not exist "%%P\controls.sii.bak" (
            copy /y "%temp%\controls_sandbox.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        :: Jetzt patcht PowerShell die lokale Sandbox-Datei auf der C-Festplatte (ASCII-erzwungen)
        :: Hier hat OneDrive KEINERLEI Zugriffsrechte und kann nichts blockieren!
        powershell -NoProfile -ExecutionPolicy Bypass -Command "$text = [System.IO.File]::ReadAllText('%temp%\controls_sandbox.sii'); $newLines = ' config_lines: \"mix dsteerleft ``keyboard.a?0``\"' + [Environment]::NewLine + ' config_lines: \"mix dsteerright ``keyboard.d?0``\"' + [Environment]::NewLine + ' config_lines: \"mix dsteering ``(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)``\"' + [Environment]::NewLine + ' config_lines: \"mix steering ``dsteering``\"' + [Environment]::NewLine + ' config_lines: \"mix msteering ``-mouse.rel_position.x?0 * c_msens``\"' + [Environment]::NewLine + ' config_lines: \"mix mpedals ``-mouse.rel_position.y?0 * c_msens``\"' + [Environment]::NewLine + ' config_lines: \"mix dforward ``0``\"' + [Environment]::NewLine + ' config_lines: \"mix dbackward ``0``\"' + [Environment]::NewLine + ' config_lines: \"mix aforward ``(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)``\"' + [Environment]::NewLine + ' config_lines: \"mix abackward ``keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)``\"' + [Environment]::NewLine + ' config_lines: \"mix forward ``aforward``\"' + [Environment]::NewLine + ' config_lines: \"mix backward ``abackward``\"'; $text = $text -replace '(?s) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $newLines; [System.IO.File]::WriteAllText('%temp%\controls_sandbox.sii', $text, [System.Text.Encoding]::ASCII)"
        
        :: Schiebe die fertig manipulierte Datei aus der Sandbox zurück in den OneDrive-Ordner
        copy /y "%temp%\controls_sandbox.sii" "%%P\controls.sii" >nul
        
        :: Sandbox bereinigen
        del /f /q "%temp%\controls_sandbox.sii" >nul 2>&1
        
        :: Schreibschutz im Spielordner wieder aktivieren
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched!
    )
)

echo.
echo [INFO] Installation process finished.
pause
