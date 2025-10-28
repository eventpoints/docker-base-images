# ===== Base (prod) =====
FROM php:8.4-fpm AS base

# Reduce apt noise & image size
ENV DEBIAN_FRONTEND=noninteractive \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_NO_INTERACTION=1

# OS deps kept minimal; mlocati script pulls build deps as needed and cleans up
RUN apt-get update && apt-get install -y --no-install-recommends \
      git ca-certificates curl zip \
    && rm -rf /var/lib/apt/lists/*

# Composer + php-ext installer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:latest /usr/bin/install-php-extensions /usr/local/bin/

# PHP extensions (imagick handled here; xsl for twig/inky)
# NOTE: keep 'uuid' only if you actually need the PECL uuid extension.
RUN install-php-extensions \
      intl zip apcu pdo_pgsql opcache gd xsl imagick \
    && install-php-extensions @composer

# Optional: if you truly need the PECL uuid extension:
# RUN install-php-extensions uuid

# FPM/OPcache sane defaults
RUN { \
      echo 'opcache.enable=1'; \
      echo 'opcache.enable_cli=0'; \
      echo 'opcache.jit=1255'; \
      echo 'opcache.jit_buffer_size=64M'; \
      echo 'opcache.memory_consumption=192'; \
      echo 'opcache.interned_strings_buffer=16'; \
      echo 'opcache.max_accelerated_files=65407'; \
      echo 'opcache.validate_timestamps=0'; \
    } > /usr/local/etc/php/conf.d/opcache.ini \
  && { \
      echo 'pm = dynamic'; \
      echo 'pm.max_children = 10'; \
      echo 'pm.start_servers = 2'; \
      echo 'pm.min_spare_servers = 1'; \
      echo 'pm.max_spare_servers = 5'; \
      echo 'pm.process_idle_timeout = 10s'; \
    } > /usr/local/etc/php-fpm.d/zz-pool-tuning.conf

WORKDIR /app
EXPOSE 9000
CMD ["php-fpm", "-F"]

# ===== Dev target (adds Xdebug only) =====
FROM base AS dev
RUN install-php-extensions xdebug \
 && { \
      echo 'zend_extension=xdebug'; \
      echo 'xdebug.mode=develop,debug'; \
      echo 'xdebug.client_host=host.docker.internal'; \
      echo 'xdebug.start_with_request=yes'; \
    } > /usr/local/etc/php/conf.d/99-xdebug.ini
