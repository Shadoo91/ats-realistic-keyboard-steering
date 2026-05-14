#!/bin/bash
echo "==================================================================================="
echo "   ATS Realistic-Keyboard-Steering (RKS) - Linux Uninstaller                      "
echo "==================================================================================="
echo

TARGET_DIR="$HOME/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"

if [ ! -d "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] ATS profile directory not found!"
    exit 1
fi

echo "Restoring original backups..."
echo

BACKUP_FOUND=0

find "$TARGET_DIR" -name "controls.sii.bak" | while read -r BAK_FILE; do
    BACKUP_FOUND=1
    FILE="${BAK_FILE%.bak}"
    echo "Restoring Profile: $(basename "$(dirname "$FILE")")"
    
    chmod 644 "$FILE" 2>/dev/null
    chmod 644 "$BAK_FILE"
    
    rm -f "$FILE"
    mv "$BAK_FILE" "$FILE"
    
    echo "  -> Backup successfully restored!"
    echo "-----------------------------------------------------------------------------------"
done

if [ "$BACKUP_FOUND" -eq 0 ]; then
    echo "[INFO] No backups found. Nothing to restore."
else
    echo "[INFO] Uninstallation completed successfully! All profiles restored."
fi
