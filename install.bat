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
echo   [SANDBOX APP-INJECTOR - NATIVE ONEDRIVE BYPASS]
echo ===================================================================================
echo.

:: 1. Pfade definieren (Scharfe Fokussierung auf den OneDrive-Pfad deines Kumpels)
set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Forcing Cloud Stream and executing Sandbox Patch...
echo.

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        :: Attribute im Cloud-Verzeichnis aufheben
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        :: DIE RETTUNG: Nativer Windows-Befehl ZWINGT OneDrive zum physischen Download auf die Festplatte
        copy /y "%%P\controls.sii" "%temp%\controls_sandbox.sii" >nul
        
        :: Erst wenn die Datei physisch in der Sandbox liegt, wird das Backup im Cloud-Ordner erstellt
        if not exist "%%P\controls.sii.bak" (
            copy /y "%temp%\controls_sandbox.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        :: Temporaere Arbeitsdatei loeschen falls vorhanden
        if exist "%temp%\controls_ready.tmp" del /f /q "%temp%\controls_ready.tmp" >nul
        
        :: 3. Datei Zeile fuer Zeile auslesen und manipulierten Block injizieren
        set "patched=0"
        for /f "usebackq tokens=* delims=" %%L in ("%temp%\controls_sandbox.sii") do (
            set "line=%%L"
            set "written=0"
            
            if not "!line:mix dsteerleft=! "=="!line! " ( echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dsteerright=! "=="!line! " ( echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dsteering=! "=="!line! " ( echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix steering=! "=="!line! " ( echo  config_lines: "mix steering `dsteering`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix msteering=! "=="!line! " ( echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix mpedals=! "=="!line! " ( echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dforward=! "=="!line! " ( echo  config_lines: "mix dforward `0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix dbackward=! "=="!line! " ( echo  config_lines: "mix dbackward `0`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix aforward=! "=="!line! " ( echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix abackward=! "=="!line! " ( echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix forward=! "=="!line! " ( echo  config_lines: "mix forward `aforward`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            if not "!line:mix backward=! "=="!line! " ( echo  config_lines: "mix backward `abackward`" >> "%temp%\controls_ready.tmp" & set "written=1" )
            
            if "!written!"=="0" (
                echo !line! >> "%temp%\controls_ready.tmp"
            )
        )
        
        :: Schiebe die fertig modifizierte Datei aus der Sandbox zurueck zu OneDrive
        copy /y "%temp%\controls_ready.tmp" "%%P\controls.sii" >nul
        
        :: Sandbox bereinigen
        del /f /q "%temp%\controls_sandbox.sii" "%temp%\controls_ready.tmp" >nul 2>&1
        
        :: Schreibschutz im Spielordner wieder aktivieren für SCS
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched^!
    )
)

echo.
echo [INFO] Installation process finished.
pause
