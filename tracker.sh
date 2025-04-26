#!/data/data/com.termux/files/usr/bin/bash
# VERAN IP TRACKER v5.0 - ULTIMATE EDITION

# INSTALL MISSING TOOLS
if ! command -v socat &> /dev/null; then
    echo "Installing socat..."
    pkg install -y socat
fi

if ! command -v curl &> /dev/null; then
    echo "Installing curl..."
    pkg install -y curl
fi

clear
echo -e "\e[1;31m
 ██▒   █▓ ██▓ ██▀███   ▄████  ██▀███  ▓█████ 
▓██░   █▒▓██▒▓██ ▒ ██▒▒██▒  ██▒▓██ ▒ ██▒▓█   ▀ 
 ▓██  █▒░▒██▒▓██ ░▄█ ▒▒██░  ██▒▓██ ░▄█ ▒▒███   
  ▒██ █░░░██░▒██▀▀█▄  ▒██   ██░▒██▀▀█▄  ▒▓█  ▄ 
   ▒▀█░  ░██░░██▓ ▒██▒░ ████▓▒░░██▓ ▒██▒░▒████▒
   ░ ▐░  ░▓  ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░░ ▒░ ░
   ░ ░░   ▒ ░  ░▒ ░ ▒░  ░ ▒ ▒░   ░▒ ░ ▒░ ░ ░  ░
     ░░   ▒ ░  ░░   ░ ░ ░ ░ ▒    ░░   ░    ░   
      ░   ░     ░         ░ ░     ░        ░  ░
\e[0m"

# CONFIG
PORT=8080
SECRET="veran123"  # CHANGE THIS!

# CREATE LOG FILE IF NOT EXISTS
touch ips.log

echo -e "\e[1;32m[+] Starting VERAN Tracker on port ${PORT}\e[0m"
echo -e "\e[1;36m[+] Tracking URL: http://$(curl -s ifconfig.me):${PORT}/${SECRET}/any-id\e[0m"
echo -e "\e[1;33m[+] View logs: tail -f ips.log\e[0m\n"

while true; do
  {
    echo -e "HTTP/1.1 200 OK\r\nContent-Length: 9\r\n\r\nLoading..."
    IP=$(echo $SOCAT_PEERADDR | cut -d':' -f4)
    UA=$(grep -m 1 'User-Agent:' | sed 's/User-Agent: //')
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # GET GEOLOCATION
    GEO=$(curl -s "https://ipapi.co/${IP}/json/")
    COUNTRY=$(echo "$GEO" | grep '"country_name":' | cut -d'"' -f4)
    CITY=$(echo "$GEO" | grep '"city":' | cut -d'"' -f4)
    
    # LOG EVERYTHING
    echo "${TIMESTAMP} | ${IP} | ${UA} | ${CITY}, ${COUNTRY}" >> ips.log
    echo -e "\e[1;35m[+] ${TIMESTAMP} - ${IP} from ${CITY}, ${COUNTRY}\e[0m"
  } | socat -d -d -lf /dev/null TCP-LISTEN:${PORT},reuseaddr,fork -
done
