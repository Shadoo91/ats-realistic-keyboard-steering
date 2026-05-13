@echo off
title SCS Games Turbo-Input Installer
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
echo   ATS ^& ETS2 Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
echo   [NATIVE HYBRID INJECTOR - ENFORCED SCS-ASCII FORMAT]
echo ===================================================================================
echo.

:: 1. Automatische Pfad-Erkennung für ATS und ETS2 (Prüft Standard und OneDrive)
set "PROFILE_DIR=%USERPROFILE%\Documents"
if not exist "%PROFILE_DIR%\American Truck Simulator\profiles" (
    set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente"
)
if not exist "%PROFILE_DIR%\American Truck Simulator\profiles" (
    set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents"
)

echo Searching for active game profiles...
echo.

:: 2. Erstelle eine saubere, temporäre VBScript-Datei in der lokalen Sandbox.
:: VBScript liest die Datei als Ganzblock ein und zerschießt niemals die Backticks.
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
echo     regEx.Pattern = " config_lines\[330\]:[\s\S]*?config_lines\[341\]:[^\r\n]*"
echo     newLines = " config_lines: ""mix dsteerleft `keyboard.a?0`""" ^& vbCrLf ^& _
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
echo                " config_lines: ""mix backward `abackward`"""
echo     If regEx.Test(text^) Then
echo         text = regEx.Replace(text, newLines^)
echo         Set ts = fso.OpenTextFile(configFile, 2, True, 0^)
echo         ts.Write text
echo         ts.Close
echo         WScript.Echo "  -> Successfully patched!"
echo     Else
echo         WScript.Echo "  -> [ERROR] Target lines not found or already modified."
echo     End If
echo     file.Attributes = file.Attributes + 1
echo End If
) > "%temp%\ats_ets_vbs_core.vbs"

:: 3. American Truck Simulator patchen (falls vorhanden)
if exist "%PROFILE_DIR%\American Truck Simulator\profiles" (
    echo [ATS] Profiles folder detected.
    for /d %%P in ("%PROFILE_DIR%\American Truck Simulator\profiles\*") do (
        if exist "%%P\controls.sii" (
            echo   Processing ATS Profile: %%~nxP
            attrib -r -s -h "%%P\controls.sii" >nul 2>&1
            cscript //nologo "%temp%\ats_ets_vbs_core.vbs" "%%P\controls.sii"
        )
    )
    echo.
)

:: 4. Euro Truck Simulator 2 patchen (falls vorhanden)
if exist "%PROFILE_DIR%\Euro Truck Simulator 2\profiles" (
    echo [ETS2] Profiles folder detected.
    for /d %%P in ("%PROFILE_DIR%\Euro Truck Simulator 2\profiles\*") do (
        if exist "%%P\controls.sii" (
            echo   Processing ETS2 Profile: %%~nxP
            attrib -r -s -h "%%P\controls.sii" >nul 2>&1
            cscript //nologo "%temp%\ats_ets_vbs_core.vbs" "%%P\controls.sii"
        )
    )
    echo.
)

:: Sandbox leeren
del "%temp%\ats_ets_vbs_core.vbs" >nul 2>&1

echo [INFO] Installation process finished.
pause
