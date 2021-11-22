#!/bin/bash
# Modified sublist3r extension script that provides host lookup on subdomains post discovery
# Working on adding additional features


read -p "Enter hostname (Ex: google.com): " host

echo "[+] Running Sublist3r..."
sublist3r -d $host > sublist3r.txt

# Removes color formatting from Sublist3r output
echo "[+] Cleaning output..."
cat sublist3r.txt | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" > cleaned.txt

# grep for only the subdomains from the cleaned Sublist3r output 
grep -o "[^/]*.$host" cleaned.txt | sort | grep -wv 'Enumerating' > list.txt

# handles host lookup on the subdomains
echo "[+] Handling subdomain lookup..."
for domains in $(cat list.txt); do host $domains >> hostlookup.txt
done

# avoid duplicate entry output if the script is ran more than once...
cat hostlookup.txt | uniq -u > r.txt
cat r.txt | grep -wv "not found" | cut -d " " -f1,4 | sort -u > results.txt

echo "[+] Cleaning up directory..."
rm -rf cleaned.txt list.txt host.txt hostlookup.txt r.txt

echo "[+] Done!"
