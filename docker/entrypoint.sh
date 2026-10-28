#!/bin/sh
set -e
cd /var/www/html

mkdir -p storage/app storage/logs storage/framework/cache/data storage/framework/sessions storage/framework/views bootstrap/cache

# Buat APP_KEY otomatis kalau belum diisi, lalu simpan di volume agar tidak berubah saat container dibuat ulang.
if [ -z "$APP_KEY" ]; then
    KEYFILE=storage/app/.app_key
    if [ ! -s "$KEYFILE" ]; then
        echo "base64:$(head -c 32 /dev/urandom | base64)" > "$KEYFILE"
    fi
    APP_KEY="$(cat "$KEYFILE")"
    export APP_KEY
fi

php artisan package:discover --ansi

if [ "$APP_ENV" = "production" ]; then
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
fi

chown -R www-data:www-data storage bootstrap/cache

exec "$@"
