#!/bin/bash
echo "===================================================================="
echo "   ATS Realistic-Keayboard-Steering (RKS) (Turbo-Mode) - for Linux  "
echo "===================================================================="
echo

TARGET_DIR="$HOME/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"

if [ ! -d "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] ATS profile directory not found!"
    exit 1
fi

BACKUPS=$(find "$TARGET_DIR" -name "controls.sii.bak")

if [ -z "$BACKUPS" ]; then
    echo "[INFO] No backups found. System is already in original state."
    exit 0
fi

find "$TARGET_DIR" -name "controls.sii.bak" | while read -r BAK_FILE; do
    FILE="${BAK_FILE%.bak}"
    echo "[INFO] Restoring profile: $(basename "$(dirname "$FILE")")"
    
    if [ -f "$FILE" ]; then
        chmod 644 "$FILE"
        rm "$FILE"
    fi
    
    mv "$BAK_FILE" "$FILE"
    chmod 644 "$FILE"
done

echo
echo "[INFO] Uninstallation complete. Original steering configuration restored!"
