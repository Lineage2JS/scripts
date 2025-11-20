#!/bin/bash

set -e  # Break execution on errors

# Update packages before running scripts
echo "Updating the package list..."
sudo apt update
sudo apt upgrade -y

# List of scripts to execute
SCRIPTS=(
    "http://lineage2js.github.io/scripts/install_tools.sh"
    "http://lineage2js.github.io/scripts/install_db.sh"
    "http://lineage2js.github.io/scripts/setup_db.sh"
    "http://lineage2js.github.io/scripts/install_web_server.sh"
    "http://lineage2js.github.io/scripts/install_web_ui.sh"
    "http://lineage2js.github.io/scripts/install_login_server.sh"
)

for script_url in "${SCRIPTS[@]}"; do
    script_name=$(basename "$script_url")
    echo "Execute $script_name..."
    wget -q -O - "$script_url" | bash
    echo "----------------------------------------"
done
