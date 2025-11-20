#!/bin/bash

set -e  # Break execution on errors

# Конфигурация
APP_NAME="lineage2js-web-server"
APP_DIR="/opt/$APP_NAME"
REPO_URL="https://github.com/Lineage2JS/web-server.git"

echo "=== Развертывание Lineage2 Web Server ==="

# Проверка прав
if [[ $EUID -ne 0 ]]; then
    echo "Ошибка: Запустите скрипт с sudo"
    exit 1
fi

# Проверка Node.js
if ! command -v node &> /dev/null; then
    echo "Ошибка: Node.js не установлен"
    exit 1
fi

echo "Node.js: $(node --version)"

# Создание директории
echo "Создание директории..."
mkdir -p $APP_DIR

# Клонирование/обновление репозитория
echo "Клонирование репозитория..."
cd $APP_DIR
if [ -d ".git" ]; then
    git pull
else
    git clone $REPO_URL .
fi

# Установка зависимостей
echo "Установка зависимостей..."
npm ci --only=production

# Создание службы
echo "Создание systemd службы..."
cat > /etc/systemd/system/$APP_NAME.service << EOF
[Unit]
Description=Lineage2JS Web Server
After=network.target

[Service]
Type=simple
WorkingDirectory=$APP_DIR
Environment=NODE_ENV=production
Environment=STATIC_FILES_PATH=/var/www/html/lineage2js-web-ui/
ExecStart=/usr/bin/node server.js
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Запуск службы
echo "Запуск службы..."
systemctl daemon-reload
systemctl enable $APP_NAME
systemctl restart $APP_NAME

echo "=== Готово! ==="
echo "Приложение: $APP_DIR"
echo "Управление: systemctl status $APP_NAME"
echo "Логи: journalctl -u $APP_NAME -f"
