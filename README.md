# ATS Realistic Keyboard Steering (with Turbo-Mode)

⚠️ **CRITICAL IN-GAME MENU NOTICE (For English & German users):**
After running the installer, **Throttle (Gas) and Brake will visually appear as "Not Bound" / "Nicht belegt" inside your in-game options menu!** 
* **This is 100% intentional and required!** 
* The script completely detaches the rigid digital lines to unlock the high-fidelity 3-stage analog physics matrix. 
* **Do NOT rebind W and S in the menu!** If you click there and re-assign W and S, the game will force full-throttle/full-brake digital logic, and the realistic physics script will be completely disabled. Just leave the fields empty and drive!

⚠️ **IMPORTANT NOTICE:** This repository contains the official installation scripts and physics configuration files. It is designed as a mandatory companion/supplement to the official Steam Workshop mod. Make sure you are subscribed to the mod on Steam before running these files!  
🔗 **[Steam Workshop Link](https://steamcommunity.com/sharedfiles/filedetails/?id=3725174940)**

This script updates your American Truck Simulator input configuration to provide realistic, physics-compliant keyboard controls. It implements a multi-stage input logic ("Turbo Mode") that allows precise cruising, multi-tier braking, and sharp maneuvers without altering game physics files.

---

## 🎮 Features & Control Layout

### 🔹 Steering (A / D)
* **Cruise & Maneuver Logic (A / D):** Smooth and precise input at **35%** sensitivity for high-speed highway stability.
* **Intelligent Braking-Turbo (A/D + Spacebar OR LAlt while Braking):** Instantly boosts your steering angle to **90%** max capacity for tight turns or emergency maneuvers. 
* **Anti-Twitch Acceleration Guard:** The steering turbo automatically stays completely deactivated while accelerating (`W + LAlt`), preventing your truck from spinning out at high speeds. It only activates when braking (`S`).
* **Dynamic Speed Damping:** Automatically tones down steering sharpness at high speeds based on your in-game Non-Linearity to prevent truck rollovers.

### 🔹 Throttle
* **Smooth Throttle (W Key):** Limits independent acceleration power to **35%**. Perfect for realistic city driving, smooth takeoffs, and precise yard parking.
* **Partial Throttle Boost (Left Alt Key Only):** Serves as an independent **55%** mid-stage throttle cruise control or hill climbing assist.
* **Kickdown / Turbo Gas (W + Left Alt together):** Unlocks the full highway power of your truck, merging both stages to deliver **90%** total throttle output.

### 🔹 Braking
* **Stage 1 - Smooth Brake (S Key):** Triggers a soft **10%** baseline deceleration. Lights up your brake lights naturally without instantly triggering ABS or locking up the tires.
* **Stage 2 - Mid Brake (S + Left Alt):** Engages a controlled **60%** medium deceleration force. Simultaneously unlocks the 90% steering turbo for tactical evasive action.
* **Stage 3 - Emergency Brake (S + Spacebar):** Instantly engages **90%** brutal maximum braking force for heavy ABS emergency stops. Simultaneously unlocks the 90% steering turbo.

⚠️ **CRITICAL KEYBIND NOTICE:** Since **Spacebar** and **Left Alt** are now hardcoded into the RKS steering and multi-stage braking/throttle matrix, you **MUST** ensure these two keys are not bound to any other functions (like Handbrake or Camera toggle) inside the in-game options! Rebind conflicting functions to other keys to prevent double-activation issues.

---

## ⚙️ Recommended In-Game Settings

* **Steering Sensitivity:** Adjust to your liking! Moving the slider changes the steering intensity. Your custom formula scales perfectly with this option.
* **Steering Non-Linearity:** Pull the slider to the **Right (50% - 80%)** to unleash the full speed-damping on highways.
* **Braking Intensity:** Set to **50% (Middle / Default)**. This provides the most realistic stopping distance combined with your Turbo-Brake. Adjust freely for harder or softer braking.

---

## 🚀 Installation Guide

### 📥 Prerequisites
Before running the installer, go to Steam ➔ Right-click American Truck Simulator ➔ Properties ➔ Controller ➔ Set Steam Input to **"Disable Steam Input"**. If active, Steam Input will emulate a gamepad and override this configuration.

### 🪟 Windows (10 / 11) Instruction
1. Completely close the game.
2. Download `rks_preset_controls.sii`, `rks_injector_core.ps1`, and `Launcher_Windows_RKS.bat` into the **same folder** (e.g., your Downloads folder). 
   *(Note: Both the .bat and .ps1 files must be in the same directory!)*
3. Double-click **`Launcher_Windows_RKS.bat`** to launch the manager. 
4. Type **`A`** and press Enter to patch all your profiles automatically.

### 🐧 Linux Instruction (Pop!_OS / Ubuntu / Steam Deck)
1. Completely close the game.
2. Download `rks_preset_controls.sii` and `install_linux_rks_1.0.sh` into the **same folder**.
3. Open your terminal in that directory.
4. Make the script executable and run it by typing:
   ```bash
   chmod +x install_linux_rks_1.0.sh
   ./install_linux_rks_1.0.sh
   ```
5. Type **`A`** and press Enter to patch all your profiles automatically.

### 💡 Alternative Manual Installation (If scripts fail due to OS restrictions)
If your operating system blocks the automatic installers, you can easily apply the custom logic manually:
1. Open your ATS profile folder: `Documents / American Truck Simulator / profiles / YOUR_PROFILE_ID /`
2. Open your existing **`controls.sii`** file with a text editor (like Notepad++).
3. Look for the lines starting from `mix dsteerleft` down to `mix backward` (usually around lines 330-341).
4. Delete those specific lines and replace them by copy-pasting the exact 12 configuration lines from the **`rks_preset_controls.sii`** file included in this repository.
5. Save and close the file.

---

## ↩️ Uninstallation & Rollback
If you ever want to revert back to your old controls and completely remove the mod, the manager has a built-in safety rollback feature:
1. Simply restart the manager script according to your system:
   * **Windows:** Double-click **`Launcher_Windows_RKS.bat`**
   * **Linux:** Run `./install_linux_rks_1.0.sh` in your terminal.
2. Inside the script main menu, type **`R`** and press Enter to trigger the **Restore backups** system.
3. The script will automatically delete the RKS configuration and safely restore your original profile settings from the `.bak` file.

---

## 🇩🇪 Deutsche Version

Dieses Skript aktualisiert deine American Truck Simulator Steuerungskonfiguration für eine realistische und präzise Tastaturbedienung. Es implementiert eine mehrstufige Eingabelogik ("Turbo-Modus"), die präzises Fahren auf Autobahnen sowie scharfe Manöver in der Stadt ermöglicht – völlig ohne Modifikation von Spieldateien.

⚠️ **WICHTIGER HINWEIS:** Dieses Repository dient als zwingende Ergänzung zur offiziellen Steam-Workshop-Mod. Stelle sicher, dass du die Mod auf Steam abonniert hast, bevor du diese Dateien ausführst!  
🔗 **[Steam Workshop Link](https://steamcommunity.com/sharedfiles/filedetails/?id=3725174940)**

⚠️ **WICHTIGER HINWEIS ZUM INGAME-MENÜ:**
Nachdem du den Installer ausgeführt hast, werden **Gas und Bremse im Steuerungsmenü des Spiels optisch als "Nicht belegt" angezeigt!** 
* **Das ist zu 100% so gewollt und technisch zwingend notwendig!** 
* Das Skript klemmt die starren digitalen Leitungen im Hintergrund ab, um die präzise, analoge 3-Stufen-Physik überhaupt erst zu ermöglichen.
* **Belege W und S NIEMALS neu im Menü!** Wenn du in die leeren Felder klickst und W/S dort wieder einträgst, schaltet das Spiel sofort zurück auf die standardmäßige digitale Vollgas-/Vollbremsungs-Logik und zerstört das gesamte RKS-Skript. Lass die Felder einfach leer und fahr los!

### 🎮 Features & Tastenbelegung

#### 🔹 Lenkung (A / D)
* **Cruising-Logik (A / D):** Sanfter und präziser Einschlag bei **35%** Grundempfindlichkeit für maximale Stabilität bei schneller Fahrt auf Highways.
* **Intelligenter Brems-Turbo (A/D + Leertaste ODER Links-Alt beim Bremsen):** Erzwingt sofort maximal **90%** Einschlagwinkel für enge Stadtkurven oder Notmanöver.
* **Anti-Ausbrech-Schutz beim Beschleunigen:** Während du Gas givst (`W + Links-Alt`), bleibt der Lenkungs-Turbo komplett gesperrt. Das verhindert das gefährliche Verreißen des Lkw bei hoher Geschwindigkeit. Er zündet nur, wenn du bremst (`S`).
* **Geschwindigkeits-Dämpfung:** Die Lenkung wird bei hohen Geschwindigkeiten automatisch feiner gedämpft, um ein Umkippen des Lkw zu verhindern.

#### 🔹 Gas geben
* **Sanftes Gas (W-Taste):** Begrenzt die reine Motorleistung auf **35%**. Perfekt für realistisches Anfahren, Rangieren und Stadtverkehr.
* **Zwischengas / Teil-Beschleunigung (Nur Links-Alt):** Fungiert als eigenständige **55%** Gasstufe. Ideal als "manueller Tempomat" oder für leichte Steigungen.
* **Kickdown / Turbo-Gas (W + Links-Alt zusammen):** Kombiniert beide Stufen für volle Beschleunigung und schaltet gebündelte **90%** Gesamtleistung für Autobahnen frei.

#### 🔹 Bremsen
* **Stufe 1 - Sanfte Bremse (S-Taste):** Löst eine weiche Verzögerung von **10%** aus. Schaltet die Bremslichter an, verhindert aber blockierende Reifen beim Heranrollen an Kreuzungen.
* **Stufe 2 - Zwischenbremse (S + Links-Alt):** Greift mit einer kontrollierten, mittleren Verzögerung von **60%**. Schaltet gleichzeitig den 90%-Lenkungs-Turbo für sofortige Ausweichmanöver frei.
* **Stufe 3 - Gefahrenbremsung (S + Leertaste):** Aktiviert sofort eine brutale **90%** maximale Bremskraft für schwere Notbremsungen mit ABS. Schaltet gleichzeitig den 90%-Lenkungs-Turbo frei.

⚠️ **WICHTIGER HINWEIS ZUR TASTENBELEGUNG:** Da die **Leertaste** und **Links-Alt** nun fest in die mathematische Matrix deiner Lenkung, Bremsen und Gänge integriert sind, musst du im Spielmenü zwingend sicherstellen, dass diese beiden Tasten **nicht doppelt belegt sind** (z. B. für die Handbremse oder Kamerawechsel)! Lege Konflikte im Menü auf andere Tasten um, um Fehlfunktionen zu vermeiden.

---

## ⚙️ Empfohlene Einstellungen
* **Lenkempfindlichkeit:** Nach Belieben im Menü einstellbar! Der Regler skaliert flüssig mit deiner neuen Formel.
* **Lenkungs-Nichtlinearität:** Schiebe den Regler weit nach **Rechts (50% - 80%)**, um die geschwindigkeitsabhängige Abdämpfung auf Highways zu aktivieren.
* **Bremsstärke:** Stelle den Regler auf **50% (Mitte / Default)** für den realistischsten Bremsweg in Kombination mit der Turbo-Bremse.

### 🚀 Installations-Anleitung

#### 📥 Vorbereitung
1. Klicke in Steam mit der rechten Maustaste auf ATS ➔ Eigenschaften ➔ Controller ➔ Stelle Steam-Eingabe auf **"Steam-Eingabe deaktivieren"**. Wenn aktiv, emuliert Steam ein Gamepad und ignoriert die Tastatur-Befehle der Datei.

#### 🪟 Windows (10 / 11) Anleitung
1. Schließe das Spiel vollständig.
2. Lade die Dateien `rks_preset_controls.sii`, `rks_injector_core.ps1` und `Launcher_Windows_RKS.bat` in den **selben Ordner** herunter (z.B. deinen Downloads-Ordner).
   *(Hinweis: Sowohl die .bat- als auch die .ps1-Datei müssen zwingend im selben Verzeichnis liegen!)*
3. Führe die Datei **`Launcher_Windows_RKS.bat`** per Doppelklick aus, um den Manager zu starten.
4. Tippe im Menü **`A`** ein und drücke Enter, um die Modifikation vollautomatisch auf alle Profile anzuwenden.

#### 🐧 Linux Anleitung (Pop!_OS / Ubuntu / Steam Deck)
1. Schließe das Spiel vollständig.
2. Lade die Dateien `rks_preset_controls.sii` und `install_linux_rks_1.0.sh` in den **selben Ordner** herunter.
3. Öffne dein Terminal in diesem Ordner.
4. Mache das Skript ausführbar und starte es mit folgenden Befehlen:
   ```bash
   chmod +x install_linux_rks_1.0.sh
   ./install_linux_rks_1.0.sh
   ```
5. Tippe im Terminal-Menü **`A`** ein und drücke Enter, um die Anpassung zu aktivieren.

#### 💡 Alternative Manuelle Installation (Falls Skripte blockiert werden)
1. Öffne deinen ATS-Profilordner: `Dokumente / American Truck Simulator / profiles / DEINE_PROFIL_ID /`
2. Öffne deine vorhandene **`controls.sii`** mit einem Texteditor (z.B. Notepad++).
3. Suche nach den Zeilen von `mix dsteerleft` bis `mix backward` (normalerweise die Zeilen 330-341).
4. Lösche diese spezifischen Zeilen und ersetze sie, indem du die 12 Konfigurationszeilen aus der bereitgestellten **`rks_preset_controls.sii`** per Copy-Paste einfügst.
5. Speichere und schließe die Datei.

---

## ↩️ Deinstallation & Rollback
Wenn du deine alten Steuerungseinstellungen wiederherstellen und die Mod restlos entfernen möchtest, kannst du das integrierte Rückroll-System des Managers nutzen:
1. Starte das jeweilige Hauptskript deines Systems einfach erneut:
   * **Windows:** Doppelklick auf **`Launcher_Windows_RKS.bat`**
   * **Linux:** Starte `./Launcher_Linux_RKS` im Terminal.
2. Tippe im Hauptmenü des Skripts den Buchstaben **`R`** ein und drücke Enter, um das **Restore backups** System zu aktivieren.
3. Das Skript löscht die RKS-Befehle automatisch und stellt deine originale Steuerung fehlerfrei aus der Backup-Datei wieder her.

---

## ⚠️ Terms of Use & Copyright
© 2026 Shadoo91. All rights reserved.
* **No Redistribution:** You are strictly prohibited from re-uploading, redistributing, or mirroring these scripts or the repository files on any other platform, forum, or modding site.
* **No Unauthorized Modifications:** Modifying, editing, or copying code from these installers or configuration files for public release or sharing is not allowed.
* **Credits & Attribution:** If you showcase, review, or feature this project (e.g., on YouTube, blogs, or community forums), you MUST explicitly credit me as the author and provide direct links to this GitHub repository and the official Steam Workshop page.
