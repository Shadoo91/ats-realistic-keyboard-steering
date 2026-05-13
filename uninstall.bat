@echo off
title ATS Turbo-Input Uninstaller
echo ===================================================
echo   ATS Turbo Keyboard Input Uninstaller for Windows
echo ===================================================
echo.

set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] ATS profile directory not found!
    goto END
)

echo Restoring original files...
echo.

:: Erstelle ein temporaeres PowerShell-Skript, um Zeilen-Uebergänge ohne Sonderzeichen zu verarbeiten
echo $bakFiles = Get-ChildItem -Path '%PROFILE_DIR%' -Filter 'controls.sii.bak' -Recurse > "%temp%\ats_unpatch.ps1"
echo if ($bakFiles.Count -eq 0) { Write-Host '[INFO] No backups found. System is already in original state.' -ForegroundColor Yellow; exit } >> "%temp%\ats_unpatch.ps1"
echo foreach ($bak in $bakFiles) { >> "%temp%\ats_unpatch.ps1"
echo     $configFile = Join-Path $bak.DirectoryName 'controls.sii' >> "%temp%\ats_unpatch.ps1"
echo     Write-Host "Restoring profile: $($bak.Directory.Name)" -ForegroundColor Green >> "%temp%\ats_unpatch.ps1"
echo     if (Test-Path $configFile) { >> "%temp%\ats_unpatch.ps1"
echo         $attrib = Get-ItemProperty $configFile >> "%temp%\ats_unpatch.ps1"
echo         if ($attrib.Attributes -match 'ReadOnly') { [System.IO.File]::SetAttributes($configFile, [System.IO.FileAttributes]::Normal) } >> "%temp%\ats_unpatch.ps1"
echo         Remove-Item $configFile -Force >> "%temp%\ats_unpatch.ps1"
echo     } >> "%temp%\ats_unpatch.ps1"
echo     Move-Item $bak.FullName $configFile -Force >> "%temp%\ats_unpatch.ps1"
echo     [System.IO.File]::SetAttributes($configFile, [System.IO.FileAttributes]::Normal) >> "%temp%\ats_unpatch.ps1"
echo } >> "%temp%\ats_unpatch.ps1"

:: Fuehre das Skript aus und loesche die temporaere Datei
powershell -NoProfile -ExecutionPolicy Bypass -File "%temp%\ats_unpatch.ps1"
del "%temp%\ats_unpatch.ps1"

echo.
echo [INFO] Uninstallation complete. Original steering configuration restored!
:END
echo.
pause
