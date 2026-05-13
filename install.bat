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
echo   [REAL PATH INJECTOR - NO GHOST FOLDERS]
echo ===================================================================================
echo.

:: 1. Pfade der Reihe nach durchprüfen und schauen, welcher ECHTE Profildaten enthält
set "PROFILE_DIR="

:: Test 1: Lokaler Standard-Ordner (Höchste Priorität!)
if exist "%USERPROFILE%\Documents\American Truck Simulator\profiles\*" (
    set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"
)

:: Test 2: OneDrive Documents (Falls lokal leer oder nicht da)
if not defined PROFILE_DIR (
    if exist "%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles\*" (
        set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
    )
)

:: Test 3: OneDrive Dokumente (Deutsche Variante)
if not defined PROFILE_DIR (
    if exist "%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles\*" (
        set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"
    )
)

:: Sicherheitsnetz: Falls das Skript im falschen, leeren Ordner festsitzt
if defined PROFILE_DIR (
    :: Zähle ob wirklich controls.sii Dateien drin liegen
    set "file_count=0"
    for /r "%PROFILE_DIR%" %%F in (controls.sii) do ( if exist "%%F" set /a file_count+=1 )
    if !file_count! equ 0 ( set "PROFILE_DIR=" )
)

:: 2. Falls kein echter Ordner gefunden wurde, Notfall-Hinweis ausgeben
if not defined PROFILE_DIR (
    echo [ERROR] No active American Truck Simulator profiles found!
    echo.
    echo Windows OneDrive is blocking the automatic path detection.
    echo.
    echo PLEASE DO THIS MANUALLY:
    echo 1. Open your real 'American Truck Simulator\profiles' folder in Windows Explorer.
    echo 2. Copy this 'install.bat' directly into that folder.
    echo 3. Run it from there!
    echo.
    pause
    exit
)

echo Real active profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Patching configuration files...
echo.

:: 3. Profile durchlaufen und dynamisch patchen (Nummernunabhängig)
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        ) else (
            echo   -^> Backup already exists. Skipping backup.
        )
        
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        copy /y "%%P\controls.sii" "%temp%\controls_sandbox.sii" >nul 2>&1
        
        findstr /v /c:"mix dsteer" /c:"mix steering" /c:"mix msteering" /c:"mix mpedals" /c:"mix dforward" /c:"mix dbackward" /c:"mix aforward" /c:"mix abackward" /c:"mix forward" /c:"mix backward" "%temp%\controls_sandbox.sii" > "%temp%\controls_filtered.tmp" 2>nul
        findstr /v /x "}" "%temp%\controls_filtered.tmp" > "%temp%\controls_ready.tmp" 2>nul
        
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
        
        copy /y "%temp%\controls_ready.tmp" "%%P\controls.sii" >nul 2>&1
        del /f /q /a "%temp%\controls_sandbox.sii" "%temp%\controls_filtered.tmp" "%temp%\controls_ready.tmp" >nul 2>&1
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched^!
    )
)

echo.
echo [INFO] Installation process finished.
pause
