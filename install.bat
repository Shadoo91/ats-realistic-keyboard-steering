@echo off
title ATS Turbo-Input Installer
setlocal enabledelayedexpansion

echo =======================================================================
echo   ATS Realistic Keyboard Steering Installer for Windows ~ by Shadoo91
echo =======================================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] ATS profile directory not found!
    pause
    exit
)

echo Searching profiles and creating backups...
echo.

for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        :: 1. Backup erstellen, falls noch keins existiert
        if not exist "%%P\controls.sii.bak" (
            copy "%%P\controls.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        :: 2. Schreibschutz aufheben
        attrib -r "%%P\controls.sii"
        
        :: 3. Neue Datei temporaer aufbauen
        type nul > "%%P\controls.tmp"
        
        :: 4. Datei Zeile fuer Zeile lesen und deinen Code exakt einfügen
        for /f "tokens=* delims=" %%L in (%%P\controls.sii) do (
            set "line=%%L"
            
            set "check=!line:config_lines[330]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[331]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[332]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[333]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix steering `dsteering`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[334]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[335]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[336]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix dforward `0`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[337]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix dbackward `0`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[338]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[339]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[340]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix forward `aforward`" >> "%%P\controls.tmp"
            ) else (
            set "check=!line:config_lines[341]:=!"
            if not "!check!"=="!line!" (
                echo  config_lines: "mix backward `abackward`" >> "%%P\controls.tmp"
            ) else (
                echo !line! >> "%%P\controls.tmp"
            ))))))))))))
        )
        
        :: 5. Temporaere Datei zur echten Datei machen
        move /y "%%P\controls.tmp" "%%P\controls.sii" >nul
        
        :: 6. Schreibschutz wieder aktivieren
        attrib +r "%%P\controls.sii"
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
