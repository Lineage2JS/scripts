#!/bin/bash

set -e  # Break execution on errors

# Настройки базы данных
DB_HOST="localhost"
DB_PORT="5432"
DB_USER="postgres"
DB_PASSWORD="root"
DB_NAME="l2db"
SQL_URL="https://lineage2js.github.io/scripts/l2db.sql"
SQL_FILE="l2db.sql"

# Экспорт пароля для psql
export PGPASSWORD="$DB_PASSWORD"

# Полный путь к SQL файлу
FULL_PATH="$(pwd)/$SQL_FILE"

echo "Connect to $DB_HOST:$DB_PORT..."

# Проверка подключения к PostgreSQL
echo "Проверка подключения к PostgreSQL..."
if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres -c "SELECT 1;" >/dev/null 2>&1; then
    echo "ERROR: Cannot connect to PostgreSQL server!"
    echo "Please make sure that:"
    echo "1. PostgreSQL is installed and running"
    echo "2. Server is listening on $DB_HOST:$DB_PORT"
    echo "3. User '$DB_USER' exists and password is correct"
    echo ""
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✓ Подключение к PostgreSQL успешно"

# Проверка существования базы данных
echo "Проверка существования базы данных $DB_NAME..."
DB_EXISTS=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d postgres -t -A -c "SELECT 1 FROM pg_database WHERE datname = '$DB_NAME';")

if [ "$DB_EXISTS" = "1" ]; then
    echo "Database $DB_NAME already exists! Exiting."
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✓ База данных $DB_NAME не существует, продолжаем..."

# Скачивание SQL файла
echo "Downloading SQL file from $SQL_URL..."
if ! wget -q "$SQL_URL" -O "$SQL_FILE"; then
    echo "Error: Failed to download SQL file!"
    read -p "Press Enter to continue..."
    exit 1
fi

if [ ! -f "$FULL_PATH" ]; then
    echo "Error: SQL file not found at $FULL_PATH!"
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✓ SQL файл успешно скачан"

# Создание базы данных
echo "Creating database $DB_NAME..."
if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -c "CREATE DATABASE $DB_NAME;" >/dev/null 2>&1; then
    echo "Error: Failed to create database $DB_NAME!"
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✓ База данных $DB_NAME создана"

# Импорт SQL файла
echo "Importing SQL file $SQL_FILE..."
if ! psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -q -f "$FULL_PATH"; then
    echo "Error: Failed to import SQL file!"
    read -p "Press Enter to continue..."
    exit 1
fi

echo "✓ SQL файл успешно импортирован"

# Вывод списка созданных таблиц
echo ""
echo "Created tables in database $DB_NAME:"
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -A -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public' ORDER BY table_name;"

# Удаление временного файла
echo "Deleting temporary file..."
rm -f "$FULL_PATH"

echo ""
echo "Done!"
