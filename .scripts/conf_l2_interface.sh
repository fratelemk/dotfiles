#!/bin/bash

prompt() {
	read -p "$1" input
	echo "$input"
}

conn=$(prompt "Connection: ")
if ! nmcli -t -f NAME con show | grep -w $conn &> /dev/null; then
    echo Connection $conn does not exist. Aborting...
    exit 1
fi

addr=$(prompt "IPv4 Address (CIDR): ")

nmcli con modify $conn ipv4.method manual
nmcli con modify $conn ipv6.method disabled

nmcli con modify $conn ipv4.never-default yes

nmcli con modify $conn ipv4.addresses $addr

nmcli	con down $conn && nmcli	con up $conn

