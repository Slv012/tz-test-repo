# stage 1: build stage. install dependencies and build the application
FROM php:8.4.5-fpm-alpine@sha256:5682435e64a0b2bd03337f2b9a92eacb8e095295377f3e2fa65eea15eae447b2 AS builder
RUN apk add --no-cache \
    bash \
    git \
    libzip-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    icu-dev \
    postgresql-dev \
    zlib-dev \
    unzip \
    curl \
    pkgconfig
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql intl zip
COPY --from=composer:2.8.6 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/symfony
COPY my-symfony-app/composer.json /var/www/symfony/
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# stage 2: production-ready image
FROM php:8.4.5-fpm-alpine@sha256:5682435e64a0b2bd03337f2b9a92eacb8e095295377f3e2fa65eea15eae447b2
RUN apk add --no-cache \
    libzip \
    libpng \
    libjpeg-turbo \
    freetype \
    icu \
    postgresql-libs \
    zlib
COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-*/ /usr/local/lib/php/extensions/no-debug-non-zts-*/
COPY --from=builder /usr/bin/composer /usr/bin/composer
COPY --from=builder /var/www/symfony /var/www/symfony
COPY ./my-symfony-app /var/www/symfony
RUN chown -R www-data:www-data /var/www/symfony
RUN echo "error_log = /dev/stderr" >> /usr/local/etc/php/php.ini
USER www-data

EXPOSE 9000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:9000/health || exit 1

CMD ["php-fpm"]