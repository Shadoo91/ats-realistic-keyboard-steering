# ATS Realistic Keyboard Steering (with Turbo-Mode)

⚠️ **IMPORTANT NOTICE:** This repository contains the official installation scripts and physics configuration files. It is designed as a **mandatory companion/supplement to the official Steam Workshop mod**. Make sure you are subscribed to the mod on Steam before running these files!

This script updates your American Truck Simulator input configuration to provide realistic, physics-compliant keyboard controls. It implements a dual-stage input logic ("Turbo Mode") that allows precise cruising and sharp maneuvers without altering game physics files.

## 🎮 Features & Control Layout

* **Steering (A / D):** Smooth and precise input at 35% sensitivity for highway stability.
  * **Turbo Steering (A/D + Spacebar):** Instantly forces 100% steering angle for sharp city turns or emergency maneuvers.
* **Throttle:**
  * **W Key (Smooth Throttle):** Limits acceleration power to 35%. Perfect for realistic city driving, smooth takeoffs, and precise yard parking.
  * **Left Alt Key (Kickdown / Turbo Gas):** Unlocks the full power of your truck. Holding W + Left Alt gives you 90% total throttle for highways and steep inclines.
* **Braking:**
  * **S Key (Smooth Brake):** Triggers a soft 10% deceleration. Activates brake lights without locking up the tires.
  * **Turbo Brake (S + Spacebar):** Instantly engages 60% maximum braking force for heavy emergency stops.

## ⚙️ Recommended In-Game Settings

* **Steering Sensitivity:** Adjust to your liking! Moving the slider changes the steering intensity. Your custom formula scales perfectly with this in-game option.
* **Braking Intensity:** Set to **50% (Middle / Default)**. This provides the most realistic stopping distance combined with your Turbo-Brake. Adjust freely for harder or softer braking.
* **Physics Customization:** If the truck still feels too stiff or rolls too much for your taste, simply adjust the official *Chassis Stiffness* and *Cabin Stiffness* sliders in the gameplay options menu to your personal preference.

## 🚀 Installation Guide

### 📥 Prerequisites
Before running the installer, go to Steam -> Right-click American Truck Simulator -> Properties -> Controller -> Set Steam Input to "Disable Steam Input". If active, Steam Input will emulate a gamepad and override this configuration.

### 🪟 Windows 11 Instruction
1. Close the game.
2. Download `install.bat` and `uninstall.bat` from this repository.
3. Double-click `install.bat` to run the installer. It will automatically find all your ATS profiles, create a backup, and apply the patch.

### 🐧 Linux Instruction (Pop!_OS / Ubuntu)
1. Close the game.
2. Open your terminal in the directory where `install.sh` is located.
3. Make the script executable and run it:
   ```bash
   chmod +x install.sh uninstall.sh
   ./install.sh
   ```

## ↩️ Uninstallation
If you ever want to revert back to your old controls, simply run the `uninstall.bat` (Windows) or `./uninstall.sh` (Linux) script. It will instantly delete the modified layout and restore your original configuration from the backup file.

---

## 🇩🇪 Deutsche Version

Dieses Skript aktualisiert deine American Truck Simulator Steuerungskonfiguration für eine realistische und präzise Tastaturbedienung. Es implementiert eine zweistufige Eingabelogik ("Turbo-Modus"), die präzises Fahren auf Autobahnen sowie scharfe Manöver in der Stadt ermöglicht – völlig ohne Modifikation von Spieldateien.

⚠️ **WICHTIGER HINWEIS:** Dieses Repository enthält die offiziellen Installations-Skripte und Physik-Dateien. Es dient als **zwingende Ergänzung zur offiziellen Steam-Workshop-Mod**. Stelle sicher, dass du die Mod auf Steam abonniert hast, bevor du diese Dateien ausführst!

