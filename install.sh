#!/bin/bash
echo "==================================================================================="
echo "   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for LINUX ~ by Shadoo91   "
echo "   [LINE INJECTOR - 100% STABLE - KEEPS PLAYER SETTINGS]                           "
echo "==================================================================================="
echo

# 1. Automatische Pfad-Erkennung (Standard & Flatpak/Steam Deck)
TARGET_DIR="$HOME/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"

if [ ! -d "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/270880/pfx/drive_c/users/steamuser/Documents/American Truck Simulator/profiles"
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "[ERROR] ATS profile directory not found!"
    exit 1
fi

echo "Profiles directory found at:"
echo "$TARGET_DIR"
echo
echo "Injecting RKS formulas into existing profiles..."
echo

# 2. Profile durchlaufen und Zeilen gezielt patchen
find "$TARGET_DIR" -name "controls.sii" | while read -r FILE; do
    echo "[INFO] Patching ATS Profile: $(basename "$(dirname "$FILE")")"
    
    # Schreibschutz aufheben, um Datei bearbeiten zu koennen
    chmod 644 "$FILE"
    
    # Backup erstellen, falls noch nicht vorhanden
    BAK_FILE="${FILE}.bak"
    if [ ! -f "$BAK_FILE" ]; then
        cp "$FILE" "$BAK_FILE"
        echo "  -> Backup created: controls.sii.bak"
    else
        echo "  -> Backup already exists. Skipping backup."
    fi
    
    TEMP_FILE="${FILE}.tmp"
    
    # Präzises Ersetzen der Zeilen, unabhängig von der Zeilennummer, unter Beibehaltung der Codierung
    awk '
    /mix dsteerleft/   { print " config_lines: \"mix dsteerleft `keyboard.a?0`\""; next }
    /mix dsteerright/  { print " config_lines: \"mix dsteerright `keyboard.d?0`\""; next }
    /mix dsteering/    { print " config_lines: \"mix dsteering `(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * (0.55 - keyboard.s?0 * 0.25))`\""; next }
    /mix steering/     { print " config_lines: \"mix steering `dsteering * (1.0 - (c_steer_func * 0.5))`\""; next }
    /mix aforward/     { print " config_lines: \"mix aforward `(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)`\""; next }
    /mix abackward/    { print " config_lines: \"mix abackward `keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)`\""; next }
    { print }
    ' "$FILE" > "$TEMP_FILE"
    
    # Temporäre Datei über die originale controls.sii bewegen
    mv -f "$TEMP_FILE" "$FILE"
    
    echo "  -> Successfully injected formulas without losing player binds!"
    echo "-----------------------------------------------------------------------------------"
done

echo
echo "[INFO] Installation completed successfully!"
