# syntax=docker/dockerfile:1

# Tahap 1: build aset frontend (React + Tailwind) dengan Vite
FROM node:22-alpine AS assets
WORKDIR /app
COPY package.json package-lock.json .npmrc ./
RUN npm ci
COPY vite.config.js ./
COPY resources ./resources
COPY public ./public
RUN npm run build

# Tahap 2: pasang dependency PHP (tanpa paket dev)
FROM composer:2 AS vendor
WORKDIR /app
COPY composer.json composer.lock* ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist --no-interaction --ignore-platform-reqs
COPY . .
RUN composer dump-autoload --no-dev --optimize --no-scripts --ignore-platform-reqs

# Tahap 3: image akhir, PHP-FPM + Nginx dalam satu container
FROM php:8.3-fpm-alpine
RUN apk add --no-cache nginx supervisor \
    && mkdir -p /run/nginx

COPY docker/php.ini /usr/local/etc/php/conf.d/zz-portfolio.ini
COPY docker/php-fpm.conf /usr/local/etc/php-fpm.d/zz-portfolio.conf
COPY docker/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

WORKDIR /var/www/html
COPY --from=vendor /app ./
COPY --from=assets /app/public/build ./public/build

EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1

ENTRYPOINT ["entrypoint"]
CMD ["supervisord", "-c", "/etc/supervisord.conf"]
