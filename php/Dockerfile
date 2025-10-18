FROM php:8.2-fpm AS symfony_php

# persistent / runtime deps
RUN apt-get update && apt-get install -y \
    git \
    zip \
    ca-certificates \
    curl \
    lsb-release \
    gnupg

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
# keep your pinned installer
COPY --from=mlocati/php-extension-installer:2.1.65 /usr/bin/install-php-extensions /usr/local/bin/

# 1) Use the installer for everything EXCEPT imagick (and include xsl here)
RUN install-php-extensions \
    intl \
    zip \
    apcu \
    pdo_pgsql \
    uuid \
    opcache \
    xdebug-^3.3 \
    gd \
    xsl

# 2) Install imagick via Debian + PECL (works on amd64/arm64, Bookworm)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        imagemagick \
        libmagickwand-dev \
        libmagickcore-dev; \
    printf "\n" | pecl install imagick; \
    docker-php-ext-enable imagick; \
    rm -rf /var/lib/apt/lists/*

# (rest of your file unchanged)
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

# Install Node
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
ENV NODE_MAJOR=21
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" > /etc/apt/sources.list.d/nodesource.list
RUN apt-get update && apt-get install -y nodejs

WORKDIR /app
ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
