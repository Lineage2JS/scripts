#!/bin/bash

set -e # Break execution on errors

REPO_URL="https://github.com/Lineage2JS/web-ui.git"
PROJECT_DIR="web-ui"
TARGET_DIR="/var/www/html/lineage2js-web-ui"
BUILD_DIR="dist"

echo "=== Start web-ui deployment ==="

# Cloning a repository
echo "1. Клонирование репозитория..."
if [ -d "$PROJECT_DIR" ]; then
    echo "Папка $PROJECT_DIR уже существует, удаляем..."
    rm -rf "$PROJECT_DIR"
fi
git clone "$REPO_URL"
cd "$PROJECT_DIR"

# Installing
echo "2. Установка зависимостей npm..."
npm install

# Build
echo "3. Сборка проекта..."
npm run build

# 4) Создание целевой папки
echo "4. Создание целевой папки..."
sudo mkdir -p "$TARGET_DIR"

# 5) Копирование собранных файлов
echo "5. Копирование собранных файлов..."
sudo cp -r "$BUILD_DIR"/* "$TARGET_DIR"/

# 6) Удаление папки проекта после развертывания
echo "6. Удаление папки проекта после развертывания..."
cd ..
if [ -d "$PROJECT_DIR" ]; then
    echo "Удаляем папку $PROJECT_DIR..."
    rm -rf "$PROJECT_DIR"
    echo "Папка $PROJECT_DIR успешно удалена"
else
    echo "Папка $PROJECT_DIR уже удалена или не существует"
fi

# Проверка результата
echo "7. Проверка результата..."
if [ -d "$TARGET_DIR" ] && [ "$(ls -A "$TARGET_DIR")" ]; then
    echo "Файлы успешно скопированы в $TARGET_DIR"
    echo "Содержимое папки:"
    ls -la "$TARGET_DIR"
else
    echo "Ошибка: папка $TARGET_DIR пуста или не существует"
    exit 1
fi

echo "=== Deployment completed successfully! ==="
