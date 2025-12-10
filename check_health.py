import json
import time
import platform
import subprocess

STATUS_FILE = 'status.json'
TARGET_HOST = "8.8.8.8" # Google DNS as a connectivity proxy

def ping(host):
    """
    Returns True if host (str) responds to a ping request.
    Remember that a host may not respond to a ping (ICMP) request even if the host name is valid.
    """
    param = '-n' if platform.system().lower() == 'windows' else '-c'
    command = ['ping', param, '1', host]
    
    try:
        return subprocess.call(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL) == 0
    except Exception:
        return False

def check_health():
    print(f"Checking connectivity to {TARGET_HOST}...")
    is_up = ping(TARGET_HOST)
    
    status_data = {
        "sharepoint_status": "Active" if is_up else "Unreachable", # Proxying SP status with general internet
        "report_server_status": "Idle" if is_up else "Down",       # Mock logic
        "last_checked": time.strftime("%Y-%m-%d %H:%M:%S")
    }
    
    with open(STATUS_FILE, 'w') as f:
        json.dump(status_data, f, indent=4)
        
    print(f"Status updated: {status_data}")

if __name__ == "__main__":
    # In a real service, this might loop or be triggered by cron/Task Scheduler
    # For demo, we'll run it once.
    check_health()
