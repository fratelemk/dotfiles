#!/bin/bash
set -euo pipefail

# Function to prompt for user input
prompt() {
    read -p "$1" input
    echo "$input"
}

echo "Generating ~/.gitconfig..."

# Get name and email
name=$(prompt "Name: ")
email=$(prompt "Email: ")

# Backup existing .gitconfig if exists
if [[ -f "$HOME/.gitconfig" ]]; then
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.bak"
    echo "Existing .gitconfig backed up to ~/.gitconfig.bak"
fi

# Generate the new .gitconfig file
cat <<EOF > "$HOME/.gitconfig"
[init]
    defaultBranch = main
[user]
    name = $name
    email = $email
[core]
    editor = vim
EOF

echo ".gitconfig generated successfully at $HOME/.gitconfig"
