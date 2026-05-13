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
            if not "!line:config_lines[330]:=!"=="!line!" ( echo  config_lines[330]: "mix dsteerleft `keyboard.a?0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[331]:=!"=="!line!" ( echo  config_lines[331]: "mix dsteerright `keyboard.d?0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[332]:=!"=="!line!" ( echo  config_lines[332]: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[333]:=!"=="!line!" ( echo  config_lines[333]: "mix steering `dsteering`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[334]:=!"=="!line!" ( echo  config_lines[334]: "mix msteering `-mouse.rel_position.x?0 * c_msens`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[335]:=!"=="!line!" ( echo  config_lines[335]: "mix mpedals `-mouse.rel_position.y?0 * c_msens`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[336]:=!"=="!line!" ( echo  config_lines[336]: "mix dforward `0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[337]:=!"=="!line!" ( echo  config_lines[337]: "mix dbackward `0`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[338]:=!"=="!line!" ( echo  config_lines[338]: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[339]:=!"=="!line!" ( echo  config_lines[339]: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[340]:=!"=="!line!" ( echo  config_lines[340]: "mix forward `aforward`" >> "%%P\controls.tmp" & set "patched=1" )
            if not "!line:config_lines[341]:=!"=="!line!" ( echo  config_lines[341]: "mix backward `abackward`" >> "%%P\controls.tmp" & set "patched=1" )
            
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
