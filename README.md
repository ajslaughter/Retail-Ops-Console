# Retail Operations Command Center

A centralized, sci-fi themed dashboard for automating Retail System Specialist tasks. This tool combines a modern web UI with powerful local automation scripts for SharePoint cleanup and Cognos reporting.

## Features

- **Unified Dashboard**: Single-pane-of-glass for monitoring and actions.
- **Real-Time Status**: Live health checks for SharePoint and Report Servers.
- **SharePoint Automation**: One-click archiving and cleanup of old list items.
- **Cognos Automation**: Headless browser automation for generating and downloading reports.
- **Persistent Sessions**: Smart authentication handling to minimize login prompts.

## Prerequisites

Before setting up, ensure you have the following installed:

1.  **Python 3.x**: [Download Python](https://www.python.org/downloads/)
2.  **Google Chrome**: Required for the Selenium automation script.
3.  **PowerShell 5.1+**: Pre-installed on most Windows systems.
4.  **SharePoint PnP PowerShell**:
    ```powershell
    Install-Module -Name PnP.PowerShell -Scope CurrentUser
    ```

## Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/ajslaughter/Retail-Ops-Console.git
    cd Retail-Ops-Console
    ```

2.  **Create a Virtual Environment** (Recommended):
    ```bash
    python -m venv venv
    .\venv\Scripts\activate
    ```

3.  **Install Python Dependencies**:
    ```bash
    pip install flask selenium
    ```

## Usage

1.  **Start the Server**:
    Run the Flask application to start the backend engine.
    ```bash
    python app.py
    ```
    *You should see output indicating the server is running on http://0.0.0.0:5000*

2.  **Access the Dashboard**:
    Open your web browser and navigate to:
    [http://localhost:5000](http://localhost:5000)

3.  **Check System Health**:
    To manually trigger a status update (or schedule this via Task Scheduler):
    ```bash
    python check_health.py
    ```
    *The dashboard status dots will update automatically within 5 seconds.*

## Configuration

- **SharePoint**: Edit `scripts/archive_sharepoint.ps1` to set your specific Site URL and List Name.
- **Cognos**: Edit `scripts/trigger_cognos.py` to set your Portal URL and Report Name.
- **Chrome Profile**: The first time you run the Cognos script, you may need to log in manually. The script uses a local `chrome_profile` folder to remember your session for future runs.

## Security Note

This application is designed for **local use** or within a secured corporate intranet. It executes shell commands on the host machine. Do not expose this server to the public internet.
