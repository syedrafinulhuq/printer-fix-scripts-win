---
## 📂 Repo Structure

```
printer-fix-scripts-win/
│
├── scripts/
│   ├── FixPrinter.bat
│   ├── FixPrinter.ps1
│   └── ManualCommands.txt
│
└── README.md
```

---

## 📄 README.md

````markdown
# 🖨️ Printer Fix Scripts

This repository provides **one-click and manual tools** to fix common Windows printer issues.

These scripts help when:
- Printer does not show up in **Printers & Scanners**
- Print jobs are **stuck in the queue**
- Windows shows **“Printer not found / offline”**
- Print Spooler crashes or stops working

---

## 📂 Files

All scripts are in the [`scripts/`](scripts/) folder:

### 1. FixPrinter.bat
- Type: Batch Script (`.bat`)
- Use: **Double-click fix**
- Features:
  - Stops Print Spooler
  - Clears stuck print jobs
  - Restarts Print Spooler
  - Launches Windows Printer Troubleshooter

👉 Recommended for everyday users.

---

### 2. FixPrinter.ps1
- Type: PowerShell Script (`.ps1`)
- Use: **Advanced fix**
- Features:
  - Does everything the `.bat` script does
  - Sets Print Spooler startup to **Automatic**
  - Restarts related services (BITS, DNS Cache)
  - Enables **Network Discovery** & **Printer Sharing**
  - Optionally: Add a **network printer by IP** (requires driver installed)

👉 Recommended for IT admins / advanced users.

---

### 3. ManualCommands.txt
- Type: Text file
- Use: **Run commands manually in Command Prompt**
- Contains:
  ```cmd
  net stop spooler

  rd /s /q "%systemroot%\System32\spool\PRINTERS"

  net start spooler
````

and

```cmd
msdt.exe /id PrinterDiagnostic
```

👉 Recommended for quick copy-paste troubleshooting.

---

## ⚡ How to Use

### A) Quick Fix (FixPrinter.bat)

1. Download the repo

   ```bash
   git clone https://github.com/YOUR-USERNAME/printer-fix-scripts.git
   ```

   or [Download ZIP](../../archive/refs/heads/main.zip)
2. Extract the files
3. Go to the `scripts` folder
4. Right-click **FixPrinter.bat** → **Run as administrator**

---

### B) Advanced Fix (FixPrinter.ps1)

1. Open **PowerShell as Administrator**
2. Navigate to the folder:

   ```powershell
   cd C:\path\to\printer-fix-scripts\scripts
   ```
3. Run:

   ```powershell
   .\FixPrinter.ps1
   ```
4. Follow prompts (optional printer IP + driver name for network printers)

---

### C) Manual Commands

1. Open **Command Prompt (Admin)**
2. Copy commands from `ManualCommands.txt`
3. Run them one by one

---

## 🔒 Notes

* Always **run as Administrator**
* Works on **Windows 10 and Windows 11**
* If network printer setup fails, ensure:

  * Printer is online and reachable via IP
  * Drivers are already installed
  * PC and printer are on the same network
* Still not working? → Install latest drivers from the manufacturer

---

## 🛠️ Example Run

```
=== Restarting Print Spooler and clearing old print jobs ===

The Print Spooler service was stopped successfully.
The Print Spooler service was started successfully.

=== Launching Windows Printer Troubleshooter ===
```

---

## 🤝 Contributions

Pull requests welcome!
You can extend this repo with scripts for other tech-support fixes (Wi-Fi, updates, etc.).

---

```
---

```
