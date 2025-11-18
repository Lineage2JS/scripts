#!/bin/bash

set -e  # Прерывать выполнение при ошибках

echo "=== Начало развертывания web-ui проекта ==="

# 1) Клонирование репозитория
echo "1. Клонирование репозитория..."
if [ -d "web-ui" ]; then
    echo "Папка web-ui уже существует, удаляем..."
    rm -rf web-ui
fi
git clone https://github.com/Lineage2JS/web-ui.git
cd web-ui

# 2) Установка зависимостей
echo "2. Установка зависимостей npm..."
npm install

# 3) Сборка проекта
echo "3. Сборка проекта..."
npm run build

# 4) Создание целевой папки
echo "4. Создание целевой папки..."
sudo mkdir -p /var/www/html/web-ui/

# 5) Копирование собранных файлов
echo "5. Копирование собранных файлов..."
sudo cp -r dist/* /var/www/html/web-ui/

# Проверка результата
echo "6. Проверка результата..."
if [ -d "/var/www/html/web-ui" ] && [ "$(ls -A /var/www/html/web-ui/)" ]; then
    echo "Файлы успешно скопированы в /var/www/html/web-ui/"
    echo "Содержимое папки:"
    ls -la /var/www/html/web-ui/
else
    echo "Ошибка: папка /var/www/html/web-ui/ пуста или не существует"
    exit 1
fi

echo "=== Развертывание завершено успешно! ==="
