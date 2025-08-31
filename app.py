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