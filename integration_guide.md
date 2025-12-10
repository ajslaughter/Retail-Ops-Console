# Integration Guide: Connecting the Console to the Scripts

This guide explains how to bridge the gap between your "Pretty Button" (HTML/JS) and the "Ugly Script" (PowerShell/Python) running on your local machine.

## The Problem
Standard HTML running in a browser cannot execute local files or commands for security reasons. You cannot just `<a href="file:///script.ps1">Run</a>`.

## The Solution: Electron or Node.js Wrapper
To make this work, we need a "middleman" that has permission to talk to the Operating System.

### Option A: Electron (Recommended for a standalone App)
Electron wraps your HTML in a specialized browser window that *does* have access to Node.js, allowing you to run OS commands.

#### 1. Structure
- **Renderer Process**: Your `dashboard.html`. It sends a message ("Hey, run the script!") to the Main Process.
- **Main Process**: A `main.js` file running in the background. It listens for the message, executes the PowerShell script, and sends the output back.

#### 2. Implementation Steps
1.  **Initialize Project**: `npm init -y`
2.  **Install Electron**: `npm install electron --save-dev`
3.  **Create `main.js`**:

```javascript
const { app, BrowserWindow, ipcMain } = require('electron');
const { spawn } = require('child_process');
const path = require('path');

function createWindow () {
  const win = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false // Note: For production, use preload scripts for better security
    }
  });
  win.loadFile('dashboard.html');
}

app.whenReady().then(createWindow);

// Listen for the 'run-script' event from dashboard.html
ipcMain.on('run-script', (event, scriptType) => {
  let command, args;

  if (scriptType === 'Archive SharePoint') {
    command = 'powershell.exe';
    args = ['-File', path.join(__dirname, 'scripts/archive_sharepoint.ps1')];
  } else if (scriptType === 'Cognos Burst') {
    command = 'python';
    args = [path.join(__dirname, 'scripts/trigger_cognos.py')];
  }

  const child = spawn(command, args);

  child.stdout.on('data', (data) => {
    // Send logs back to the UI
    event.reply('script-log', data.toString());
  });

  child.stderr.on('data', (data) => {
    event.reply('script-error', data.toString());
  });
});
```

4.  **Update `dashboard.html`**:
    Add this to your script section to send the event:
```javascript
const { ipcRenderer } = require('electron');

function runTask(taskName) {
    ipcRenderer.send('run-script', taskName);
}

ipcRenderer.on('script-log', (event, message) => {
    log(message, 'info');
});
```

### Option B: Simple Node.js Server (If you want to keep using Chrome)
If you don't want to build a full app, you can run a tiny local web server that listens for requests.

1.  **Create `server.js`** using Express.
2.  **Endpoint**: Create a route like `/api/run-script`.
3.  **Dashboard**: Change your buttons to `fetch('http://localhost:3000/api/run-script')`.

## Security Note
This "Command Center" pattern gives a web page full control over your computer. **NEVER** host this on a public web server. Keep it strictly local or within a secured corporate intranet with proper authentication.
