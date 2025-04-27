import os
from flask import Flask, request, redirect
from datetime import datetime
import secrets

app = Flask(__name__)

# CONFIG
PORT = 8080
SECRET = "veran"  # Change this!
BASE_URL = "http://localhost"  # No IP needed!

# Generate random tracking IDs
def generate_id():
    return secrets.token_urlsafe(8)

print(f"""
\033[1;31m
 ██▒   █▓ ██▓ ██▀███   ▄████  ██▀███  ▓█████ 
▓██░   █▒▓██▒▓██ ▒ ██▒▒██▒  ██▒▓██ ▒ ██▒▓█   ▀ 
 ▓██  █▒░▒██▒▓██ ░▄█ ▒▒██░  ██▒▓██ ░▄█ ▒▒███   
  ▒██ █░░░██░▒██▀▀█▄  ▒██   ██░▒██▀▀█▄  ▒▓█  ▄ 
   ▒▀█░  ░██░░██▓ ▒██▒░ ████▓▒░░██▓ ▒██▒░▒████▒
   ░ ▐░  ░▓  ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░░ ▒░ ░
   ░ ░░   ▒ ░  ░▒ ░ ▒░  ░ ▒ ▒░   ░▒ ░ ▒░ ░ ░  ░
     ░░   ▒ ░  ░░   ░ ░ ░ ░ ▒    ░░   ░    ░   
      ░   ░     ░         ░ ░     ░        ░  ░
\033[0m
""")

@app.route(f'/{SECRET}/<id>')
def track(id):
    ip = request.remote_addr
    ua = request.user_agent.string
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Save to log file
    with open("ips.log", "a") as f:
        f.write(f"{now} | {id} | {ip} | {ua[:50]}\n")

    print(f"\033[1;32m[+] {now} - {id} - {ip}\033[0m")
    return redirect("about:blank", code=302)

@app.route('/generate')
def generate():
    track_id = generate_id()
    return {
        "tracking_url": f"{BASE_URL}:{PORT}/{SECRET}/{track_id}",
        "tracking_id": track_id
    }

if __name__ == '__main__':
    print("\033[1;36m[+] Use these commands:\033[0m")
    print("\033[1;33mcurl http://localhost:8080/generate \033[0m- Creates new tracking link")
    print("\033[1;33mcat ips.log \033[0m- View captured data")
    print("\033[1;33mngrok http {PORT} \033[0m- Make public (optional)\n")
    app.run(host='0.0.0.0', port=PORT)
