@echo off
title ATS Local Profile Installer
setlocal enabledelayedexpansion

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
echo   [LOCAL DIRECT PATCH ENGINE - NO POWERSHELL - NO VBS]
echo ===================================================================================
echo.

:: Fokus ausschliesslich auf den echten, lokalen Benutzerordner
set "PROFILE_DIR=C:\Users\ar\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] Local American Truck Simulator profiles directory not found!
    echo Please make sure the profile folder '61726E65' is placed inside:
    echo C:\Users\ar\Documents\American Truck Simulator\profiles\
    pause
    exit
)

echo Local profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Patching configuration files...
echo.

for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        :: Schreibschutz aufheben
        attrib -r "%%P\controls.sii" >nul 2>&1
        
        :: Backup erstellen
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        )
        
        :: Filtert die alten Zeilen sauber heraus
        findstr /v /c:"mix dsteer" /c:"mix steering" /c:"mix msteering" /c:"mix mpedals" /c:"mix dforward" /c:"mix dbackward" /c:"mix aforward" /c:"mix abackward" /c:"mix forward" /c:"mix backward" "%%P\controls.sii" > "%temp%\controls_filtered.tmp" 2>nul
        
        :: Entfernt die schliessende Klammer "}" am Ende
        findstr /v /x "}" "%temp%\controls_filtered.tmp" > "%temp%\controls_ready.tmp" 2>nul
        
        :: Fuegt deine Turbo-Zeilen fehlerfrei unten an
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
        
        :: Schiebt die fertige Datei zurueck
        copy /y "%temp%\controls_ready.tmp" "%%P\controls.sii" >nul
        del /f /q "%temp%\controls_filtered.tmp" "%temp%\controls_ready.tmp" >nul 2>&1
        
        :: Schreibschutz fuer das Spiel wieder rein
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched profile^!
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
