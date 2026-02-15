# Operations Automation Console

A lightweight web console for running operations automations and monitoring service health from one place. The project ships with example integrations for SharePoint maintenance and Cognos report execution, and can be adapted to other internal workflows.

## What this project provides

- **Centralized task execution** for recurring operational scripts.
- **Live status visibility** for connected upstream systems.
- **Structured runtime logging** in the browser UI.
- **Reference automations** for SharePoint cleanup and report generation.

## Typical use cases

- Scheduled or ad-hoc cleanup of aging records.
- Triggering report jobs without opening multiple tools.
- Capturing operational output for handoff and incident notes.

## Prerequisites

- Python 3.9+
- PowerShell 5.1+ (for the SharePoint script)
- Google Chrome (for Selenium-driven report automation)

Optional dependency for SharePoint operations:

```powershell
Install-Module -Name PnP.PowerShell -Scope CurrentUser
```

## Installation

```bash
git clone <your-repo-url>
cd <your-project-folder>
python -m venv venv
# Windows
.\venv\Scripts\activate
# macOS/Linux
source venv/bin/activate
pip install flask selenium
```

## Running locally

Start the web application:

```bash
python app.py
```

Open the UI at:

- `http://localhost:5000`

Optional: refresh status data manually:

```bash
python check_health.py
```

## Configuration

Update these files for your environment:

- `scripts/archive_sharepoint.ps1`
  - Site URL
  - List name
  - Backup/export directory
- `scripts/trigger_cognos.py`
  - Portal URL
  - Report name
  - Download directory

## Security and deployment guidance

This tool executes host-level commands. Keep it behind trusted network boundaries and add authentication/authorization controls before broader deployment.

Recommended controls for enterprise environments:

- Restrict network access (private subnet / VPN / internal gateway).
- Run with least-privileged service accounts.
- Centralize logs and audit script execution.
- Store secrets in environment variables or a secrets manager (not source files).

## Windows executable distribution (recommended for non-technical users)

Short answer: **yes**—packaging this as a Windows executable is a good way to reduce local setup friction.

Trade-offs to be aware of:

- You still need to distribute updates when scripts or config change.
- Endpoint controls (AV/AppLocker) may require code signing or allowlisting.
- Secrets should remain external (environment variables or secure store), not embedded in the executable.

Build a Windows executable with PyInstaller:

```powershell
# from repo root
python -m pip install --upgrade pip pyinstaller
pyinstaller --noconfirm --clean --onedir --name OpsAutomationConsole `
  --add-data "dashboard.html;." `
  --add-data "scripts;scripts" `
  app.py
```

Output:

- Executable bundle: `dist/OpsAutomationConsole/`
- Launch file: `dist/OpsAutomationConsole/OpsAutomationConsole.exe`

For convenience, this repo includes `scripts/build_windows_exe.ps1`.
