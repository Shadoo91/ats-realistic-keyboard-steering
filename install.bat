@echo off
title ATS Turbo-Input Installer + Backup
echo =================================================================================
echo   ATS Realistic-Keayboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo  
echo =================================================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] ATS profile directory not found!
    goto END
)

echo Searching profiles and creating backups...
echo.

powershell -Command "^
$files = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii' -Recurse;^
if ($files.Count -eq 0) { Write-Host '[ERROR] No controls.sii found!' -ForegroundColor Red; exit }^
foreach ($file in $files) {^
    Write-Host \"Processing profile: $($file.Directory.Name)\" -ForegroundColor Green;^
    $bakFile = Join-Path $file.DirectoryName 'controls.sii.bak';^
    if (-not (Test-Path $bakFile)) {^
        Copy-Item $file.FullName $bakFile -Force;^
        Write-Host \"  -^> Backup created: controls.sii.bak\" -ForegroundColor Yellow;^
    } else {^
        Write-Host \"  -^> Backup already exists. Skipping backup.\" -ForegroundColor Gray;^
    }^
    $attrib = Get-ItemProperty $file.FullName;^
    if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal) }^
    $content = Get-Content $file.FullName;^
    for ($i=0; $i -lt $content.Count; $i++) {^
        if ($content[$i] -match 'config_lines\[330\]:') { $content[$i] = ' config_lines: \"mix dsteerleft `keyboard.a?0`\"' }^
        if ($content[$i] -match 'config_lines\[331\]:') { $content[$i] = ' config_lines: \"mix dsteerright `keyboard.d?0`\"' }^
        if ($content[$i] -match 'config_lines\[332\]:') { $content[$i] = ' config_lines: \"mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`\"' }^
        if ($content[$i] -match 'config_lines\[333\]:') { $content[$i] = ' config_lines: \"mix steering `dsteering`\"' }^
        if ($content[$i] -match 'config_lines\[334\]:') { $content[$i] = ' config_lines: \"mix msteering `-mouse.rel_position.x?0 * c_msens`\"' }^
        if ($content[$i] -match 'config_lines\[335\]:') { $content[$i] = ' config_lines: \"mix mpedals `-mouse.rel_position.y?0 * c_msens`\"' }^
        if ($content[$i] -match 'config_lines\[336\]:') { $content[$i] = ' config_lines: \"mix dforward `0`\"' }^
        if ($content[$i] -match 'config_lines\[337\]:') { $content[$i] = ' config_lines: \"mix dbackward `0`\"' }^
        if ($content[$i] -match 'config_lines\[338\]:') { $content[$i] = ' config_lines: \"mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`\"' }^
        if ($content[$i] -match 'config_lines\[339\]:') { $content[$i] = ' config_lines: \"mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`\"' }^
        if ($content[$i] -match 'config_lines\[340\]:') { $content[$i] = ' config_lines: \"mix forward `aforward`\"' }^
        if ($content[$i] -match 'config_lines\[341\]:') { $content[$i] = ' config_lines: \"mix backward `abackward`\"' }^
        if ($content[$i] -match 'config_lines\[358\]:') { $content[$i] = ' config_lines: \"mix airhorn `keyboard.lalt?0 | semantical.airhorn?0`\"' }^
        if ($content[$i] -match 'mix parkingbrake') {^
            $lineNum = $content[$i].Split('[').Split(']');^
            $content[$i] = ' config_lines[' + $lineNum + ']: \"mix parkingbrake `keyboard.backspace?0`\"';^
        }^
    }^
    $content | Set-Content $file.FullName;^
    [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly);^
}"

echo.
echo [INFO] Installation completed successfully!
:END
echo.
pause
