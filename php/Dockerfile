FROM php:8.2-fpm AS symfony_php

# Update apt package index and install essential utilities
RUN apt-get update && apt-get install -y \
    git \
    zip \

# Copy pre-built PHP extensions for faster builds
COPY --from=mlocati/php-extension-installer:2.1.65 \
    /usr/local/bin/install-php-extensions /usr/local/bin/
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions using install-php-extensions
RUN install-php-extensions \
    intl \
    zip \
    apcu \
    pdo_pgsql \
    imagick \
    uuid \
    opcache \
    xdebug-^3.3

# Copy healthcheck script and set permissions
COPY docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

# Configure healthcheck with retries and timeout
HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

# Copy PHP configuration files
COPY php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY conf.d/99-php.ini $PHP_INI_DIR/conf.d/99-php.ini

# Copy custom entrypoint script and set permissions
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

# Set environment variables for Composer, PHP configuration, and entrypoint
ENV COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_ALLOW_SUPERUSER=1 \
    PATH="${PATH}:/root/.composer/vendor/bin" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS=1 \
    PHP_OPCACHE_MAX_ACCELERATED_FILES=15000 \
    PHP_OPCACHE_MEMORY_CONSUMTION=192 \
    PHP_OPCACHE_MAX_WASTED_PERCENTAGE=10 \
    PHP_EXPOSE_PHP="1"

# Set the working directory for application files
WORKDIR /app

# Define the entrypoint and command for starting the PHP application
ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]
