@echo off
title ATS Turbo-Input Installer + Backup
echo ===================================================================================
echo   ATS Realistic-Keayboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91 
echo ===================================================================================
echo.
set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] ATS profile directory not found!
    goto END
)

echo Searching profiles and creating backups...
echo.

:: Erstelle ein absolut sicheres PowerShell-Skript, das die Zeilen ohne Filterung austauscht
(
echo $files = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii' -Recurse
echo if ^($files.Count -eq 0^) { Write-Host '[ERROR] No controls.sii found!' -ForegroundColor Red; exit }
echo foreach ^($file in $files^) {
echo     Write-Host "Processing profile: ^($file.Directory.Name^)" -ForegroundColor Green
echo     $bakFile = Join-Path $file.DirectoryName 'controls.sii.bak'
echo     if ^(-not ^(Test-Path $bakFile^)^) {
echo         Copy-Item $file.FullName $bakFile -Force
echo         Write-Host "  -> Backup created: controls.sii.bak" -ForegroundColor Yellow
echo     } else {
echo         Write-Host "  -> Backup already exists. Skipping backup." -ForegroundColor Gray
echo     }
echo     $attrib = Get-ItemProperty $file.FullName
echo     if ^($attrib.Attributes -match 'ReadOnly'^) { [System.IO.File]::SetAttributes^($file.FullName, [System.IO.FileAttributes]::Normal^) }
echo     $content = Get-Content $file.FullName -Raw
echo     $lines = @'
echo  config_lines[330]: "mix dsteerleft `keyboard.a?0`"
echo  config_lines[331]: "mix dsteerright `keyboard.d?0`"
echo  config_lines[332]: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`"
echo  config_lines[333]: "mix steering `dsteering`"
echo  config_lines[334]: "mix msteering `-mouse.rel_position.x?0 * c_msens`"
echo  config_lines[335]: "mix mpedals `-mouse.rel_position.y?0 * c_msens`"
echo  config_lines[336]: "mix dforward `0`"
echo  config_lines[337]: "mix dbackward `0`"
echo  config_lines[338]: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`"
echo  config_lines[339]: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`"
echo  config_lines[340]: "mix forward `aforward`"
echo  config_lines[341]: "mix backward `abackward`"
echo '@
echo     $content = $content -replace '(?s) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $lines
echo     [System.IO.File]::WriteAllText^($file.FullName, $content, ^(New-Object System.Text.UTF8Encoding^($false^)^)^)
echo     [System.IO.File]::SetAttributes^($file.FullName, [System.IO.FileAttributes]::ReadOnly^)
echo }
) > "%temp%\ats_patch.ps1"

:: Fuehre das fehlerfreie Skript aus und loesche es danach
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\ats_patch.ps1"
del "%temp%\ats_patch.ps1"

echo.
echo [INFO] Installation completed successfully!
:END
echo.
pause
