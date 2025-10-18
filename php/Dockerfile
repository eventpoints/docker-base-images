FROM php:8.4-fpm

# base deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    git zip ca-certificates curl gnupg lsb-release \
 && rm -rf /var/lib/apt/lists/*

# composer + installer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/

# common extensions (xsl needed for twig/inky-extra)
RUN install-php-extensions \
    intl zip apcu pdo_pgsql uuid opcache xdebug gd xsl

# imagick via PECL (most reliable across arch)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends imagemagick libmagickwand-dev libmagickcore-dev; \
    printf "\n" | pecl install imagick; \
    docker-php-ext-enable imagick; \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
CMD ["php-fpm"]
