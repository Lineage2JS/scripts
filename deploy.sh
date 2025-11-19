#!/bin/bash

# Обновляем пакеты перед выполнением скриптов
echo "Обновляем список пакетов..."
apt update

# Список скриптов для выполнения
SCRIPTS=(
    "http://lineage2js.github.io/scripts/install_tools.sh"
    "http://lineage2js.github.io/scripts/install_db.sh"
    "http://lineage2js.github.io/scripts/setup_db.sh"
    "http://lineage2js.github.io/scripts/deploy_web_server.sh"
    "http://lineage2js.github.io/scripts/deploy_web_ui.sh"
)

for script_url in "${SCRIPTS[@]}"; do
    script_name=$(basename "$script_url")
    echo "Выполняем $script_name..."
    wget -q -O - "$script_url" | bash
    echo "----------------------------------------"
done
