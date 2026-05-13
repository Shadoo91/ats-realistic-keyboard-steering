@echo off
title ATS Turbo-Input Installer
setlocal enabledelayedexpansion

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91
echo   [RAW BATCH APPEND ENGINE - NO SCRIPTING DEPENDENCIES]
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
echo Patching configuration files...
echo.

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        :: Schreibschutz brechen und OneDrive-Download erzwingen
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        type "%%P\controls.sii" >nul 2>&1
        
        :: Backup erstellen, falls noch nicht vorhanden
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        :: Erstelle eine saubere temporaere Datei OHNE die alten Zeilen 330-341
        :: findstr filtert alle Zeilen heraus, die diese Nummern oder deine alten Patches enthalten
        findstr /v /c:"config_lines[330]:" /c:"config_lines[331]:" /c:"config_lines[332]:" /c:"config_lines[333]:" /c:"config_lines[334]:" /c:"config_lines[335]:" /c:"config_lines[336]:" /c:"config_lines[337]:" /c:"config_lines[338]:" /c:"config_lines[339]:" /c:"config_lines[340]:" /c:"config_lines[341]:" /c:"mix dsteer" /c:"mix steering" /c:"mix msteering" /c:"mix mpedals" /c:"mix dforward" /c:"mix dbackward" /c:"mix aforward" /c:"mix abackward" /c:"mix forward" /c:"mix backward" "%%P\controls.sii" > "%%P\controls.tmp"
        
        :: Jetzt loeschen wir die letzte schliessende Klammer "}" der Datei, um unseren Code vor ihr einzufuegen
        findstr /v /x "}" "%%P\controls.tmp" > "%%P\controls.sii"
        del /f /q "%%P\controls.tmp" >nul 2>&1
        
        :: Jetzt klatschen wir deine neuen Turbo-Zeilen und die schliessende Klammer einfach unten ran!
        :: Keine Schleifen, kein PowerShell, kein JScript. Reiner Text-Append.
        echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%%P\controls.sii"
        echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%%P\controls.sii"
        echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%%P\controls.sii"
        echo  config_lines: "mix steering `dsteering`" >> "%%P\controls.sii"
        echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%%P\controls.sii"
        echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%%P\controls.sii"
        echo  config_lines: "mix dforward `0`" >> "%%P\controls.sii"
        echo  config_lines: "mix dbackward `0`" >> "%%P\controls.sii"
        echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%%P\controls.sii"
        echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%%P\controls.sii"
        echo  config_lines: "mix forward `aforward`" >> "%%P\controls.sii"
        echo  config_lines: "mix backward `abackward`" >> "%%P\controls.sii"
        echo } >> "%%P\controls.sii"
        
        :: Schreibschutz wieder aktivieren, damit das Spiel es frisst
        attrib +r "%%P\controls.sii"
        echo   -^> Successfully patched^!
    )
)

echo.
echo [INFO] Installation process finished.
pause
