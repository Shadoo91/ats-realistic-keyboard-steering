#!/bin/bash
echo "==================================================================================="
echo "   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for LINUX ~ by Shadoo91   "
echo "==================================================================================="
echo

# 1. Prüfen ob die Preset-Datei im selben Ordner existiert
if [ ! -f "controls_preset.sii" ]; then
    echo "[ERROR] 'controls_preset.sii' not found in this directory!"
    echo "Please make sure to extract all files from the ZIP archive."
    exit 1
fi

# 2. Automatische Pfad-Erkennung (Standard & Flatpak Steam)
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
echo "Injecting working control preset..."
echo

# 3. Profile durchlaufen und die funktionierende Datei direkt reinkopieren
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
    
    # Überschreibe die Datei direkt mit deinem funktionierenden Preset!
    cp "controls_preset.sii" "$FILE"
    
    # WICHTIG: Datei beschreibbar lassen (kein chmod 444), damit ATS korrekt speichern kann!
    echo "  -> Successfully injected verified preset!"
    echo "-----------------------------------------------------------------------------------"
done

echo
echo "[INFO] Installation completed successfully!"
