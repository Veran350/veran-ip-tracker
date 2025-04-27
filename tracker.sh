#!/data/data/com.termux/files/usr/bin/bash
# VERAN IP TRACKER v7.0 - CLICKABLE LINKS EDITION

# INSTALL DEPENDENCIES
pkg update -y && pkg install -y socat curl jq

# CONFIG
PORT=8080
SECRET="happy"  # Change this if needed
LOG_FILE="ips.log"
PUBLIC_IP=$(curl -s ifconfig.me)

# COLORS
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

# CREATE LOG FILE
touch $LOG_FILE

show_banner() {
  clear
  echo -e "${RED}
  ██▒   █▓ ██▓ ██▀███   ▄████  ██▀███  ▓█████ 
 ▓██░   █▒▓██▒▓██ ▒ ██▒▒██▒  ██▒▓██ ▒ ██▒▓█   ▀ 
  ▓██  █▒░▒██▒▓██ ░▄█ ▒▒██░  ██▒▓██ ░▄█ ▒▒███   
   ▒██ █░░░██░▒██▀▀█▄  ▒██   ██░▒██▀▀█▄  ▒▓█  ▄ 
    ▒▀█░  ░██░░██▓ ▒██▒░ ████▓▒░░██▓ ▒██▒░▒████▒
    ░ ▐░  ░▓  ░ ▒▓ ░▒▓░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░░░ ▒░ ░
    ░ ░░   ▒ ░  ░▒ ░ ▒░  ░ ▒ ▒░   ░▒ ░ ▒░ ░ ░  ░
      ░░   ▒ ░  ░░   ░ ░ ░ ░ ▒    ░░   ░    ░   
       ░   ░     ░         ░ ░     ░        ░  ░
${NC}"
}

start_tracker() {
  TRACKING_ID=$(date +%s)
  TRACKING_URL="http://${PUBLIC_IP}:${PORT}/${SECRET}/${TRACKING_ID}"
  
  echo -e "\n${GREEN}[+] TRACKING URL (CLICKABLE):${NC}"
  echo -e "${CYAN}${TRACKING_URL}${NC}"
  echo -e "\n${YELLOW}Waiting for connections...${NC}"
  
  socat TCP-LISTEN:$PORT,reuseaddr,fork SYSTEM:"
    echo -e \"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r
    <html><body style='background:#000;color:#0f0;font-family:monospace'>
    <h1>Loading...</h1>
    <meta http-equiv=\"refresh\" content=\"0;url=about:blank\">
    </body></html>\";
    
    IP=\$(echo \$SOCAT_PEERADDR | cut -d':' -f4);
    UA=\$(echo \"\$SOCAT_PEERINFO\" | grep 'User-Agent:' | sed 's/User-Agent: //');
    GEO=\$(curl -s \"https://ipapi.co/\${IP}/json/\");
    echo \"\$(date '+%Y-%m-%d %H:%M:%S') | \${IP} | \${UA} | \${TRACKING_ID}\" >> $LOG_FILE;
  "
}

show_menu() {
  while true; do
    echo -e "\n${RED}VERAN IP TRACKER MENU${NC}"
    echo -e "${GREEN}1. Generate Tracking Link"
    echo -e "2. View Captured IPs"
    echo -e "3. Exit${NC}"
    
    read -p $'\n'"Select option (1-3): " choice
    
    case $choice in
      1) start_tracker ;;
      2) cat $LOG_FILE ;;
      3) exit 0 ;;
      *) echo -e "${RED}Invalid option!${NC}" ;;
    esac
  done
}

# MAIN
show_banner
show_menu
