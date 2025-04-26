#!/data/data/com.termux/files/usr/bin/bash  
# VERAN IP TRACKER v4.0 - BASH EDITION  

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
SECRET="happy"  # CHANGE THIS!  

echo -e "\e[1;32m[+] Starting VERAN Tracker on port ${PORT}\e[0m"  
echo -e "\e[1;36m[+] Tracking URL: http://$(curl -s ifconfig.me):${PORT}/${SECRET}/any-id\e[0m"  
echo -e "\e[1;33m[+] Logs: tail -f ips.log\e[0m\n"  

while true; do  
  {  
    echo -e "HTTP/1.1 200 OK\r\nContent-Length: 9\r\n\r\nLoading..."  
    IP=$(echo $SOCAT_PEERADDR | cut -d':' -f4)  
    UA=$(grep -m 1 'User-Agent:' | sed 's/User-Agent: //')  
    echo "$(date '+%Y-%m-%d %H:%M:%S') | ${IP} | ${UA}" >> ips.log  
    echo -e "\e[1;35m[+] ${IP} connected!\e[0m"  
  } | socat -d -d -lf /dev/null TCP-LISTEN:${PORT},reuseaddr,fork -  
done  
