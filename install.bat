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
echo   [UNBREAKABLE POWER PATCH ENGINE - ONEDRIVE PROOF]
echo ===================================================================================
echo.

:: 1. Pfade definieren (OneDrive-Fokus)
set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Executing Enforced Sandbox Block Replacement...
echo.

:: 2. Erstelle eine temporaere PowerShell-Skriptdatei. 
:: Das verhindert, dass CMD ueber eckige Klammern oder Backticks stolpert!
(
echo $PROFILE_DIR = '%PROFILE_DIR%'
echo $files = Get-ChildItem -Path $PROFILE_DIR -Filter "controls.sii" -Recurse
echo foreach ^($file in $files^) {
echo     $sandboxFile = Join-Path $env:TEMP "controls_sandbox.sii"
echo     $bakFile = Join-Path $file.DirectoryName "controls.sii.bak"
echo     if ^(-not ^(Test-Path $bakFile^)^) { Copy-Item $file.FullName $bakFile -Force }
echo     $attrib = Get-ItemProperty $file.FullName
echo     if ^($attrib.Attributes -match "ReadOnly"^) { [System.IO.File]::SetAttributes^($file.FullName, [System.IO.FileAttributes]::Normal^) }
echo     Copy-Item $file.FullName $sandboxFile -Force
echo     $text = [System.IO.File]::ReadAllText^($sandboxFile^)
echo     $newLines = ' config_lines: "mix dsteerleft ``keyboard.a?0``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix dsteerright ``keyboard.d?0``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix dsteering ``(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix steering ``dsteering``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix msteering ``-mouse.rel_position.x?0 * c_msens``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix mpedals ``-mouse.rel_position.y?0 * c_msens``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix dforward ``0``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix dbackward ``0``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix aforward ``(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix abackward ``keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix forward ``aforward``"' + [Environment]::NewLine +
echo                 ' config_lines: "mix backward ``abackward``"'
echo     $text = $text -replace '\(?s\) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $newLines
echo     [System.IO.File]::WriteAllText^($sandboxFile, $text, [System.Text.Encoding]::ASCII^)
echo     Move-Item $sandboxFile $file.FullName -Force
echo     [System.IO.File]::SetAttributes^($file.FullName, [System.IO.FileAttributes]::ReadOnly^)
echo     Write-Host "  -> Successfully patched profile: ^($file.Directory.Name^)" -ForegroundColor Green
echo }
) > "%temp%\ats_final_injector.ps1"

:: 3. Starte die PowerShell isoliert im Hintergrund
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\ats_final_injector.ps1"
del "%temp%\ats_final_injector.ps1" >nul 2>&1

echo.
echo [INFO] Installation process finished.
pause
