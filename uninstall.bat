@echo off
title ATS Turbo-Input Uninstaller
echo =====================================================================
echo   ATS Realistic-Keayboard-Steering (RKS) (Turbo-Mode) - for Windows
echo ======================================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] ATS profile directory not found!
    goto END
)

echo Restoring original files...
echo.

powershell -Command "^
$bakFiles = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii.bak' -Recurse;^
if ($bakFiles.Count -eq 0) { Write-Host '[INFO] No backups found. System is already in original state.' -ForegroundColor Yellow; exit }^
foreach ($bak in $bakFiles) {^
    $configFile = Join-Path $bak.DirectoryName 'controls.sii';^
    Write-Host \"Restoring profile: $($bak.Directory.Name)\" -ForegroundColor Green;^
    if (Test-Path $configFile) {^
        $attrib = Get-ItemProperty $configFile;^
        if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($configFile, [System.IO.FileAttributes]::Normal) }^
        Remove-Item $configFile -Force;^
    }^
    Move-Item $bak.FullName $configFile -Force;^
    [System.IO.File]::SetAttributes($configFile, [System.IO.FileAttributes]::Normal);^
}"

echo.
echo [INFO] Uninstallation complete. Original steering configuration restored!
:END
echo.
pause
