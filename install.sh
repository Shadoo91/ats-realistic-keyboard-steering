#!/bin/bash
echo "==================================================================================="
echo "   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for LINUX ~ by Shadoo91   "
echo "   [FULL PRESET INJECTOR - 100% STABLE]                                            "
echo "==================================================================================="
echo

# 1. Prüfen ob die vollständige 590-Zeilen Preset-Datei im selben Ordner existiert
if [ ! -f "controls_preset.sii" ]; then
    echo "[ERROR] 'controls_preset.sii' not found in this directory!"
    echo "Please make sure to extract all files from the ZIP archive."
    exit 1
fi

# 2. Automatische Pfad-Erkennung (Standard & Flatpak/Steam Deck)
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
echo "Injecting complete 590-line control preset..."
echo

# 3. Profile durchlaufen und das komplette Preset drüberkopieren
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
    
    # Überschreibe die Datei direkt mit deiner kompletten controls_preset.sii
    cp "controls_preset.sii" "$FILE"
    
    # WICHTIG: Kein Schreibschutz am Ende (kein chmod 444), damit ATS im Spiel speichern darf!
    echo "  -> Successfully injected verified 590-line preset!"
    echo "-----------------------------------------------------------------------------------"
done

echo
echo "[INFO] Installation completed successfully!"
