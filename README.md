# ATS Realistic Keyboard Steering (with Turbo-Mode)

⚠️ **IMPORTANT NOTICE:** This repository contains the official installation scripts and physics configuration files. It is designed as a mandatory companion/supplement to the official Steam Workshop mod. Make sure you are subscribed to the mod on Steam before running these files!  
🔗 **[Steam Workshop Link](https://steamcommunity.com/sharedfiles/filedetails/?id=3725174940)**

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
* **Anti-Twitch Balance:** When braking heavily with `S + Spacebar`, the steering turbo automatically downscales from 90% to **65%** to compensate for the extreme weight shift and tire grip, preventing your truck from spinning out control.

---

## ⚙️ Recommended In-Game Settings

* **Steering Sensitivity:** Adjust to your liking! Moving the slider changes the steering intensity. Your custom formula scales perfectly with this option.
* **Steering Non-Linearity:** Pull the slider to the **Right (50% - 80%)** to unleash the full geschwindigkeitsabhängige Abdämpfung (Speed-Damping) on highways.
* **Braking Intensity:** Set to **50% (Middle / Default)**. This provides the most realistic stopping distance combined with your Turbo-Brake. Adjust freely for harder or softer braking.

---

## 🚀 Installation Guide

### 📥 Prerequisites
Before running the installer, go to Steam ➔ Right-click American Truck Simulator ➔ Properties ➔ Controller ➔ Set Steam Input to **"Disable Steam Input"**. If active, Steam Input will emulate a gamepad and override this configuration.

### 🪟 Windows 11 / 10 Instruction
1. Close the game.
2. Download `controls_preset.sii`, `install.bat`, and `uninstall.bat` into the **same folder**.
3. Double-click `install.bat` to run the installer. It will automatically find all your ATS profiles, create a safe `.bak` backup, and apply the patch.

### 🐧 Linux Instruction (Pop!_OS / Ubuntu)
1. Close the game.
2. Open your terminal in the directory where `install.sh` is located.
3. Make the script executable and run it:
   ```bash
   chmod +x install.sh uninstall.sh
   ./install.sh
   ```

---

## ↩️ Uninstallation
If you ever want to revert back to your old controls, simply run the `uninstall.bat` (Windows) or `./uninstall.sh` (Linux) script. It will instantly delete the modified injector preset and restore your original configuration from the backup file.

---

## 🇩🇪 Deutsche Version

Dieses Skript aktualisiert deine American Truck Simulator Steuerungskonfiguration für eine realistische und präzise Tastaturbedienung. Es implementiert eine zweistufige Eingabelogik ("Turbo-Modus"), die präzises Fahren auf Autobahnen sowie scharfe Manöver in der Stadt ermöglicht – völlig ohne Modifikation von Spieldateien.

⚠️ **WICHTIGER HINWEIS:** Dieses Repository dient als zwingende Ergänzung zur offiziellen Steam-Workshop-Mod. Stelle sicher, dass du die Mod auf Steam abonniert hast, bevor du diese Dateien ausführst!  
🔗 **[Steam Workshop Link](https://steamcommunity.com/sharedfiles/filedetails/?id=3725174940)**

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
1. Klicke in Steam mit der rechten Maustaste auf ATS ➔ Eigenschaften ➔ Controller ➔ Stelle Steam-Eingabe auf **"Steam-Eingabe deaktivieren"**.
2. Schließe das Spiel.
3. Lade `controls_preset.sii`, `install.bat` und `uninstall.bat` in den **selben Ordner** herunter.
4. Führe die `install.bat` per Doppelklick aus. Das Skript sucht alle Profile, erstellt ein Backup und injiziert das Preset.

---

## ⚠️ Terms of Use & Copyright
© 2026 Shadoo91. All rights reserved.
* **No Redistribution:** You are strictly prohibited from re-uploading, redistributing, or mirroring these scripts or the repository files on any other platform, forum, or modding site.
* **No Unauthorized Modifications:** Modifying, editing, or copying code from these installers or configuration files for public release or sharing is not allowed.
* **Credits & Attribution:** If you showcase, review, or feature this project (e.g., on YouTube, blogs, or community forums), you MUST explicitly credit me as the author and provide direct links to this GitHub repository and the official Steam Workshop page.
