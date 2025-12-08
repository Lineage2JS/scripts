#!/bin/bash

set -e # Break execution on errors

# Configuration
APP_NAME="lineage2js-game-server"
APP_DIR="/opt/$APP_NAME"
REPO_URL="https://github.com/Lineage2JS/game-server.git"

echo "=== Deploying Lineage2 Game Server ==="

# Checking rights
if [[ $EUID -ne 0 ]]; then
    echo "Error: Run script with sudo"
    exit 1
fi

# Checking Node.js
if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed"
    exit 1
fi

# Checking npm
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed"
    exit 1
fi

# Creating a directory
echo "Creating a directory..."
mkdir -p $APP_DIR

# Cloning/updating a repository
echo "Cloning a repository..."
cd $APP_DIR
if [ -d ".git" ]; then
    echo "Updating an existing repository..."
    git pull
else
    echo "Cloning a new repository..."
    git clone $REPO_URL .
fi

# Installing dependencies
echo "Installing dependencies..."
npm ci --only=production

# Creating a service
echo "Creating a systemd service..."
cat > /etc/systemd/system/$APP_NAME.service << EOF
[Unit]
Description=Lineage2JS Game Server
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR
Environment=NODE_ENV=production
ExecStart=/usr/bin/node server.js
Restart=on-failure
RestartSec=5
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

# Starting the service
echo "Starting the service..."
systemctl daemon-reload
systemctl enable $APP_NAME
systemctl restart $APP_NAME

echo "=== Done! ==="
echo "App: $APP_DIR"
echo "Control: systemctl status $APP_NAME"
echo "Logs: journalctl -u $APP_NAME -f"
echo "Default port: 7777 (check configuration in $APP_DIR/config/)"
