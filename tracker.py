#!/data/data/com.termux/files/usr/bin/python3
# VERAN IP TRACKER v3.0 - PYTHON EDITION
import os
from flask import Flask, request
from datetime import datetime

app = Flask(__name__)
PORT = 8080
SECRET = "veran123"  # Change this!

print(r"""
 __   __  _______  __    _  ___   _______ 
|  |_|  ||       ||  |  | ||   | |       |
|       ||   _   ||   |_| ||   | |  _____|
|       ||  | |  ||       ||   | | |_____ 
|       ||  |_|  ||  _    ||   | |_____  |
| ||_|| ||       || | |   ||   |  _____| |
|_|   |_||_______||_|  |__||___| |_______|
""")

print(f"[+] Python IP Tracker Ready")
print(f"[+] Tracking URL: http://YOUR-IP:{PORT}/{SECRET}/any-id")
print(f"[+] View Data: cat ips.txt\n")

@app.route(f'/{SECRET}/<id>')
def track(id):
    ip = request.headers.get('X-Forwarded-For', request.remote_addr)
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    log = {
        'id': id,
        'ip': ip,
        'time': timestamp,
        'user_agent': request.user_agent.string,
    }
    
    with open('ips.txt', 'a') as f:
        f.write(f"{log}\n")
    
    print(f"[+] {timestamp} - {ip} ({id})")
    return "Loading..."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=PORT)
