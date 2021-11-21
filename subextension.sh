#!/bin/bash
# Custom sublist3r extension script that provides an nslookup on subdomains post discovery
# Working on adding additional features


read -p "Enter hostname: " host

echo "[+] Running Sublist3r..."
sublist3r -d $host > sublist3r.txt

echo "[+] Cleaning output..."
cat sublist3r.txt | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" > cleaned.txt

cat cleaned.txt | cut -d'.' -f2,3 | tail -n 1 > host.txt

hostname=$(cat host.txt)

grep -o "[^/]*.$hostname" cleaned.txt | sort | grep -wv 'Enumerating' > list.txt

echo "[+] Handling subdomain lookup..."
for domains in $(cat list.txt); do nslookup $domains >> nslookup.txt
done

# avoid duplicate entry output if the script is ran more than once...
cat nslookup.txt | uniq -u > results.txt

echo "[+] Cleaning up directory..."
rm -rf cleaned.txt list.txt host.txt nslookup.txt


echo "[+] Done!"