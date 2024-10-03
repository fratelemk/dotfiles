#!/bin/bash

check_root() {
	if [[ $EUID -ne 0 ]]; then
		echo "This script must be run as root" 1>&2
		exit 1
	fi
}

install_packages() {
	echo "Updating the system..."
	dnf update -y

	echo "Installing packages..."
	dnf install -y git ansible screen vim alacritty stow iperf3 wireshark
}


check_root

