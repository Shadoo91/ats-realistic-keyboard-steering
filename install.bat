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
echo   [ENFORCED RAW DATA INJECTOR - NO FORMAT BREAKS]
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

:: 2. Direktes Ausfuehren via PowerShell im Raw-String-Modus (Ueberspringt jede CMD-Sonderzeichen-Blockade)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$PROFILE_DIR = '%PROFILE_DIR%'; $files = Get-ChildItem -Path $PROFILE_DIR -Filter 'controls.sii' -Recurse; foreach ($file in $files) { Write-Host \"Processing: $($file.Directory.Name)\" -ForegroundColor Cyan; $sandboxFile = Join-Path $env:TEMP 'controls_sandbox.sii'; $bakFile = Join-Path $file.DirectoryName 'controls.sii.bak'; if (-not (Test-Path $bakFile)) { Copy-Item $file.FullName $bakFile -Force; Write-Host '  -> Backup created successfully!' -ForegroundColor Yellow }; $attrib = Get-ItemProperty $file.FullName; if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal) }; Copy-Item $file.FullName $sandboxFile -Force; $text = [System.IO.File]::ReadAllText($sandboxFile); $newLines = ' config_lines: \"mix dsteerleft ``keyboard.a?0``\"' + [Environment]::NewLine + ' config_lines: \"mix dsteerright ``keyboard.d?0``\"' + [Environment]::NewLine + ' config_lines: \"mix dsteering ``(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)``\"' + [Environment]::NewLine + ' config_lines: \"mix steering ``dsteering``\"' + [Environment]::NewLine + ' config_lines: \"mix msteering ``-mouse.rel_position.x?0 * c_msens``\"' + [Environment]::NewLine + ' config_lines: \"mix mpedals ``-mouse.rel_position.y?0 * c_msens``\"' + [Environment]::NewLine + ' config_lines: \"mix dforward ``0``\"' + [Environment]::NewLine + ' config_lines: \"mix dbackward ``0``\"' + [Environment]::NewLine + ' config_lines: \"mix aforward ``(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)``\"' + [Environment]::NewLine + ' config_lines: \"mix abackward ``keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)``\"' + [Environment]::NewLine + ' config_lines: \"mix forward ``aforward``\"' + [Environment]::NewLine + ' config_lines: \"mix backward ``abackward``\"'; $text = $text -replace '(?s) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $newLines; [System.IO.File]::WriteAllText($sandboxFile, $text, [System.Text.Encoding]::ASCII); Move-Item $sandboxFile $file.FullName -Force; [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly); Write-Host '  -> Successfully patched profile!' -ForegroundColor Green }"

echo.
echo [INFO] Installation process finished.
pause
