@echo off
title ATS Turbo-Input Installer
setlocal enabledelayedexpansion

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91
echo ===================================================================================
echo.

:: 1. Pfade definieren (Standard und OneDrive)
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" (
    set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
)
if not exist "%PROFILE_DIR%" (
    set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"
)

if not exist "%PROFILE_DIR%" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    echo Please run the installer directly inside your 'profiles' folder if you use a custom path.
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Searching profiles and patching controls...
echo.

:: 2. Erstelle das optimierte, ausfallsichere VBScript
(
echo Set fso = CreateObject("Scripting.FileSystemObject"^)
echo Set args = WScript.Arguments
echo profilePath = args(0^)
echo configFile = profilePath ^& "\controls.sii"
echo bakFile = profilePath ^& "\controls.sii.bak"
echo If fso.FileExists(configFile^) Then
echo     On Error Resume Next
echo     Set file = fso.GetFile(configFile^)
echo     If Err.Number ^<^\^> 0 Then
echo         WScript.Echo "  -> [ERROR] Cloud file is not downloaded yet. Open it once in Windows Explorer!"
echo         Err.Clear
echo         WScript.Quit
echo     End If
echo     If file.Size = 0 Then
echo         WScript.Echo "  -> [ERROR] File is empty or locked by OneDrive sync."
echo         WScript.Quit
echo     End If
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
echo                " config_lines: ""mix backward `abackward`"""
echo     If regEx.Test(text^) Then
echo         text = regEx.Replace(text, newLines^)
echo         Set ts = fso.OpenTextFile(configFile, 2, True, 0^)
echo         ts.Write text
echo         ts.Close
echo         WScript.Echo "  -> Successfully patched!"
echo     Else
echo         WScript.Echo "  -> [ERROR] Target lines 330-341 not found. Your controls might be custom modified."
echo     End If
echo     file.Attributes = file.Attributes + 1
echo     On Error GoTo 0
echo Else
echo     WScript.Echo "  -> [ERROR] controls.sii file does not exist in this folder."
echo End If
) > "%temp%\ats_vbs_patch.vbs"

:: 3. Profile durchlaufen und VBScript ausfuehren
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P" (
        echo Processing profile: %%~nxP
        cscript //nologo "%temp%\ats_vbs_patch.vbs" "%%P"
    )
)

del "%temp%\ats_vbs_patch.vbs"

echo.
echo [INFO] Installation process finished.
pause
