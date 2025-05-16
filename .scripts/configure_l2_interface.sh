#!/bin/bash
set -euo pipefail

# Prompt function
prompt() {
    read -rp "$1" input
    echo "$input"
}

# Prompt for connection name
conn=$(prompt "Connection: ")

# Check if the connection exists
if ! nmcli -t -f NAME con show | grep -Fxq -- "$conn"; then
    echo "Connection '$conn' does not exist. Aborting..."
    exit 1
fi

# Prompt for IPv4 address
addr=$(prompt "IPv4 Address (CIDR): ")

# Apply network configuration
echo "Configuring connection '$conn'..."
nmcli con modify "$conn" ipv4.method manual
nmcli con modify "$conn" ipv6.method disabled
nmcli con modify "$conn" ipv4.never-default yes
nmcli con modify "$conn" ipv4.addresses "$addr"

# Restart the connection
echo "Restarting connection '$conn'..."
nmcli con down "$conn"
nmcli con up "$conn"

echo "Connection '$conn' configured successfully."
