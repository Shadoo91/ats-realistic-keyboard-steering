@echo off
title ATS Turbo-Input Installer

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
echo   [NATIVE ENGINE - NO POWERSHELL - NO PYTHON]
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
echo Patching configuration files...
echo.

:: 2. Erstelle ein unzerstoerbares JScript, das auf JEDEM Windows-PC existiert
(
echo var fso = new ActiveXObject("Scripting.FileSystemObject"^);
echo var args = WScript.Arguments;
echo var profilePath = args(0^);
echo var configFile = profilePath + "\\controls.sii";
echo var bakFile = configFile + ".bak";
echo if (fso.FileExists(configFile^)^) {
echo     if (!fso.FileExists(bakFile^)^) { fso.CopyFile(configFile, bakFile, true^); }
echo     var file = fso.GetFile(configFile^);
echo     if (file.Attributes ^& 1^) { file.Attributes -= 1; }
echo     var ts = fso.OpenTextFile(configFile, 1, false, 0^);
echo     var text = ts.ReadAll(^);
echo     ts.Close(^);
echo     var newLines = " config_lines: \"mix dsteerleft `keyboard.a?0`\"\r\n" +
echo                    " config_lines: \"mix dsteerright `keyboard.d?0`\"\r\n" +
echo                    " config_lines: \"mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`\"\r\n" +
echo                    " config_lines: \"mix steering `dsteering`\"\r\n" +
echo                    " config_lines: \"mix msteering `-mouse.rel_position.x?0 * c_msens`\"\r\n" +
echo                    " config_lines: \"mix mpedals `-mouse.rel_position.y?0 * c_msens`\"\r\n" +
echo                    " config_lines: \"mix dforward `0`\"\r\n" +
echo                    " config_lines: \"mix dbackward `0`\"\r\n" +
echo                    " config_lines: \"mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`\"\r\n" +
echo                    " config_lines: \"mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`\"\r\n" +
echo                    " config_lines: \"mix forward `aforward`\"\r\n" +
echo                    " config_lines: \"mix backward `abackward`\"";
echo     var regex = / config_lines\[330\]:[\s\S]*?config_lines\[341\]:[^\r\n]*/;
echo     if (regex.test(text^)^) {
echo         text = text.replace(regex, newLines^);
echo         var ws = fso.OpenTextFile(configFile, 2, true, 0^);
echo         ws.Write(text^);
echo         ws.Close(^);
echo         WScript.Echo("  -> Successfully patched!"^);
echo     } else {
echo         WScript.Echo("  -> [ERROR] Lines 330-341 not found. Already patched?"^);
echo     }
echo     file.Attributes += 1;
echo }
) > "%temp%\ats_js_patch.js"

:: 3. Profile durchlaufen und JScript aufrufen
for /d %%P in ("%PROFILE_DIR%\*") do (
    if exist "%%P\controls.sii" (
        echo Processing profile: %%~nxP
        cscript //nologo "%temp%\ats_js_patch.js" "%%P"
    )
)

del "%temp%\ats_js_patch.js"

echo.
echo [INFO] Installation process finished.
pause
