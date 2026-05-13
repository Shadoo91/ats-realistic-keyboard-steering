#!/bin/bash
echo "======================================================================================"
echo "   ATS Realistic-Keayboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91    "
echo "======================================================================================"
echo

TARGET_DIR="$HOME/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"

if [ ! -d "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] ATS profile directory not found!"
    exit 1
fi

find "$TARGET_DIR" -name "controls.sii" | while read -r FILE; do
    echo "[INFO] Processing profile: $(basename "$(dirname "$FILE")")"
    
    BAK_FILE=
