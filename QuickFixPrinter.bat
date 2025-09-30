@echo off

REM — Run as admin check
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This script must be run as Administrator.
    pause
    exit /b 1
)

echo.
echo Restarting Print Spooler service...
echo.

net stop spooler
timeout /t 2 /nobreak >nul

echo.
echo Clearing spooler files...
echo.

rd /s /q "%systemroot%\System32\spool\PRINTERS" 2>nul
md "%systemroot%\System32\spool\PRINTERS" 2>nul

echo.
echo Starting Print Spooler service...
echo.

net start spooler
timeout /t 2 /nobreak >nul

echo.
echo Restarting related services (BCD, PlugPlay)...
echo.

sc stop BITS 2>nul
sc start BITS 2>nul
sc stop Dnscache 2>nul
sc start Dnscache 2>nul

echo.
echo Enabling Network Discovery and File & Printer Sharing (requires admin)...
echo.

powershell -Command "Set-NetFirewallRule -DisplayGroup 'Network Discovery' -Enabled True -ErrorAction SilentlyContinue; Set-NetFirewallRule -DisplayGroup 'File and Printer Sharing' -Enabled True -ErrorAction SilentlyContinue"

echo.
echo Launching Windows built-in printer troubleshooter...
echo.

msdt.exe /id PrinterDiagnostic

echo.
echo Done. Please try printing or re-detecting the printer from Settings -> Printers & scanners.
echo.
pause
