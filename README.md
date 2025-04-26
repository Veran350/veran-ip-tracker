# 🚀 VERAN IP Tracker  

## 💻 **Run in Termux**  
```bash
# 1. Install requirements
pkg update && pkg install nodejs git -y

# 2. Clone & run (replace YOUR-USERNAME)
git clone https://github.com/YOUR-USERNAME/veran-ip-tracker.git
cd veran-ip-tracker
npm install express geoip-lite
node tracker.js
