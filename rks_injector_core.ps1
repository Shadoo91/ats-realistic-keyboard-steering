# ===================================================================================
#   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
#   [POWERSHELL PROFILE INJECTOR - WITH SAFETY FALLBACK PRESET & ROLLBACK INFO]
# ===================================================================================

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

Clear-Host
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$PresetFile = Join-Path $ScriptDir "rks_preset_controls.sii"

Write-Host "====================================================================================" -ForegroundColor Cyan
Write-Host "   ATS Realistic-Keyboard-Steering (RKS) ~ Profile Manager" -ForegroundColor Cyan
Write-Host "====================================================================================" -ForegroundColor Cyan
Write-Host ""

$AtsDocPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "American Truck Simulator")
$SearchPaths = @(
    [System.IO.Path]::Combine($AtsDocPath, "profiles"),
    [System.IO.Path]::Combine($AtsDocPath, "steam_profiles")
)

$SteamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Valve\Steam" -Name "InstallPath" -ErrorAction SilentlyContinue).InstallPath
if ($SteamPath -and (Test-Path $SteamPath)) {
    $UserdataPath = [System.IO.Path]::Combine($SteamPath, "userdata")
    if (Test-Path $UserdataPath) {
        foreach ($UserDir in (Get-ChildItem -Path $UserdataPath -Directory)) {
            $AtsCloudPath = [System.IO.Path]::Combine($UserDir.FullName, "270880", "remote", "profiles")
            if (Test-Path $AtsCloudPath) { $SearchPaths += $AtsCloudPath }
        }
    }
}

$TargetPaths = $SearchPaths | Select-Object -Unique | Where-Object { Test-Path $_ }

if ($TargetPaths.Count -eq 0) {
    Write-Host "[ERROR] No American Truck Simulator profile directories found!" -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    Exit
}

$ControlFiles = @()
foreach ($Dir in $TargetPaths) {
    foreach ($F in (Get-ChildItem -Path $Dir -Filter "controls.sii" -Recurse -ErrorAction SilentlyContinue)) {
        $Type = "Local"; if ($F.FullName -match "steam_profiles") { $Type = "Steam Copy" } elseif ($F.FullName -match "userdata") { $Type = "Steam Cloud" }
        $ControlFiles += [PSCustomObject]@{ Index = 0; Path = $F.FullName; Folder = $F.Directory.Name; Type = $Type; FileInfo = $F; HasBackup = (Test-Path ($F.FullName + ".bak")) }
    }
}

if ($ControlFiles.Count -eq 0) {
    Write-Host "[INFO] No 'controls.sii' files found!" -ForegroundColor Yellow
    Read-Host "Press Enter to exit..."
    Exit
}

for ($i = 0; $i -lt $ControlFiles.Count; $i++) { $ControlFiles[$i].Index = $i + 1 }

Write-Host "Detected ATS Profiles:" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------------------------"
foreach ($CF in $ControlFiles) {
    $BakStatus = if ($CF.HasBackup) { "[Backup: Yes]" } else { "[Backup: No ]" }
    Write-Host " [$($CF.Index)] " -NoNewline -ForegroundColor Cyan
    Write-Host "Folder: $($CF.Folder,-20) | Type: $($CF.Type,-12) | $BakStatus" -ForegroundColor White
}
Write-Host "------------------------------------------------------------------------------------"
Write-Host " [A] Patch ALL profiles  |  [R] Restore backups  |  [E] Exit" -ForegroundColor Yellow
Write-Host "------------------------------------------------------------------------------------"
Write-Host ""

$Selection = (Read-Host "Please select an option").Trim().ToUpper()
if ($Selection -eq "E") { Exit }

# INTERAKTIVES BACKUP-ROLLBACK SYSTEM
if ($Selection -eq "R") {
    Write-Host ""
    $RollbackSel = (Read-Host "Restore ALL backups [A] or select a specific Profile Number? (A/Number)").Trim().ToUpper()
    
    $FilesToRollback = @()
    if ($RollbackSel -eq "A") {
        $FilesToRollback = $ControlFiles
    } else {
        $SelectedRIdx = 0
        if ([int]::TryParse($RollbackSel, [ref]$SelectedRIdx) -and $SelectedRIdx -le $ControlFiles.Count -and $SelectedRIdx -gt 0) {
            $FilesToRollback = @($ControlFiles[$SelectedRIdx - 1])
        } else {
            Write-Host "[ERROR] Invalid selection!" -ForegroundColor Red
            Read-Host "Press Enter to exit..."
            Exit
        }
    }

    Write-Host ""
    Write-Host "Starting Rollback System..." -ForegroundColor Cyan
    foreach ($CF in $FilesToRollback) {
        $BackupPath = $CF.Path + ".bak"
        if (Test-Path $BackupPath) {
            if ($CF.FileInfo.IsReadOnly) { $CF.FileInfo.IsReadOnly = $false }
            Copy-Item -Path $BackupPath -Destination $CF.Path -Force
            Remove-Item -Path $BackupPath -Force
            Write-Host "  -> Restored: $($CF.Folder)" -ForegroundColor Green
        } else {
            Write-Host "  -> No backup found for: $($CF.Folder)" -ForegroundColor DarkYellow
        }
    }
    Read-Host "Rollback finished. Press Enter to exit..."
    Exit
}

