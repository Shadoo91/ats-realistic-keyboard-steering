@echo off
title ATS Profile Installer
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
echo   [PRECISE BLOCK INJECTOR - NO LINE COUNT ALTERATION]
echo ===================================================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%\*" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Executing precise line replacement...
echo.

:: 1. Erstelle das VBScript, das die Werte exakt an Ort und Stelle austauscht.
:: Das verhindert, dass findstr unbemerkt die halbe Datei weglöscht!
(
echo Set fso = CreateObject("Scripting.FileSystemObject"^)
echo Set args = WScript.Arguments
echo configFile = args(0^)
echo If fso.FileExists(configFile^) Then
echo     text = fso.OpenTextFile(configFile, 1, False, 0^).ReadAll
echo     Set regEx = New RegExp
echo     regEx.Global = True
echo     regEx.IgnoreCase = True
echo     regEx.MultiLine = True
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix dsteerleft\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix dsteerleft `keyboard.a?0`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix dsteerright\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix dsteerright `keyboard.d?0`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix dsteering\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix steering\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix steering `dsteering`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix msteering\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix msteering `-mouse.rel_position.x?0 * c_msens`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix mpedals\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix mpedals `-mouse.rel_position.y?0 * c_msens`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix dforward\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix dforward `0`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix dbackward\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix dbackward `0`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix aforward\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix aforward `0`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix abackward\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix abackward `0`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix forward\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix forward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`"""^)
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix backward\s+[^""]*"""
echo     text = regEx.Replace(text, " config_lines: ""mix backward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`"""^)
echo     Set ts = fso.OpenTextFile(configFile, 2, True, 0^)
echo     ts.Write text
echo     ts.Close
echo End If
) > "%temp%\ats_block_inject.vbs"

:: 2. Profile durchlaufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing ATS Profile: %%~nxP
        attrib -r -s -h "%%P\controls.sii" >nul 2>&1
        
        if not exist "%%P\controls.sii.bak" (
            copy /y "%%P\controls.sii" "%%P\controls.sii.bak" >nul 2>&1
            echo   -^> Backup created: controls.sii.bak
        )
        
        cscript //nologo "%temp%\ats_block_inject.vbs" "%%P\controls.sii"
        attrib +r "%%P\controls.sii" >nul 2>&1
        echo   -^> Successfully patched profile!
        echo -----------------------------------------------------------------------------------
    )
)

del "%temp%\ats_block_inject.vbs" >nul 2>&1
echo [INFO] Installation completed.
pause
