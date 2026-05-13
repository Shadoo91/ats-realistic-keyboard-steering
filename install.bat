@echo off
title ATS Turbo-Input Installer
setlocal enabledelayedexpansion

echo ===================================================
echo   ATS Turbo Keyboard Input Installer for Windows  
echo ===================================================
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
        
        if not exist "%%P\controls.sii.bak" (
            copy "%%P\controls.sii" "%%P\controls.sii.bak" >nul
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        attrib -r "%%P\controls.sii"
        type nul > "%%P\controls.tmp"
        
        for /f "usebackq tokens=* delims=" %%L in ("%%P\controls.sii") do (
            set "line=%%L"
            set "patched=0"
            
            :: Loest das Nummern-Problem: Sucht nach den NAMEN statt nach den Nummern!
            if not "!line:mix dsteerleft=! "=="!line! " ( echo  config_lines: "mix dsteerleft `keyboard.a?0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix dsteerright=! "=="!line! " ( echo  config_lines: "mix dsteerright `keyboard.d?0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix dsteering=! "=="!line! " ( echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix steering=! "=="!line! " ( echo  config_lines: "mix steering `dsteering`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix msteering=! "=="!line! " ( echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix mpedals=! "=="!line! " ( echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix dforward=! "=="!line! " ( echo  config_lines: "mix dforward `0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix dbackward=! "=="!line! " ( echo  config_lines: "mix dbackward `0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix aforward=! "=="!line! " ( echo  config_lines: "mix aforward `0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix abackward=! "=="!line! " ( echo  config_lines: "mix abackward `0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix forward=! "=="!line! " ( echo  config_lines: "mix forward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:mix backward=! "=="!line! " ( echo  config_lines: "mix backward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%%P\controls.tmp" & set "patched=1" )
            
            if "!patched!"=="0" (
                echo !line! >> "%%P\controls.tmp"
            )
        )
        
        move /y "%%P\controls.tmp" "%%P\controls.sii" >nul
        attrib +r "%%P\controls.sii"
    )
)

echo.
echo [INFO] Installation completed successfully!
pause
