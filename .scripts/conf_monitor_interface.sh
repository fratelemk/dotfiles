#!/bin/bash

read -p "Interface: " iface

if nmcli -t -f DEVICE connection show | grep -w $iface &> /dev/null; then
    conn=$(nmcli -t -f NAME,DEVICE con show | grep ":$iface" | cut -d':' -f1)
    nmcli con modify $conn ipv4.method disabled
    nmcli con modify $conn ipv6.method disabled
else
    echo Interface $iface does not exist. Aborting...
    exit 1
fi



