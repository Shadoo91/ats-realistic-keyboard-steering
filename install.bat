@echo off
title ATS Turbo-Input Installer
setlocal enabledelayedexpansion

:: ==========================================
:: ADMIN-RECHTE PRÜFEN & ANFORDERN
:: ==========================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting Administrator privileges...
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)

cd /d "%~dp0"

echo ===================================================================================
echo   ATS Realistic-Keyboard-Steering (RKS) (Turbo-Mode) - for Windows ~ by Shadoo91
echo   [B64 ENFORCED CORE ENGINE - UNBREAKABLE]
echo ===================================================================================
echo.

:: 1. Pfade definieren (OneDrive-Fokus)
set "PROFILE_DIR=%USERPROFILE%\OneDrive\Dokumente\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\OneDrive\Documents\American Truck Simulator\profiles"
if not exist "%PROFILE_DIR%" set "PROFILE_DIR=%USERPROFILE%\Documents\American Truck Simulator\profiles"

if not exist "%PROFILE_DIR%" (
    echo [ERROR] American Truck Simulator profiles directory not found!
    pause
    exit
)

echo Profiles directory found at:
echo "%PROFILE_DIR%"
echo.
echo Executing Base64 Isolated Patch Engine...
echo.

:: 2. Der komplett verschluesselte Befehlsblock (Ueberspringt JEDEN Windows-Formatfehler)
set "B64_CMD=JFBST0ZJTEVfRElSID0gJyVQUk9GSUxFX0RJUiUnOyAkZmlsZXMgPSBHZXQtQ2hpbGRJdGVtIC1QYXRoICRQUk9GSUxFX0RJUiAtRmlsdGVyICdjb250cm9scy5zaWknIC1SZWN1cnNlOyBmb3JlYWNoICgkZmlsZSBpbiAkZmlsZXMpIHsgV3JpdGUtSG9zdCAiUHJvY2Vzc2luZzogJCgkZmlsZS5EaXJlY3RvcnkuTmFtZSkiIC1Gb3JlZ3JvdW5kQ29sb3IgQ3lhbjsgJHNhbmRib3hGaWxlID0gSm9pbi1QYXRoICRlbnY6VEVNUCAnY29udHJvbHNfc2FuZGJveC5zaWknOyAkYmFrRmlsZSA9IEpvaW4tUGF0aCAkZmlsZS5EaXJlY3RvcnlOYW1lICdjb250cm9scy5zaWkuYmFrJzsgY29weSAtbGl0ZXJhbHBhdGggJGZpbGUuRnVsbE5hbWUgJHNhbmRib3hGaWxlIC1Gb3JjZTsgW1N5c3RlbS5JTy5GaWxlXTo6U2V0QXR0cmlidXRlcygkZmlsZS5GdWxsTmFtZSwgW1N5c3RlbS5JTy5GaWxlQXR0cmlidXRlc106Ok5vcm1hbCk7IGlmICgtbm90IChUZXN0LVBhdGggJGJha0ZpbGUpKSB7IENvcHktSXRlbSAkc2FuZGJveEZpbGUgJGJha0ZpbGUgLUZvcmNlOyBXcml0ZS1Ib3N0ICcgIC0+IEJhY2t1cCBjcmVhdGVkIHN1Y2Nlc3NmdWxseSEnIC1Gb3JlZ3JvdW5kQ29sb3IgWWVsbG93IH07ICR0ZXh0ID0gW1N5c3RlbS5JTy5GaWxlXTo6UmVhZEFsbFRleHQoJHNhbmRib3hGaWxlKTsgJG5ld0xpbmVzID0gJyBjb250cm9sc19saW5lc1szMzBdOiAibWl4IGRzdGVlcmxlZnQgYGtleWJvYXJkLmE/MGBjcmlwdF9saW5lcyInICsgW0Vudmlyb25tZW50XTo6TmV3TGluZSArICcgY29udHJvbHNfbGluZXNbMzMxXTogIm1peCBkc3RlZXJyaWdodCBga2V5Ym9hcmQuZD8wYGNyaXB0X2xpbmVzIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzJdOiAibWl4IGRzdGVlcmluZyBgKGtleWJvYXJkLmE/MCAtIGtleWJvYXJkLmQ/MCkgKiAoMC4zNSArIGtleWJvYXJkLnNwYWNlPzAgKiAwLjY1KWBjcmlwdF9saW5lcyInICsgW0Vudmlyb25tZW50XTo6TmV3TGluZSArICcgY29udHJvbHNfbGluZXNbMzMzXTogIm1peCBzdGVlcmluZyBgZHN0ZWVyaW5nYGNyaXB0X2xpbmVzIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzRdOiAibWl4IG1zdGVlcmluZyBgLW1vdXNlLnJlbF9wb3NpdGlvbi54PzAgKiBjX21zZW5zYGNyaXB0X2xpbmVzIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzVdOiAibWl4IG1wZWRhbHMgYC1tb3VzZS5yZWxfcG9zaXRpb24ueT8wICogY19tc2Vuc2BgIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzZdOiAibWl4IGRmb3J3YXJkIGAwYCInICsgW0Vudmlyb25tZW50XTo6TmV3TGluZSArICcgY29udHJvbHNfbGluZXNbMzM3XTogIm1peCBkYmFja3dhcmQgYDBgIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzhdOiAibWl4IGFmb3J3YXJkIGAoa2V5Ym9hcmQudzcwICogMC4zNSkgKyAoa2V5Ym9hcmQubGFsdD8wICogMC41NSlgIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzldOiAibWl4IGFiYWNrd2FyZCBga2V5Ym9hcmQubzcwICogKDAuMTAgKyBrZXlib2FyZC5zcGFjZT8wICogMC41MClgIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szNDBdOiAibWl4IGZvcndhcmQgYGFmb3J3YXJkYCInICsgW0Vudmlyb25tZW50XTo6TmV3TGluZSArICcgY29udHJvbHNfbGluZXNbMzQxXTogIm1peCBiYWNrd2FyZCBgYWJhY2t3YXJkYCInOyAkdGV4dCA9ICR0ZXh0IC1yZXBsYWNlICcoP3MpIGNvbnRyb2xzX2xpbmVzXDMzMFw6Lipjb250cm9sc19saW5lc1wzNDFcOltedXJcbl0qJywgJG5ld0xpbmVzOyBbdGV4dC5lbmNvZGluZ106OmFzY2lpLmdldHN0cmluZygodGV4dC5lbmNvZGluZ106OmFzY2lpLmdldGJ5dGVzKCR0ZXh0KSkpIHwgb3V0LWZpbGUgJHNhbmRib3hGaWxlIC1lbmNvZGluZyBhc2NpaTsgY29weSAtbGl0ZXJhbHBhdGggJHNhbmRib3hGaWxlICRmaWxlLkZ1bGxOYW1lIC1Gb3JjZTsgUmVtb3ZlLUl0ZW0gJHNhbmRib3hGaWxlIC1Gb3JjZTsgW1N5c3RlbS5JTy5GaWxlXTo6U2V0QXR0cmlidXRlcygkZmlsZS5GdWxsTmFtZSwgW1N5c3RlbS5JTy5GaWxlQXR0cmlidXRlc106OlJlYWRPbmx5KTsgV3JpdGUtSG9zdCAnICAtPiBTdWNjZXNzZnVsbHkgcGF0Y2hlZCBwcm9maWxlIScgLUZvcmVncm91bmRDb2xvciBHcmVlIH0="

:: 3. Ausfuehren des Base64-Datenstroms
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand %B64_CMD%

echo.
echo [INFO] Installation process finished.
pause
