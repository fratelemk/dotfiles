#!/bin/bash

prompt() {
	read -p "$1" input
	echo "$input"
}

echo "Generating .gitconfig..."

name=$(prompt "Name: ")
email=$(prompt "Email: ")

cat <<EOF > ~/.gitconfig
[init]
	defaultBranch = main
[user]
	name = $name
	email = $email
[core]
	editor = vim
EOF

echo ".gitconfig generated successfully at ~/.gitconfig"

