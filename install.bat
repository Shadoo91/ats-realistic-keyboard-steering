@echo off
title ATS Turbo-Input Installer
echo Launching Installer...
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] ATS profile directory not found!
    pause
    exit
)

:: Erstelle das PowerShell-Skript direkt lokal aus dieser Batch-Datei heraus
(
echo $PROFILE_DIR = '%PROFILE_DIR%'
echo $files = Get-ChildItem -Path $PROFILE_DIR -Filter "controls.sii" -Recurse
echo if ^($files.Count -eq 0^) { Write-Host '[ERROR] No controls.sii found!' -ForegroundColor Red; exit }
echo foreach ^($file in $files^) {
echo     Write-Host "Processing profile: ^($file.Directory.Name^)" -ForegroundColor Green
echo     $bakFile = Join-Path $file.DirectoryName "controls.sii.bak"
echo     if ^(-not ^(Test-Path $bakFile^)^) {
echo         Copy-Item $file.FullName $bakFile -Force
echo         Write-Host "  -> Backup created: controls.sii.bak" -ForegroundColor Yellow
echo     } else {
echo         Write-Host "  -> Backup already exists. Skipping backup." -ForegroundColor Gray
echo     }
echo     $attrib = Get-ItemProperty $file.FullName
echo     if ^($attrib.Attributes -match "ReadOnly"^) {
echo         [System.IO.File]::SetAttributes^($file.FullName, [System.IO.FileAttributes]::Normal^)
echo     }
echo     $content = Get-Content $file.FullName -Raw
echo     $newLines = @'
echo  config_lines: "mix dsteerleft `keyboard.a?0`"
echo  config_lines: "mix dsteerright `keyboard.d?0`"
echo  config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`"
echo  config_lines: "mix steering `dsteering`"
echo  config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`"
echo  config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`"
echo  config_lines: "mix dforward `0`"
echo  config_lines: "mix dbackward `0`"
echo  config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`"
echo  config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`"
echo  config_lines: "mix forward `aforward`"
echo  config_lines: "mix backward `abackward`"
echo '@
echo     $content = $content -replace '\(?s\) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $newLines
echo     [System.IO.File]::WriteAllText^($file.FullName, $content, ^(New-Object System.Text.UTF8Encoding^($false^)^)^)
echo     [System.IO.File]::SetAttributes^($file.FullName, [System.IO.FileAttributes]::ReadOnly^)
echo }
) > "%temp%\ats_local_patch.ps1"

:: Fuehre das lokale Skript aus und loesche es danach sofort
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\ats_local_patch.ps1"
del "%temp%\ats_local_patch.ps1"

echo.
echo [INFO] Installation completed successfully!
pause
