#!/bin/bash

set -e # Break execution on errors

REPO_URL="https://github.com/Lineage2JS/web-ui.git"
PROJECT_DIR="web-ui"
TARGET_DIR="/var/www/html/lineage2js-web-ui"
BUILD_DIR="dist"

echo "=== Deploying web-ui ==="

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

# Cloning/updating a repository
echo "Cloning a repository..."
if [ -d "$PROJECT_DIR" ]; then
    echo "The $PROJECT_DIR folder already exists, delete it..."
    rm -rf "$PROJECT_DIR"
fi
git clone "$REPO_URL"
cd "$PROJECT_DIR"

# Installing dependencies
echo "Installing dependencies..."
npm install

# Build
echo "Build..."
npm run build

# Creating a directory
echo "Creating a directory..."
sudo mkdir -p "$TARGET_DIR"

# Copying collected files
echo "Copying collected files..."
sudo cp -r "$BUILD_DIR"/* "$TARGET_DIR"/

# Deleting a project folder after deployment
echo "Deleting a project folder after deployment..."
cd ..
if [ -d "$PROJECT_DIR" ]; then
    echo "Delete the $PROJECT_DIR folder..."
    rm -rf "$PROJECT_DIR"
    echo "The $PROJECT_DIR folder was successfully deleted."
else
    echo "The $PROJECT_DIR folder has already been deleted or does not exist."
fi

# Checking the result
echo "Checking the result..."
if [ -d "$TARGET_DIR" ] && [ "$(ls -A "$TARGET_DIR")" ]; then
    echo "Files successfully copied to $TARGET_DIR"
    echo "Folder contents:"
    ls -la "$TARGET_DIR"
else
    echo "Error: The $TARGET_DIR folder is empty or does not exist."
    exit 1
fi

echo "=== Deployment completed successfully! ==="
