#!/bin/bash
set -euo pipefail

read -p "Interface: " iface

if nmcli -t -f DEVICE connection show | grep -wq -- "$iface"; then
    conn=$(nmcli -t -f NAME,DEVICE con show | grep ":$iface" | cut -d':' -f1)

    if [[ -z "$conn" ]]; then
        echo "No connection found for interface: $iface"
        exit 1
    fi

    echo "Disabling IPv4 and IPv6 on connection: $conn"

    nmcli con modify "$conn" ipv4.method disabled
    nmcli con modify "$conn" ipv6.method disabled

    echo "IPv4 and IPv6 disabled on $conn"
else
    echo "Interface '$iface' does not exist. Aborting..."
    exit 1
fi
