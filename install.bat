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

powershell -Command "$files = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii' -Recurse; if ($files.Count -eq 0) { Write-Host '[ERROR] No controls.sii found!' -ForegroundColor Red; exit }; foreach ($file in $files) { Write-Host \"Processing profile: $($file.Directory.Name)\" -ForegroundColor Green; $bakFile = Join-Path $file.DirectoryName 'controls.sii.bak'; if (-not (Test-Path $bakFile)) { Copy-Item $file.FullName $bakFile -Force; Write-Host \"  -> Backup created\" -ForegroundColor Yellow } else { Write-Host \"  -> Backup already exists\" -ForegroundColor Gray }; $attrib = Get-ItemProperty $file.FullName; if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal) }; $raw = [System.IO.File]::ReadAllText($file.FullName); $raw = $raw -replace 'config_lines\[330\]:.*', 'config_lines[330]: \"mix dsteerleft `\`keyboard.a?0`\`\"'; $raw = $raw -replace 'config_lines\[331\]:.*', 'config_lines[331]: \"mix dsteerright `\`keyboard.d?0`\`\"'; $raw = $raw -replace 'config_lines\[332\]:.*', 'config_lines[332]: \"mix dsteering `\`(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`\`\"'; $raw = $raw -replace 'config_lines\[333\]:.*', 'config_lines[333]: \"mix steering `\`dsteering`\`\"'; $raw = $raw -replace 'config_lines\[334\]:.*', 'config_lines[334]: \"mix msteering `\`-mouse.rel_position.x?0 * c_msens`\`\"'; $raw = $raw -replace 'config_lines\[335\]:.*', 'config_lines[335]: \"mix mpedals `\`-mouse.rel_position.y?0 * c_msens`\`\"'; $raw = $raw -replace 'config_lines\[336\]:.*', 'config_lines[336]: \"mix dforward `\`0`\`\"'; $raw = $raw -replace 'config_lines\[337\]:.*', 'config_lines[337]: \"mix dbackward `\`0`\`\"'; $raw = $raw -replace 'config_lines\[338\]:.*', 'config_lines[338]: \"mix aforward `\`(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`\`\"'; $raw = $raw -replace 'config_lines\[339\]:.*', 'config_lines[339]: \"mix abackward `\`keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`\`\"'; $raw = $raw -replace 'config_lines\[340\]:.*', 'config_lines[340]: \"mix forward `\`aforward`\`\"'; $raw = $raw -replace 'config_lines\[341\]:.*', 'config_lines[341]: \"mix backward `\`abackward`\`\"'; [System.IO.File]::WriteAllText($file.FullName, $raw); [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly) }"

echo.
echo [INFO] Installation completed successfully!
:END
echo.
pause
