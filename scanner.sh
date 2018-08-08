#!/bin/bash
# Coded By : A_Asaker
mymac=$(ip link show wlan0 | awk '/ether/ {print $2}')
nmapres=$(sudo nmap -sP 192.168.1.0/24 )
ips=$(echo $nmapres | sed 's/ Nmap scan/\nNmap scan/g' | sed 's/ MAC Address/\nMAC Address/g' | sed 's/ Host is/\nHost is/g' | grep "Nmap scan" | cut -d " " -f 5)
macs=$(echo $nmapres | sed 's/ Nmap scan/\nNmap scan/g' | sed 's/ MAC Address:/\nMAC Address:/g' | sed 's/ Host is/\nHost is/g' | grep "MAC Address:" | cut -d " " -f 3)
char="192.168."
while :
do
	if [[ $ips == *$'\n'* ]]; then
	    ips=${ips/$'\n'/ }
	else
	    break
	fi
done
num=$(awk -F"${char}" '{print NF-1}' <<< "${ips}")
while :
do
	if [[ $macs == *$'\n'* ]]; then
	    macs=${macs/$'\n'/ }
	else
	    break
	fi
done

for i in `seq 1 $num`; do
	ip=$(echo $ips | cut -d " " -f "$i")
	mac=$(echo $macs | cut -d " " -f "$i")
	case $mac in
# 		mac)
# 			mac=$mac" (You MAC Device Name)"
# 			;;
# example:ff:ff:ff:ff:ff:ff)
# 			mac=$mac" (Device-1)"
# 			;;		
# 		fe:fe:fe:fe:fe:fe)
# 			mac=$mac" (Device-2)"
# 			;;				
		"")
			mac=$mymac" (Mine)"
			;;
		*)
			mac=$mac" (Unknown)"
  	esac
	echo "( $i ) IP : $ip || MAC Address : $mac "
done
