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

:: Erstelle eine temporaere PowerShell-Skriptdatei, um Maskierungsfehler im CMD-Terminal zu verhindern
echo $files = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii' -Recurse > "%temp%\ats_patch.ps1"
echo if ($files.Count -eq 0) { Write-Host '[ERROR] No controls.sii found!' -ForegroundColor Red; exit } >> "%temp%\ats_patch.ps1"
echo foreach ($file in $files) { >> "%temp%\ats_patch.ps1"
echo     Write-Host "Processing profile: $($file.Directory.Name)" -ForegroundColor Green >> "%temp%\ats_patch.ps1"
echo     $bakFile = Join-Path $file.DirectoryName 'controls.sii.bak' >> "%temp%\ats_patch.ps1"
echo     if (-not (Test-Path $bakFile)) { >> "%temp%\ats_patch.ps1"
echo         Copy-Item $file.FullName $bakFile -Force >> "%temp%\ats_patch.ps1"
echo         Write-Host "  -> Backup created: controls.sii.bak" -ForegroundColor Yellow >> "%temp%\ats_patch.ps1"
echo     } else { >> "%temp%\ats_patch.ps1"
echo         Write-Host "  -> Backup already exists. Skipping backup." -ForegroundColor Gray >> "%temp%\ats_patch.ps1"
echo     } >> "%temp%\ats_patch.ps1"
echo     $attrib = Get-ItemProperty $file.FullName >> "%temp%\ats_patch.ps1"
echo     if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal) } >> "%temp%\ats_patch.ps1"
echo     $content = Get-Content $file.FullName >> "%temp%\ats_patch.ps1"
echo     for ($i=0; $i -lt $content.Count; $i++) { >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[330\]:') { $content[$i] = ' config_lines: "mix dsteerleft `\`keyboard.a?0`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[331\]:') { $content[$i] = ' config_lines: "mix dsteerright `\`keyboard.d?0`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[332\]:') { $content[$i] = ' config_lines: "mix dsteering `\`(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[333\]:') { $content[$i] = ' config_lines: "mix steering `\`dsteering`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[334\]:') { $content[$i] = ' config_lines: "mix msteering `\`-mouse.rel_position.x?0 * c_msens`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[335\]:') { $content[$i] = ' config_lines: "mix mpedals `\`-mouse.rel_position.y?0 * c_msens`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[336\]:') { $content[$i] = ' config_lines: "mix dforward `\`0`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[337\]:') { $content[$i] = ' config_lines: "mix dbackward `\`0`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[338\]:') { $content[$i] = ' config_lines: "mix aforward `\`(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[339\]:') { $content[$i] = ' config_lines: "mix abackward `\`keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[340\]:') { $content[$i] = ' config_lines: "mix forward `\`aforward`\`"' } >> "%temp%\ats_patch.ps1"
echo         if ($content[$i] -match 'config_lines\[341\]:') { $content[$i] = ' config_lines: "mix backward `\`abackward`\`"' } >> "%temp%\ats_patch.ps1"
echo     } >> "%temp%\ats_patch.ps1"
echo     [System.IO.File]::WriteAllLines($file.FullName, $content, (New-Object System.Text.UTF8Encoding($false))) >> "%temp%\ats_patch.ps1"
echo     [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly) >> "%temp%\ats_patch.ps1"
echo } >> "%temp%\ats_patch.ps1"

:: Fuehre das saubere Skript aus und loesche es danach
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\ats_patch.ps1"
del "%temp%\ats_patch.ps1"

echo.
echo [INFO] Installation completed successfully!
:END
echo.
pause
