# Operations Automation Console

A lightweight web console for running operations automations and monitoring service health from one place.

## What this project provides

- Centralized task execution for recurring operational scripts.
- Live status visibility for connected upstream systems.
- Structured runtime logging in the browser UI.
- Reference automations for content cleanup and report generation.

## Prerequisites

- Python 3.9+
- PowerShell 5.1+ (for the archive script)
- Google Chrome (for Selenium-driven report automation)

Optional dependency for SharePoint operations:

```powershell
Install-Module -Name PnP.PowerShell -Scope CurrentUser
```

## Quick start

```bash
git clone <your-repo-url>
cd <your-project-folder>
python -m venv venv
# Windows
.\venv\Scripts\activate
# macOS/Linux
source venv/bin/activate
pip install flask selenium
python app.py
```

Open:

- `http://localhost:5000`

Optional status refresh:

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

## Deployment and security notes

This tool executes host-level commands. Keep it behind trusted network boundaries and add authentication/authorization controls before broad deployment.

Recommended controls:

- Restrict network access (private subnet / VPN / internal gateway).
- Run with least-privileged service accounts.
- Centralize logs and audit script execution.
- Store secrets in environment variables or a secrets manager.

## Windows EXE distribution

For non-technical users, package the app as a Windows executable bundle.

See: [`docs/windows-exe.md`](docs/windows-exe.md)
