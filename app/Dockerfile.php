FROM composer:2 AS vendor

WORKDIR /app

COPY composer.json  composer.lock ./

RUN composer install \
        --no-dev \
        --prefer-dist \
        --no-interaction \
        --no-progress \
        --no-scripts

FROM php:8.3-fpm-alpine

RUN docker-php-ext-install pdo_mysql

WORKDIR /var/www

COPY --from=vendor /app/vendor ./vendor

COPY composer.json ./
COPY src/ ./src/
COPY public/ ./public/
COPY database/ ./database


EXPOSE 9000

CMD [ "php-fpm", "-F" ]