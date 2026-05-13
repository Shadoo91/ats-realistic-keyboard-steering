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
echo   [SAFE APPEND ENGINE - STRIKT ATS FILTER]
echo ===================================================================================
echo.

echo Scanning system for active ATS profiles...
echo.

:: 1. VBScript das NUR die allerletzte schliessende Klammer modifiziert.
:: Verhindert das versehentliche Loeschen von anderen Belegungen!
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
echo     regEx.Pattern = " config_lines\[\d+\]:\s*""mix (dsteerleft|dsteerright|dsteering|steering|msteering|mpedals|dforward|dbackward|aforward|abackward|forward|backward)\s+[^""]*""[\r\n]*"
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
echo                " config_lines: ""mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix forward `aforward`""" ^& vbCrLf ^& _
echo                " config_lines: ""mix backward `abackward`""" ^& vbCrLf ^& "}"
echo     text = regEx.Replace(text, newLines^)
echo     Set ts = fso.OpenTextFile(configFile, 2, True, 0^)
echo     ts.Write text
echo     ts.Close
echo End If
) > "%temp%\ats_vbs_append.vbs"

set "FOUND_ANY=0"

:: 2. Die Suchmaschine mit DEINEM STRIKTEN ATS-Profil-Filter
for /f "delims=" %%F in ('dir "%USERPROFILE%\controls.sii" /s /b 2^>nul') do (
    set "FILE_PATH=%%F"
    set "DIR_PATH=%%~dpF"
    
    :: DEIN STRIKTER FILTER: Nur American Truck Simulator/profiles zulassen!
    echo !FILE_PATH! | findstr /i /c:"American Truck Simulator\profiles" >nul 2>&1
    if !errorlevel! equ 0 (
        echo !FILE_PATH! | findstr /i /c:".bak" >nul 2>&1
        if !errorlevel! neq 0 (
            echo Real ATS Profile Detected:
            echo "!FILE_PATH!"
            set "FOUND_ANY=1"
            
            attrib -r -s -h "!FILE_PATH!" >nul 2>&1
            
            if not exist "!DIR_PATH!controls.sii.bak" (
                copy /y "!FILE_PATH!" "!DIR_PATH!controls.sii.bak" >nul 2>&1
                echo   -^> Backup created: controls.sii.bak
            )
            
            copy /y "!FILE_PATH!" "%temp%\controls_sandbox.sii" >nul 2>&1
            cscript //nologo "%temp%\ats_vbs_append.vbs" "%temp%\controls_sandbox.sii" >nul 2>&1
            
            replace "%temp%\controls_sandbox.sii" "!DIR_PATH!." /R /U >nul 2>&1
            copy /y "%temp%\controls_sandbox.sii" "!FILE_PATH!" >nul 2>&1
            
            del /f /q "%temp%\controls_sandbox.sii" >nul 2>&1
            attrib +r "!FILE_PATH!" >nul 2>&1
            echo   -^> SUCCESSFULLY PATCHED!
            echo -----------------------------------------------------------------------------------
        )
    )
)

del "%temp%\ats_vbs_append.vbs" >nul 2>&1

if "!FOUND_ANY!"=="0" (
    echo [ERROR] No active American Truck Simulator profiles found on this PC.
)

echo.
echo [INFO] Installation completed.
pause
