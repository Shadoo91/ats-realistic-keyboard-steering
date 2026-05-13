#!/bin/bash
echo "==============================================================================="
echo "   ATS Realistic-Keayboard-Steering (RKS) (Turbo-Mode) for Linux ~ by Shadoo   "
echo "==============================================================================="
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
    
    BAK_FILE="${FILE}.bak"
    if [ ! -f "$BAK_FILE" ]; then
        cp "$FILE" "$BAK_FILE"
        echo "  -> Backup created: controls.sii.bak"
    else
        echo "  -> Backup already exists. Skipping backup."
    fi
    
    chmod 644 "$FILE"
    
    sed -i 's|config_lines\[330\]:.*|config_lines\[330\]: "mix dsteerleft `keyboard.a?0`"|' "$FILE"
    sed -i 's|config_lines\[331\]:.*|config_lines\[331\]: "mix dsteerright `keyboard.d?0`"|' "$FILE"
    sed -i 's|config_lines\[332\]:.*|config_lines\[332\]: "mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * 0.65)`"|' "$FILE"
    sed -i 's|config_lines\[333\]:.*|config_lines\[333\]: "mix steering `dsteering`"|' "$FILE"
    sed -i 's|config_lines\[334\]:.*|config_lines\[334\]: "mix msteering `-mouse.rel_position.x?0 * c_msens`"|' "$FILE"
    sed -i 's|config_lines\[335\]:.*|config_lines\[335\]: "mix mpedals `-mouse.rel_position.y?0 * c_msens`"|' "$FILE"
    sed -i 's|config_lines\[336\]:.*|config_lines\[336\]: "mix dforward `0`"|' "$FILE"
    sed -i 's|config_lines\[337\]:.*|config_lines\[337\]: "mix dbackward `0`"|' "$FILE"
    sed -i 's|config_lines\[338\]:.*|config_lines\[338\]: "mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`"|' "$FILE"
    sed -i 's|config_lines\[339\]:.*|config_lines\[339\]: "mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`"|' "$FILE"
    sed -i 's|config_lines\[340\]:.*|config_lines\[340\]: "mix forward `aforward`"|' "$FILE"
    sed -i 's|config_lines\[341\]:.*|config_lines\[341\]: "mix backward `abackward`"|' "$FILE"
    
    sed -i 's|config_lines\[358\]:.*|config_lines\[358\]: "mix airhorn `keyboard.lalt?0 \| semantical.airhorn?0`"|' "$FILE"
    sed -i 's|mix parkingbrake.*|mix parkingbrake `keyboard.backspace?0`"|' "$FILE"
    
    chmod 444 "$FILE"
done

echo
echo "[INFO] Installation completed successfully!"
