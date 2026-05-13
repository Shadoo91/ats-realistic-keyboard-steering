@echo off
title SCS Games Turbo-Input Installer
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
echo   ATS ^& ETS2 Realistic-Keyboard-Steering (RKS) (Turbo-Mode) ~ by Shadoo91
echo   [B64 UNIVERSAL INJECTOR - NO FORMAT BREAKS]
echo ===================================================================================
echo.

echo Scanning system and executing Base64 Isolated Patch Engine...
echo Please wait a moment...
echo.

:: Der komplett verschluesselte Befehlsblock (Ueberspringt JEDEN Windows-Formatfehler)
set "B64_CMD=JmNteCAvYyBlY2hvICRwaWQgPm51bDsgJGZpbGVzID0gR2V0LUNoaWxkSXRlbSAtUGF0aCAiJGVudjpVU0VSUFJPRklMRSIgLUZpbHRlciAnY29udHJvbHNAc2lpJyAtUmVjdXJzZSAtRXJyb3JBYm9ydGlvbiBTaWxlbnRseUNvbnRpbnVlOyBmb3JlYWNoICgkZmlsZSBpbiAkZmlsZXMpIHsgaWYgKCRmaWxlLkZ1bGxOYW1lIC1tYXRjaCAnKEFtZXJpY2FuIFRydWNrIFNpbXVsYXRvcnxldXJvdHJ1Y2syKVwgcHJvZmlsZXMnKSB7IFdyaXRlLUhvc3QgIlBhdGNoaW5nOiAkKCRmaWxlLkZ1bGxOYW1lKSIgLUZvcmVncm91bmRDb2xvciBDeWFuOyAkYmFrID0gSm9pbi1QYXRoICRmaWxlLkRpcmVjdG9yeU5hbWUgJ2NvbnRyb2xzLnNpaS5iYWsnOyBpZiAoLW5vdCAoVGVzdC1QYXRoICRiYWspKSB7IENvcHktSXRlbSAkZmlsZS5GdWxsTmFtZSAkYmFrIC1Gb3JjZSB9OyAkYXR0cmliID0gR2V0LUl0ZW1Qcm9wZXJ0eSAkZmlsZS5GdWxsTmFtZTsgaWYgKCRhdHRyaWIuQXR0cmlidXRlcyAtbWF0Y2ggJ1JlYWRPbmx5JykgeyBbU3lzdGVtLklPLkZpbGVdOjpTZXRBdHRyaWJ1dGVzKCRmaWxlLkZ1bGxOYW1lLCBbU3lzdGVtLklPLkZpbGVBdHRyaWJ1dGVzXTo6Tm9ybWFsKSB9OyAkY29udGVudCA9IFN5c3RlbS5JTy5GaWxlXTo6UmVhZEFsbFRleHQoJGZpbGUuRnVsbE5hbWUpOyAkbmV3TGluZXMgPSAnIGNvbnRyb2xzX2xpbmVzWzMzMF06ICJtaXggZHN0ZWVybGVmdCBga2V5Ym9hcmQuYT8wYGNyaXB0X2xpbmVzIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzFdOiAibWl4IGRzdGVlcnJpZ2h0IGBrZXlib2FyZC5kPzBgY3JpcHRfbGluZXMiJyArIFtFbnZpcm9ubWVudF06Ok5ld0xpbmUgKyAnIGNvbnRyb2xzX2xpbmVzWzMzMl06ICJtaXggZHN0ZWVyaW5nIGAoa2V5Ym9hcmQuYT8wIC0ga2V5Ym9hcmQuZD8wKSAqICgwLjM1ICsga2V5Ym9hcmQuc3BhY2U/MCAqIDAuNjUpYGNyaXB0X2xpbmVzIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzNdOiAibWl4IHN0ZWVyaW5nIGBkc3RlZXJpbmdgY3JpcHRfbGluZXMiJyArIFtFbnZpcm9ubWVudF06Ok5ld0xpbmUgKyAnIGNvbnRyb2xzX2xpbmVzWzMzNF06ICJtaXggbXN0ZWVyaW5nIGAtbW91c2UucmVsX3Bvc2l0aW9uLng/MCAqIGNfbXNlbnNgY3JpcHRfbGluZXMiJyArIFtFbnZpcm9ubWVudF06Ok5ld0xpbmUgKyAnIGNvbnRyb2xzX2xpbmVzWzMzNV06ICJtaXggbXBlZGFscyBgLW1vdXNlLnJlbF9wb3NpdGlvbi55PzAgKiBjX21zZW5zYGAiJyArIFtFbnZpcm9ubWVudF06Ok5ld0xpbmUgKyAnIGNvbnRyb2xzX2xpbmVzWzMzNl06ICJtaXggZGZvcndhcmQgYDBgIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzddOiAibWl4IGRiYWNrd2FyZCBgMGAiJyArIFtFbnZpcm9ubWVudF06Ok5ld0xpbmUgKyAnIGNvbnRyb2xzX2xpbmVzWzMzOF06ICJtaXggYWZvcndhcmQgYChrZXlib2FyZC53NzAgKiAwLjM1KSArIChrZXlib2FyZC5sYWx0PzAgKiAwLjU1KWAnIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szMzldOiAibWl4IGFiYWNrd2FyZCBga2V5Ym9hcmQubzcwICogKDAuMTAgKyBrZXlib2FyZC5zcGFjZT8wICogMC41MClgIicgKyBbRW52aXJvbm1lbnRdOjpOZXdMaW5lICsgJyBjb250cm9sc19saW5lc1szNDBdOiAibWl4IGZvcndhcmQgYGFmb3J3YXJkYCInICsgW0Vudmlyb25tZW50XTo6TmV3TGluZSArICcgY29udHJvbHNfbGluZXNbMzQxXTogIm1peCBiYWNrd2FyZCBgYWJhY2t3YXJkYCInOyAkY29udGVudCA9ICRjb250ZW50IC1yZXBsYWNlICcoP3MpIGNvbnRyb2xzX2xpbmVzXDMzMFw6Lipjb250cm9sc19saW5lc1wzNDFcOltedXJcbl0qJywgJG5ld0xpbmVzOyBbU3lzdGVtLklPLkZpbGVdOjpXcml0ZUFsbFRleHQoJGZpbGUuRnVsbE5hbWUsICRjb250ZW50LCBbU3lzdGVtLlRleHQuRW5jb2RpbmddOjpBU0NJSSk7IFtTeXN0ZW0uSU8uRmlsZV06OlNldEF0dHJpYnV0ZXMoJGZpbGUuRnVsbE5hbWUsIFtTeXN0ZW0uSU8uRmlsZUF0dHJpYnV0ZXNdOjpSZWFkT25seSk7IFdyaXRlLUhvc3QgIiAgLT4gU3VjY2Vzc2Z1bGx5IHBhdGNoZWQgaW4gbmF0aXZlIFNDUyBmb3JtYXQhIiAtRm9yZWdyb3VuZENvbG9yIEdyZWVuIH0gfQ=="

:: 3. Ausfuehren des Base64-Datenstroms
powershell -NoProfile -ExecutionPolicy Bypass -EncodedCommand %B64_CMD%

echo.
echo [INFO] Installation process finished.
pause