$FilesToPatch = @()
if ($Selection -eq "A") { $FilesToPatch = $ControlFiles }
else {
    $SelectedIdx = 0
    if ([int]::TryParse($Selection, [ref]$SelectedIdx)) {
        $FilesToPatch = $ControlFiles | Where-Object { $_.Index -eq $SelectedIdx }
    }
}

if ($FilesToPatch.Count -eq 0) { Write-Host "[ERROR] Invalid selection!" -ForegroundColor Red; Exit }

# EXAKTE DOPPEL-BACKTICK ERSETZUNG GEGEN VERSCHLUCKEN
$Replacements = @{
    '(?i)(config_lines\[\d+\]:\s+)"mix dsteerleft .*"'   = '$1"mix dsteerleft ``keyboard.a?0``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix dsteerright .*"'  = '$1"mix dsteerright ``keyboard.d?0``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix dsteering .*"'    = '$1"mix dsteering ``(keyboard.a?0 - keyboard.d?0) * (0.40 + (keyboard.space?0 * 0.50) + (keyboard.s?0 * keyboard.lalt?0 * 0.20))``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix steering .*"'     = '$1"mix steering ``dsteering * (1.0 - c_steer_func)``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix msteering .*"'    = '$1"mix msteering ``-mouse.rel_position.x?0 * c_msens``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix mpedals .*"'      = '$1"mix mpedals ``-mouse.rel_position.y?0 * c_msens``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix dforward .*"'     = '$1"mix dforward ``0``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix dbackward .*"'    = '$1"mix dbackward ``0``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix aforward .*"'     = '$1"mix aforward ``(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix abackward .*"'    = '$1"mix abackward ``keyboard.s?0 * (0.10 + (keyboard.lalt?0 * 0.50) + (keyboard.space?0 * 0.80))``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix forward .*"'      = '$1"mix forward ``aforward``"'
    '(?i)(config_lines\[\d+\]:\s+)"mix backward .*"'     = '$1"mix backward ``abackward``"'
}

foreach ($CF in $FilesToPatch) {
    $File = $CF.FileInfo
    Write-Host "Processing: $($CF.Folder) [$($CF.Type)]" -ForegroundColor Yellow
    if ($File.IsReadOnly) { $File.IsReadOnly = $false }
    
    $BackupPath = $File.FullName + ".bak"
    if (-not (Test-Path $BackupPath)) { Copy-Item -Path $File.FullName -Destination $BackupPath -Force }
    
    $Content = [System.IO.File]::ReadAllText($File.FullName, [System.Text.Encoding]::UTF8)
    $Modified = $false
    
    foreach ($Key in $Replacements.Keys) {
        if ($Content -match $Key) { $Content = $Content -replace $Key, $Replacements[$Key]; $Modified = $true }
    }
    
    if ($Modified) {
        [System.IO.File]::WriteAllText($File.FullName, $Content, [System.Text.Encoding]::UTF8)
        Write-Host "  -> Success: RKS formulas injected!" -ForegroundColor Green
    } else {
        Write-Host "  -> [WARNING] Target lines not found. File might be corrupted." -ForegroundColor DarkYellow
        if (Test-Path $PresetFile) {
            Write-Host ""
            Write-Host "     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" -ForegroundColor Red
            Write-Host "     WARNING: Installing the preset will reset your custom in-game keybinds " -ForegroundColor Yellow
            Write-Host "              and sensitivity settings to default RKS values!" -ForegroundColor Yellow
            Write-Host "              Your original settings are SAFELY backed up in 'controls.sii.bak'." -ForegroundColor Green
            Write-Host "              You will need to manually reconfigure your basic controls in-game." -ForegroundColor Yellow
            Write-Host "     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" -ForegroundColor Red
            Write-Host ""
            $Choice = Read-Host "     Do you still want to overwrite with the clean RKS Default Preset? (Y/N)"
            if ($Choice.Trim().ToUpper() -eq "Y") {
                Copy-Item -Path $PresetFile -Destination $File.FullName -Force
                Write-Host "     -> Success: Overwritten with clean RKS Preset!" -ForegroundColor Green
                Write-Host ""
                Write-Host "     ------------------------------------------------------------------------" -ForegroundColor Cyan
                Write-Host "     HOW TO RESTORE YOUR ORIGINAL SETTINGS LATER:" -ForegroundColor Yellow
                Write-Host "     Option 1 (Automatic): Restart this tool and press [R] in the main menu." -ForegroundColor White
                Write-Host "     Option 2 (Manual): Go to your profile folder:" -ForegroundColor White
                Write-Host "                        $($File.DirectoryName)" -ForegroundColor Gray
                Write-Host "                        Delete 'controls.sii' and rename 'controls.sii.bak'" -ForegroundColor White
                Write-Host "                        back to 'controls.sii'." -ForegroundColor White
                Write-Host "     ------------------------------------------------------------------------" -ForegroundColor Cyan
                Write-Host ""
            } else { Write-Host "     -> Skipped preset installation." -ForegroundColor Gray }
        } else { Write-Host "     -> Fallback preset file 'rks_preset_controls.sii' not found in script folder!" -ForegroundColor Red }
    }
    Write-Host "------------------------------------------------------------------------------------"
}
Read-Host "Process finished. Press Enter to exit..."
