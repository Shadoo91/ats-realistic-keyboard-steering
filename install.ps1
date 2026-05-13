$PROFILE_DIR = Join-Path $env:USERPROFILE "Documents\American Truck Simulator\profiles"

if (-not (Test-Path $PROFILE_DIR)) {
    Write-Host "[ERROR] ATS profile directory not found!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit
}

Write-Host "Searching profiles and creating backups..." -ForegroundColor Cyan
Write-Host ""

$files = Get-ChildItem -Path $PROFILE_DIR -Filter "controls.sii" -Recurse
if ($files.Count -eq 0) {
    Write-Host "[ERROR] No controls.sii found!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit
}

foreach ($file in $files) {
    Write-Host "Processing profile: $($file.Directory.Name)" -ForegroundColor Green
    $bakFile = Join-Path $file.DirectoryName "controls.sii.bak"
    
    if (-not (Test-Path $bakFile)) {
        Copy-Item $file.FullName $bakFile -Force
        Write-Host "  -> Backup created: controls.sii.bak" -ForegroundColor Yellow
    } else {
        Write-Host "  -> Backup already exists. Skipping backup." -ForegroundColor Gray
    }
    
    $attrib = Get-ItemProperty $file.FullName
    if ($attrib.Attributes -match "ReadOnly") {
        [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::Normal)
    }
    
    $content = Get-Content $file.FullName -Raw
    
    # Der exakte Textblock, der unveraendert eingefuegt wird
    $newLines = @'
 config_lines: "mix dsteerleft `keyboard.a?0`"
 config_lines: "mix dsteerright `keyboard.d?0`"
 config_lines: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`"
 config_lines: "mix steering `dsteering`"
 config_lines: "mix msteering `-mouse.rel_position.x?0 * c_msens`"
 config_lines: "mix mpedals `-mouse.rel_position.y?0 * c_msens`"
 config_lines: "mix dforward `0`"
 config_lines: "mix dbackward `0`"
 config_lines: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`"
 config_lines: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`"
 config_lines: "mix forward `aforward`"
 config_lines: "mix backward `abackward`"
'@

    # Ersetzt die Zeilen 330 bis 341 im Profil des Users
    $content = $content -replace '(?s) config_lines\[330\]:.*config_lines\[341\]:[^\r\n]*', $newLines
    
    # Speichert zwingend in echtem UTF-8 ohne BOM ab, damit das Spiel es liest
    [System.IO.File]::WriteAllText($file.FullName, $content, (New-Object System.Text.UTF8Encoding($false)))
    [System.IO.File]::SetAttributes($file.FullName, [System.IO.FileAttributes]::ReadOnly)
}

Write-Host ""
Write-Host "[INFO] Installation completed successfully!" -ForegroundColor Green
Read-Host "Press Enter to exit..."
