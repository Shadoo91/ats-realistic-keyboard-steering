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

:: Ab hier läuft das Skript offiziell als Administrator!
cd /d "%~dp0"

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91
echo   [RUNNING AS ADMINISTRATOR]
echo ===================================================================================
echo.

:: 1. Pfade definieren (Standard und OneDrive)
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"

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

:: 2. Fehlerfreier Patch via PowerShell (mit erzwungenem Cloud-Download)
powershell -NoProfile -ExecutionPolicy Bypass -Command "$files = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii' -Recurse; if ($files.Count -eq 0) { Write-Host '[ERROR] No controls.sii found!' -ForegroundColor Red; exit }; foreach ($file in $files) { Write-Host \"Processing profile: $($file.Directory.Name)\" -ForegroundColor Green; $bakFile = Join-Path $file.DirectoryName 'controls.sii.bak'; if (-not (Test-Path $bakFile)) { Copy-Item $file.FullName $bakFile -Force; Write-Host '  -> Backup created: controls.sii.bak' -ForegroundColor Yellow } else { Write-Host '  -> Backup already exists. Skipping backup.' -ForegroundColor Gray }; $attrib = Get-ItemProperty $file.FullName; if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal) }; try { $text = [System.IO.File]::ReadAllText($file.FullName); $newLines = ' config_lines: \"mix dsteerleft ``keyboard.a?0``\"' + [Environment]::NewLine + ' config_lines: \"mix dsteerright ``keyboard.d?0``\"' + [Environment]::NewLine + ' config_lines: \"mix dsteering ``(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)``\"' + [Environment]::NewLine + ' config_lines: \"mix steering ``dsteering``\"' + [Environment]::NewLine + ' config_lines: \"mix msteering ``-mouse.rel_position.x?0 * c_msens``\"' + [Environment]::NewLine + ' config_lines: \"mix mpedals ``-mouse.rel_position.y?0 * c_msens``\"' + [Environment]::NewLine + ' config_lines: \"mix dforward ``0``\"' + [Environment]::NewLine + ' config_lines: \"mix dbackward ``0``\"' + [Environment]::NewLine + ' config_lines: \"mix aforward ``(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)``\"' + [Environment]::NewLine + ' config_lines: \"mix abackward ``keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)``\"' + [Environment]::NewLine + ' config_lines: \"mix forward ``aforward``\"' + [Environment]::NewLine + ' config_lines: \"mix backward ``abackward``\"'; $text = $text -replace '(?s) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $newLines; [System.IO.File]::WriteAllText($file.FullName, $text, (New-Object System.Text.UTF8Encoding($false))); Write-Host '  -> Successfully patched!' -ForegroundColor Green } catch { Write-Host '  -> [ERROR] Failed to read or download file from OneDrive Cloud.' -ForegroundColor Red } [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly) }"

echo.
echo [INFO] Installation process finished.
pause
