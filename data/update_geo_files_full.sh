#!/bin/sh

# Находим первую папку в /mnt/
USB_DIR=$(find /mnt -mindepth 1 -maxdepth 1 -type d | head -n 1)

# Проверяем, что USB-папка найдена
if [ -z "$USB_DIR" ]; then
  echo "USB-папка не найдена в /mnt/"
  exit 1
fi

echo "USB-папка найдена: $USB_DIR"

# Путь к каталогу для сохранения файлов
TARGET_DIR="$USB_DIR/usr/share/v2raya"

# URL-адреса для загрузки файлов
GEOIP_URL="https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/latest/download/geoip.dat"
GEOSITE_URL="https://github.com/runetfreedom/russia-v2ray-rules-dat/releases/latest/download/geosite.dat"

# Проверка наличия целевой директории
if [ ! -d "$TARGET_DIR" ]; then
    echo "Каталог $TARGET_DIR не существует. Создаю..."
    mkdir -p "$TARGET_DIR" || { echo "Не удалось создать каталог $TARGET_DIR."; exit 1; }
fi

# Функция для загрузки файла
download_file() {
    local url=$1
    local output=$2

    echo "Загрузка файла с URL: $url"
    curl -L --fail -A "Mozilla/5.0" -o "$output" "$url"
    if [ $? -eq 0 ]; then
        echo "Файл успешно загружен: $output"
    else
        echo "Ошибка при загрузке файла: $url"
        exit 1
    fi
}

# Загрузка geoip.dat
download_file "$GEOIP_URL" "$TARGET_DIR/geoip.dat"

# Загрузка geosite.dat
download_file "$GEOSITE_URL" "$TARGET_DIR/geosite.dat"

# Создание копии geosite.dat с новым именем
cp "$TARGET_DIR/geosite.dat" "$TARGET_DIR/LoyalsoldierSite.dat"
echo "Файл geosite.dat скопирован в LoyalsoldierSite.dat"
