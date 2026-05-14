# ATS Realistic Keyboard Steering (with Turbo-Mode)

⚠️ **IMPORTANT NOTICE:** This repository contains the official installation scripts and physics configuration files. It is designed as a mandatory companion/supplement to the official Steam Workshop mod. Make sure you are subscribed to the mod on Steam before running these files!  
🔗 **[Steam Workshop Link](https://steamcommunity.com)**

This script updates your American Truck Simulator input configuration to provide realistic, physics-compliant keyboard controls. It implements a dual-stage input logic ("Turbo Mode") that allows precise cruising and sharp maneuvers without altering game physics files.

---

## 🎮 Features & Control Layout

### 🔹 Steering (A / D)
* **Cruise & Maneuver Logic (A / D):** Smooth and precise input at **35%** sensitivity for high-speed highway stability.
* **Turbo Steering (A / D + Spacebar):** Instantly boosts your steering angle to **90%** max capacity for tight city turns or emergency maneuvers. 
* **Dynamic Speed Damping:** Automatically tones down steering sharpness at high speeds based on your in-game Non-Linearity to prevent truck rollovers.

### 🔹 Throttle
* **Smooth Throttle (W Key):** Limits independent acceleration power to **35%**. Perfect for realistic city driving, smooth takeoffs, and precise yard parking.
* **Partial Throttle Boost (Left Alt Key Only):** Serves as an independent **55%** mid-stage throttle cruise control or hill climbing assist.
* **Kickdown / Turbo Gas (W + Left Alt together):** Unlocks the full highway power of your truck, merging both stages to deliver **90%** total throttle output.

### 🔹 Braking
* **Smooth Brake (S Key):** Triggers a soft **10%** baseline deceleration. Lights up your brake lights naturally without instantly triggering ABS or locking up the tires.
* **Heavy Turbo Brake (S + Spacebar):** Instantly engages up to **60%** maximum braking force for heavy emergency stops.
* **Anti-Twitch Balance:** When braking heavily with `S + Spacebar`, the steering turbo automatically downscales from 90% to **65%** to compensate for the extreme weight shift and tire grip, preventing your truck from spinning out of control.

---

## ⚙️ Recommended In-Game Settings

* **Steering Sensitivity:** Adjust to your liking! Moving the slider changes the steering intensity. Your custom formula scales perfectly with this option.
* **Steering Non-Linearity:** Pull the slider to the **Right (50% - 80%)** to unleash the full geschwindigkeitsabhängige Abdämpfung (Speed-Damping) on highways.
* **Braking Intensity:** Set to **50% (Middle / Default)**. This provides the most realistic stopping distance combined with your Turbo-Brake. Adjust freely for harder or softer braking.

---

## 🚀 Installation Guide

### 📥 Prerequisites
Before running the installer, go to Steam ➔ Right-click American Truck Simulator ➔ Properties ➔ Controller ➔ Set Steam Input to **"Disable Steam Input"**. If active, Steam Input will emulate a gamepad and override this configuration.

### 🪟 Windows (10 / 11) Instruction
1. Completely close the game.
2. Download `controls_preset.sii`, `install_windows_rks_1.0.bat`, and `uninstall_windows_rks_1.0.bat` into the **same folder** (e.g., your Downloads folder).
3. Double-click **`install_windows_rks_1.0.bat`** to run the installer. 
4. It will automatically find all your ATS profiles, create a safe `.bak` backup, and apply the patch.

### 🐧 Linux Instruction (Pop!_OS / Ubuntu / Steam Deck)
1. Completely close the game.
2. Download `controls_preset.sii`, `install_linux_rks_1.0.sh`, and `uninstall_linux_rks_1.0.sh` into the **same folder**.
3. Open your terminal in that directory.
4. Make the script executable and run it by typing:
   ```bash
   chmod +x install_linux_rks_1.0.sh uninstall_linux_rks_1.0.sh
   ./install_linux_rks_1.0.sh
   ```

---

## ↩️ Uninstallation
If you ever want to revert back to your old controls, simply run the uninstaller depending on your system:
* **Windows:** Double-click **`uninstall_windows_rks_1.0.bat`**
* **Linux:** Run `./uninstall_linux_rks_1.0.sh` in your terminal.

It will instantly delete the injector preset and safely restore your original configuration from the backup file.

---

## 🇩🇪 Deutsche Version

Dieses Skript aktualisiert deine American Truck Simulator Steuerungskonfiguration für eine realistische und präzise Tastaturbedienung. Es implementiert eine zweistufige Eingabelogik ("Turbo-Modus"), die präzises Fahren auf Autobahnen sowie scharfe Manöver in der Stadt ermöglicht – völlig ohne Modifikation von Spieldateien.

⚠️ **WICHTIGER HINWEIS:** Dieses Repository dient als zwingende Ergänzung zur offiziellen Steam-Workshop-Mod. Stelle sicher, dass du die Mod auf Steam abonniert hast, bevor du diese Dateien ausführst!  
🔗 **[Steam Workshop Link](https://steamcommunity.com)**

### 🎮 Features & Tastenbelegung

#### 🔹 Lenkung (A / D)
* **Cruising-Logik (A / D):** Sanfter und präziser Einschlag bei **35%** Grundempfindlichkeit für maximale Stabilität bei schneller Fahrt.
* **Turbo-Lenkung (A / D + Leertaste):** Erzwingt sofort maximal **90%** Einschlagwinkel für enge Kurven in Städten oder Ausweichmanöver.
* **Geschwindigkeits-Dämpfung:** Die Lenkung wird bei hohen Geschwindigkeiten automatisch feiner gedämpft, um ein Umkippen des Lkw zu verhindern.

#### 🔹 Gas geben
* **Sanftes Gas (W-Taste):** Begrenzt die reine Motorleistung auf **35%**. Perfekt für realistisches Anfahren, Rangieren und Stadtverkehr.
* **Zwischengas / Teil-Beschleunigung (Nur Links-Alt):** Fungiert als eigenständige **55%** Gasstufe. Ideal als "manueller Tempomat" oder für leichte Steigungen.
* **Kickdown / Turbo-Gas (W + Links-Alt zusammen):** Kombiniert beide Stufen für volle Beschleunigung und schaltet gebündelte **90%** Gesamtleistung für Autobahnen frei.

#### 🔹 Bremsen
* **Sanfte Bremse (S-Taste):** Löst eine weiche Verzögerung von **10%** aus. Schaltet die Bremslichter an, verhindert aber blockierende Reifen.
* **Turbo-Bremse (S + Leertaste):** Schaltet sofort **60%** maximale Bremskraft für harte Notbremsungen frei.
* **Anti-Ausbrech-Schutz:** Wenn du mit `S + Leertaste` voll bremst, wird der Lenkungs-Turbo automatisch von 90% auf **65%** gedrosselt. Das gleicht die extreme Gewichtsverlagerung nach vorne perfekt aus, sodass der Lkw beim Bremsen in Kurven nicht unkontrolliert ausbricht.

### ⚙️ Empfohlene Einstellungen
* **Lenkempfindlichkeit:** Nach Belieben einstellbar! Der Regler skaliert flüssig mit deiner neuen Formel.
* **Lenkungs-Nichtlinearität:** Schiebe den Regler weit nach **Rechts (50% - 80%)**, um die geschwindigkeitsabhängige Abdämpfung auf Highways zu aktivieren.
* **Bremsstärke:** Stelle den Regler auf **50% (Mitte / Standard)** für den realistischsten Bremsweg in Kombination mit der Turbo-Bremse.

### 🚀 Installations-Anleitung

#### 📥 Vorbereitung
1. Klicke in Steam mit der rechten Maustaste auf ATS ➔ Eigenschaften ➔ Controller ➔ Stelle Steam-Eingabe auf **"Steam-Eingabe deaktivieren"**. Wenn aktiv, emuliert Steam ein Gamepad und ignoriert die Tastatur-Befehle der Datei.

#### 🪟 Windows (10 / 11) Anleitung
1. Schließe das Spiel vollständig.
2. Lade die Dateien `controls_preset.sii`, `install_windows_rks_1.0.bat` und `uninstall_windows_rks_1.0.bat` in den **selben Ordner** herunter (z.B. deinen Downloads-Ordner).
3. Führe die Datei **`install_windows_rks_1.0.bat`** per Doppelklick aus.
4. Das Skript sucht automatisch alle deine ATS-Profile, erstellt ein sicheres Backup und wendet den Patch an.

#### 🐧 Linux Anleitung (Pop!_OS / Ubuntu / Steam Deck)
1. Schließe das Spiel vollständig.
2. Lade die Dateien `controls_preset.sii`, `install_linux_rks_1.0.sh` und `uninstall_linux_rks_1.0.sh` in den **selben Ordner** herunter.
3. Öffne dein Terminal in diesem Ordner.
4. Mache das Skript ausführbar und starte es mit folgenden Befehlen:
   ```bash
   chmod +x install_linux_rks_1.0.sh uninstall_linux_rks_1.0.sh
   ./install_linux_rks_1.0.sh
   ```

---

## ↩️ Deinstallation
Wenn du deine alten Steuerungseinstellungen wiederherstellen möchtest, führe einfach den passenden Uninstaller für dein System aus:
* **Windows:** Führe die **`uninstall_windows_rks_1.0.bat`** per Doppelklick aus.
* **Linux:** Starte `./uninstall_linux_rks_1.0.sh` im Terminal.

Das Skript löscht das modifizierte Preset und stellt deine originale Konfiguration sofort aus der Backup-Datei wieder her.

---

## ⚠️ Terms of Use & Copyright
© 2026 Shadoo91. All rights reserved.
* **No Redistribution:** You are strictly prohibited from re-uploading, redistributing, or mirroring these scripts or the repository files on any other platform, forum, or modding site.
* **No Unauthorized Modifications:** Modifying, editing, or copying code from these installers or configuration files for public release or sharing is not allowed.
* **Credits & Attribution:** If you showcase, review, or feature this project (e.g., on YouTube, blogs, or community forums), you MUST explicitly credit me as the author and provide direct links to this GitHub repository and the official Steam Workshop page.
