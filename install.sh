#!/bin/bash

# ===================================================================================
#   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
#   [LINUX PROFILE INJECTOR - WITH SAFETY FALLBACK PRESET & ROLLBACK INFO]
# ===================================================================================

clear
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE}")" && pwd)"
PRESET_FILE="$SCRIPT_DIR/rks_preset_controls.sii"

echo "===================================================================================="
echo "   ATS Realistic-Keyboard-Steering (RKS) ~ Profile Manager (Linux)"
echo "===================================================================================="
echo ""

declare -a SEARCH_PATHS=()
if [ -d "$HOME/.local/share/American Truck Simulator/profiles" ]; then SEARCH_PATHS+=("$HOME/.local/share/American Truck Simulator/profiles"); fi
if [ -d "$HOME/.local/share/American Truck Simulator/steam_profiles" ]; then SEARCH_PATHS+=("$HOME/.local/share/American Truck Simulator/steam_profiles"); fi

for STEAM_DIR in "$HOME/.local/share/Steam" "$HOME/.var/app/com.valvesoftware.Steam/.local/share/Steam"; do
    if [ -d "$STEAM_DIR/userdata" ]; then
        while IFS= read -r -d '' path; do SEARCH_PATHS+=("$path"); done < <(find "$STEAM_DIR/userdata" -type d -path "*/270880/remote/profiles" -print0 2>/dev/null)
    fi
done

