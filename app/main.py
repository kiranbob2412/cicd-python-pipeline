import os
import threading
import time
from flask import Flask, jsonify

app = Flask(__name__)

APP_ENV = os.getenv("APP_ENV", "development")

def add(a, b):
    return a + b

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "environment": APP_ENV
    })

def start_server():
    app.run(host="0.0.0.0", port=8080)

if __name__ == "__main__":
    print("CI/CD Pipeline Application Running", flush=True)
    print("Environment:", APP_ENV, flush=True)
    print("2 + 3 =", add(2, 3), flush=True)

    server = threading.Thread(target=start_server, daemon=True)
    server.start()

    while True:
        time.sleep(30)
