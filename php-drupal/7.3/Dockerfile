FROM php:7.3-fpm
LABEL maintainer="Johannes Kees <johannes@lets-byte.it>"

EXPOSE 80

RUN apt-get update && apt-get install -y \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        zlib1g-dev \
        libzip-dev \
        curl \
        nano \
        mysql-client \
        nginx \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install  mysqli \
    && docker-php-ext-install  mbstring \
    && docker-php-ext-install  gd \
    && docker-php-ext-install  opcache \
    && docker-php-ext-install  zip

RUN rm /etc/nginx/sites-enabled/default

COPY ./nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./fpm.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV PRE_SCRIPTS_DIR=/var/scripts/pre
ENV AFTER_SCRIPTS_DIR=/var/scripts/after

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
