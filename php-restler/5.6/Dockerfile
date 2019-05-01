FROM php:5.6.40-fpm
LABEL maintainer="Jan-Moritz Galler <jan@lets-byte.it>"

EXPOSE 80

RUN apt-get update && apt-get install -y \
        libpq-dev \
        zlib1g-dev \
        libzip-dev \
        curl \
        nano \
        nginx \
    && docker-php-ext-install -j$(nproc) pdo \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install  mbstring \
    && docker-php-ext-install  zip \
    && docker-php-ext-install  ldap

RUN rm /etc/nginx/sites-enabled/default

COPY ./nginx-default.conf /etc/nginx/conf.d/default.conf
COPY ./fpm.conf /usr/local/etc/php-fpm.d/www.conf

COPY ./docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["php-fpm"]
