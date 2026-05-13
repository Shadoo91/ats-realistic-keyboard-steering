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
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
echo   [DYNAMIC REGEX INJECTOR - WINDOWS SCANCODE FIX]
echo ===================================================================================
echo.

:: 1. Automatische Pfad-Erkennung nur fuer ATS (Prueft Standard und OneDrive)
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%\*" (
    set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"
)
if not exist "%PROFILE_DIR%\*" (
    set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
)

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    echo Please make sure the game is installed and launched at least once.
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Searching for active ATS profiles...
echo.

:: 2. Erstelle ein unzerstoerbares VBScript, das nach NAMEN sucht und Windows-Scancodes nutzt
(
echo Set fso = CreateObject("Scripting.FileSystemObject"^)
echo Set args = WScript.Arguments
echo configFile = args(0^)
echo bakFile = configFile ^& ".bak"
echo If fso.FileExists(configFile^) Then
echo     If Not fso.FileExists(bakFile^) Then fso.CopyFile configFile, bakFile, True
echo     Set file = fso.GetFile(configFile^)
echo     If file.Attributes And 1 Then file.Attributes = file.Attributes - 1
echo     text = fso.OpenTextFile(configFile, 1, False, 0^).ReadAll
echo     Set regEx = New RegExp
echo     regEx.Global = True
echo     regEx.IgnoreCase = True
echo     regEx.MultiLine = True
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix (dsteerleft|dsteerright|dsteering|steering|msteering|mpedals|dforward|dbackward|aforward|abackward|forward|backward)\s+[^""]*"""
echo     If regEx.Test(text^) Then text = regEx.Replace(text, ""^)
echo     regEx.Pattern = "^\s*$"
echo     text = regEx.Replace(text, ""^)
echo     regEx.Pattern = "\s*\}"
echo     newLines = vbCrLf ^& _
echo                " config_lines: ""mix dsteerleft `keyboard.a?0`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix dsteerright `keyboard.d?0`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix steering `dsteering`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix msteering `-mouse.rel_position.x?0 * c_msens`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix mpedals `-mouse.rel_position.y?0 * c_msens`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix dforward `0`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix dbackward `0`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix aforward `(keyboard.w70 * 0.35) + (keyboard.lalt?0 * 0.55)`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix abackward `keyboard.s70 * (0.10 + keyboard.space?0 * 0.50)`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix forward `aforward`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix backward `abackward`""" ^& vbCrLf ^& "}"
echo     text = regEx.Replace(text, newLines^)
echo     Set ts = fso.OpenTextFile(configFile, 2, True, 0^)
echo     ts.Write text
echo     ts.Close
echo     WScript.Echo "  -> Successfully patched in native SCS format!"
echo     file.Attributes = file.Attributes + 1
echo End If
) > "%temp%\ats_vbs_scancode_fix.vbs"

:: 3. Profile durchlaufen und VBScript ausfuehren
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing ATS Profile: %%~nxP
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        cscript //nologo "%temp%\ats_vbs_scancode_fix.vbs" "%%P\controls.sii"
    )
)

del "%temp%\ats_vbs_scancode_fix.vbs" >nul 2>&1

echo.
echo [INFO] Installation process finished.
pause
