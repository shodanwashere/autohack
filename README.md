# autohack
Shodan's Autonomous Hack Platform. This script is run against a domain and returns a directory with a list of files pertaining to each of that domain's discoverable subdomains. They will contain entries for possible exploits to try against those endpoints, pointing to different vulnerabilities.

## Requirements
This script was specifically written to run on Kali Linux due to ease of use, but you can run it on any distro you want. Packages `sublist3r`, `nmap` and `searchsploit` are required.

## Usage
```
$ chmod +x autohack.sh
$ ./autohack.sh <domain>
```

## Explanation
The script is very straightforward, and its execution is divided into 3 parts:

1. `sublist3r` will enumerate all subdomains discoverable by popular search engines related to the specified domain.
2. Then, `nmap` will scan for open ports and vulnerable services on all of those subdomains.
3. Finally, `searchsploit` will examine the `nmap` scan results and try to find exploits related to vulnerable services on those endpoints.

This isn't a fits-all solution, nor does it automatically hack targets, if you think that's what the name implies. The objective is to discover possible points of entry. It's on you to figure out the rest.
