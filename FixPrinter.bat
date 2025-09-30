@echo off

echo.
echo === Restarting Print Spooler and clearing old print jobs ===
echo.

net stop spooler

rd /s /q "%systemroot%\System32\spool\PRINTERS"

net start spooler

echo.
echo === Launching Windows Printer Troubleshooter ===
echo.

msdt.exe /id PrinterDiagnostic

echo.
echo Done. Close this window when finished.
pause
