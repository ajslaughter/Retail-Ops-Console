# Windows EXE Packaging Guide

This project can be distributed to end users as a Windows executable bundle to reduce local Python setup overhead.

## Recommendation

Use a **PyInstaller `--onedir` build** for better runtime compatibility and simpler troubleshooting.

## Trade-offs

- You must redistribute builds when app code or scripts change.
- Corporate endpoint controls (Defender/AppLocker) may block unsigned binaries.
- Keep credentials/secrets external (environment variables or secret store), not bundled.

## Build command

```powershell
# from repository root
python -m pip install --upgrade pip pyinstaller
pyinstaller --noconfirm --clean --onedir --name OpsAutomationConsole `
  --add-data "dashboard.html;." `
  --add-data "scripts;scripts" `
  app.py
```

## Output

- Bundle directory: `dist/OpsAutomationConsole/`
- Executable: `dist/OpsAutomationConsole/OpsAutomationConsole.exe`

## Scripted build

You can run:

```powershell
./scripts/build_windows_exe.ps1
```

This script installs/updates PyInstaller and builds the same `--onedir` output.
