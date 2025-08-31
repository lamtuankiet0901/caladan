#!/bin/bash
apt-get update
apt-get install -y python3 python3-pip python3-flask

# Create a directory for the Flask app
mkdir /home/ubuntu/myflaskapp
cd /home/ubuntu/myflaskapp

# Create the app.py file from a variable
sudo cat <<EOF > app.py
from flask import Flask
import subprocess
import threading
import time

app = Flask(__name__)
latency = "Not measured yet"

def measure_latency():
    global latency
    while True:
        try:
            # Ping Server2's private IP
            result = subprocess.run(
                ["ping", "-c", "1", "${server2_private_ip}"],
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                latency = result.stdout.split("time=")[-1].split(" ")[0]
            else:
                latency = "Timeout"
        except Exception as e:
            latency = f"Error: {str(e)}"
        time.sleep(10)

@app.route('/metrics')
def metrics():
    return f'network_latency_ms {latency}\n'

if __name__ == '__main__':
    thread = threading.Thread(target=measure_latency)
    thread.daemon = True
    thread.start()
    app.run(host='0.0.0.0', port=80)
EOF

# Start Flask app
sudo python3 app.py