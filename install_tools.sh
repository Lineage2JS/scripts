#!/bin/bash

set -e  # Break execution on errors

echo "=== Installing tools ==="

# Updating the package list
echo "Updating the package list..."
sudo apt update

# Installation Git
echo "Installation Git..."
sudo apt install -y git

# Installing Node.js and npm
echo "Installing Node.js and npm..."
sudo apt install -y nodejs npm

# Installing additional useful tools
echo "Installing additional useful tools..."
sudo apt install -y curl wget

echo "=== Installation complete! ==="
echo ""
echo "Installed versions:"
echo "Git: $(git --version)"
echo "Node.js: $(node --version)"
echo "npm: $(npm --version)"
