#!/bin/bash
# Color
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`

# Runtime
date=`date`

usage() { 
echo "Usage: $0 [-i <ip> OR -u <URL>] [-p <port>] [-t fuzz type <dir|file|quickfile>]"
echo -e "\n" 
echo "Manual Method Quick References"
echo "For ${blue}Directories${reset}"
echo "export URL=http://target-ip:port/FUZZ/"
echo "For ${blue}Files${reset}"
echo "export URL=http://target-ip:port/FUZZ"
echo -e "\n"
echo "${blue}Directories${reset}" 
echo 'wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404 "$URL"'
echo "${blue}Files${reset}"
echo 'wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 404 "$URL"'
echo "${blue}Quick File Hits${reset}"
echo 'wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/quickhits.txt --hc 404 --hh <char> "$URL"'
echo -e "\n"
echo "Additional Test Cases"
echo "${blue}Large Words${reset}"
echo 'wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-words.txt --hc 404 "$URL"'
echo "${blue}Fuzzing Usernames${reset}"
echo 'wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/top-usernames-shortlist.txt --hc 404,403 "$URL"'
1>&2; exit 1; 
}

while getopts ":u:i:p:t:" flag
do
    case "$flag" in
    	u) URL=${OPTARG};;
        i) ip=${OPTARG};;
        p) port=${OPTARG};;
        t) type=${OPTARG};;
        *) usage ;;
    esac
done

shift $((OPTIND-1))

# If type left blank, print usage
if [ -z "${type}" ]; then
	usage
fi

# If no port specified, default to port 80
if [ -z ${port} ]; then
	port=80
fi

# If no IP specified, default to localhost
if [ -z ${ip} ]; then
	ip=127.0.0.1
fi


####### Checking Fuzz Type ######
# If type dir then directory fuzz
if [ $type == 'dir' ]; then
	echo -e "\n"
	echo -e "${green}Running Directory Fuzz${reset} @ $date\n"
	if [ -z ${URL} ]; then
		URL=http://$ip:$port/FUZZ/
		wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404 "$URL"
	else
		wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-directories.txt --hc 404 "$URL"
	fi
fi

# If type file then file fuzz
if [ $type == 'file' ]; then
	echo -e "\n"
	echo -e "${green}Running File Fuzz${reset} @ $date\n"
	if [ -z ${URL} ]; then
		URL=http://$ip:$port/FUZZ
		wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 404 "$URL"
	else
		wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/raft-large-files.txt --hc 404 "$URL"
	fi
fi

# If type quickfile then quickhit fuzz
if [ $type == 'quickfile' ]; then
	echo -e "\n"
	echo -e "${green}Running Quickhits${reset} @ $date\n"
	if [ -z ${URL} ]; then
		URL=http://$ip:$port/FUZZ
		read -p "Enter Char Count (type 0 if unsure): " char
		wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/quickhits.txt --hc 404 --hh $char "$URL"
	else
		read -p "Enter Char Count (type 0 if unsure): " char
		wfuzz -c -z file,/usr/share/seclists/Discovery/Web-Content/quickhits.txt --hc 404 --hh $char "$URL"
	fi
fi
