param(
    [string]$AppName = "OpsAutomationConsole"
)

$ErrorActionPreference = "Stop"

Write-Host "Installing build dependencies..." -ForegroundColor Cyan
python -m pip install --upgrade pip pyinstaller

Write-Host "Building Windows executable bundle..." -ForegroundColor Cyan
pyinstaller --noconfirm --clean --onedir --name $AppName `
  --add-data "dashboard.html;." `
  --add-data "scripts;scripts" `
  app.py

Write-Host "Build complete. Output: dist/$AppName" -ForegroundColor Green
