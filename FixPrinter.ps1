# Requires - Run in elevated PowerShell

Write-Host ""
Write-Host "Stopping Print Spooler..."
Write-Host ""

Stop-Service -Name Spooler -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

Write-Host ""
Write-Host "Clearing spooler files..."
Write-Host ""

$spool = "$env:SystemRoot\System32\spool\PRINTERS"
if (Test-Path $spool) {
    Get-ChildItem -Path $spool -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "Starting Print Spooler and setting to Automatic..."
Write-Host ""

Set-Service -Name Spooler -StartupType Automatic
Start-Service -Name Spooler

Write-Host ""
Write-Host "Restarting Background Intelligent Transfer Service and DNS Client (if present)..."
Write-Host ""

Get-Service -Name BITS, Dnscache -ErrorAction SilentlyContinue | ForEach-Object { Restart-Service -InputObject $_ -ErrorAction SilentlyContinue }

Write-Host ""
Write-Host "Enabling Network Discovery & File and Printer Sharing firewall rules (if supported)..."
Write-Host ""

Try {
    Get-NetFirewallRule -DisplayGroup "Network Discovery" -ErrorAction Stop | Enable-NetFirewallRule -ErrorAction SilentlyContinue
    Get-NetFirewallRule -DisplayGroup "File and Printer Sharing" -ErrorAction Stop | Enable-NetFirewallRule -ErrorAction SilentlyContinue
} catch { }

Write-Host ""
Write-Host "If you want to add a network printer now, enter its IP. Otherwise press Enter to skip."
Write-Host ""

$printerIP = Read-Host "Printer IP (or Enter to skip)"
if ($printerIP -ne "") {

    Write-Host ""
    Write-Host "Pinging printer IP $printerIP ..."
    Write-Host ""

    $ping = Test-Connection -ComputerName $printerIP -Count 2 -Quiet
    if (-not $ping) {
        Write-Host "Printer IP not reachable. Check network/cables and try again."
        exit
    }

    $portName = "IP_$printerIP"
    Write-Host ""
    Write-Host "Creating TCP/IP port $portName ..."
    Write-Host ""

    if (-not (Get-PrinterPort -Name $portName -ErrorAction SilentlyContinue)) {
        Add-PrinterPort -Name $portName -PrinterHostAddress $printerIP
    } else {
        Write-Host "Port already exists."
    }

    Write-Host ""
    Write-Host "Provide the exact Driver Name installed on this PC for the printer (example: 'Canon Generic Plus UFR II')."
    Write-Host "If driver not installed, install the driver first and re-run this script."
    Write-Host ""

    $driverName = Read-Host "Driver Name (case-sensitive)"
    if ($driverName -eq "") {
        Write-Host "No driver name entered. Skipping Add-Printer step."
        exit
    }

    $printerName = Read-Host "Printer name to show in Windows (e.g., Office-Canon-F6600)"
    if ($printerName -eq "") { $printerName = "NetworkPrinter-$printerIP" }

    Write-Host ""
    Write-Host "Adding printer '$printerName' using driver '$driverName' on port '$portName'..."
    Write-Host ""

    try {
        Add-Printer -Name $printerName -DriverName $driverName -PortName $portName -ErrorAction Stop
        Write-Host "Printer added successfully."
    } catch {
        Write-Host "Failed to add printer. Error: $_.Exception.Message"
        Write-Host "Make sure the driver name is exact and that the driver is installed on this machine."
    }
}

Write-Host ""
Write-Host "Done. Please test printing."
Write-Host ""
