@echo off
title ATS Turbo-Input Installer
setlocal enabledelayedexpansion

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91
echo   [AUTOMATIC PRO-SEARCH ENGINE - FIND ANY PROFILE]
echo ===================================================================================
echo.

echo Searching your hard drive for active ATS profiles...
echo (This may take a moment, please wait...)
echo.

set "FOUND_PROFILE=0"

:: Das Skript durchsucht den gesamten Benutzerordner nach der echten controls.sii
for /f "delims=" %%F in ('dir "%USERPROFILE%\controls.sii" /s /b 2^>nul') do (
    set "FILE_PATH=%%F"
    set "DIR_PATH=%%~dpF"
    
    :: Geisterordner oder leere Backup-Verzeichnisse ignorieren
    if exist "!FILE_PATH!" (
        echo Real active profile found at:
        echo "!DIR_PATH!"
        set "FOUND_PROFILE=1"
        
        :: 1. Schreibschutz aufheben
        attrib -r "!FILE_PATH!" >nul 2>&1
        
        :: 2. Backup erstellen, falls noch nicht vorhanden
        if not exist "!DIR_PATH!controls.sii.bak" (
            copy /y "!FILE_PATH!" "!DIR_PATH!controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        )
        
        :: 3. Temporaere Arbeitsdatei leeren
        type nul > "!DIR_PATH!controls.tmp"
        
        :: 4. Datei Zeile fuer Zeile auslesen und exakt ersetzen
        for /f "usebackq tokens=* delims=" %%L in ("!FILE_PATH!") do (
            set "line=%%L"
            set "written=0"
            
            if not "!line:mix dsteerleft=! "=="!line! " ( echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix dsteerright=! "=="!line! " ( echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix dsteering=! "=="!line! " ( echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix steering=! "=="!line! " ( echo  config_lines: "mix steering `dsteering`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix msteering=! "=="!line! " ( echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix mpedals=! "=="!line! " ( echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix dforward=! "=="!line! " ( echo  config_lines: "mix dforward `0`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix dbackward=! "=="!line! " ( echo  config_lines: "mix dbackward `0`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix aforward=! "=="!line! " ( echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix abackward=! "=="!line! " ( echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix forward=! "=="!line! " ( echo  config_lines: "mix forward `aforward`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            if not "!line:mix backward=! "=="!line! " ( echo  config_lines: "mix backward `abackward`" >> "!DIR_PATH!controls.tmp" & set "written=1" )
            
            if "!written!"=="0" (
                echo !line! >> "!DIR_PATH!controls.tmp"
            )
        )
        
        :: 5. Temporaere Datei ueber die originale kopieren
        copy /y "!DIR_PATH!controls.tmp" "!FILE_PATH!" >nul 2>&1
        del /f /q "!DIR_PATH!controls.tmp" >nul 2>&1
        
        :: 6. Schreibschutz wieder aktivieren für das Spiel
        attrib +r "!FILE_PATH!" >nul 2>&1
        echo   -^> Successfully patched^!
        echo.
    )
)

if "!FOUND_PROFILE!"=="0" (
    echo [ERROR] Could not find any active controls.sii file on your PC.
    echo Please start American Truck Simulator at least once to create your profile!
    echo.
)

echo [INFO] Installation completed.
pause