UNIQUE_PATHS=($(printf "%s\n" "${SEARCH_PATHS[@]}" | sort -u))
if [ ${#UNIQUE_PATHS[@]} -eq 0 ]; then echo -e "\e[31m[ERROR] No profile folders found!\e[0m"; exit 1; fi

declare -a CONTROL_FILES=()
declare -a FILE_TYPES=()
declare -a PROFILE_NAMES=()

echo "Detected ATS Profiles:"
echo "------------------------------------------------------------------------------------"
INDEX=1
for DIR in "${UNIQUE_PATHS[@]}"; do
    while IFS= read -r -d '' file; do
        CONTROL_FILES+=("$file")
        TYPE="Local"; if [[ "$file" == *"steam_profiles"* ]]; then TYPE="Steam Copy"; elif [[ "$file" == *"userdata"* ]]; then TYPE="Steam Cloud"; fi
        FILE_TYPES+=("$TYPE")
        PROF_DIR=$(basename "$(dirname "$file")"); PROFILE_NAMES+=("$PROF_DIR")
        BAK_STATUS="[Backup: No ]"; if [ -f "${file}.bak" ]; then BAK_STATUS="[Backup: Yes]"; fi
        printf " [\e[36m%s\e[0m] Folder: \e[37m%-20s\e[0m | Type: \e[35m%-12s\e[0m | %s\n" "$INDEX" "$PROF_DIR" "$TYPE" "$BAK_STATUS"
        INDEX=$((INDEX + 1))
    done < <(find "$DIR" -type f -name "controls.sii" -print0 2>/dev/null)
done

echo "------------------------------------------------------------------------------------"
echo -e " [\e[32mA\e[0m] Patch ALL  |  [\e[33mR\e[0m] Restore Backups  |  [\e[31mE\e[0m] Exit"
echo "------------------------------------------------------------------------------------"
echo ""

read -p "Please select an option: " SELECTION
SELECTION=$(echo "$SELECTION" | tr '[:lower:]' '[:upper:]' | xargs)
if [ "$SELECTION" == "E" ]; then exit 0; fi

if [ "$SELECTION" == "R" ]; then
    for i in "${!CONTROL_FILES[@]}"; do
        FILE="${CONTROL_FILES[$i]}"; BACKUP="${FILE}.bak"
        if [ -f "$BACKUP" ]; then
            chmod +w "$FILE" 2>/dev/null; cp -f "$BACKUP" "$FILE"; rm -f "$BACKUP"
            echo -e "  -> \e[32mRestored: ${PROFILE_NAMES[$i]}\e[0m"
        fi
    done
    exit 0
fi

declare -a TARGETS_TO_PATCH=()
if [ "$SELECTION" == "A" ]; then TARGETS_TO_PATCH=("${!CONTROL_FILES[@]}")
elif [[ "$SELECTION" =~ ^[0-9]+$ ]] && [ "$SELECTION" -ge 1 ] && [ "$SELECTION" -le "${#CONTROL_FILES[@]}" ]; then
    TARGETS_TO_PATCH+=("$((SELECTION - 1))")
fi

if [ ${#TARGETS_TO_PATCH[@]} -eq 0 ]; then echo -e "\e[31m[ERROR] Invalid selection!\e[0m"; exit 1; fi

for idx in "${TARGETS_TO_PATCH[@]}"; do
    FILE="${CONTROL_FILES[$idx]}"; BACKUP="${FILE}.bak"
    echo -e "Processing: ${PROFILE_NAMES[$idx]} [${FILE_TYPES[$idx]}]"
    chmod +w "$FILE" 2>/dev/null
    if [ ! -f "$BACKUP" ]; then cp "$FILE" "$BACKUP"; fi
    
    if grep -q "mix dsteering" "$FILE"; then
        sed -i 's|mix dsteerleft .*|mix dsteerleft "keyboard.a?0"|' "$FILE"
        sed -i 's|mix dsteerright .*|mix dsteerright "keyboard.d?0"|' "$FILE"
        sed -i 's|mix dsteering .*|mix dsteering "(keyboard.a?0 - keyboard.d?0) * (0.35 + keyboard.space?0 * (0.55 - keyboard.s?0 * 0.25))"|' "$FILE"
        sed -i 's|mix steering .*|mix steering "dsteering * (1.0 - (c_steer_func * 0.5))"|' "$FILE"
        sed -i 's|mix aforward .*|mix aforward "(keyboard.w?0 * 0.35) + (keyboard.lalt?0 * 0.55)"|' "$FILE"
        sed -i 's|mix abackward .*|mix abackward "keyboard.s?0 * (0.10 + keyboard.space?0 * 0.50)"|' "$FILE"
        echo -e "  -> \e[32mSuccess: RKS formulas injected!\e[0m"
    else
        echo -e "  -> \e[33m[WARNING] Target lines not found. File might be corrupted.\e[0m"
        if [ -f "$PRESET_FILE" ]; then
            echo ""
            echo -e "     \e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
            echo -e "     \e[33mWARNING: Installing the preset will reset your custom in-game keybinds \e[0m"
            echo -e "              \e[33mand sensitivity settings to default RKS values!\e[0m"
            echo -e "              \e[32mYour original settings are SAFELY backed up in 'controls.sii.bak'.\e[0m"
            echo -e "              \e[33mYou will need to manually reconfigure your basic controls in-game.\e[0m"
            echo -e "     \e[31m!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\e[0m"
            echo ""
            read -p "     Do you still want to overwrite with the clean RKS Default Preset? (Y/N): " CHOICE
            CHOICE=$(echo "$CHOICE" | tr '[:lower:]' '[:upper:]' | xargs)
            if [ "$CHOICE" == "Y" ]; then
                cp -f "$PRESET_FILE" "$FILE"
                echo -e "     -> \e[32mSuccess: Overwritten with clean RKS Preset!\e[0m"
                echo ""
                echo -e "     \e[36m------------------------------------------------------------------------\e[0m"
                echo -e "     \e[33mHOW TO RESTORE YOUR ORIGINAL SETTINGS LATER:\e[0m"
                echo -e "     Option 1 (Automatic): Restart this script and press [R] in the main menu."
                echo -e "     Option 2 (Manual): Go to your profile directory:"
                echo -e "                        $(dirname "$FILE")"
                echo -e "                        Delete 'controls.sii' and rename 'controls.sii.bak'"
                echo -e "                        back to 'controls.sii'."
                echo -e "     \e[36m------------------------------------------------------------------------\e[0m"
                echo ""
            else echo "     -> Skipped preset installation."; fi
        else echo -e "     -> \e[31mFallback preset file 'rks_preset_controls.sii' not found!\e[0m"; fi
    fi
    echo "------------------------------------------------------------------------------------"
done
read -p "Process finished. Press Enter to exit..."
