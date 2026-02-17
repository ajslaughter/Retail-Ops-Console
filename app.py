import os
import subprocess
import json
import sys
from flask import Flask, send_file, jsonify

app = Flask(__name__)


def resource_path(relative_path):
    base_path = getattr(sys, "_MEIPASS", os.path.dirname(os.path.abspath(__file__)))
    return os.path.join(base_path, relative_path)


# Configuration
SCRIPTS_DIR = resource_path('scripts')
STATUS_FILE = 'status.json'


@app.route('/')
def index():
    return send_file(resource_path('dashboard.html'))


@app.route('/api/run-archive', methods=['POST'])
def run_archive():
    try:
        script_path = os.path.join(SCRIPTS_DIR, 'archive_sharepoint.ps1')
        result = subprocess.run(
            ["powershell.exe", "-File", script_path],
            capture_output=True,
            text=True
        )
        return jsonify({
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr
        })
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


@app.route('/api/run-cognos', methods=['POST'])
def run_cognos():
    try:
        script_path = os.path.join(SCRIPTS_DIR, 'trigger_cognos.py')
        result = subprocess.run(
            ["python", script_path],
            capture_output=True,
            text=True
        )
        return jsonify({
            "success": result.returncode == 0,
            "output": result.stdout,
            "error": result.stderr
        })
    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


@app.route('/api/status', methods=['GET'])
def get_status():
    try:
        if os.path.exists(STATUS_FILE):
            with open(STATUS_FILE, 'r') as f:
                data = json.load(f)
            return jsonify(data)
        return jsonify({"status": "Unknown", "details": "Status file not found"})
    except Exception as e:
        return jsonify({"status": "Error", "details": str(e)}), 500


if __name__ == '__main__':
    print("Starting Operations Automation Console server...")
    print("Dashboard available at http://localhost:5000")
    app.run(host='0.0.0.0', port=5000, debug=True)
