#!/bin/bash
if [[ $# -eq 0 ]]; then
    echo "Error: not enough args"
    echo "Usage: ./autohack.sh <domain>"
    exit 1
fi

if [ `id -u` -ne 0 ]; then
    echo "!!! This script requires root privileges for certain sections !!!"
    echo "Please provide your password below or Ctrl+C to cancel."
    exec sudo "$0" "$@"
    exit 0
fi

echo "[+] Enumerating subdomains of $1"
sublist3r -d $1 -o $PWD/$1.subdomains.txt &> /dev/null
endpoints=`wc -l < $PWD/$1.subdomains.txt`
echo "[!] Found $endpoints subdomains"
echo "[+] Beginning nmap scans"
scanned=0
while read -r line; do
    echo "[*] Scanning $line ($scanned/$endpoints)"
    sudo nmap -v -sV -sC -O -T4 -n -oX $PWD/$line.nmap.xml $line &> /dev/null
    if [ $? -eq 0 ]; then
        scanned=$(($scanned + 1))
    fi
    echo -e -n "\r\033[1A\033[0K"
done < $PWD/$1.subdomains.txt
echo "[!] Scanned $scanned endpoints successfully"
echo "[+] Beginning searchsploit for each endpoint"
mkdir $PWD/autohack.results.$1
for file in $PWD/*.nmap.xml; do
    filename=`basename $file`
    searchsploit --nmap $PWD/$filename -j > $PWD/autohack.results.$1/$filename.searchsploit.json
done
sudo rm -rf $PWD/*.subdomains.txt $PWD/*.nmap.xml
echo "[!] Finished scanning. You can find results at $PWD/autohack.results.$1"
