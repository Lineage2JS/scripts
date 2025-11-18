#!/bin/bash

set -e  # Прерывать выполнение при ошибках

echo "=== Начало установки PostgreSQL ==="

# Обновление системы
echo "1. Обновление пакетов..."
sudo apt update
sudo apt upgrade -y

# Установка PostgreSQL
echo "2. Установка PostgreSQL..."
sudo apt install postgresql postgresql-contrib -y

# Запуск и включение службы
echo "3. Запуск службы PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Проверка статуса
echo "4. Проверка статуса службы..."
sudo systemctl status postgresql --no-pager

# Установка пароля для пользователя postgres
echo "5. Установка пароля 'root' для пользователя postgres..."
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'root';"

# Настройка аутентификации (меняем peer на md5)
echo "6. Настройка аутентификации..."
PG_HBA_FILE=$(sudo find /etc/postgresql -name "pg_hba.conf" | head -1)
if [ -n "$PG_HBA_FILE" ]; then
    sudo cp "$PG_HBA_FILE" "${PG_HBA_FILE}.backup"
    sudo sed -i 's/local   all             all                                     peer/local   all             all                                     md5/g' "$PG_HBA_FILE"
    echo "Файл аутентификации обновлен: $PG_HBA_FILE"
else
    echo "Предупреждение: Файл pg_hba.conf не найден"
fi

# Перезапуск PostgreSQL
echo "7. Перезапуск PostgreSQL..."
sudo systemctl restart postgresql

# Проверка установки
echo "8. Проверка установки..."
echo "Версия PostgreSQL:"
psql --version

echo "9. Проверка подключения..."
sudo -u postgres psql -c "SELECT version();"

echo "=== Установка завершена успешно! ==="
echo ""
echo "Данные для подключения:"
echo "Пользователь: postgres"
echo "Пароль: root"
echo "Хост: localhost"
echo "Порт: 5432"
echo ""
echo "Пример подключения:"
echo "psql -U postgres -h localhost"
echo ""
echo "Для подключения без пароля (локально):"
echo "sudo -u postgres psql"
