#!/bin/bash
read -p "🔍 Enter IP: " IP
if [ -z "$IP" ]; then
    echo -e "\e[1;32m❌ IP not entered, operation canceled.\e[0m"
    exit 1
fi
echo -e "\e[1;36m✅ R1Scanner Report for $IP\e[0m"
echo "------------------------------------"
echo -e "\e[1;5m[+] Ping\e[0m"
ping -c 4 $IP
echo -e "\e[1;5m[+] Netcat Port 443\e[0m"
nc -zv $IP 443
echo -e "\e[1;5m[+] Telnet Port 443\e[0m"
(echo quit | telnet $IP 443 2>&1) | head -n 10
echo -e "\e[1;5m[+] MTR (ICMP)\e[0m"
mtr -n --report-wide -c 10 $IP
echo -e "\e[1;5m[+] MTR (TCP Port 443)\e[0m"
mtr -P 443 -n --report-wide -c 10 $IP
echo -e "\e[1;5m[+] Nmap Port 443\e[0m"
nmap -p 443 $IP
echo -e "\e[1;5m[+] Curl Header\e[0m"
curl -I -m 10 https://$IP 2>/dev/null
echo -e "\e[1;5m[+] OpenSSL Certificate\e[0m"
echo | openssl s_client -connect $IP:443 -servername $IP 2>/dev/null | openssl x509 -noout -dates
echo -e "\e[1;32m✅ Report Completed\e[0m"
