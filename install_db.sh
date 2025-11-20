#!/bin/bash

set -e  # Break execution on errors

echo "=== Starting the PostgreSQL installation ==="

# System update
echo "1. Updating packages..."
sudo apt update
sudo apt upgrade -y

# Installing PostgreSQL
echo "2. Installing PostgreSQL..."
sudo apt install postgresql postgresql-contrib -y

# Starting and enabling the service
echo "3. Starting the PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Checking status
echo "4. Checking the service status..."
sudo systemctl status postgresql --no-pager

# Setting a password for the postgres user
echo "5. Setting 'root' password for postgres user..."
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'root';"

# Setting up authentication (changing peer to md5)
echo "6. Setting up authentication..."
PG_HBA_FILE=$(sudo find /etc/postgresql -name "pg_hba.conf" | head -1)
if [ -n "$PG_HBA_FILE" ]; then
    sudo cp "$PG_HBA_FILE" "${PG_HBA_FILE}.backup"
    sudo sed -i 's/local   all             all                                     peer/local   all             all                                     md5/g' "$PG_HBA_FILE"
    echo "Authentication file updated: $PG_HBA_FILE"
else
    echo "Warning: pg_hba.conf file not found"
fi

# Restarting PostgreSQL
echo "7. Restarting PostgreSQL..."
sudo systemctl restart postgresql

# Checking the installation
echo "8. Checking the installation..."
echo "PostgreSQL version:"
psql --version

echo "9. Checking connection..."
sudo -u postgres psql -c "SELECT version();"

echo "=== Installation completed successfully! ==="
echo ""
echo "Connection details:"
echo "User: postgres"
echo "Password: root"
echo "Host: localhost"
echo "Port: 5432"
echo ""
echo "Connection example:"
echo "psql -U postgres -h localhost"
echo ""
echo "To connect without a password (locally):"
echo "sudo -u postgres psql"
