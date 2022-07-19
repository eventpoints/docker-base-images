FROM php:8.1-fpm AS symfony_php

# persistent / runtime deps
RUN apt-get update && apt-get install -y \
		git \
        zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY --from=mlocati/php-extension-installer:1.5.16 /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions \
    intl \
    zip \
    apcu \
    pdo_pgsql \
    imagick \
    uuid \
    opcache \
    xdebug

COPY docker-healthcheck.sh /usr/local/bin/docker-healthcheck
RUN chmod +x /usr/local/bin/docker-healthcheck

HEALTHCHECK --interval=10s --timeout=3s --retries=3 CMD ["docker-healthcheck"]

COPY php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENV COMPOSER_MEMORY_LIMIT=-1
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV PATH="${PATH}:/root/.composer/vendor/bin"

WORKDIR /srv/app

ENTRYPOINT ["docker-entrypoint"]
CMD ["php-fpm"]

