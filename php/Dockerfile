FROM php:8.2-fpm AS symfony_php

# persistent / runtime deps
RUN apt-get update && apt-get install -y \
		git \
        zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:2.1.65 /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    intl \
    zip \
    apcu \
    pdo_pgsql \
    imagick \
    uuid \
    opcache \
    xdebug-^3.1 \
&& php -m

COPY docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

COPY php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY conf.d/99-php.ini $PHP_INI_DIR/conf.d/99-php.ini

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENV COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="${PATH}:/root/.composer/vendor/bin" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=15000 \
    PHP_OPCACHE_MEMORY_CONSUMPTION=192 \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE=10 \
    PHP_OPCACHE_PRELOAD="" \
    PHP_EXPOSE_PHP="1"

WORKDIR /app

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
