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
echo   [PYTHON CORE REPLACEMENT ENGINE]
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
echo Executing Python Core Patch Engine...
echo.

:: 2. Schreibe ein unzerstoerbares Python-Skript, das absolut keine Zeichen- oder Cloudfehler kennt
(
echo import os, re, shutil
echo profile_dir = r'%PROFILE_DIR%'
echo new_lines = ''' config_lines: "mix dsteerleft `keyboard.a?0`"
echo  config_lines: "mix dsteerright `keyboard.d?0`"
echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`"
echo  config_lines: "mix steering `dsteering`"
echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`"
echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`"
echo  config_lines: "mix dforward `0`"
echo  config_lines: "mix dbackward `0`"
echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`"
echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`"
echo  config_lines: "mix forward `aforward`"
echo  config_lines: "mix backward `abackward`"'''
echo for root, dirs, files in os.walk(profile_dir^):
echo     if 'controls.sii' in files:
echo         config_file = os.path.join(root, 'controls.sii'^)
echo         bak_file = config_file + '.bak'
echo         print(f"Processing profile: {os.path.basename(root^)}"^)
echo         try:
echo             if not os.path.exists(bak_file^): shutil.copyfile(config_file, bak_file^)
echo             os.chmod(config_file, 0o666^)
echo             with open(config_file, 'r', encoding='utf-8', errors='ignore'^) as f: text = f.read(^)
echo             patched_text = re.sub(r'(?s) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', new_lines, text^)
echo             with open(config_file, 'w', encoding='utf-8', newline='\r\n'^) as f: f.write(patched_text^)
echo             os.chmod(config_file, 0o444^)
echo             print("  -> Successfully patched!"^)
echo         except Exception as e: print(f"  -> [ERROR] Access blocked: {e}"^)
) > "%temp%\ats_py_patch.py"

:: 3. Starte den Python-Kern, der in Windows integriert ist
python "%temp%\ats_py_patch.py" 2>nul
if %errorlevel% neq 0 (
    python3 "%temp%\ats_py_patch.py" 2>nul
)
del "%temp%\ats_py_patch.py"

echo.
echo [INFO] Installation process finished.
pause