### 🎮 Features & Tastenbelegung
* **Lenkung (A / D):** Sanfter und präziser Einschlag bei 35% Grundempfindlichkeit für maximale Stabilität bei hoher Fahrt.
  * **Turbo-Lenkung (A/D + Leertaste):** Erzwingt sofort 100% Einschlagwinkel für enge Kurven in Städten oder Ausweichmanöver.
* **Gas geben:**
  * **W-Taste (Sanftes Gas):** Begrenzt die Motorleistung auf 35%. Perfekt für realistisches Anfahren, Rangieren und Stadtverkehr.
  * **Linke Alt-Taste (Kickdown / Turbo-Gas):** Schaltet zusätzliche 55% Leistung frei. Das Halten von W + Links-Alt ergibt 90% Gesamtgas für Autobahnen und Steigungen.
* **Bremsen:**
  * **S-Taste (Sanfte Bremse):** Löst eine weiche Verzögerung von 10% aus. Schaltet die Bremslichter an, verhindert aber blockierende Reifen.
  * **Turbo-Bremse (S + Leertaste):** Schaltet sofort 60% maximale Bremskraft für harte Notbremsungen frei.

### ⚙️ Empfohlene Einstellungen
* **Lenkempfindlichkeit:** Nach Belieben im Menü einstellbar! Das Verschieben des Reglers ändert die Intensität der Lenkung. Deine Formel skaliert perfekt mit dieser Option.
* **Bremsstärke:** Stelle den Regler auf **50% (Mitte / Standard)**. Dies liefert in Kombination mit der Turbo-Bremse den realistischsten Bremsweg. Kann nach Geschmack frei verschoben werden.
* **Physik-Feintuning:** Falls dir der Truck immer noch zu steif ist oder zu stark wankt, passe einfach die offiziellen Regler für *Aufliegerstabilität*, *Fahrwerksteifigkeit* und *Kabinensteifigkeit* im Gameplay-Menü nach deinen Wünschen an.

### 🚀 Installations-Anleitung

### 📥 Vorbereitung
Klicke vor der Installation in Steam mit der rechten Maustaste auf American Truck Simulator -> Eigenschaften -> Controller -> Stelle Steam-Eingabe auf "Steam-Eingabe deaktivieren". Wenn aktiv, emuliert Steam ein Gamepad und ignoriert die Tastatur-Befehle der Datei.

### 🪟 Windows 11 Anleitung
1. Schließe das Spiel.
2. Lade die Dateien `install.bat` und `uninstall.bat` aus diesem Repository herunter.
3. Führe die `install.bat` per Doppelklick aus. Das Skript sucht automatisch alle deine ATS-Profile, erstellt ein Backup und wendet den Patch an.

### 🐧 Linux Anleitung (Pop!_OS / Ubuntu)
1. Schließe das Spiel.
2. Öffne dein Terminal in dem Ordner, in dem die `install.sh` liegt.
3. Mache das Skript ausführbar und starte es:
   ```bash
   chmod +x install.sh uninstall.sh
   ./install.sh
   ```

### ↩️ Deinstallation
Wenn du deine alten Steuerungseinstellungen wiederherstellen möchtest, führe einfach die `uninstall.bat` (Windows) oder `./uninstall.sh` (Linux) aus. Das Skript löscht die modifizierten Zeilen und stellt deine originale Konfiguration aus der Backup-Datei wieder her.

---

## ⚠️ Terms of Use & Copyright

© 2026 Shadoo91. All rights reserved.

1. **No Redistribution:** You are strictly prohibited from re-uploading, redistributing, or mirroring these scripts or the repository files on any other platform, forum, or modding site.
2. **No Unauthorized Modifications:** Modifying, editing, or copying code from these installers or configuration files for public release or sharing is not allowed.
3. **Credits & Attribution:** If you showcase, review, or feature this project (e.g., on YouTube, blogs, or community forums), you MUST explicitly credit me as the author and provide direct links to this GitHub repository and the official Steam Workshop page.
